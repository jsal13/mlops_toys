with source as (
    select * from {{ source('loancorp', 'loan_info') }}
),
renamed as (
    select
    --ids
        {{ adapter.quote("LOAN_ID") }} as loan_id,
        {{ adapter.quote("LOAN_STATUS_ID") }} as loan_status_id,
        {{ adapter.quote("LENDER_ID") }} as lender_id,
        --numeric
        {{ adapter.quote("DUE_INTEREST_AMOUNT") }} as due_interest_amount,
        {{ adapter.quote("DUE_PRINCIPAL_AMOUNT") }} as due_principal_amount,
        {{ adapter.quote("DUE_ESCROW_AMOUNT") }} as due_escrow_amount,
        {{ adapter.quote("DUE_FEES_AMOUNT") }} as due_fees_amount,
        {{ adapter.quote("PREVIOUS_PAYMENT_AMOUNT") }}
            as previous_payment_amount,
        {{ adapter.quote("NEXT_PAYMENT_AMOUNT") }} as next_payment_amount,
        {{ adapter.quote("CREDIT_LIMIT_AMOUNT") }} as credit_limit_amount,
        {{ adapter.quote("NUMBER_OF_UNIQUE_DELINQUENCIES") }}
            as number_of_unique_delinquencies,
        --dates
        {{ adapter.quote("RECORDED_AT") }} as recorded_at,
        {{ adapter.quote("FOLLOWUP_ON") }} as followup_on,
        {{ adapter.quote("PREVIOUS_PAYMENT_ON") }} as previous_payment_on,
        {{ adapter.quote("NEXT_PAYMENT_ON") }} as next_payment_on
    from source
),
bigints_casted_to_ints as (
    select
        * replace (
            loan_id::int as loan_id,
            loan_status_id::int as loan_status_id,
            lender_id::int as lender_id,
            number_of_unique_delinquencies::int
                as number_of_unique_delinquencies
        )
    from
        renamed
)
select * from bigints_casted_to_ints
