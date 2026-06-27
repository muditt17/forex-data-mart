{% snapshot cash_lease_snapshot %}
{{
  config(
    unique_key='lease_id',
    strategy='check',
    check_cols=['bank_id','currency_code','lease_amount','interest_rate','lease_start','lease_end'],
    invalidate_hard_deletes=True
  )
}}
select * from {{ source('raw','cash_lease_raw') }}
{% endsnapshot %}
