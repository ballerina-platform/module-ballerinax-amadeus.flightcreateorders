# Running Tests

## Prerequisites

To run the tests against the live Amadeus API you need an Amadeus for Developers application and its API key and API secret. Follow the [Setup guide](https://github.com/ballerina-platform/module-ballerinax-amadeus.flightcreateorders/blob/main/ballerina/README.md#setup-guide) to obtain them.

## Test environments

There are two test environments. The default is a mock server for the Amadeus Flight Create Orders API, together with a mock OAuth token endpoint. The other is the live Amadeus API.

 Test Groups | Environment
-------------|------------------------------------------------
 mock_tests  | Mock server for the Amadeus Flight Create Orders API (default)
 live_tests  | Amadeus Flight Create Orders API

## Running tests against the mock server

No configuration is needed. When `IS_LIVE_SERVER` is not set to `true`, the tests run against the mock server on port `9090` and the mock token endpoint on port `9444`.

```bash
./gradlew clean test
```

## Running tests against the live API

Set the following environment variables and run the live test group. The live booking test is skipped because it would create a real order.

```bash
export IS_LIVE_SERVER=true
export AMADEUS_CLIENT_ID=<api-key>
export AMADEUS_CLIENT_SECRET=<api-secret>
./gradlew clean test -Pgroups=live_tests
```
