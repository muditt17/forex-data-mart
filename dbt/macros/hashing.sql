{% macro hash_key(cols) -%}
  md5(
    {%- for col in cols -%}
      coalesce(cast({{ col }} as varchar), '')
      {%- if not loop.last -%} || '|' || {%- endif -%}
    {%- endfor -%}
  )
{%- endmacro %}

{% macro hashdiff(cols) -%}
  md5(
    {%- for col in cols -%}
      coalesce(cast({{ col }} as varchar), '')
      {%- if not loop.last -%} || '|' || {%- endif -%}
    {%- endfor -%}
  )
{%- endmacro %}
