select
    cust.customer_id,
    cust.full_name as customer_name,
    cust.customer_address,
    cust.customer_age,
    tlpc.number_of_loan_ids as number_of_unique_loans_assigned,
    ldaa.due_interest_amount_sum as total_interest_paid,
    ldaa.due_principal_amount_sum as total_principal_paid,
    ldaa.due_escrow_amount_sum as total_escrow_paid,
    ldaa.due_fees_amount_sum as total_fees_paid
from
    {{ ref("int_loans_due_amounts_aggregated") }} as ldaa
left join
    {{ ref("stg_loancorp__customers") }} as cust
    on ldaa.customer_id = cust.customer_id
left join
    {{ ref("stg_loancorp__total_loans_per_customer") }} as tlpc
    on ldaa.customer_id = tlpc.customer_id
