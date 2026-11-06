## Overview

[Recurly](https://recurly.com/) is a subscription management and recurring billing platform that handles plans, accounts, subscriptions, invoices, coupons and payment collection for subscription businesses.

The Recurly connector lets Ballerina applications manage the full billing lifecycle through the Recurly V3 REST API. It supports version `v2021-02-25` of the API.

### Key features

- Create and maintain customer accounts, billing information, shipping addresses and account notes
- Define plans, add-ons, items and price segments, and manage subscriptions including pause, cancel, reactivate and plan changes
- Generate, collect, refund and void invoices and track line items, credit payments and transactions
- Create coupons, unique coupon codes, gift cards and redemptions
- Work with external subscriptions, external products and external invoices for app-store billing
- Export data and review usage, entitlements, dunning campaigns and business entities

## Setup guide

To use the Recurly connector, you need a Recurly site and a private API key.

### Step 1: Sign in to Recurly

1. Sign in to your [Recurly](https://app.recurly.com/login) account. If you do not have an account, sign up for one.

2. Select the site you want to connect to.

### Step 2: Create an API key

1. Open the [API Credentials](https://app.recurly.com/go/developer/api_keys) page of your site.

2. Create a new private API key and copy its value.

### Step 3: Choose the API region

The connector targets `https://v3.recurly.com` by default. Sites hosted in the EU region use `https://v3.eu.recurly.com`, which you can pass as the `serviceUrl` when creating the client.

## Quickstart

To use the Recurly connector in your Ballerina application, update the `.bal` file as follows:

### Step 1: Import the module

Import the `recurly` module.

```ballerina
import ballerinax/recurly;
```

### Step 2: Instantiate a new connector

1. Create a `Config.toml` file and configure the API key obtained in the steps above:

```toml
apiKey = "<API key>"
```

2. Create a `recurly:ConnectionConfig` with the API key as the username and initialize the connector with it. Recurly expects an empty password, so a single space is used because the HTTP client does not accept an empty one.

```ballerina
configurable string apiKey = ?;

final recurly:Client recurlyClient = check new ({
    auth: {
        username: apiKey,
        password: " "
    }
});
```

### Step 3: Invoke the connector operation

Now, utilize the available connector operations.

#### List the site's accounts

```ballerina
public function main() returns error? {
    recurly:AccountList _ = check recurlyClient->listAccounts({"Accept": "application/vnd.recurly.v2021-02-25+json"}, 'limit = 10);
}
```

### Step 4: Run the Ballerina application

```bash
bal run
```

## Examples

The Recurly connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-recurly/tree/main/examples/), covering the following use cases:

1. [Subscription onboarding](https://github.com/ballerina-platform/module-ballerinax-recurly/tree/main/examples/subscription_onboarding) - Verify a plan, create an account, subscribe it to the plan and read its balance.

2. [Invoice collection review](https://github.com/ballerina-platform/module-ballerinax-recurly/tree/main/examples/invoice_collection_review) - List an account's past due invoices, review their balances and optionally collect them.
