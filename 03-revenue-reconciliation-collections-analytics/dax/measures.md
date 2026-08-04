# DAX Measures

All 22 measures below are explicit DAX measures verified directly in the model's `_Measures` table. None were invented or rewritten beyond minor formatting for readability.

### Total_Contracted_Value

```dax
Total_Contracted_Value =
SUM(fact_applications_and_bookings[contract_value])
```

**Purpose:** Sums the total contracted value of all bookings.

**Business interpretation:** Represents the full value the organization has contracted to deliver, regardless of what has been billed, collected, or recognized as revenue yet.

**Filter behavior:** Responds to any filter on `fact_applications_and_bookings` (fiscal year, term, etc.).

**Format:** Currency.

**Used on:** Revenue bridge waterfall (via `Bridge_Value`).

---

### Total_Payments_Received

```dax
Total_Payments_Received =
CALCULATE(
    SUM(fact_accounting_transactions[amount]),
    fact_accounting_transactions[transaction_type_description] = "Payment"
)
```

**Purpose:** Sums transaction amounts flagged as payments.

**Business interpretation:** Raw payment total from the accounting ledger. Payment amounts are stored as negative values in the source system (standard ledger convention), so this measure returns a negative number — it is negated wherever it's presented as a positive cash figure (see `Cash_Collected`).

**Filter behavior:** Responds to fiscal year, term, and any other filter on `fact_accounting_transactions`.

**Format:** Currency.

**Used on:** Building block for `Outstanding_Receivables`, `Collection_Rate`, `Cash_Collected`.

---

### Total_Charges

```dax
Total_Charges =
CALCULATE(
    SUM(fact_accounting_transactions[amount]),
    fact_accounting_transactions[transaction_type_description] = "Charge"
)
```

**Purpose:** Sums transaction amounts flagged as charges.

**Business interpretation:** Total amount billed to customers, before payments or refunds are netted against it.

**Filter behavior:** Responds to fiscal year, term, and any other filter on `fact_accounting_transactions`.

**Format:** Currency.

**Used on:** Building block for `Outstanding_Receivables` and `Collection_Rate`.

---

### Total_Refunds

```dax
Total_Refunds =
CALCULATE(
    SUM(fact_accounting_transactions[amount]),
    fact_accounting_transactions[transaction_type_description] = "Refund"
)
```

**Purpose:** Sums transaction amounts flagged as refunds.

**Business interpretation:** Total amount refunded to customers.

**Filter behavior:** Responds to fiscal year, term, and any other filter on `fact_accounting_transactions`.

**Format:** Currency.

**Used on:** Building block for `Outstanding_Receivables`.

---

### Outstanding_Receivables

```dax
Outstanding_Receivables =
[Total_Charges] + [Total_Payments_Received] + [Total_Refunds]
```

**Purpose:** Nets charges, payments, and refunds into a single outstanding-balance figure.

**Business interpretation:** The amount still owed by customers after payments and refunds are applied against charges billed. This is the "Outstanding Balance" / "Still to Collect" figure shown throughout the report.

**Filter behavior:** Inherits the fiscal-year and term filter context of whatever visual it's placed in — this is how the same measure produces a different Outstanding Balance per fiscal year in the Collections Performance table.

**Format:** Currency.

**Used on:** Executive Overview card, Revenue & Collections cards, Collections Performance table, revenue bridge waterfall.

---

### Revenue_Recognized_FY

```dax
Revenue_Recognized_FY =
ABS(
    CALCULATE(
        SUM(fact_accounting_transactions[amount]),
        fact_accounting_transactions[charge_group_description] IN {
            "R&B Academic Year",
            "R&B SUMMER",
            "R&B Early Arrival or Extensions",
            "RB Short-Term Reservation",
            "RB Weekly Stays"
        },
        fact_accounting_transactions[transaction_type_description] = "Charge"
    )
)
```

**Purpose:** Sums only the Room & Board–related charge categories and returns the absolute value.

**Business interpretation:** This is the model's definition of "earned revenue" — Room & Board charges specifically, which the Executive Overview page confirms represent roughly 91% of all charges. Other charge categories (fees, onboard services, deposits, deferred income) are excluded.

**Filter behavior:** Responds to fiscal year, term, and any filter on `fact_accounting_transactions`.

**Format:** Currency.

**Used on:** Revenue Earned cards, clustered column chart by category, revenue bridge, `Avg_Revenue_per_Student`, dynamic chart title (`Title_Revenue_Bridge`).

---

### Deferred_Revenue

```dax
Deferred_Revenue =
CALCULATE(
    SUM(fact_accounting_transactions[amount]),
    fact_accounting_transactions[charge_group_description] = "DEFERRED INCOME",
    fact_accounting_transactions[transaction_type_description] = "Charge"
)
```

**Purpose:** Sums transactions specifically categorized as deferred income.

