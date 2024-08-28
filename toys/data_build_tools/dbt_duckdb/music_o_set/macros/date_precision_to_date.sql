{% macro date_precision_to_date(date_col, date_col_precision) %}
    {# Creates a year 'XXXX-01-01' from a date like '1965' or 'mai/1965'. #}
    case
        when contains(
        {{ date_col }}, '/')
            then case
                when
                    regexp_extract(
                    {{ date_col }}, '\d\d')::smallint < 25
                    then
                        (
                            '20'
                            || regexp_extract(
                            {{ date_col }}, '\d\d')
                            || '-01-01'
                        )::date
                else
                    (
                        '19'
                        || regexp_extract(
                        {{ date_col }}, '\d\d')
                        || '-01-01'
                    )::date
            end
        when
            {{ date_col_precision }} = 'month'
            then (
            {{ date_col }} || '-01')::date
        when
            {{ date_col_precision }} = 'year'
            then (
            {{ date_col }} || '-01-01')::date
        else
            
            {{ date_col }}::date
    end
{% endmacro %}
