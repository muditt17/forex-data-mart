{{ config(materialized='table') }}

select
  branch_hk as branch_sk,
  branch_id,
  branch_name,
  city,
  country
from {{ ref('sat_branch_details') }}
where is_current = true
