
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

import ballerina/os;
import ballerina/test;

final boolean isLiveServer = os:getEnv("IS_LIVE_SERVER") == "true";
final string serviceUrl = isLiveServer ? "https://v3.recurly.com" : "http://localhost:9090";
final string apiKey = isLiveServer ? os:getEnv("RECURLY_API_KEY") : "test_api_key";

// Recurly expects an empty password; the Ballerina HTTP client rejects empty basic-auth passwords, so a single space is sent.
final string apiPassword = isLiveServer ? " " : "mock_password";

final Client recurly = check new ({auth: {username: apiKey, password: apiPassword}, httpVersion: isLiveServer ? "2.0" : "1.1"}, serviceUrl);

const string ACCOUNT_ID = "e28zov4fw0v2";
const string PLAN_ID = "plan-4001";
const string INVOICE_ID = "inv-1001";
const string SUBSCRIPTION_ID = "sub-2001";
const string COUPON_ID = "cpn-3001";

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListAccounts() returns error? {
    AccountList response = check recurly->listAccounts();
    test:assertTrue(response.data is Account[]);
}

@test:Config {groups: ["mock_tests"], enable: !isLiveServer}
isolated function testCreateAccount() returns error? {
    Account response = check recurly->createAccount({code: "acme-corp", email: "billing@acme.example"});
    test:assertEquals(response.code, "acme-corp");
}

@test:Config {groups: ["mock_tests"], enable: !isLiveServer}
isolated function testGetAccount() returns error? {
    Account response = check recurly->getAccount(ACCOUNT_ID);
    test:assertEquals(response.id, ACCOUNT_ID);
}

@test:Config {groups: ["mock_tests"], enable: !isLiveServer}
isolated function testUpdateAccount() returns error? {
    Account response = check recurly->updateAccount(ACCOUNT_ID, {email: "billing@acme.example"});
    test:assertEquals(response.id, ACCOUNT_ID);
}

@test:Config {groups: ["mock_tests"], enable: !isLiveServer}
isolated function testDeactivateAccount() returns error? {
    Account response = check recurly->deactivateAccount(ACCOUNT_ID);
    test:assertEquals(response.state, "inactive");
}

@test:Config {groups: ["mock_tests"], enable: !isLiveServer}
isolated function testGetAccountBalance() returns error? {
    AccountBalance response = check recurly->getAccountBalance(ACCOUNT_ID);
    test:assertTrue(response.balances is AccountBalanceAmount[]);
}

@test:Config {groups: ["mock_tests"], enable: !isLiveServer}
isolated function testGetBillingInfo() returns error? {
    BillingInfo response = check recurly->getBillingInfo(ACCOUNT_ID);
    test:assertEquals(response.accountId, ACCOUNT_ID);
}

@test:Config {groups: ["mock_tests"], enable: !isLiveServer}
isolated function testListAccountInvoices() returns error? {
    InvoiceList response = check recurly->listAccountInvoices(ACCOUNT_ID);
    test:assertTrue(response.data is Invoice[]);
}

@test:Config {groups: ["mock_tests"], enable: !isLiveServer}
isolated function testListAccountSubscriptions() returns error? {
    SubscriptionList response = check recurly->listAccountSubscriptions(ACCOUNT_ID);
    test:assertTrue(response.data is Subscription[]);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListCoupons() returns error? {
    CouponList response = check recurly->listCoupons();
    test:assertTrue(response.data is Coupon[]);
}

@test:Config {groups: ["mock_tests"], enable: !isLiveServer}
isolated function testCreateCoupon() returns error? {
    Coupon response = check recurly->createCoupon({code: "SUMMER15", name: "Summer discount", discountType: "percent"});
    test:assertTrue(response.id is string);
}

@test:Config {groups: ["mock_tests"], enable: !isLiveServer}
isolated function testGetCoupon() returns error? {
    Coupon response = check recurly->getCoupon(COUPON_ID);
    test:assertEquals(response.id, COUPON_ID);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListInvoices() returns error? {
    InvoiceList response = check recurly->listInvoices();
    test:assertTrue(response.data is Invoice[]);
}

@test:Config {groups: ["mock_tests"], enable: !isLiveServer}
isolated function testGetInvoice() returns error? {
    Invoice response = check recurly->getInvoice(INVOICE_ID);
    test:assertEquals(response.id, INVOICE_ID);
}

@test:Config {groups: ["mock_tests"], enable: !isLiveServer}
isolated function testCollectInvoice() returns error? {
    Invoice response = check recurly->collectInvoice(INVOICE_ID, {});
    test:assertEquals(response.state, "paid");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListPlans() returns error? {
    PlanList response = check recurly->listPlans();
    test:assertTrue(response.data is Plan[]);
}

@test:Config {groups: ["mock_tests"], enable: !isLiveServer}
isolated function testCreatePlan() returns error? {
    Plan response = check recurly->createPlan({code: "gold", name: "Gold Plan", currencies: [{currency: "USD", unitAmount: 49.99}]});
    test:assertTrue(response.id is string);
}

@test:Config {groups: ["mock_tests"], enable: !isLiveServer}
isolated function testGetPlan() returns error? {
    Plan response = check recurly->getPlan(PLAN_ID);
    test:assertEquals(response.id, PLAN_ID);
}

@test:Config {groups: ["mock_tests"], enable: !isLiveServer}
isolated function testUpdatePlan() returns error? {
    Plan response = check recurly->updatePlan(PLAN_ID, {description: "Gold tier monthly subscription"});
    test:assertEquals(response.id, PLAN_ID);
}

@test:Config {groups: ["mock_tests"], enable: !isLiveServer}
isolated function testRemovePlan() returns error? {
    Plan response = check recurly->removePlan(PLAN_ID);
    test:assertEquals(response.id, PLAN_ID);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListSubscriptions() returns error? {
    SubscriptionList response = check recurly->listSubscriptions();
    test:assertTrue(response.data is Subscription[]);
}

@test:Config {groups: ["mock_tests"], enable: !isLiveServer}
isolated function testCreateSubscription() returns error? {
    Subscription response = check recurly->createSubscription({planCode: "gold", currency: "USD", account: {code: "acme-corp"}});
    test:assertTrue(response.id is string);
}

@test:Config {groups: ["mock_tests"], enable: !isLiveServer}
isolated function testGetSubscription() returns error? {
    Subscription response = check recurly->getSubscription(SUBSCRIPTION_ID);
    test:assertEquals(response.id, SUBSCRIPTION_ID);
}

@test:Config {groups: ["mock_tests"], enable: !isLiveServer}
isolated function testCancelSubscription() returns error? {
    Subscription response = check recurly->cancelSubscription(SUBSCRIPTION_ID, {});
    test:assertEquals(response.state, "canceled");
}

@test:Config {groups: ["mock_tests"], enable: !isLiveServer}
isolated function testGetTransaction() returns error? {
    Transaction response = check recurly->getTransaction("txn-5001");
    test:assertEquals(response.id, "txn-5001");
}
