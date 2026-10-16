# Examples

The `ballerinax/amadeus.flightcreateorders` connector provides practical examples illustrating usage in various scenarios.

1. **[Round trip flight booking](https://github.com/ballerina-platform/module-ballerinax-amadeus.flightcreateorders/tree/main/examples/round_trip_flight_booking)** - Book a round-trip flight order for one traveler with outbound and return itineraries and read back the booking references.

2. **[Group trip flight booking](https://github.com/ballerina-platform/module-ballerinax-amadeus.flightcreateorders/tree/main/examples/group_trip_flight_booking)** - Book a one-way flight order for a group of travelers with a shared contact and list the travelers recorded on the order.

## Prerequisites

1. Obtain an API key and API secret for Amadeus Enterprise APIs through your Amadeus account manager. The Amadeus Self-Service portal was decommissioned on 17 July 2026, so applications and credentials can no longer be created there.

2. For each example, create a `Config.toml` file with the related configuration. Here's an example of how your Config.toml file should look:

```toml
clientId = "<api-key>"
clientSecret = "<api-secret>"
tokenUrl = "https://api.amadeus.com/v1/security/oauth2/token"
serviceUrl = "https://api.amadeus.com/v1/booking"
```

Each example lists the additional values it needs in its own README.

## Running an example

Execute the following commands to build an example from the source:

* To build an example:

    ```bash
    bal build
    ```

* To run an example:

    ```bash
    bal run
    ```

## Building the examples with the local module

**Warning**: Due to the absence of support for reading local repositories for single Ballerina files, the Bala of the module is manually written to the central repository as a workaround. Consequently, the bash script may modify your local Ballerina repositories.

Execute the following commands to build all the examples against the changes you have made to the module locally:

* To build all the examples:

    ```bash
    ./build.sh build
    ```

* To run all the examples:

    ```bash
    ./build.sh run
    ```
