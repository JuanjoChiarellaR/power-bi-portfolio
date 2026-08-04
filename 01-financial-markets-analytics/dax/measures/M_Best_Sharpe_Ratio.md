# M_Best_Sharpe_Ratio

**Home table:** VW_MARKET_ANALYTICS

```dax
M_Best_Sharpe_Ratio =
MAXX(
    VALUES(VW_MARKET_ANALYTICS[TICKER]),
    CALCULATE([M_Sharpe_Ratio])
)
```

**Purpose:** Finds the highest Sharpe Ratio among the selected tickers,
respecting the selected date range.

**Format:** Decimal number, 2 decimals.
