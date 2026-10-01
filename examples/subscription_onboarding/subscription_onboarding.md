# Subscription onboarding

This example looks up a plan by its code, and when confirmed creates a customer account, subscribes it to the plan and reads the account balance.

## Prerequisites

### 1. Get a Recurly API key

Create a private API key in the [API Credentials](https://app.recurly.com/go/developer/api_keys) page of your Recurly site.

### 2. Configuration

Create a `Config.toml` file in this example's directory with the following content:

```toml
apiKey = "<recurly-api-key>"
planCode = "<plan-code>"
accountCode = "<new-account-code>"
accountEmail = "<account-email>"
firstName = "<first-name>"
lastName = "<last-name>"
currency = "<currency-code, e.g. USD>"
confirmSubscription = false
```

Creating an account and a subscription changes billing data, so the example only does this when `confirmSubscription` is `true`. Otherwise it only verifies the plan.

## Run the example

Execute the following command to run the example:

```bash
bal run
```
