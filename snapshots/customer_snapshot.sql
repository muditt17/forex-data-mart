{% snapshot customer_snapshot %}
{{
  config(
    target_schema='snapshots',
    unique_key='customer_id',
    strategy='check',
    check_cols=['first_name','last_name','nationality','risk_rating','kyc_status'],
    invalidate_hard_deletes=True
  )
}}
select * from {{ source('raw','customers_raw') }}
{% endsnapshot %}
