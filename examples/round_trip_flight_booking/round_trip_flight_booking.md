# Round trip flight booking

This example books a round-trip flight order for one traveler. It takes a round-trip flight offer priced with the Amadeus Flight Offers Price API, books it unchanged with the traveler's identity and contact details, and prints the booking references returned by Amadeus.

## Prerequisites

### 1. Get Amadeus API credentials

Obtain an API key and API secret for Amadeus Enterprise APIs through your Amadeus account manager. The Amadeus Self-Service portal was decommissioned on 17 July 2026, so new credentials can no longer be created there. The key and secret are used as the client ID and client secret of the OAuth 2.0 client credentials grant.

### 2. Price the flight offer

Price the round-trip offer to book with the Flight Offers Price API and save its full JSON response as `flight_offers_price.json` in this example's directory. The offer is booked as returned, including its price and traveler pricings, so it must be priced for one traveler with id `1`.

### 3. Configuration

Create a `Config.toml` file in this example's directory with the following content:

```toml
clientId = "<api-key>"
clientSecret = "<api-secret>"
tokenUrl = "<token-endpoint, e.g. https://api.amadeus.com/v1/security/oauth2/token, or https://test.api.amadeus.com/v1/security/oauth2/token for the test environment>"
serviceUrl = "<booking-endpoint, e.g. https://api.amadeus.com/v1/booking, or https://test.api.amadeus.com/v1/booking for the test environment>"
pricingResponsePath = "flight_offers_price.json"
travelerFirstName = "<first-name>"
travelerLastName = "<last-name>"
travelerDateOfBirth = "<date-of-birth, e.g. 1982-01-16>"
travelerEmail = "<email-address>"
travelerPhone = "<phone-number>"
travelerCountryCallingCode = "<country-calling-code, e.g. 33>"
```

## Run the example

Execute the following command to run the example:

```bash
bal run
```
