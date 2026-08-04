# Calculated Columns

One verified calculated column exists in the model.

### fact_accounting_transactions[Charge_Category]

```dax
Charge_Category =
SWITCH(
    TRUE(),
    fact_accounting_transactions[charge_group_description] IN {
        "R&B Academic Year",
        "R&B SUMMER",
        "R&B Early Arrival or Extensions",
        "RB Short-Term Reservation",
        "RB Weekly Stays"
    }, "Room & Board",
    fact_accounting_transactions[charge_group_description] = "DEFERRED INCOME", "Deferred Income",
    fact_accounting_transactions[charge_group_description] = "PrePayment", "Pre-Payment Deposit",
    fact_accounting_transactions[charge_group_description] IN {
        "FEES",
        "SCH TAX (ACCRUED)",
        "COMMISSIONS"
    }, "Fees & Other",
    fact_accounting_transactions[charge_group_description] IN {
        "DINING MEALS",
        "ALCOHOLIC BEVERAGES",
        "Shopping Cart Items",
        "COUNCIL- SOCIAL ...",
        "DISCOUNT & ALLO..."
    }, "Onboard Services",
    "Other"
)
```

**Purpose:** Collapses the source system's many granular `charge_group_description` values into six readable, report-friendly categories.

**Business interpretation:** This is the categorization that drives the "91% of Charges Are Room & Board" donut chart on the Executive Overview page — it's the single place in the model where raw source-system charge codes are translated into business language.

**Home table:** `fact_accounting_transactions`.

**Used on:** Charge-category donut chart, Executive Overview page.
