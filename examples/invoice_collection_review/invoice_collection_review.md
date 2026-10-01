# Invoice collection review

This example lists the past due invoices of an account, re-reads each one to show its current balance and, when enabled, attempts to collect them.

## Prerequisites

### 1. Get a Recurly API key

Create a private API key in the [API Credentials](https://app.recurly.com/go/developer/api_keys) page of your Recurly site.

### 2. Configuration

Create a `Config.toml` file in this example's directory with the following content:

```toml
apiKey = "<recurly-api-key>"
accountId = "<account-id-or-code-prefixed-code>"
pageSize = 50
collectPastDue = false
```

Collecting an invoice charges the customer's payment method, so the example only does this when `collectPastDue` is `true`.

## Run the example

Execute the following command to run the example:

```bash
bal run
```
