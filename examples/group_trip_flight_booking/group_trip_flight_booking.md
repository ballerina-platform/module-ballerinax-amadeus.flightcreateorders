# Group trip flight booking

This example books a one-way flight order for a group of travelers. It takes a flight offer priced with the Amadeus Flight Offers Price API, books it unchanged for the configured passengers with a group contact, and prints each traveler that Amadeus recorded on the order.

## Prerequisites

### 1. Get Amadeus API credentials

Obtain an API key and API secret for Amadeus Enterprise APIs through your Amadeus account manager. The Amadeus Self-Service portal was decommissioned on 17 July 2026, so new credentials can no longer be created there. The key and secret are used as the client ID and client secret of the OAuth 2.0 client credentials grant.

### 2. Price the flight offer

Price the offer to book with the Flight Offers Price API and save its full JSON response as `flight_offers_price.json` in this example's directory. The offer is booked as returned, including its price and traveler pricings, so it must be priced for the same number of travelers as `passengers`, with traveler ids `1`, `2`, … in the order the passengers are listed.

### 3. Configuration

Create a `Config.toml` file in this example's directory with the following content. `passengers` takes between 1 and 18 entries, the most a single flight order holds.

```toml
clientId = "<api-key>"
clientSecret = "<api-secret>"
tokenUrl = "<token-endpoint, e.g. https://api.amadeus.com/v1/security/oauth2/token, or https://test.api.amadeus.com/v1/security/oauth2/token for the test environment>"
serviceUrl = "<booking-endpoint, e.g. https://api.amadeus.com/v1/booking, or https://test.api.amadeus.com/v1/booking for the test environment>"
pricingResponsePath = "flight_offers_price.json"
groupContactEmail = "<contact-email-address>"

passengers = [
    {firstName = "<first-name>", lastName = "<last-name>", dateOfBirth = "<date-of-birth, e.g. 1982-01-16>"},
    {firstName = "<first-name>", lastName = "<last-name>", dateOfBirth = "<date-of-birth>"}
]
```

## Run the example

Execute the following command to run the example:

```bash
bal run
```
