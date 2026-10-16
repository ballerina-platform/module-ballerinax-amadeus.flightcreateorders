## Overview

[Amadeus](https://developers.amadeus.com/) offers travel APIs for searching, pricing and booking flights, hotels and related travel services. The Flight Create Orders API creates a flight order, which books the priced flight offers for the travelers and contacts supplied in the request. Forms of payment can be supplied only where the Amadeus account supports them; the former Self-Service offering did not accept them.

The Amadeus Flight Create Orders connector lets Ballerina applications book flights through the Amadeus booking engine. It supports version 1.10.0 of the Flight Create Orders API.

### Key features

- Create flight orders from priced flight offers
- Attach traveler identity, contact and loyalty details to a booking
- Provide ticketing agreements and remarks with the order, and forms of payment where the Amadeus account supports them
- Authenticate with the OAuth 2.0 client credentials grant

## Setup guide

To use the Amadeus Flight Create Orders connector, you need an API key and API secret for Amadeus Enterprise APIs.

> **Note:** The Amadeus Self-Service portal was decommissioned on 17 July 2026. New registrations and app creation there stopped, and Self-Service API keys were disabled, so credentials can no longer be created through the Self-Service workspace.

1. Contact your Amadeus account manager to get access to the Flight Create Orders API through Amadeus Enterprise.

2. Obtain the **API Key** and **API Secret** issued for your application. They are the client ID and client secret used to obtain access tokens from `https://api.amadeus.com/v1/security/oauth2/token` (`https://test.api.amadeus.com/v1/security/oauth2/token` for the test environment).

## Quickstart

To use the Amadeus Flight Create Orders connector in your Ballerina application, update the `.bal` file as follows:

### Step 1: Import the module

Import the `amadeus.flightcreateorders` module, and `ballerina/io` to read the priced flight offer.

```ballerina
import ballerina/io;
import ballerinax/amadeus.flightcreateorders as amadeus;
```

### Step 2: Instantiate a new connector

1. Create a `Config.toml` file and configure the credentials obtained in the steps above:

```toml
clientId = "<API Key>"
clientSecret = "<API Secret>"
```

2. Create an `amadeus:ConnectionConfig` with the OAuth 2.0 client credentials and initialize the connector with it.

```ballerina
configurable string clientId = ?;
configurable string clientSecret = ?;

final amadeus:Client amadeusClient = check new ({
    auth: {
        tokenUrl: "https://api.amadeus.com/v1/security/oauth2/token",
        clientId,
        clientSecret
    }
});
```

### Step 3: Invoke the connector operation

Now, utilize the available connector operations.

#### Create a flight order

Book a flight offer priced with the Flight Offers Price API, passing the priced offer unchanged. `flight_offers_price.json` holds that API's response.

```ballerina
public function main() returns error? {
    json pricingResponse = check io:fileReadJson("flight_offers_price.json");
    json pricedOffers = check pricingResponse.data.flightOffers;
    amadeus:FlightOffer[] flightOffers = check pricedOffers.cloneWithType();

    amadeus:Success_Booking booking = check amadeusClient->createFlightOrder({
        data: {
            'type: "flight-order",
            flightOffers,
            travelers: [
                {
                    id: "1",
                    dateOfBirth: "1982-01-16",
                    name: {firstName: "JORGE", lastName: "GONZALES"},
                    contact: {
                        emailAddress: "jorge.gonzales833@telefonica.es",
                        phones: [{deviceType: "MOBILE", countryCallingCode: "34", number: "480080076"}]
                    }
                }
            ]
        }
    });
    io:println("Flight order created: ", booking.data.id ?: "unassigned");
}
```

### Step 4: Run the Ballerina application

```bash
bal run
```

## Examples

The Amadeus Flight Create Orders connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-amadeus.flightcreateorders/tree/main/examples/), covering the following use cases:

1. [Round trip flight booking](https://github.com/ballerina-platform/module-ballerinax-amadeus.flightcreateorders/tree/main/examples/round_trip_flight_booking) - Book a round-trip flight order for one traveler with outbound and return itineraries and read back the booking references.

2. [Group trip flight booking](https://github.com/ballerina-platform/module-ballerinax-amadeus.flightcreateorders/tree/main/examples/group_trip_flight_booking) - Book a one-way flight order for a group of travelers with a shared contact and list the travelers recorded on the order.
