# Power Query Transformations

## Source

All tables originate from a single cloud-hosted MySQL database, connected in **Import mode** (confirmed directly from the model — every table partition is set to `mode: import`; this is not a live or DirectQuery connection, and the report reflects the data as of the most recent refresh). Server hostname, database name, and any other connection-specific details are intentionally excluded from this documentation.

## Loaded tables and their transformations

### fact_accounting_transactions
- Removed an internal row-ID column (`my_row_id`) not needed for analysis.
- Converted `transaction_date` to a proper date type (first to datetime, then trimmed to date).
- Converted `amount` and `tax_amount` to currency type.
- Added the `Charge_Category` calculated column (see [`../dax/calculated-columns.md`](../dax/calculated-columns.md)).

### fact_applications_and_bookings
- Converted 16 date/numeric columns to their correct types (application/booking/contract/deposit/offer/cancel dates to datetime; contract nights to whole number; contract value, expected room rate, and room rate amount to decimal number).
- Removed the internal row-ID column.
- Sorted rows by application ID.
- **Merged in `entry_id`** from a separate applications-to-entries bridge query via a left-outer join on `application_id`, then renamed the resulting column to `entry_id`. This bridge query is the source of the placeholder-application-ID data-quality finding documented in [`../documentation/data-quality-findings.md`](../documentation/data-quality-findings.md) — it exists in the model's Power Query layer as a load-disabled staging query (not a separate visible table), used only to feed this merge step.
- Sorted rows by entry ID.

### dim_entries
- Loaded directly from the source with standard column typing; no additional transformation steps beyond what Power BI applies automatically on import.
- **Note on scope:** this table's source columns include some demographic and health-related fields (citizenship, gender, nationality, dietary/allergy information) alongside application/entry-status fields. None of these are referenced by any visual in the published report — every visual in the model only aggregates via `COUNTROWS()` and status filters — but because the connection is Import mode, the raw column-level data is cached inside the PBIX file itself. This is the reason the PBIX file is not included in this public repository; see the project README's "Limitations and Next Steps" section.

### dim_terms
- Loaded directly from the source with standard column typing.

### dim_Calendar
- Not sourced from MySQL at all — built entirely in DAX from `CALENDARAUTO()`, see [`../dax/calculated-tables.md`](../dax/calculated-tables.md).

## Additional staging/validation queries

The model's Power Query layer contains several additional queries with loading disabled (staging and validation queries, including a duplicate/validation pass over the applications-bookings bridge and over `dim_terms` and `fact_accounting_transactions`, plus a few merge-only queries). These aren't loaded into the model and don't appear as tables in the report, but their presence indicates the underlying data was validated and reconciled during development, beyond just the final loaded tables.

## Not verifiable from this repository

Table relationships, cardinality, and the exact MySQL schema are not republished here beyond what's stated above, in line with the security review performed before publishing (see the project README).
