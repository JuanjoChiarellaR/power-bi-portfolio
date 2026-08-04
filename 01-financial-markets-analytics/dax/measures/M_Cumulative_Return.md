# M_Cumulative_Return

**Home table:** VW_MARKET_ANALYTICS

```dax
M_Cumulative_Return =
VAR CurrentDate =
    MAX(VW_MARKET_ANALYTICS[PRICE_DATE])

VAR FirstSelectedDate =
    MINX(
        ALLSELECTED(VW_MARKET_ANALYTICS[PRICE_DATE]),
        VW_MARKET_ANALYTICS[PRICE_DATE]
    )

RETURN
    PRODUCTX(
        FILTER(
            ALLSELECTED(VW_MARKET_ANALYTICS[PRICE_DATE]),
            VW_MARKET_ANALYTICS[PRICE_DATE] >= FirstSelectedDate
                && VW_MARKET_ANALYTICS[PRICE_DATE] <= CurrentDate
        ),
        1
            + CALCULATE(
                AVERAGE(VW_MARKET_ANALYTICS[DAILY_RETURN])
            )
    ) - 1
```

**Purpose:** Calculates the cumulative return of each ticker from the start
of the selected date range up to the current date of each chart point.

**Responds to:** date range slicer, ticker slicer, individual line context.

**Format:** Percentage, 2 decimals.
