{# TABLE DOCUMENTATION #}

{% docs stg_loancorp__customers %}
# Loancorp Customers Table

## Details

This table holds information about loancorp customers.

- Age
- Address
- Social Security Number

{% enddocs %}

{% docs stg_loancorp__lenders %}
This table holds information about loancorp lenders.
{% enddocs %}

{% docs stg_loancorp__loan_customer_lookup %}
This table holds information about loancorp lenders.
{% enddocs %}

{% docs stg_loancorp__loan_info %}
This table holds information about loans.
{% enddocs %}

{% docs stg_loancorp__statuses %}
This table is a loan_id to customer_id lookup.
{% enddocs %}

{% docs stg_loancorp__total_loans_per_customer %}
This table is a loan_id to customer_id lookup.
{% enddocs %}

{# COLUMN DOCUMENTATION #}

{% docs loancorp__customer_id %}
The ID of the associated customer.
{% enddocs %}

{% docs loancorp__full_name %}
The first and last name of the customer.
{% enddocs %}

{% docs loancorp__customer_address %}
The current address of the customer.
{% enddocs %}

{% docs loancorp__social_security_number %}
The social security number of the customer.
{% enddocs %}

{% docs loancorp__customer_age %}
The age of the customer.
{% enddocs %}

{% docs loancorp__loan_status_id %}
The ID of the associated loan status.
{% enddocs %}

{% docs loancorp__loan_status_value %}
The value of the loan status.
{% enddocs %}

{% docs loancorp__loan_id %}
The ID of the associated loan.
{% enddocs %}

{% docs loancorp__lender_id %}
The ID of the associated lender.
{% enddocs %}

{% docs loancorp__lender_name %}
The name of the lender.
{% enddocs %}

{% docs loancorp__due_interest_amount %}
The amount the customer owes in interest.
{% enddocs %}

{% docs loancorp__due_principal_amount %}
The amount the customer owes of the principal.
{% enddocs %}

{% docs loancorp__due_escrow_amount %}
The amount the customer owes of the escrow.
{% enddocs %}

{% docs loancorp__due_fees_amount %}
The amount the customer owes of the fees.
{% enddocs %}

{% docs loancorp__previous_payment_amount %}
The previous payment the customer successfully made.
{% enddocs %}

{% docs loancorp__next_payment_amount %}
The next payment the customer is schedule to make.
{% enddocs %}

{% docs loancorp__credit_limit_amount %}
The credit limit of the customer.
{% enddocs %}

{% docs loancorp__number_of_unique_delinquencies %}
The number of unique delinquencies the customer has at loancorp.
{% enddocs %}

{% docs loancorp__recorded_at %}
The timestamp this row was created on.
{% enddocs %}

{% docs loancorp__followup_on %}
The date a followup is scheduled.
{% enddocs %}

{% docs loancorp__previous_payment_on %}
The date of the most recent previous payment.
{% enddocs %}

{% docs loancorp__next_payment_on %}
The date the next payment is due.
{% enddocs %}

{% docs loancorp__number_of_loan_ids %}
The number of distinct loan_ids assigned to the corresponding customer_id.
{% enddocs %}
