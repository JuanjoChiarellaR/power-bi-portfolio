# M_Lowest_Volatility_Card

**Home table:** VW_MARKET_ANALYTICS

```dax
M_Lowest_Volatility_Card =
VAR LowestTicker =
    [M_Lowest_Volatility_Ticker]

VAR LowestVolatility =
    [M_Lowest_Volatility]

RETURN
    IF(
        ISBLANK(LowestVolatility),
        BLANK(),
        LowestTicker
            & " | "
            & FORMAT(LowestVolatility, "0.00%")
    )
```

**Purpose:** Displays the ticker and its volatility in a single card.

**Example:** AGG | 4.47%
**Card title:** Lowest Volatility.
