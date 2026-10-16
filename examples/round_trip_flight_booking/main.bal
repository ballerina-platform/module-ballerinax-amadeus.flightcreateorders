// Books a round-trip flight order for a single traveler from a flight offer that was priced beforehand.

import ballerina/io;
import ballerinax/amadeus.flightcreateorders as amadeus;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string tokenUrl = ?;
configurable string serviceUrl = ?;
configurable string pricingResponsePath = "flight_offers_price.json";
configurable string travelerFirstName = ?;
configurable string travelerLastName = ?;
configurable string travelerDateOfBirth = ?;
configurable string travelerEmail = ?;
configurable string travelerPhone = ?;
configurable string travelerCountryCallingCode = ?;

public function main() returns error? {
    amadeus:Client amadeusClient = check new ({
        auth: {tokenUrl, clientId, clientSecret}
    }, serviceUrl);

    // The priced round-trip offer, as returned by the Flight Offers Price API, is booked unchanged.
    json pricingResponse = check io:fileReadJson(pricingResponsePath);
    json pricedOffers = check pricingResponse.data.flightOffers;
    amadeus:FlightOffer[] flightOffers = check pricedOffers.cloneWithType();

    amadeus:FlightOrderQuery payload = {
        data: {
            'type: "flight-order",
            flightOffers,
            travelers: [
                {
                    id: "1",
                    dateOfBirth: travelerDateOfBirth,
                    name: {firstName: travelerFirstName, lastName: travelerLastName},
                    contact: {
                        emailAddress: travelerEmail,
                        phones: [
                            {deviceType: "MOBILE", countryCallingCode: travelerCountryCallingCode, number: travelerPhone}
                        ]
                    }
                }
            ]
        }
    };

    amadeus:Success_Booking booking = check amadeusClient->createFlightOrder(payload);
    io:println("Flight order created with id: ", booking.data.id ?: "unassigned");
    amadeus:AssociatedRecord[]? records = booking.data.associatedRecords;
    if records is () || records.length() == 0 {
        io:println("No booking reference is available for this order yet");
        return;
    }
    foreach amadeus:AssociatedRecord associatedRecord in records {
        io:println("Booking reference: ", associatedRecord.reference);
    }
}
