# M_Latest_Adj_Close

**Home table:** VW_MARKET_ANALYTICS

```dax
M_Latest_Adj_Close =
VAR LatestDate =
    MAX(
        VW_MARKET_ANALYTICS[PRICE_DATE]
    )

RETURN
    CALCULATE(
        MAX(
            VW_MARKET_ANALYTICS[ADJ_CLOSE]
        ),
        VW_MARKET_ANALYTICS[PRICE_DATE] = LatestDate
    )
```

**Purpose:** Returns the adjusted price for the latest date within the
selected period.

**Format:** Currency, 2 decimals.
