# Technical Inventory

## Data source

| Component | Detail |
|---|---|
| Source type | Cloud-hosted MySQL database |
| Connection mode | Import (verified from every table partition — not DirectQuery, not a live connection) |
| Refresh | Reflects the data as of the most recent import |

## Fact tables

| Table | Grain | Key fields |
|---|---|---|
| `fact_accounting_transactions` | One row per accounting transaction | amount, tax_amount, transaction_type_description (Charge/Payment/Refund), charge_group_description, transaction_date, term_session_id, entry_id, Charge_Category (calculated column) |
| `fact_applications_and_bookings` | One row per application/booking | application_id, application_status, booking_status, contract_value, contract dates, room_rate_amount, entry_id |

## Dimension tables

| Table | Purpose |
|---|---|
| `dim_entries` | One row per applicant/entry; `entry_status` drives all funnel-stage measures |
| `dim_terms` | Term/session reference data |
| `dim_Calendar` | Custom DAX-built fiscal-year calendar (`CALENDARAUTO`-based, FY end month = June) |

## Supporting tables

| Table | Purpose |
|---|---|
| `_Measures` | Houses all 22 explicit DAX measures |
| `Funnel_Stages` | 5-row disconnected ordering table for the funnel chart |
| `Waterfall_Stages` | 4-row disconnected ordering table (defined in the model; not the table behind the published waterfall) |
| `Waterfall_Bridge` | 3-row disconnected ordering table behind the published revenue bridge waterfall |

## Relationships

Both fact tables relate to `dim_entries` and `dim_terms` (one-to-many); `dim_Calendar` relates to `fact_accounting_transactions[transaction_date]` (one-to-many). See [`data-model.md`](data-model.md).

## DAX measures

22 explicit measures — full list with code, purpose, and format in [`../dax/measures.md`](../dax/measures.md).

## Calculated columns

1 verified calculated column (`fact_accounting_transactions[Charge_Category]`) — see [`../dax/calculated-columns.md`](../dax/calculated-columns.md).

## Calculated tables

4 verified calculated tables (`dim_Calendar`, `Funnel_Stages`, `Waterfall_Stages`, `Waterfall_Bridge`) — see [`../dax/calculated-tables.md`](../dax/calculated-tables.md).

## Power Query transformations

Column removal, date/currency type conversion, a bridge-table merge on `application_id`, and several load-disabled staging/validation queries — see [`../power-query/transformations.md`](../power-query/transformations.md).

## Report pages and visuals

| Page | Visuals |
|---|---|
| Executive Overview | 5 KPI cards, a 5-stage funnel chart, a clustered column chart (revenue by fiscal year), a donut chart (charges by category) |
| Revenue & Collections | 4 KPI cards, a fiscal-year slicer, a revenue-bridge waterfall chart, a pivot table (Collections Performance by Fiscal Year), a pipeline-alert text box, two recommendation text boxes |

Conditional formatting, drill-through pages, and bookmarks were not found in the report — the two pages above are the complete report.

## Not independently verifiable from this repository

Exact table cardinality/filter-direction settings and the live MySQL schema, since confirming these precisely would require opening the model in Power BI Desktop with live source access.
