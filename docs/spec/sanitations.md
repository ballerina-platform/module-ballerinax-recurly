_Author_:  Dimuthu Madushan \
_Created_: 2026/10/01 \
_Updated_: 2026/10/01 \
_Edition_: Swan Lake

# Sanitation for OpenAPI specification

This document records the sanitation done on top of the official OpenAPI specification from Recurly. 
The OpenAPI specification is obtained from [wso2/api-specs](https://github.com/wso2/api-specs/blob/main/openapi/recurly/recurly/v2021-02-25/openapi.yaml).
These changes are done in order to improve the overall usability, and as workarounds for some known language limitations.

1. Replace references to properties of another schema with references to the enum schemas
- **Original**: `PurchaseCreate.transaction.initiator` and `merchant_reason_code` referenced `#/components/schemas/Transaction/properties/initiator` and `.../merchant_reason_code`.
- **Updated**: They reference `#/components/schemas/TransactionInitiatorEnum` and `#/components/schemas/TransactionMerchantReasonCodeEnum`.
- **Reason**: `bal openapi flatten` turns a `$ref` to a schema property into a reference to a non-existent schema, which makes client generation fail.

2. Convert JavaScript-style regular expression literals in `pattern` to plain patterns
- **Original**: Patterns such as `/^[a-z0-9_+-]+$/` and `/^[a-z0-9_-]+$/i` (plan codes, item codes, coupon codes and others).
- **Updated**: The enclosing slashes are removed (`^[a-z0-9_+-]+$`) and the `i` flag is expanded into explicit upper and lower case ranges (`^[a-zA-Z0-9_+-]+$`).
- **Reason**: Ballerina treats the slashes as part of the regular expression, so the generated constraint rejected every valid value (for example every plan code).

3. Remove the duplicate `Address` member from `InvoiceAddress`
- **Original**: `InvoiceAddress` is `allOf` of `Address` and `AddressWithName`, and `AddressWithName` already extends `Address`.
- **Updated**: `InvoiceAddress` is `allOf` of `AddressWithName` only.
- **Reason**: The generated record included `Address` twice, which fails with "redeclared type reference".

4. Rename operation IDs to camelCase and shorten names that exceed 37 characters
- **Original**: snake_case operation IDs such as `list_accounts`, plus `get_a_billing_info`, `put_external_subscription` and `put_dunning_campaign_bulk_update`, and `external_product_external_product_reference` style names over 37 characters.
- **Updated**: camelCase IDs (`listAccounts`), `getBillingInfoById`, `upsertExternalSubscription`, `bulkUpdateDunningCampaign` and shortened `ExternalProductReference`, `ExternalSubscriptionInvoices` and `ExternalSubscriptionPhases` names.
- **Reason**: Ballerina method names must be camelCase, must not start with an HTTP verb and are limited to 37 characters. The decisions are stored in `docs/spec/ai-mappings.json`. The summary of `DELETE /accounts/{accountId}/billing_infos/{billingInfoId}` was changed to "Remove a specific billing information of an account" because it duplicated the summary of the account-level operation.

5. Replace the API description with a concise summary
- **Original**: `info.description` held the full "Getting Started" guide (versioning, authentication, pagination, idempotency and the change log), about 210 lines of Markdown.
- **Updated**: `info.description` is "Manage Recurly accounts, plans, subscriptions, invoices, coupons and transactions through the Recurly V3 REST API (v2021-02-25)."
- **Reason**: The description becomes the doc comment of the generated `Client` class, where the vendor guide is too long and partly irrelevant to Ballerina users.

6. Change `AccountAcquisitionUpdate.cost` from `object` to `array`
- **Original**: The `cost` field was defined as a `object`.
- **Updated**: The `cost` field has been changed to `array`.
- **Reason**: The API returns cost as array; updated for accurate representation.

## OpenAPI cli command

The following command was used to generate the Ballerina client from the OpenAPI specification. The command should be executed from the repository root directory.

```bash
bal openapi -i docs/spec/aligned_ballerina_openapi.json -o ballerina --mode client --license docs/license.txt --client-methods remote
```

Note: The license year is hardcoded to 2024, change if necessary.
