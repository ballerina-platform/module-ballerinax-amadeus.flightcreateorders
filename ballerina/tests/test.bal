// Copyright (c) 2026, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/http;
import ballerina/oauth2;
import ballerina/os;
import ballerina/test;

final boolean isLiveServer = os:getEnv("IS_LIVE_SERVER") == "true";
final string serviceUrl = isLiveServer ? "https://test.api.amadeus.com/v1/booking" : "http://localhost:9090";
final string clientId = isLiveServer ? os:getEnv("AMADEUS_CLIENT_ID") : "test_client_id";
final string clientSecret = isLiveServer ? os:getEnv("AMADEUS_CLIENT_SECRET") : "test_client_secret";

function initClient() returns Client|error {
    if isLiveServer {
        return new ({
            auth: {
                tokenUrl: "https://test.api.amadeus.com/v1/security/oauth2/token",
                clientId,
                clientSecret
            }
        }, serviceUrl);
    }
    return new ({
        auth: {tokenUrl: "http://localhost:9444/oauth2/token", clientId, clientSecret, clientConfig: {httpVersion: oauth2:HTTP_1_1}},
        httpVersion: http:HTTP_1_1
    }, serviceUrl);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testCreateFlightOrder() returns error? {
    if isLiveServer {
        return;
    }
    Client amadeus = check initClient();
    FlightOrderQuery payload = {
        data: {
            'type: "flight-order",
            flightOffers: [
                {
                    'type: "flight-offer",
                    id: "1",
                    'source: "GDS",
                    itineraries: [
                        {
                            segments: [
                                {
                                    departure: {iataCode: "GIG", at: "2026-03-01T21:05:00"},
                                    arrival: {iataCode: "MAD", at: "2026-03-02T12:20:00"},
                                    carrierCode: "KL",
                                    number: "2410"
                                }
                            ]
                        }
                    ]
                }
            ],
            travelers: [
                {
                    id: "1",
                    dateOfBirth: "1982-01-16",
                    name: {firstName: "JORGE", lastName: "GONZALES"},
                    gender: "MALE"
                }
            ]
        }
    };
    Success_Booking response = check amadeus->createFlightOrder(payload);
    test:assertEquals(response.data.'type, "flight-order");
    test:assertTrue(response.data.id is string);
    test:assertEquals(response.data.flightOffers.length(), 1);
}

@test:Config {groups: ["mock_tests"]}
function testCreateFlightOrderWithoutOffers() returns error? {
    Client amadeus = check initClient();
    FlightOrderQuery payload = {data: {'type: "flight-order", flightOffers: []}};
    Success_Booking|error response = amadeus->createFlightOrder(payload);
    test:assertTrue(response is error);
}
