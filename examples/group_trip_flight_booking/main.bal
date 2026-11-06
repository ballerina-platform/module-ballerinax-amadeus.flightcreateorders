// Books a one-way flight order for a group of travelers and reports the order and its travelers.

import ballerina/io;
import ballerinax/amadeus.flightcreateorders as amadeus;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string tokenUrl = ?;
configurable string serviceUrl = ?;
configurable string pricingResponsePath = "flight_offers_price.json";
configurable string groupContactEmail = ?;
configurable Passengers passengers = ?;

type Passengers Passenger[];

type Passenger record {|
    string firstName;
    string lastName;
    string dateOfBirth;
|};

// A flight order holds at most 18 travelers.
const MAX_TRAVELERS = 18;

public function main() returns error? {
    if passengers.length() == 0 {
        return error("At least one passenger must be configured");
    }
    if passengers.length() > MAX_TRAVELERS {
        return error(string `A flight order holds at most ${MAX_TRAVELERS} travelers, but ${passengers.length()} are configured`);
    }
    amadeus:Client amadeusClient = check new ({
        auth: {tokenUrl, clientId, clientSecret}
    }, serviceUrl);

    // The priced offer, as returned by the Flight Offers Price API, is booked unchanged.
    json pricingResponse = check io:fileReadJson(pricingResponsePath);
    json pricedOffers = check pricingResponse.data.flightOffers;
    amadeus:FlightOffer[] flightOffers = check pricedOffers.cloneWithType();

    // Traveler ids 1..n match the travelerId values the offer was priced for.
    amadeus:Traveler[] travelers = [];
    foreach int index in 0 ..< passengers.length() {
        Passenger passenger = passengers[index];
        travelers.push({
            id: (index + 1).toString(),
            dateOfBirth: passenger.dateOfBirth,
            name: {firstName: passenger.firstName, lastName: passenger.lastName}
        });
    }

    amadeus:FlightOrderQuery payload = {
        data: {
            'type: "flight-order",
            flightOffers,
            travelers,
            contacts: [
                {
                    addresseeName: {firstName: passengers[0].firstName, lastName: passengers[0].lastName},
                    purpose: "STANDARD",
                    emailAddress: groupContactEmail
                }
            ]
        }
    };

    amadeus:Success_Booking booking = check amadeusClient->createFlightOrder(payload);
    amadeus:Traveler[] booked = booking.data.travelers ?: [];
    io:println("Flight order ", booking.data.id ?: "unassigned", " created for ", booked.length(), " traveler(s)");
    foreach amadeus:Traveler traveler in booked {
        io:println("Traveler ", traveler.id ?: "?", ": ", traveler.name?.firstName ?: "", " ", traveler.name?.lastName ?: "");
    }
}