**Business interpretation:** The pre-payments collected for future-period service that haven't yet been recognized as revenue. Because deferred revenue is a liability, this figure should always be positive — the negative values observed for FY2024-25 and FY2025-26 are the data-quality anomaly documented in [`../documentation/data-quality-findings.md`](../documentation/data-quality-findings.md).

**Filter behavior:** Responds to fiscal year and any filter on `fact_accounting_transactions`.

**Format:** Currency.

**Used on:** "Deferred to Future FY" card, Collections Performance table.

---

### Total_Applicants

```dax
Total_Applicants =
COUNTROWS(dim_entries)
```

**Purpose:** Counts every row (entry) in the entries dimension.

**Business interpretation:** Total number of applications received.

**Filter behavior:** Responds to any filter applied to `dim_entries`.

**Format:** Whole number.

**Used on:** Applicants card, funnel chart (via `Funnel_Value`), `Conversion_Rate`.

---

### Total_Sailed

```dax
Total_Sailed =
CALCULATE(
    COUNTROWS(dim_entries),
    dim_entries[entry_status] = "HIST"
)
```

**Purpose:** Counts entries whose status is "HIST" (historical / completed).

**Business interpretation:** Number of customers who completed the full service cycle.

**Filter behavior:** Responds to any filter on `dim_entries`.

**Format:** Whole number.

**Used on:** Students Sailed card, funnel chart, `Avg_Revenue_per_Student`, `Conv_Accept_to_Sail`, `Conversion_Rate`.

---

### Total_Confirmed

```dax
Total_Confirmed =
CALCULATE(
    COUNTROWS(dim_entries),
    dim_entries[entry_status]
        IN {"RESV", "INRM", "HIST"}
)
```

**Purpose:** Counts entries whose status indicates a confirmed booking.

**Business interpretation:** Number of applicants who reached the "Confirmed" funnel stage.

**Filter behavior:** Responds to any filter on `dim_entries`.

**Format:** Whole number.

**Used on:** Funnel chart (via `Funnel_Value`).

---

### Total_Offered

```dax
Total_Offered =
CALCULATE(
    COUNTROWS(dim_entries),
    dim_entries[entry_status]
        IN {"TENT", "RESV", "INRM", "HIST", "HELD", "CNCL"}
)
```

**Purpose:** Counts entries whose status indicates an offer was made (including later-stage and cancelled statuses, since those applicants passed through the offer stage too).

**Business interpretation:** Number of applicants who reached the "Offered" funnel stage.

**Filter behavior:** Responds to any filter on `dim_entries`.

**Format:** Whole number.

**Used on:** Funnel chart, `Conv_Offer_to_Accept`.

---

### Total_Accepted

```dax
Total_Accepted =
CALCULATE(
    COUNTROWS(dim_entries),
    dim_entries[entry_status]
        IN {"RESV", "INRM", "HIST", "HELD"}
)
```

**Purpose:** Counts entries whose status indicates acceptance.

**Business interpretation:** Number of applicants who reached the "Accepted" funnel stage.

**Filter behavior:** Responds to any filter on `dim_entries`.

**Format:** Whole number.

**Used on:** Funnel chart, `Conv_Offer_to_Accept`, `Conv_Accept_to_Sail`.

---

### Avg_Revenue_per_Student

```dax
Avg_Revenue_per_Student =
DIVIDE(
    [Revenue_Recognized_FY],
    [Total_Sailed]
)
```

**Purpose:** Divides recognized revenue by the number of customers who completed the service cycle.

**Business interpretation:** Average revenue generated per customer who sailed.

**Filter behavior:** Inherits fiscal-year/term filter context from both underlying measures.

**Format:** Currency.

**Used on:** "Avg. Revenue / Student" card on the Executive Overview.

---

### Collection_Rate

```dax
Collection_Rate =
DIVIDE(
    [Total_Payments_Received] * -1,
    [Total_Charges]
)
```

**Purpose:** Expresses payments received as a percentage of charges billed.

**Business interpretation:** The core collections KPI — what share of billed revenue has actually been collected in cash. Above 100% (as in FY2024-25) means more cash came in than was charged in that period, typically from early/advance payments.

**Filter behavior:** Responds to fiscal year and any filter on `fact_accounting_transactions`.

**Format:** Percentage.

**Used on:** Collection Rate card, Collections Performance table.

---

### Conv_Offer_to_Accept

```dax
Conv_Offer_to_Accept =
DIVIDE([Total_Accepted], [Total_Offered])
```

**Purpose:** Ratio of accepted applicants to offered applicants.

**Business interpretation:** Conversion rate from the "Offered" to "Accepted" funnel stage.

**Filter behavior:** Responds to any filter on `dim_entries`.

**Format:** General number (not formatted as a currency or percentage in the model; interpreted as a ratio).

**Used on:** Not directly placed on either report page in the current model — available as a supporting measure.

---

### Conv_Accept_to_Sail

```dax
Conv_Accept_to_Sail =
DIVIDE([Total_Sailed], [Total_Accepted])
```

**Purpose:** Ratio of customers who sailed to customers who were accepted.

**Business interpretation:** Conversion rate from the "Accepted" to "Sailed" funnel stage.

