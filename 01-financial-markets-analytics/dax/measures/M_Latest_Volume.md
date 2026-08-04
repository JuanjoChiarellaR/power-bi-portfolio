# M_Latest_Volume

**Home table:** VW_MARKET_ANALYTICS

```dax
M_Latest_Volume =
VAR LatestDate =
    MAX(
        VW_MARKET_ANALYTICS[PRICE_DATE]
    )

RETURN
    CALCULATE(
        MAX(
            VW_MARKET_ANALYTICS[VOLUME]
        ),
        VW_MARKET_ANALYTICS[PRICE_DATE] = LatestDate
    )
```

**Purpose:** Returns the trading volume for the latest date of the
selected ticker.

**Format:** Whole number; may be displayed in millions on the visual.
