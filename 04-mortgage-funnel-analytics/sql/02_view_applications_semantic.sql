CREATE VIEW hmda_funnel.v_applications_semantic AS
SELECT
  state_code, county_code, derived_loan_product_type, derived_dwelling_category,
  conforming_loan_limit, derived_ethnicity, derived_race, derived_sex, applicant_age,
  debt_to_income_ratio, income, loan_amount,
  TRY_CAST(property_value AS DOUBLE) AS property_value_num,
  TRY_CAST(interest_rate AS DOUBLE) AS interest_rate_num,
  TRY_CAST(rate_spread AS DOUBLE) AS rate_spread_num,
  TRY_CAST(discount_points AS DOUBLE) AS discount_points_num,
  TRY_CAST(total_loan_costs AS DOUBLE) AS total_loan_costs_num,
  TRY_CAST(origination_charges AS DOUBLE) AS origination_charges_num,
  ffiec_msa_md_median_family_income, action_taken,
  CASE action_taken
    WHEN 1 THEN 'Originated' WHEN 2 THEN 'Approved not accepted' WHEN 3 THEN 'Denied'
    WHEN 4 THEN 'Withdrawn' WHEN 5 THEN 'Incomplete' WHEN 7 THEN 'Preapproval denied'
    WHEN 8 THEN 'Preapproval approved not accepted'
  END AS funnel_stage,
  CASE WHEN action_taken = 1 THEN 'Originated' WHEN action_taken = 3 THEN 'Risk-based leakage' ELSE 'Process-based leakage' END AS leakage_category,
  CASE WHEN action_taken IN (2, 8) THEN true ELSE false END AS is_approved_not_converted,
  "denial_reason-1",
  CASE "denial_reason-1"
    WHEN 1 THEN 'Debt-to-income ratio' WHEN 2 THEN 'Employment history' WHEN 3 THEN 'Credit history'
    WHEN 4 THEN 'Collateral' WHEN 5 THEN 'Insufficient cash' WHEN 6 THEN 'Unverifiable information'
    WHEN 7 THEN 'Credit application incomplete' WHEN 8 THEN 'Mortgage insurance denied'
    WHEN 9 THEN 'Other' WHEN 10 THEN 'Not applicable' WHEN 1111 THEN 'Exempt'
  END AS denial_reason_label,
  CASE WHEN TRY_CAST(property_value AS DOUBLE) > 0 THEN loan_amount / TRY_CAST(property_value AS DOUBLE) END AS ltv_calculated
FROM hmda_funnel.applications;
