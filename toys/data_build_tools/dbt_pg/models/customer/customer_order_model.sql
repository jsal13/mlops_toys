select
  rc.name
  , ro.ordered_at	
  , ro.order_total
from
  {{ ref('raw_customers') }} rc join {{ ref('raw_orders') }} ro
  on rc.id = ro.customer