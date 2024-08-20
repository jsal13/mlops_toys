SELECT
    RC.NAME,
    RO.ORDERED_AT,
    RO.ORDER_TOTAL
FROM
    {{ ref('raw_customers') }} AS RC INNER JOIN {{ ref('raw_orders') }} AS RO
    ON RC.ID = RO.CUSTOMER
