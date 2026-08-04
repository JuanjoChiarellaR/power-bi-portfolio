# Data Model

## Structure

A Power BI analytical model with two central fact tables connected to shared dimensions for applicants, terms, and calendar analysis:

- **`fact_accounting_transactions`** — the transaction ledger: amount, tax amount, transaction type (Charge / Payment / Refund), charge group/item description, transaction date, linked to a term session and an entry.
- **`fact_applications_and_bookings`** — the applications and bookings ledger: application/booking status and dates, contract value and dates, room rate, linked to an entry.
- **`dim_entries`** — one row per applicant/entry, with status (`entry_status`) driving the funnel-stage measures.
- **`dim_terms`** — term/session reference data (academic year, term, session, term start/end dates).
- **`dim_Calendar`** — a custom DAX-built fiscal-year calendar (see [`../dax/calculated-tables.md`](../dax/calculated-tables.md)).
- **`_Measures`** — a dedicated measures table (no data rows) holding all 22 DAX measures.
- **`Funnel_Stages`, `Waterfall_Stages`, `Waterfall_Bridge`** — small disconnected ordering tables that drive the funnel chart and the two waterfall-style measures.

## Relationships

Both fact tables relate to the shared dimensions through one-to-many relationships: `dim_entries` and `dim_terms` each relate to both fact tables, and `dim_Calendar` relates to `fact_accounting_transactions` on transaction date. This structure lets revenue, collection, and deferred-balance figures be sliced consistently by fiscal year, term, and entry status.

## Connection and refresh

Confirmed directly from the model: every table is set to **Import mode**. Power BI imported data from a cloud-hosted MySQL database and transformed it into this analytical model — the report reflects the data as of the most recent import, not a live or continuously refreshing connection. (An earlier draft of this project's source materials described the connection as real-time; that claim was not supported by the model and has been corrected here.)

## What isn't published here

Server hostname, database name, and other connection-specific details are intentionally excluded. Table cardinality and filter-direction details beyond what's stated above would require opening the model in Power BI Desktop to confirm precisely.
