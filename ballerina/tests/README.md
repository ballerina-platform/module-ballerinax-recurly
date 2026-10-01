# Running tests

The tests run against a local mock server (`tests/mock_service.bal`) that covers 25 operations across accounts, billing information, coupons, invoices, plans, subscriptions and transactions.

## Run against the mock server

```bash
bal test
```

## Run against Recurly

Set the following environment variables and run the live test group:

```bash
export IS_LIVE_SERVER=true
export RECURLY_API_KEY=<private API key>
bal test --groups live_tests
```

Only the list operations run live; the mutating operations are covered by the mock server only.
