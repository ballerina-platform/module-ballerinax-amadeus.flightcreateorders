_Author_:  @DimuthuMadushan \
_Created_: 2026/10/16 \
_Updated_: 2026/10/16 \
_Edition_: Swan Lake

# Sanitation for OpenAPI specification

This document records the sanitation done on top of the official OpenAPI specification from Amadeus Flight Create Orders. 
The OpenAPI specification is obtained from [https://github.com/wso2/api-specs/blob/main/openapi/amadeus/flightcreateorders/1.10.0/openapi.json](https://github.com/wso2/api-specs/blob/main/openapi/amadeus/flightcreateorders/1.10.0/openapi.json).
These changes are done in order to improve the overall usability, and as workarounds for some known language limitations.


1. Update the API Paths
- **Original**: Paths included common prefix `/booking` in each endpoint.
- **Updated**: Common prefix removed from endpoints as it is now in the base URL.
- **Reason**: Simplifies API paths and avoids duplication.
<!-- auto-generated -->

2. Add the OAuth 2.0 security scheme
- **Original**: The specification declares no `securityDefinitions` and no top-level `security`, so the generated client has no `auth` configuration.
- **Updated**: Added an `oauth2` security definition (`flow: application`, token URL `https://api.amadeus.com/v1/security/oauth2/token`, the production endpoint — see item 4 — no scopes) and a top-level `security` requirement referencing it. The aligned spec carries it as a `clientCredentials` flow.
- **Reason**: Amadeus self-service APIs authenticate with the OAuth 2.0 client credentials grant, using the application's API key and secret.

3. Rename the operation `createFligtOrders` to `createFlightOrder`
- **Original**: `operationId` `createFligtOrders` (vendor typo) on `POST /booking/flight-orders`.
- **Updated**: `createFlightOrder`, recorded in `ai-mappings.json` against the aligned path `/flight-orders` and method `post`. The change lives in the aligned spec and is reproduced from `ai-mappings.json` on a re-align.
- **Reason**: Fixes the typo in the public method name.

4. Point the server at the production environment
- **Original**: `host` `test.api.amadeus.com`, so the client's default service URL was the test environment `https://test.api.amadeus.com/v1/booking`.
- **Updated**: `host` `api.amadeus.com`, giving the default service URL `https://api.amadeus.com/v1/booking`. The OAuth 2.0 token URL added in item 2 uses the matching production host, since a token issued by one environment is not accepted by the other.
- **Reason**: The connector's defaults should target the production API. The test environment stays available by passing its service URL and token URL explicitly.

5. Rewrite the API description
- **Original**: `info.description` covered only a pointer to the authorization guide and a note about test-environment data.
- **Updated**: A short summary of what the API does (creates flight orders from priced flight offers), how it authenticates (OAuth 2.0 client credentials) and that it targets production by default.
- **Reason**: `info.description` becomes the doc comment of the generated `Client`, so it should explain the client to a Ballerina user.

6. Add missing field descriptions
- **Original**: These properties had no `description`: `Tax.amount`, `Tax.code`, `Fee.amount`, `B2bWallet.reportingData`, the `additionalServices` array of the extended price, the `number` and `category` of `AutomatedProcessCommon.queue`, the inline `additionalServices` object (`AdditionalServicesRequest`) of the segment fare details, and the `AllotmentDetails` schema.
- **Updated**: Added a short description to each, in the original spec. `AllotmentDetails` is referenced by `$ref`, so its description sits on the schema itself, where the generator reads it for the referencing field.
- **Reason**: Fields without a description generate undocumented record fields, which `bal build` reports as `undocumented field` warnings.

7. Correct two string patterns
- **Original**: `EmergencyContact.addresseeName` had the pattern `[a-zA-Z -]` and `Phone.countryCallingCode` had `[0-9+]{2,5}`.
- **Updated**: `[a-zA-Z -]+` and `[0-9+]{1,5}`, in the original spec.
- **Reason**: Ballerina constraints match the whole value, so `[a-zA-Z -]` accepted only a one-character name, and `{2,5}` rejected the documented calling code `1` for the US. The connector validates responses against these patterns by default, so valid values failed in both directions.

## OpenAPI cli command

The following command was used to generate the Ballerina client from the OpenAPI specification. The command should be executed from the repository root directory.

```bash
bal openapi -i docs/spec/aligned_ballerina_openapi.json -o ballerina --mode client --license docs/license.txt --client-methods remote
```

Note: The license year is hardcoded to 2026, change if necessary.
