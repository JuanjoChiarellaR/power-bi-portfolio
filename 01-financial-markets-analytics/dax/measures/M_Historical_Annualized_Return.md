# M_Historical_Annualized_Return

**Home table:** VW_MARKET_ANALYTICS

```dax
M_Historical_Annualized_Return =
AVERAGE(
    VW_MARKET_ANALYTICS[DAILY_RETURN]
) * 252
```

**Purpose:** Annualizes the average daily return observed in the selected
period.

**Note:** This is a historical annualized return, not an expected return or
forecast.

**Format:** Percentage, 2 decimals.
