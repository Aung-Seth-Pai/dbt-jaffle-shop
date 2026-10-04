with order_data as (
    select
        order_id,
        customer_id,
        order_date
    from {{ ref('stg_jaffle_shop__orders') }}
),

payments as (
    select
        order_id,
        payment_status,
        payment_amount
    from {{ ref('stg_stripe__payments') }}
),

order_payments as (
    select
        order_id,
        sum(case when payment_status = 'success' then payments.payment_amount end) as amount
    from payments
    group by 1
),

final as (
    select 
        order_data.order_id,
        order_data.customer_id,
        order_data.order_date,
        coalesce(order_payments.amount, 0) as amount
    from order_data
    left join order_payments using (order_id)

)

select * from final
