{% macro musicoset_json_to_real_json(json_col) %}
    {# Transforms CSV-pulled json with single quotes into legal json. #}
 
    {# Replace all single quotes with double quotes, except for internal single quotes. #}
    {# Also replaces double-quotes with single quotes for names. #}

    {%- set danging_quote_pattern = "(?<![{}])\\'(?![{}:])" -%}
    {%- set value = modules.re.sub(json_col, danging_quote_pattern, "") -%}
    {%- set value2 = modules.re.sub(value, "{'", "{\"") -%}
    {%- set value3 = modules.re.sub(value2, "'}", "\"}") -%}
    {%- set value4 = modules.re.sub(value3, "': '", "\": \"") -%}
    {%- set value5 = modules.re.sub(value4, "', '", "\", \"") -%}

    {{ value5 }}::json

    {# {%- set no_double_quotes = dbt.replace(value, '\'\"\'', '\'\'') -%}
    {%- set no_start_braces_quotes = dbt.replace(no_double_quotes, '\'{\'\'\'', '\'{\"\'') -%}
    {%- set no_end_braces_quotes = dbt.replace(no_start_braces_quotes, '\'\'\'}\'', '\'\"}\'') -%}
    {%- set no_singles_around_colon = dbt.replace(no_end_braces_quotes, '\'\'\': \'\'\'', '\'\": \"\'') -%}
    {%- set no_singles_around_comma = dbt.replace(no_singles_around_colon, '\'\'\', \'\'\'', '\'\", \"\'') -%} #}

    {# {%- set left_side_colon_replacement = dbt.replace(no_singles_around_comma, '\'\'\': \'', '\'\": \'') -%} #}
    
    {{ no_singles_around_comma }}

{% endmacro %}


