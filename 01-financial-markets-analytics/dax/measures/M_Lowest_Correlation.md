# M_Lowest_Correlation

**Home table:** FACT_CORRELATION_MATRIX

```dax
M_Lowest_Correlation =
VAR SelectedPairs =
    FILTER(
        FACT_CORRELATION_MATRIX,
        FACT_CORRELATION_MATRIX[TICKER_A]
            <> FACT_CORRELATION_MATRIX[TICKER_B]
            && CONTAINSROW(
                ALLSELECTED(
                    DIM_TICKER_FILTER[TICKER]
                ),
                FACT_CORRELATION_MATRIX[TICKER_A]
            )
            && CONTAINSROW(
                ALLSELECTED(
                    DIM_TICKER_FILTER[TICKER]
                ),
                FACT_CORRELATION_MATRIX[TICKER_B]
            )
    )

RETURN
    MINX(
        SelectedPairs,
        FACT_CORRELATION_MATRIX[CORRELATION]
    )
```

**Purpose:** Finds the lowest correlation among selected assets,
excluding the diagonal where a ticker is compared with itself.

**Format:** Decimal number, 2 decimals.
**Note:** This numeric measure supports analysis/formatting; the final
card uses the text-pair measure below.
