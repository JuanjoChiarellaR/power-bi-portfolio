# M_Best_Sharpe_Card

**Home table:** VW_MARKET_ANALYTICS

```dax
M_Best_Sharpe_Card =
VAR BestTicker =
    [M_Best_Sharpe_Ticker]

VAR BestSharpe =
    [M_Best_Sharpe_Ratio]

RETURN
    IF(
        ISBLANK(BestSharpe),
        BLANK(),
        BestTicker
            & " | "
            & FORMAT(BestSharpe, "0.00")
    )
```

**Purpose:** Combines the ticker and Sharpe value into a single measure
for card display.

**Example:** GLD | 1.01
**Card title:** Best Risk-Adjusted Performer.
