// Reviews the open invoices of an account and, once confirmed, collects the ones that are past due.

import ballerina/io;
import ballerinax/recurly;

configurable string apiKey = ?;
configurable string accountId = ?;
configurable int pageSize = 50;
configurable boolean collectPastDue = false;

public function main() returns error? {
    // Recurly expects an empty password; a single space is sent because the HTTP client rejects empty ones.
    recurly:Client recurlyClient = check new ({auth: {username: apiKey, password: " "}});

    // Step 1: Read the account's invoices that are still waiting for payment.
    recurly:InvoiceList pending = check recurlyClient->listAccountInvoices(accountId, state = "past_due", 'limit = pageSize);
    recurly:Invoice[] invoices = pending.data ?: [];
    if pending.hasMore == true {
        io:println("More than ", pageSize, " past due invoices exist, raise pageSize to review all of them.");
    }
    io:println("Past due invoices: ", invoices.length());

    foreach recurly:Invoice invoice in invoices {
        string invoiceId = invoice.id ?: "";
        if invoiceId == "" {
            return error("Invoice without an id returned by Recurly");
        }

        // Step 2: Re-read the invoice to get its current balance.
        recurly:Invoice current = check recurlyClient->getInvoice(invoiceId);
        io:println("Invoice ", current.number, " balance ", current.balance, " ", current.currency);

        // Step 3: Attempt collection only when explicitly enabled.
        if collectPastDue {
            recurly:Invoice collected = check recurlyClient->collectInvoice(invoiceId, {});
            io:println("Invoice ", invoiceId, " is now ", collected.state);
        }
    }
}
