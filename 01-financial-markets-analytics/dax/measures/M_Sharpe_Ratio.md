# M_Sharpe_Ratio

**Home table:** VW_MARKET_ANALYTICS

```dax
M_Sharpe_Ratio =
VAR AnnReturn =
    [M_Historical_Annualized_Return]

VAR AnnRiskFree =
    AVERAGE(
        VW_MARKET_ANALYTICS[RISK_FREE_RATE]
    ) * 252

VAR AnnVol =
    [M_Annualized_Volatility]

RETURN
    DIVIDE(
        AnnReturn - AnnRiskFree,
        AnnVol
    )
```

**Purpose:** Measures the excess historical return earned per unit of
volatility assumed for each asset.

**Format:** Decimal number, 2 decimals.
