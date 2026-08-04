# M_Lowest_Volatility

**Home table:** VW_MARKET_ANALYTICS

```dax
M_Lowest_Volatility =
MINX(
    VALUES(VW_MARKET_ANALYTICS[TICKER]),
    CALCULATE([M_Annualized_Volatility])
)
```

**Purpose:** Finds the lowest annualized volatility among the selected
tickers within the selected date range.

**Format:** Percentage, 2 decimals.
