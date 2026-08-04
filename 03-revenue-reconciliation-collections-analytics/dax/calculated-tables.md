# Calculated Tables

Four verified calculated tables exist in the model. Power BI's automatically generated hidden date tables (one per date column, created by the default "Auto date/time" behavior) are not included here, since they are not user-authored work.

## dim_Calendar

**Type:** Calculated table.
**Relationships:** One-to-many to `fact_accounting_transactions[transaction_date]`.

```dax
dim_Calendar =
VAR FYEndMonth = 6
VAR Days = CALENDARAUTO(FYEndMonth)
RETURN ADDCOLUMNS(
    Days,
    "Year",                YEAR ( [Date] ),
    "Month Number",        MONTH ( [Date] ),
    "Month",               FORMAT ( [Date], "mmmm" ),
    "Mmm YYYY",            FORMAT ( [Date], "mmm yyyy" ),
    "Year Month Number",   YEAR ( [Date] ) * 100 + MONTH ( [Date] ),
    "Wk # of YYYY",
        "Wk "
        & WEEKNUM ( [Date], 2 )
        & " of "
        & YEAR ( [Date] ),
    "YYYYWKNUM",
        YEAR ( [Date] ) * 100 + WEEKNUM ( [Date], 2 ),
    "Day of Week Number",
        WEEKDAY ( [Date], 2 ),
    "Day of Week",
        FORMAT ( [Date], "dddd" ),
    "Fiscal Year",
        VAR m = MONTH ( [Date] )
        VAR y = YEAR  ( [Date] )
        RETURN IF (
            m <= FYEndMonth,
            ( y - 1 ) & "-" & y,
              y       & "-" & ( y + 1 )
        ),
    "Fiscal Month Number",
        MOD ( MONTH ( [Date] ) - FYEndMonth - 1 + 12, 12 ) + 1,
    "Fiscal Year Month Number",
        VAR m  = MONTH ( [Date] )
        VAR y  = YEAR  ( [Date] )
        VAR FY = IF (
                     m <= FYEndMonth,
                     ( y - 1 ) & "-" & y,
                       y       & "-" & ( y + 1 )
                 )
        VAR FM = MOD ( m - FYEndMonth - 1 + 12, 12 ) + 1
        RETURN FY & " " & FORMAT ( FM, "00" ),
    "FY Mmm",
        VAR m         = MONTH ( [Date] )
        VAR y         = YEAR  ( [Date] )
        VAR FYEndYear = IF ( m <= FYEndMonth, y, y + 1 )
        RETURN "FY" & RIGHT ( FORMAT ( FYEndYear, "0000" ), 2 ) & " " & FORMAT ( [Date], "mmm" )
)
```

**Purpose:** A fully custom fiscal-year calendar table built with `CALENDARAUTO` plus `ADDCOLUMNS`, generating one row per date across the model's date range and deriving a full set of standard and fiscal-year attributes (calendar year/month, fiscal year, fiscal month number, ISO-style week numbering).

**Business interpretation:** This is the single most technically substantial piece of DAX in the model — it correctly implements a July-to-June fiscal year (FY end month = 6) entirely in DAX, including the fiscal-year-label logic ("2023-2024" style) and a fiscal-month-number reindexing so month 1 of the fiscal year is July, not January. Every fiscal-year slicer, table, and chart in the report is driven by this table's `Fiscal Year` column.

---

## Funnel_Stages

**Type:** Calculated table (disconnected ordering table).
**Relationships:** None — used only via `SELECTEDVALUE()` inside the `Funnel_Value` measure.

```dax
Funnel_Stages =
DATATABLE(
    "Stage", STRING,
    "Stage_Order", INTEGER,
    {
        {"Applicants", 1},
        {"Offered", 2},
        {"Accepted", 3},
        {"Confirmed", 4},
        {"Sailed", 5}
    }
)
```

**Purpose:** Defines the five funnel stages and their display order.

**Business interpretation:** Drives the "From Application to Sea" funnel chart, letting one chart display five different underlying count measures (via the `Funnel_Value` switch measure) in the correct sequence.

---

## Waterfall_Stages

**Type:** Calculated table (disconnected ordering table).
**Relationships:** None.

```dax
Waterfall_Stages =
DATATABLE(
    "Stage", STRING,
    "Stage_Order", INTEGER,
    {
        {"Total Contracted", 1},
        {"Revenue Recognized", 2},
        {"Deferred Revenue", 3},
        {"Outstanding Receivables", 4}
    }
)
```

**Purpose:** Defines a 4-stage waterfall sequence, paired with the `Waterfall_Value` measure.

**Business interpretation:** A general-purpose waterfall table defined in the model; the report page's published waterfall visual actually uses `Waterfall_Bridge` (below) rather than this table. Documented here because it's a distinct, verified object in the model.

---

## Waterfall_Bridge

**Type:** Calculated table (disconnected ordering table).
**Relationships:** None.

```dax
Waterfall_Bridge =
DATATABLE(
    "Stage", STRING,
    "Stage_Order", INTEGER,
    {
        {"Contracted", 1},
        {"Not Yet Earned", 2},
        {"Cash Collected", 3}
    }
)
```

**Purpose:** Defines the 3-stage sequence for the published revenue bridge waterfall, paired with the `Bridge_Value` measure.

**Business interpretation:** Drives the "Revenue Bridge" waterfall chart on the Revenue & Collections page — Contracted → Not Yet Earned → Cash Collected → Total.
