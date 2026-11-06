# Examples

The `ballerinax/recurly` connector provides practical examples illustrating usage in various scenarios.

1. **[Subscription onboarding](https://github.com/ballerina-platform/module-ballerinax-recurly/tree/main/examples/subscription_onboarding)** - Verify a plan, create an account, subscribe it to the plan and read its balance.

2. **[Invoice collection review](https://github.com/ballerina-platform/module-ballerinax-recurly/tree/main/examples/invoice_collection_review)** - List an account's past due invoices, review their balances and optionally collect them.

## Prerequisites

1. Create a Recurly API key as described in the [Setup guide](https://central.ballerina.io/ballerinax/recurly/latest#setup-guide).

2. For each example, create a `Config.toml` file with the related configuration. Here's an example of how your Config.toml file should look:

```toml
apiKey = "<recurly-api-key>"
```

## Running an example

Execute the following commands to build an example from the source:

* To build an example:

    ```bash
    bal build
    ```

* To run an example:

    ```bash
    bal run
    ```

## Building the examples with the local module

**Warning**: Due to the absence of support for reading local repositories for single Ballerina files, the Bala of the module is manually written to the central repository as a workaround. Consequently, the bash script may modify your local Ballerina repositories.

Execute the following commands to build all the examples against the changes you have made to the module locally:

* To build all the examples:

    ```bash
    ./build.sh build
    ```

* To run all the examples:

    ```bash
    ./build.sh run
    ```
