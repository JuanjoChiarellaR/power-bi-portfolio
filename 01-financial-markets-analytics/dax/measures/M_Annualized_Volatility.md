# M_Annualized_Volatility

**Home table:** VW_MARKET_ANALYTICS

```dax
M_Annualized_Volatility =
STDEV.P(
    VW_MARKET_ANALYTICS[DAILY_RETURN]
) * SQRT(252)
```

**Purpose:** Measures the historical dispersion of daily returns and
annualizes it using the 252 trading-day convention.

**Format:** Percentage, 2 decimals.