**Filter behavior:** Responds to any filter on `dim_entries`.

**Format:** General number.

**Used on:** Not directly placed on either report page in the current model — available as a supporting measure.

---

### Funnel_Value

```dax
Funnel_Value =
SWITCH(
    SELECTEDVALUE(Funnel_Stages[Stage]),
    "Applicants", [Total_Applicants],
    "Offered",    [Total_Offered],
    "Accepted",   [Total_Accepted],
    "Confirmed",  [Total_Confirmed],
    "Sailed",     [Total_Sailed]
)
```

**Purpose:** Returns the correct count measure depending on which funnel stage is being rendered.

**Business interpretation:** Lets a single funnel chart display five different underlying measures (Total_Applicants, Total_Offered, etc.) by switching on the disconnected `Funnel_Stages[Stage]` value for each stage/bar of the funnel.

**Filter behavior:** Driven by row context from `Funnel_Stages`, a small `DATATABLE()`-based ordering table (see [`calculated-tables.md`](calculated-tables.md)) rather than any fact table filter.

**Format:** Whole number.

**Used on:** The "From Application to Sea" funnel chart, Executive Overview page.

---

### Cash_Collected

```dax
Cash_Collected =
[Total_Payments_Received] * -1
```

**Purpose:** Flips the sign of `Total_Payments_Received` to present it as a positive cash figure.

**Business interpretation:** Total cash collected from customers — the "Cash Collected" figure shown throughout the report.

**Filter behavior:** Inherits the filter context of `Total_Payments_Received`.

**Format:** Currency.

**Used on:** Cash Collected card, Collections Performance table, revenue bridge waterfall (via `Bridge_Value`).

---

### Waterfall_Value

```dax
Waterfall_Value =
SWITCH(
    SELECTEDVALUE(Waterfall_Stages[Stage]),
    "Total Contracted",      [Total_Contracted_Value],
    "Revenue Recognized",    [Revenue_Recognized_FY],
    "Deferred Revenue",      [Deferred_Revenue],
    "Outstanding Receivables", [Outstanding_Receivables]
)
```

**Purpose:** Returns the correct measure depending on which waterfall stage is being rendered.

**Business interpretation:** A general-purpose waterfall measure defined in the model but not the one actually wired to the published revenue bridge visual — the report page uses `Bridge_Value` (below) with the `Waterfall_Bridge` stage table instead. Documented here because it exists in the model and is a distinct, valid measure.

**Filter behavior:** Driven by row context from `Waterfall_Stages`, a `DATATABLE()`-based ordering table.

**Format:** General number.

**Used on:** Not the measure behind the published Revenue Bridge chart (see `Bridge_Value`); defined in the model as a supporting/alternate measure.

---

### Title_Revenue_Bridge

```dax
Title_Revenue_Bridge =
"Revenue Bridge " & SELECTEDVALUE(dim_Calendar[Fiscal Year], "All Years")
& ": $" & FORMAT([Revenue_Recognized_FY]/1000000, "0.0")
& "M Earned — $" & FORMAT([Outstanding_Receivables]/1000000, "0.0")
& "M Still to Collect"
```

**Purpose:** Builds a dynamic chart title string that updates with the selected fiscal year.

**Business interpretation:** Produces titles like "Revenue Bridge 2025-2026: $19.6M Earned — $4.3M Still to Collect" directly from the live measure values, so the title never goes stale relative to the chart it labels.

**Filter behavior:** Responds to the fiscal-year slicer on the Revenue & Collections page.

**Format:** Text.

**Used on:** Revenue bridge waterfall chart title.

---

### Bridge_Value

```dax
Bridge_Value =
SWITCH(
    SELECTEDVALUE(Waterfall_Bridge[Stage]),
    "Contracted",      [Total_Contracted_Value],
    "Not Yet Earned",  [Revenue_Recognized_FY] - [Total_Contracted_Value],
    "Cash Collected",  [Cash_Collected] * -1
)
```

**Purpose:** Returns the correct value for each stage of the published revenue bridge waterfall.

**Business interpretation:** Builds the "Contracted → Not Yet Earned → Cash Collected → Total" waterfall shown on the Revenue & Collections page, with "Not Yet Earned" computed as the gap between recognized revenue and total contracted value.

**Filter behavior:** Driven by row context from `Waterfall_Bridge`, a 3-row `DATATABLE()` ordering table.

**Format:** General number.

**Used on:** The published Revenue Bridge waterfall chart, Revenue & Collections page.

---

### Conversion_Rate

```dax
Conversion_Rate =
DIVIDE([Total_Sailed], [Total_Applicants])
```

**Purpose:** Ratio of customers who sailed to total applicants.

**Business interpretation:** End-to-end conversion rate — this is the 39.4% figure shown under the funnel chart ("From Application to Sea").

**Filter behavior:** Responds to any filter on `dim_entries`.

**Format:** Percentage.

**Used on:** The "39.4%" label under the funnel chart, Executive Overview page.
