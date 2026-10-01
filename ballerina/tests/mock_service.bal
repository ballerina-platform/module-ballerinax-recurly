
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

listener http:Listener ep0 = new (9090);

service / on ep0 {
    # Deactivate an account
    #
    # + accountId - Account ID or code. For ID no prefix is used e.g. `e28zov4fw0v2`. For code use prefix `code-`, e.g. `code-bob`
    # + redact - Permanently removes all personally identifiable information (PII) from this account after it has been deactivated, to fulfill a data subject's right to erasure under GDPR and similar privacy regulations (e.g. CCPA). Cannot be undone
    # + return - returns can be any of following types 
    # http:Ok (An account)
    # http:UnprocessableEntity (Account may already be inactive.)
    # http:DefaultStatusCodeResponse (Unexpected error.)
    resource function delete accounts/[string accountId](boolean? redact) returns Account|ErrorUnprocessableEntity|ErrorDefault {
        return accountFixture(accountId, "inactive");
    }

    # Remove a plan
    #
    # + planId - Plan ID or code. For ID no prefix is used e.g. `e28zov4fw0v2`. For code use prefix `code-`, e.g. `code-gold`
    # + return - returns can be any of following types 
    # http:Ok (Plan deleted)
    # http:NotFound (Incorrect site or plan ID.)
    resource function delete plans/[string planId]() returns Plan|ErrorNotFound {
        return planFixture(planId);
    }

    # List a site's accounts
    #
    # + ids - Filter results by their IDs. Up to 200 IDs can be passed at once using
    # commas as separators, e.g. `ids=h1at4d57xlmy,gyqgg0d3v9n1,jrsm5b4yefg6`.
    # **Important notes:**
    # * The `ids` parameter cannot be used with any other ordering or filtering
    # parameters (`limit`, `order`, `sort`, `begin_time`, `end_time`, etc)
    # * Invalid or unknown IDs will be ignored, so you should check that the
    # results correspond to your request.
    # * Records are returned in an arbitrary order. Since results are all
    # returned at once you can sort the records yourself
    # + 'limit - Limit number of records 1-200
    # + 'order - Sort order
    # + sort - Sort field. You *really* only want to sort by `updated_at` in ascending
    # order. In descending order updated records will move behind the cursor and could
    # prevent some records from being returned
    # + beginTime - Inclusively filter by begin_time when `sort=created_at` or `sort=updated_at`.
    # **Note:** this value is an ISO8601 timestamp. A partial timestamp that does not include a time zone will default to UTC
    # + endTime - Inclusively filter by end_time when `sort=created_at` or `sort=updated_at`.
    # **Note:** this value is an ISO8601 timestamp. A partial timestamp that does not include a time zone will default to UTC
    # + email - Filter for accounts with this exact email address. A blank value will return accounts with both `null` and `""` email addresses. Note that multiple accounts can share one email address
    # + subscriber - Filter for accounts with or without a subscription in the `active`,
    # `canceled`, or `future` state
    # + pastDue - Filter for accounts with an invoice in the `past_due` state
    # + return - returns can be any of following types 
    # http:Ok (A list of the site's accounts)
    # http:BadRequest (Invalid or unpermitted parameter.)
    # http:NotFound (Incorrect site ID.)
    # http:DefaultStatusCodeResponse (Unexpected error.)
    resource function get accounts(string[]? ids, AlphanumericSortEnum? 'order, TimestampSortEnum? sort, @http:Query {name: "begin_time"} string? beginTime, @http:Query {name: "end_time"} string? endTime, string? email, boolean? subscriber, @http:Query {name: "past_due"} TrueEnum? pastDue, int 'limit = 20) returns AccountList|ErrorBadRequest|ErrorNotFound|ErrorDefault {
        AccountList list = {'object: "list", hasMore: false, data: [accountFixture("e28zov4fw0v2", "active"), accountFixture("e28zov4fw0v3", "active")]};
        return list;
    }

    # Fetch an account
    #
    # + accountId - Account ID or code. For ID no prefix is used e.g. `e28zov4fw0v2`. For code use prefix `code-`, e.g. `code-bob`
    # + return - returns can be any of following types 
    # http:Ok (An account)
    # http:DefaultStatusCodeResponse (Unexpected error.)
    resource function get accounts/[string accountId]() returns Account|ErrorDefault {
        return accountFixture(accountId, "active");
    }

    # Fetch an account's balance and past due status
    #
    # + accountId - Account ID or code. For ID no prefix is used e.g. `e28zov4fw0v2`. For code use prefix `code-`, e.g. `code-bob`
    # + return - returns can be any of following types 
    # http:Ok (An account's balance)
    # http:NotFound (Incorrect site or account ID.)
    # http:DefaultStatusCodeResponse (Unexpected error.)
    resource function get accounts/[string accountId]/balance() returns AccountBalance|ErrorNotFound|ErrorDefault {
        AccountBalance balance = {'object: "account_balance", pastDue: false, account: {id: accountId, code: "acme-corp", email: "billing@acme.example", 'object: "account_mini"}, balances: [{currency: "USD", amount: 125.5, availableCreditAmount: 0.0, processingPrepaymentAmount: 0.0}]};
        return balance;
    }

    # Fetch an account's billing information
    #
    # + accountId - Account ID or code. For ID no prefix is used e.g. `e28zov4fw0v2`. For code use prefix `code-`, e.g. `code-bob`
    # + return - returns can be any of following types 
    # http:Ok (An account's billing information)
    # http:NotFound (Account has no billing information, or incorrect site or account ID.)
    # http:DefaultStatusCodeResponse (Unexpected error.)
    resource function get accounts/[string accountId]/billing_info() returns BillingInfo|ErrorNotFound|ErrorDefault {
        BillingInfo info = {id: "kgg0r7o1q3b2", 'object: "billing_info", accountId: accountId, firstName: "Ada", lastName: "Lovelace", company: "Acme Corp", valid: true, primaryPaymentMethod: true, backupPaymentMethod: false, createdAt: "2026-01-12T09:30:00Z", updatedAt: "2026-02-01T11:00:00Z"};
        return info;
    }

    # List an account's invoices
    #
    # + accountId - Account ID or code. For ID no prefix is used e.g. `e28zov4fw0v2`. For code use prefix `code-`, e.g. `code-bob`
    # + ids - Filter results by their IDs. Up to 200 IDs can be passed at once using
    # commas as separators, e.g. `ids=h1at4d57xlmy,gyqgg0d3v9n1,jrsm5b4yefg6`.
    # **Important notes:**
    # * The `ids` parameter cannot be used with any other ordering or filtering
    # parameters (`limit`, `order`, `sort`, `begin_time`, `end_time`, etc)
    # * Invalid or unknown IDs will be ignored, so you should check that the
    # results correspond to your request.
    # * Records are returned in an arbitrary order. Since results are all
    # returned at once you can sort the records yourself
    # + state - Invoice state
    # + 'limit - Limit number of records 1-200
    # + 'order - Sort order
    # + sort - Sort field. You *really* only want to sort by `updated_at` in ascending
    # order. In descending order updated records will move behind the cursor and could
    # prevent some records from being returned
    # + beginTime - Inclusively filter by begin_time when `sort=created_at` or `sort=updated_at`.
    # **Note:** this value is an ISO8601 timestamp. A partial timestamp that does not include a time zone will default to UTC
    # + endTime - Inclusively filter by end_time when `sort=created_at` or `sort=updated_at`.
    # **Note:** this value is an ISO8601 timestamp. A partial timestamp that does not include a time zone will default to UTC
    # + 'type - Filter by type when:
    # - `type=charge`, only charge invoices will be returned.
    # - `type=credit`, only credit invoices will be returned.
    # - `type=non-legacy`, only charge and credit invoices will be returned.
    # - `type=legacy`, only legacy invoices will be returned
    # + return - returns can be any of following types 
    # http:Ok (A list of the account's invoices)
    # http:BadRequest (Invalid or unpermitted parameter.)
    # http:NotFound (Incorrect site or account ID.)
    # http:DefaultStatusCodeResponse (Unexpected error.)
    resource function get accounts/[string accountId]/invoices(string[]? ids, AlphanumericSortEnum? 'order, TimestampSortEnum? sort, @http:Query {name: "begin_time"} string? beginTime, @http:Query {name: "end_time"} string? endTime, FilterInvoiceTypeEnum? 'type, InvoiceStateQueryParamEnum? state, int 'limit = 20) returns InvoiceList|ErrorBadRequest|ErrorNotFound|ErrorDefault {
        InvoiceList list = {'object: "list", hasMore: false, data: [invoiceFixture("inv-1001", "paid"), invoiceFixture("inv-1002", "pending")]};
        return list;
    }

    # List an account's subscriptions
    #
    # + accountId - Account ID or code. For ID no prefix is used e.g. `e28zov4fw0v2`. For code use prefix `code-`, e.g. `code-bob`
    # + ids - Filter results by their IDs. Up to 200 IDs can be passed at once using
    # commas as separators, e.g. `ids=h1at4d57xlmy,gyqgg0d3v9n1,jrsm5b4yefg6`.
    # **Important notes:**
    # * The `ids` parameter cannot be used with any other ordering or filtering
    # parameters (`limit`, `order`, `sort`, `begin_time`, `end_time`, etc)
    # * Invalid or unknown IDs will be ignored, so you should check that the
    # results correspond to your request.
    # * Records are returned in an arbitrary order. Since results are all
    # returned at once you can sort the records yourself
    # + 'limit - Limit number of records 1-200
    # + 'order - Sort order
    # + sort - Sort field. You *really* only want to sort by `updated_at` in ascending
    # order. In descending order updated records will move behind the cursor and could
    # prevent some records from being returned
    # + beginTime - Inclusively filter by begin_time when `sort=created_at` or `sort=updated_at`.
    # **Note:** this value is an ISO8601 timestamp. A partial timestamp that does not include a time zone will default to UTC
    # + endTime - Inclusively filter by end_time when `sort=created_at` or `sort=updated_at`.
    # **Note:** this value is an ISO8601 timestamp. A partial timestamp that does not include a time zone will default to UTC
    # + state - Filter by state.
    # - When `state=active`, `state=canceled`, `state=expired`, or `state=future`, subscriptions with states that match the query and only those subscriptions will be returned.
    # - When `state=in_trial`, only subscriptions that have a trial_started_at date earlier than now and a trial_ends_at date later than now will be returned.
    # - When `state=live`, only subscriptions that are in an active, canceled, or future state or are in trial will be returned
    # + return - returns can be any of following types 
    # http:Ok (A list of the account's subscriptions)
    # http:BadRequest (Invalid or unpermitted parameter.)
    # http:NotFound (Incorrect site or account ID.)
    # http:DefaultStatusCodeResponse (Unexpected error.)
    resource function get accounts/[string accountId]/subscriptions(string[]? ids, AlphanumericSortEnum? 'order, TimestampSortEnum? sort, @http:Query {name: "begin_time"} string? beginTime, @http:Query {name: "end_time"} string? endTime, FilterSubscriptionStateEnum? state, int 'limit = 20) returns SubscriptionList|ErrorBadRequest|ErrorNotFound|ErrorDefault {
        SubscriptionList list = {'object: "list", hasMore: false, data: [subscriptionFixture("sub-2001", "active")]};
        return list;
    }

    # List a site's coupons
    #
    # + ids - Filter results by their IDs. Up to 200 IDs can be passed at once using
    # commas as separators, e.g. `ids=h1at4d57xlmy,gyqgg0d3v9n1,jrsm5b4yefg6`.
    # **Important notes:**
    # * The `ids` parameter cannot be used with any other ordering or filtering
    # parameters (`limit`, `order`, `sort`, `begin_time`, `end_time`, etc)
    # * Invalid or unknown IDs will be ignored, so you should check that the
    # results correspond to your request.
    # * Records are returned in an arbitrary order. Since results are all
    # returned at once you can sort the records yourself
    # + 'limit - Limit number of records 1-200
    # + 'order - Sort order
    # + sort - Sort field. You *really* only want to sort by `updated_at` in ascending
    # order. In descending order updated records will move behind the cursor and could
    # prevent some records from being returned
    # + beginTime - Inclusively filter by begin_time when `sort=created_at` or `sort=updated_at`.
    # **Note:** this value is an ISO8601 timestamp. A partial timestamp that does not include a time zone will default to UTC
    # + endTime - Inclusively filter by end_time when `sort=created_at` or `sort=updated_at`.
    # **Note:** this value is an ISO8601 timestamp. A partial timestamp that does not include a time zone will default to UTC
    # + return - returns can be any of following types 
    # http:Ok (A list of the site's coupons)
    # http:BadRequest (Invalid or unpermitted parameter.)
    # http:NotFound (Incorrect site ID.)
    # http:DefaultStatusCodeResponse (Unexpected error.)
    resource function get coupons(string[]? ids, AlphanumericSortEnum? 'order, TimestampSortEnum? sort, @http:Query {name: "begin_time"} string? beginTime, @http:Query {name: "end_time"} string? endTime, int 'limit = 20) returns CouponList|ErrorBadRequest|ErrorNotFound|ErrorDefault {
        CouponList list = {'object: "list", hasMore: false, data: [couponFixture("cpn-3001", "SPRING20"), couponFixture("cpn-3002", "WELCOME10")]};
        return list;
    }

    # Fetch a coupon
    #
    # + couponId - Coupon ID or code. For ID no prefix is used e.g. `e28zov4fw0v2`. For code use prefix `code-`, e.g. `code-10off`
    # + return - returns can be any of following types 
    # http:Ok (A coupon)
    # http:NotFound (Incorrect site or coupon ID.)
    # http:DefaultStatusCodeResponse (Unexpected error.)
    resource function get coupons/[string couponId]() returns Coupon|ErrorNotFound|ErrorDefault {
        return couponFixture(couponId, "SPRING20");
    }

    # List a site's invoices
    #
    # + ids - Filter results by their IDs. Up to 200 IDs can be passed at once using
    # commas as separators, e.g. `ids=h1at4d57xlmy,gyqgg0d3v9n1,jrsm5b4yefg6`.
    # **Important notes:**
    # * The `ids` parameter cannot be used with any other ordering or filtering
    # parameters (`limit`, `order`, `sort`, `begin_time`, `end_time`, etc)
    # * Invalid or unknown IDs will be ignored, so you should check that the
    # results correspond to your request.
    # * Records are returned in an arbitrary order. Since results are all
    # returned at once you can sort the records yourself
    # + state - Invoice state
    # + 'limit - Limit number of records 1-200
    # + 'order - Sort order
    # + sort - Sort field. You *really* only want to sort by `updated_at` in ascending
    # order. In descending order updated records will move behind the cursor and could
    # prevent some records from being returned
    # + beginTime - Inclusively filter by begin_time when `sort=created_at` or `sort=updated_at`.
    # **Note:** this value is an ISO8601 timestamp. A partial timestamp that does not include a time zone will default to UTC
    # + endTime - Inclusively filter by end_time when `sort=created_at` or `sort=updated_at`.
    # **Note:** this value is an ISO8601 timestamp. A partial timestamp that does not include a time zone will default to UTC
    # + 'type - Filter by type when:
    # - `type=charge`, only charge invoices will be returned.
    # - `type=credit`, only credit invoices will be returned.
    # - `type=non-legacy`, only charge and credit invoices will be returned.
    # - `type=legacy`, only legacy invoices will be returned
    # + return - returns can be any of following types 
    # http:Ok (A list of the site's invoices)
    # http:BadRequest (Invalid or unpermitted parameter.)
    # http:NotFound (Incorrect site ID.)
    # http:DefaultStatusCodeResponse (Unexpected error.)
    resource function get invoices(string[]? ids, AlphanumericSortEnum? 'order, TimestampSortEnum? sort, @http:Query {name: "begin_time"} string? beginTime, @http:Query {name: "end_time"} string? endTime, FilterInvoiceTypeEnum? 'type, InvoiceStateQueryParamEnum? state, int 'limit = 20) returns InvoiceList|ErrorBadRequest|ErrorNotFound|ErrorDefault {
        InvoiceList list = {'object: "list", hasMore: false, data: [invoiceFixture("inv-1001", "paid"), invoiceFixture("inv-1002", "pending")]};
        return list;
    }

    # Fetch an invoice
    #
    # + invoiceId - Invoice ID or number. For ID no prefix is used e.g. `e28zov4fw0v2`. For number use prefix `number-`, e.g. `number-1000`. For number with prefix or country code, use `number-` and `prefix`, e.g. `number-TEST-FR1001`
    # + return - returns can be any of following types 
    # http:Ok (An invoice)
    # http:NotFound (Incorrect site or invoice ID.)
    # http:DefaultStatusCodeResponse (Unexpected error.)
    resource function get invoices/[string invoiceId]() returns Invoice|ErrorNotFound|ErrorDefault {
        return invoiceFixture(invoiceId, "paid");
    }

    # List a site's plans
    #
    # + ids - Filter results by their IDs. Up to 200 IDs can be passed at once using
    # commas as separators, e.g. `ids=h1at4d57xlmy,gyqgg0d3v9n1,jrsm5b4yefg6`.
    # **Important notes:**
    # * The `ids` parameter cannot be used with any other ordering or filtering
    # parameters (`limit`, `order`, `sort`, `begin_time`, `end_time`, etc)
    # * Invalid or unknown IDs will be ignored, so you should check that the
    # results correspond to your request.
    # * Records are returned in an arbitrary order. Since results are all
    # returned at once you can sort the records yourself
    # + 'limit - Limit number of records 1-200
    # + 'order - Sort order
    # + sort - Sort field. You *really* only want to sort by `updated_at` in ascending
    # order. In descending order updated records will move behind the cursor and could
    # prevent some records from being returned
    # + beginTime - Inclusively filter by begin_time when `sort=created_at` or `sort=updated_at`.
    # **Note:** this value is an ISO8601 timestamp. A partial timestamp that does not include a time zone will default to UTC
    # + endTime - Inclusively filter by end_time when `sort=created_at` or `sort=updated_at`.
    # **Note:** this value is an ISO8601 timestamp. A partial timestamp that does not include a time zone will default to UTC
    # + state - Filter by state
    # + return - returns can be any of following types 
    # http:Ok (A list of plans)
    # http:BadRequest (Invalid or unpermitted parameter.)
    # http:NotFound (Incorrect site ID.)
    # http:DefaultStatusCodeResponse (Unexpected error.)
    resource function get plans(string[]? ids, AlphanumericSortEnum? 'order, TimestampSortEnum? sort, @http:Query {name: "begin_time"} string? beginTime, @http:Query {name: "end_time"} string? endTime, ActiveStateEnum? state, int 'limit = 20) returns PlanList|ErrorBadRequest|ErrorNotFound|ErrorDefault {
        PlanList list = {'object: "list", hasMore: false, data: [planFixture("plan-4001"), planFixture("plan-4002")]};
        return list;
    }

    # Fetch a plan
    #
    # + planId - Plan ID or code. For ID no prefix is used e.g. `e28zov4fw0v2`. For code use prefix `code-`, e.g. `code-gold`
    # + return - returns can be any of following types 
    # http:Ok (A plan)
    # http:NotFound (Incorrect site or plan ID.)
    # http:DefaultStatusCodeResponse (Unexpected error.)
    resource function get plans/[string planId]() returns Plan|ErrorNotFound|ErrorDefault {
        return planFixture(planId);
    }

    # List a site's subscriptions
    #
    # + ids - Filter results by their IDs. Up to 200 IDs can be passed at once using
    # commas as separators, e.g. `ids=h1at4d57xlmy,gyqgg0d3v9n1,jrsm5b4yefg6`.
    # **Important notes:**
    # * The `ids` parameter cannot be used with any other ordering or filtering
    # parameters (`limit`, `order`, `sort`, `begin_time`, `end_time`, etc)
    # * Invalid or unknown IDs will be ignored, so you should check that the
    # results correspond to your request.
    # * Records are returned in an arbitrary order. Since results are all
    # returned at once you can sort the records yourself
    # + 'limit - Limit number of records 1-200
    # + 'order - Sort order
    # + sort - Sort field. You *really* only want to sort by `updated_at` in ascending
    # order. In descending order updated records will move behind the cursor and could
    # prevent some records from being returned
    # + beginTime - Inclusively filter by begin_time when `sort=created_at` or `sort=updated_at`.
    # **Note:** this value is an ISO8601 timestamp. A partial timestamp that does not include a time zone will default to UTC
    # + endTime - Inclusively filter by end_time when `sort=created_at` or `sort=updated_at`.
    # **Note:** this value is an ISO8601 timestamp. A partial timestamp that does not include a time zone will default to UTC
    # + state - Filter by state.
    # - When `state=active`, `state=canceled`, `state=expired`, or `state=future`, subscriptions with states that match the query and only those subscriptions will be returned.
    # - When `state=in_trial`, only subscriptions that have a trial_started_at date earlier than now and a trial_ends_at date later than now will be returned.
    # - When `state=live`, only subscriptions that are in an active, canceled, or future state or are in trial will be returned
    # + return - returns can be any of following types 
    # http:Ok (A list of the site's subscriptions)
    # http:BadRequest (Invalid or unpermitted parameter.)
    # http:NotFound (Incorrect site ID.)
    # http:DefaultStatusCodeResponse (Unexpected error.)
    resource function get subscriptions(string[]? ids, AlphanumericSortEnum? 'order, TimestampSortEnum? sort, @http:Query {name: "begin_time"} string? beginTime, @http:Query {name: "end_time"} string? endTime, FilterSubscriptionStateEnum? state, int 'limit = 20) returns SubscriptionList|ErrorBadRequest|ErrorNotFound|ErrorDefault {
        SubscriptionList list = {'object: "list", hasMore: false, data: [subscriptionFixture("sub-2001", "active"), subscriptionFixture("sub-2002", "canceled")]};
        return list;
    }

    # Fetch a subscription
    #
    # + subscriptionId - Subscription ID or UUID. For ID no prefix is used e.g. `e28zov4fw0v2`. For UUID use prefix `uuid-`, e.g. `uuid-123457890`
    # + return - returns can be any of following types 
    # http:Ok (A subscription)
    # http:NotFound (Incorrect site or subscription ID.)
    # http:DefaultStatusCodeResponse (Unexpected error)
    resource function get subscriptions/[string subscriptionId]() returns Subscription|ErrorNotFound|ErrorDefault {
        return subscriptionFixture(subscriptionId, "active");
    }

    # Fetch a transaction
    #
    # + transactionId - Transaction ID or UUID. For ID no prefix is used e.g. `e28zov4fw0v2`. For UUID use prefix `uuid-`, e.g. `uuid-123457890`
    # + return - returns can be any of following types 
    # http:Ok (A transaction)
    # http:NotFound (Incorrect site or transaction ID.)
    # http:DefaultStatusCodeResponse (Unexpected error)
    resource function get transactions/[string transactionId]() returns Transaction|ErrorNotFound|ErrorDefault {
        Transaction txn = {id: transactionId, uuid: "3a1b2c4d5e6f7a8b9c0d1e2f3a4b5c6d", 'object: "transaction", 'type: "purchase", currency: "USD", amount: 49.99, description: "Monthly gold plan", refunded: false, createdAt: "2026-03-01T08:15:00Z", updatedAt: "2026-03-01T08:15:05Z"};
        return txn;
    }

    # Create an account
    #
    # + payload - Request payload for: Create an account 
    # + return - returns can be any of following types 
    # http:Created (An account)
    # http:BadRequest (Bad request, perhaps invalid JSON?)
    # http:NotFound (Incorrect site ID.)
    # http:UnprocessableEntity (Invalid parameters or an error running the billing info verification transaction.)
    # http:DefaultStatusCodeResponse (Unexpected error.)
    resource function post accounts(@http:Payload AccountCreate payload) returns Account|ErrorBadRequest|ErrorNotFound|ErrorUnprocessableEntity|ErrorDefault {
        return accountFixture("e28zov4fw0v4", "active");
    }

    # Create a new coupon
    #
    # + payload - Request payload for: Create a new coupon 
    # + return - returns can be any of following types 
    # http:Created (A new coupon)
    # http:BadRequest (Bad request, perhaps invalid JSON?)
    # http:NotFound (Incorrect site ID.)
    # http:UnprocessableEntity (Invalid request parameters. Check that redeem_by_interval_unit and redeem_by_interval_amount are consistent with the coupon type.)
    # http:DefaultStatusCodeResponse (Unexpected error.)
    resource function post coupons(@http:Payload CouponCreate payload) returns Coupon|ErrorBadRequest|ErrorNotFound|ErrorUnprocessableEntity|ErrorDefault {
        return couponFixture("cpn-3003", "SUMMER15");
    }

    # Create a plan
    #
    # + payload - Request payload for: Create a plan 
    # + return - returns can be any of following types 
    # http:Created (A plan)
    # http:NotFound (Incorrect site ID.)
    # http:UnprocessableEntity (A validation error such as 'Code has already been taken.')
    # http:DefaultStatusCodeResponse (Unexpected error.)
    resource function post plans(@http:Payload PlanCreate payload) returns Plan|ErrorNotFound|ErrorUnprocessableEntity|ErrorDefault {
        return planFixture("plan-4003");
    }

    # Create a new subscription
    #
    # + payload - Request payload for: Create a new subscription 
    # + return - returns can be any of following types 
    # http:Created (A subscription)
    # http:NotFound (Incorrect site ID.)
    # http:UnprocessableEntity (A validation error such as 'You already have a subscription to this plan.' error running the verification transaction.)
    # http:DefaultStatusCodeResponse (Unexpected error.)
    resource function post subscriptions(@http:Payload SubscriptionCreate payload) returns Subscription|ErrorNotFound|ErrorMayHaveTransactionUnprocessableEntity|ErrorDefault {
        return subscriptionFixture("sub-2003", "active");
    }

    # Update an account
    #
    # + accountId - Account ID or code. For ID no prefix is used e.g. `e28zov4fw0v2`. For code use prefix `code-`, e.g. `code-bob`
    # + payload - Request payload for: Update an account 
    # + return - returns can be any of following types 
    # http:Ok (An account)
    # http:BadRequest (Bad request, perhaps invalid JSON?)
    # http:NotFound (Incorrect site or account ID.)
    # http:UnprocessableEntity (Invalid parameters or an error running the billing info verification transaction.)
    # http:DefaultStatusCodeResponse (Unexpected error.)
    resource function put accounts/[string accountId](@http:Payload AccountUpdate payload) returns Account|ErrorBadRequest|ErrorNotFound|ErrorMayHaveTransactionUnprocessableEntity|ErrorDefault {
        return accountFixture(accountId, "active");
    }

    # Collect a pending or past due, automatic invoice
    #
    # + invoiceId - Invoice ID or number. For ID no prefix is used e.g. `e28zov4fw0v2`. For number use prefix `number-`, e.g. `number-1000`. For number with prefix or country code, use `number-` and `prefix`, e.g. `number-TEST-FR1001`
    # + payload - Request payload for: Collect a pending or past due, automatic invoice 
    # + return - returns can be any of following types 
    # http:Ok (The updated invoice)
    # http:NotFound (Incorrect site or invoice ID.)
    # http:UnprocessableEntity (Tried collecting a manual or closed invoice, or there was an error processing the transaction.)
    # http:DefaultStatusCodeResponse (Unexpected error.)
    resource function put invoices/[string invoiceId]/collect(@http:Payload InvoiceCollect payload) returns Invoice|ErrorNotFound|ErrorMayHaveTransactionUnprocessableEntity|ErrorDefault {
        return invoiceFixture(invoiceId, "paid");
    }

    # Update a plan
    #
    # + planId - Plan ID or code. For ID no prefix is used e.g. `e28zov4fw0v2`. For code use prefix `code-`, e.g. `code-gold`
    # + payload - Request payload for: Update a plan 
    # + return - returns can be any of following types 
    # http:Created (A plan)
    # http:NotFound (Incorrect site ID.)
    # http:UnprocessableEntity (A validation error such as 'Code has already been taken.')
    # http:DefaultStatusCodeResponse (Unexpected error.)
    resource function put plans/[string planId](@http:Payload PlanUpdate payload) returns PlanCreated|ErrorNotFound|ErrorUnprocessableEntity|ErrorDefault {
        PlanCreated updated = {body: planFixture(planId)};
        return updated;
    }

    # Cancel a subscription
    #
    # + subscriptionId - Subscription ID or UUID. For ID no prefix is used e.g. `e28zov4fw0v2`. For UUID use prefix `uuid-`, e.g. `uuid-123457890`
    # + payload - Request payload for: Cancel a subscription 
    # + return - returns can be any of following types 
    # http:Ok (A canceled or failed subscription)
    # http:NotFound (Incorrect site or subscription ID.)
    # http:UnprocessableEntity (A validation error such as "Only active and future subscriptions can be canceled".)
    # http:DefaultStatusCodeResponse (Unexpected error.)
    resource function put subscriptions/[string subscriptionId]/cancel(@http:Payload SubscriptionCancel payload) returns Subscription|ErrorNotFound|ErrorUnprocessableEntity|ErrorDefault {
        return subscriptionFixture(subscriptionId, "canceled");
    }
}

// Service-mode response types. `bal openapi --mode client` collapses 4XX/5XX
// to `error` and never emits these, so they are defined here for the mock only.
public type ErrorBadRequest record {|
    *http:BadRequest;
    Error body;
|};

public type ErrorDefault record {|
    *http:DefaultStatusCodeResponse;
    Error body;
|};

public type ErrorMayHaveTransactionUnprocessableEntity record {|
    *http:UnprocessableEntity;
    ErrorMayHaveTransaction body;
|};

public type ErrorNotFound record {|
    *http:NotFound;
    Error body;
|};

public type ErrorUnprocessableEntity record {|
    *http:UnprocessableEntity;
    Error body;
|};

public type PlanCreated record {|
    *http:Created;
    Plan body;
|};

public type Error record {
    ErrorTypeEnum 'type?;
    string message?;
    record {}[] params?;
};

public type ErrorMayHaveTransaction record {
    *Error;
    # This is only included on errors with `type=transaction`
    record {} transaction_error?;
};

public type ErrorTypeEnum "bad_request"|"immutable_subscription"|"internal_server_error"|"invalid_api_key"|"invalid_api_version"|"invalid_content_type"|"invalid_permissions"|"invalid_token"|"missing_feature"|"not_found"|"rate_limited"|"service_not_available"|"simultaneous_request"|"tax_service_error"|"transaction"|"unauthorized"|"unavailable_in_api_version"|"unknown_api_version"|"validation";

isolated function accountFixture(string id, string state) returns Account {
    Account account = {
        id: id,
        code: "acme-corp",
        'object: "account",
        state: state == "inactive" ? "inactive" : "active",
        email: "billing@acme.example",
        firstName: "Ada",
        lastName: "Lovelace",
        company: "Acme Corp",
        createdAt: "2026-01-12T09:30:00Z",
        updatedAt: "2026-02-01T11:00:00Z"
    };
    return account;
}

isolated function planFixture(string id) returns Plan {
    Plan plan = {
        id: id,
        code: "gold",
        name: "Gold Plan",
        'object: "plan",
        state: "active",
        intervalUnit: "months",
        description: "Gold tier monthly subscription",
        createdAt: "2026-01-05T10:00:00Z",
        updatedAt: "2026-01-05T10:00:00Z"
    };
    return plan;
}

isolated function couponFixture(string id, string code) returns Coupon {
    Coupon coupon = {
        id: id,
        code: code,
        name: "Seasonal discount",
        'object: "coupon",
        state: "redeemable",
        duration: "single_use",
        discount: {'type: "percent", percent: 20},
        createdAt: "2026-02-10T12:00:00Z",
        updatedAt: "2026-02-10T12:00:00Z"
    };
    return coupon;
}

isolated function invoiceFixture(string id, string state) returns Invoice {
    Invoice invoice = {
        id: id,
        number: "1001",
        'object: "invoice",
        state: state == "paid" ? "paid" : "pending",
        currency: "USD",
        total: 49.99,
        balance: state == "paid" ? 0.0 : 49.99,
        createdAt: "2026-03-01T08:00:00Z",
        updatedAt: "2026-03-01T08:00:00Z",
        dueAt: "2026-03-31T08:00:00Z"
    };
    return invoice;
}

isolated function subscriptionFixture(string id, string state) returns Subscription {
    Subscription subscription = {
        id: id,
        uuid: "4b7d1a9c2e3f4a5b8c6d7e8f9a0b1c2d",
        'object: "subscription",
        state: state == "canceled" ? "canceled" : "active",
        currency: "USD",
        unitAmount: 49.99,
        quantity: 1,
        plan: {id: "plan-4001", code: "gold", name: "Gold Plan", 'object: "plan_mini"},
        createdAt: "2026-02-01T09:00:00Z",
        updatedAt: "2026-02-01T09:00:00Z"
    };
    return subscription;
}
