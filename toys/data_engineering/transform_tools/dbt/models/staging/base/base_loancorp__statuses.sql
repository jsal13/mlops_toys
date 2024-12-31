with source as (
    select * from {{ source('loancorp', 'statuses') }}
),
renamed as (
    select
        --ids
        {{ adapter.quote("LOAN_STATUS_ID") }} as loan_status_id,
        --strings
        {{ adapter.quote("LOAN_STATUS_VALUE") }} as loan_status_value
    from source
),
bigints_casted_to_ints as (
    select
        * replace (
            loan_status_id::int as loan_status_id
        )
    from
        renamed
)
select * from bigints_casted_to_ints
