// Onboards a customer: checks that the plan exists, creates the account and, once
// confirmed, subscribes the account to the plan.

import ballerina/io;
import ballerinax/recurly;

configurable string apiKey = ?;
configurable string planCode = ?;
configurable string accountCode = ?;
configurable string accountEmail = ?;
configurable string firstName = ?;
configurable string lastName = ?;
configurable string currency = ?;
configurable boolean confirmSubscription = false;

public function main() returns error? {
    // Recurly expects an empty password; a single space is sent because the HTTP client rejects empty ones.
    recurly:Client recurlyClient = check new ({auth: {username: apiKey, password: " "}});

    // Step 1: Make sure the requested plan exists and is active.
    recurly:Plan plan = check recurlyClient->getPlan("code-" + planCode);
    if plan.state != "active" {
        return error("Plan " + planCode + " is not active");
    }
    io:println("Plan found: ", plan.name, " (", plan.code, ")");

    if !confirmSubscription {
        io:println("confirmSubscription is false, skipping account creation and subscription.");
        return;
    }

    // Step 2: Create the account.
    recurly:Account account = check recurlyClient->createAccount({
        code: accountCode,
        email: accountEmail,
        firstName: firstName,
        lastName: lastName
    });
    io:println("Account created: ", account.id);

    // Step 3: Subscribe the account to the plan.
    recurly:Subscription subscription = check recurlyClient->createSubscription({
        planCode: planCode,
        currency: currency,
        account: {code: accountCode}
    });
    io:println("Subscription ", subscription.id, " is ", subscription.state);

    // Step 4: Show the balance of the new account.
    recurly:AccountBalance balance = check recurlyClient->getAccountBalance(account.id ?: "code-" + accountCode);
    io:println("Past due: ", balance.pastDue);
}
