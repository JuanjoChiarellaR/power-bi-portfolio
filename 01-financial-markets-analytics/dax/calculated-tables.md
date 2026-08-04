# Calculated Tables

## DIM_TICKER_FILTER

**Type:** Calculated table (disconnected)
**Relationships:** None — intentionally disconnected from the data model

```dax
DIM_TICKER_FILTER =
DATATABLE(
    "TICKER", STRING,
    {
        {"AGG"},
        {"GLD"},
        {"IEF"},
        {"IXN"},
        {"QQQ"},
        {"SPY"},
        {"VNQ"},
        {"VT"}
    }
)
```

**Purpose:** Creates an independent slicer that allows filtering both TICKER_A
and TICKER_B simultaneously in the correlation matrix. Built manually because
the Direct Lake model did not support building this dynamically from existing
tables.
