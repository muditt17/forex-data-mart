{{ config(materialized='view') }}

select *
from {{ source('raw','branches_raw') }}
