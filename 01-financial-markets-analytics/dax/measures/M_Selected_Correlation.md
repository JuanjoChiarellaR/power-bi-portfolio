# M_Selected_Correlation

**Home table:** FACT_CORRELATION_MATRIX

```dax
M_Selected_Correlation =
VAR CurrentTickerA =
    SELECTEDVALUE(
        FACT_CORRELATION_MATRIX[TICKER_A]
    )

VAR CurrentTickerB =
    SELECTEDVALUE(
        FACT_CORRELATION_MATRIX[TICKER_B]
    )

VAR SelectedTickers =
    ALLSELECTED(
        DIM_TICKER_FILTER[TICKER]
    )

RETURN
    IF(
        CONTAINSROW(
            SelectedTickers,
            CurrentTickerA
        )
            && CONTAINSROW(
                SelectedTickers,
                CurrentTickerB
            ),
        AVERAGE(
            FACT_CORRELATION_MATRIX[CORRELATION]
        ),
        BLANK()
    )
```

**Purpose:** Displays a correlation value only when both TICKER_A and
TICKER_B belong to the disconnected slicer selection. Also respects the
WINDOW_YEARS filter.

**Format:** Decimal number, 2 decimals.
