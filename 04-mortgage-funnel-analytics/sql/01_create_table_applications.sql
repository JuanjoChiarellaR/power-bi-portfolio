CREATE EXTERNAL TABLE hmda_funnel.applications (
  activity_year INT,
  action_taken INT,
  "denial_reason-1" INT,
  preapproval INT,
  loan_amount DOUBLE,
  property_value STRING,
  interest_rate STRING,
  rate_spread STRING,
  discount_points STRING,
  total_loan_costs STRING,
  origination_charges STRING,
  derived_loan_product_type STRING,
  derived_dwelling_category STRING,
  conforming_loan_limit STRING,
  derived_ethnicity STRING,
  derived_race STRING,
  derived_sex STRING,
  applicant_age STRING,
  income DOUBLE,
  debt_to_income_ratio STRING,
  state_code STRING,
  county_code DOUBLE,
  ffiec_msa_md_median_family_income INT
)
STORED AS PARQUET
LOCATION 's3://hmda-funnel-analytics-juanjo/raw/';
