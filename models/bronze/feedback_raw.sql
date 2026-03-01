{{ config(materialized='view') }}

select *
from {{ source('raw','feedback_raw') }}
