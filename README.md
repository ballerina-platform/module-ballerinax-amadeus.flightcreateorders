# Ballerina Amadeus Flight Create Orders connector

[![Build](https://github.com/ballerina-platform/module-ballerinax-amadeus.flightcreateorders/actions/workflows/ci.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-amadeus.flightcreateorders/actions/workflows/ci.yml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-amadeus.flightcreateorders.svg)](https://github.com/ballerina-platform/module-ballerinax-amadeus.flightcreateorders/commits/main)
[![GitHub Issues](https://img.shields.io/github/issues/ballerina-platform/ballerina-library/module/amadeus.flightcreateorders.svg?label=Open%20Issues)](https://github.com/ballerina-platform/ballerina-library/labels/module%2Famadeus.flightcreateorders)

## Overview

[Amadeus](https://developers.amadeus.com/) offers travel APIs for searching, pricing and booking flights, hotels and related travel services. The Flight Create Orders API creates a flight order, which books the priced flight offers for the travelers and contacts supplied in the request. Forms of payment can be supplied only where the Amadeus account supports them; the former Self-Service offering did not accept them.

The Amadeus Flight Create Orders connector lets Ballerina applications book flights through the Amadeus booking engine. It supports version 1.10.0 of the Flight Create Orders API.

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

## Build from the source

### Setting up the prerequisites

1. Download and install Java SE Development Kit (JDK) version 21. You can download it from either of the following sources:

    * [Oracle JDK](https://www.oracle.com/java/technologies/downloads/)
    * [OpenJDK](https://adoptium.net/)

   > **Note:** After installation, remember to set the `JAVA_HOME` environment variable to the directory where JDK was installed.

2. Download and install [Ballerina Swan Lake](https://ballerina.io/).

3. Download and install [Docker](https://www.docker.com/get-started).

   > **Note**: Ensure that the Docker daemon is running before executing any tests.

4. Export Github Personal access token with read package permissions as follows,

    ```bash
    export packageUser=<Username>
    export packagePAT=<Personal access token>
    ```

### Build options

Execute the commands below to build from the source.

1. To build the package:

   ```bash
   ./gradlew clean build
   ```

2. To run the tests:

   ```bash
   ./gradlew clean test
   ```

3. To build the without the tests:

   ```bash
   ./gradlew clean build -x test
   ```

4. To run tests against different environments:

   ```bash
   ./gradlew clean test -Pgroups=<Comma separated groups/test cases>
   ```

5. To debug the package with a remote debugger:

   ```bash
   ./gradlew clean build -Pdebug=<port>
   ```

6. To debug with the Ballerina language:

   ```bash
   ./gradlew clean build -PbalJavaDebug=<port>
   ```

7. Publish the generated artifacts to the local Ballerina Central repository:

    ```bash
    ./gradlew clean build -PpublishToLocalCentral=true
    ```

8. Publish the generated artifacts to the Ballerina Central repository:

   ```bash
   ./gradlew clean build -PpublishToCentral=true
   ```

## Contribute to Ballerina

As an open-source project, Ballerina welcomes contributions from the community.

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct

All the contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).

## Useful links

* For more information go to the [`amadeus.flightcreateorders` package](https://central.ballerina.io/ballerinax/amadeus.flightcreateorders/latest).
* For example demonstrations of the usage, go to [Ballerina By Examples](https://ballerina.io/learn/by-example/).
* Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
