select
    order_id,
    sum(payment_amount) as total_amount
from {{ ref('stg_stripe__payments') }}
where payment_status='success'
group by order_id
having sum(payment_amount) < 0