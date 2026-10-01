# Ballerina Recurly connector

[![Build](https://github.com/ballerina-platform/module-ballerinax-recurly/actions/workflows/ci.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-recurly/actions/workflows/ci.yml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-recurly.svg)](https://github.com/ballerina-platform/module-ballerinax-recurly/commits/main)
[![GitHub Issues](https://img.shields.io/github/issues/ballerina-platform/ballerina-library/module/recurly.svg?label=Open%20Issues)](https://github.com/ballerina-platform/ballerina-library/labels/module%2Frecurly)

## Overview

[Recurly](https://recurly.com/) is a subscription management and recurring billing platform that handles plans, accounts, subscriptions, invoices, coupons and payment collection for subscription businesses.

The Recurly connector lets Ballerina applications manage the full billing lifecycle through the Recurly V3 REST API. It supports version `v2021-02-25` of the API.


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

## Build from the source

### Setting up the prerequisites

1. Download and install Java SE Development Kit (JDK) version 21. You can download it from either of the following sources:

    * [Oracle JDK](https://www.oracle.com/java/technologies/downloads/)
    * [OpenJDK](https://adoptium.net/)

   > **Note:** After installation, remember to set the `JAVA_HOME` environment variable to the directory where JDK was installed.

2. Download and install [Ballerina Swan Lake](https://ballerina.io/).

3. Download and install [Docker](https://www.docker.com/get-started).

   > **Note**: Ensure that the Docker daemon is running before executing any tests.

4. Export Github Personal access token with read package permissions as follows,

    ```bash
    export packageUser=<Username>
    export packagePAT=<Personal access token>
    ```

### Build options

Execute the commands below to build from the source.

1. To build the package:

   ```bash
   ./gradlew clean build
   ```

2. To run the tests:

   ```bash
   ./gradlew clean test
   ```

3. To build the without the tests:

   ```bash
   ./gradlew clean build -x test
   ```

4. To run tests against different environments:

   ```bash
   ./gradlew clean test -Pgroups=<Comma separated groups/test cases>
   ```

5. To debug the package with a remote debugger:

   ```bash
   ./gradlew clean build -Pdebug=<port>
   ```

6. To debug with the Ballerina language:

   ```bash
   ./gradlew clean build -PbalJavaDebug=<port>
   ```

7. Publish the generated artifacts to the local Ballerina Central repository:

    ```bash
    ./gradlew clean build -PpublishToLocalCentral=true
    ```

8. Publish the generated artifacts to the Ballerina Central repository:

   ```bash
   ./gradlew clean build -PpublishToCentral=true
   ```

## Contribute to Ballerina

As an open-source project, Ballerina welcomes contributions from the community.

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct

All the contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).

## Useful links

* For more information go to the [`recurly` package](https://central.ballerina.io/ballerinax/recurly/latest).
* For example demonstrations of the usage, go to [Ballerina By Examples](https://ballerina.io/learn/by-example/).
* Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
