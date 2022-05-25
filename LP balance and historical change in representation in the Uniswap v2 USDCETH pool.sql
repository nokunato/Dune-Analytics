-- LP balance and historical change in representation in the Uniswap v2 USDC/ETH pool
with unioning as (
select 
    date_trunc('day', evt_block_time) as days
    , "to" as user
    , -1*sum(amount1/1e18) as value
    , contract_address
from uniswap_v2."Pair_evt_Burn"
where "contract_address" = '\xb4e16d0168e52d35cacd2c6185b44281ec28c9dc'
and evt_block_time > now() - interval '6 months'
and "to" = '\x7a250d5630b4cf539739df2c5dacb4c659f2488d'
group by 1, 2, 4
union all
select 
    date_trunc('day', evt_block_time) as days
    , sender as user
    , 1*sum(amount1/1e18) as value
    , contract_address
from uniswap_v2."Pair_evt_Mint"
where "contract_address" = '\xb4e16d0168e52d35cacd2c6185b44281ec28c9dc'
and evt_block_time > now() - interval '6 months'
and sender = '\x7a250d5630b4cf539739df2c5dacb4c659f2488d'
group by 1, 2, 4
),

all_trans as (
select
    user,
    days,
    sum(value) as value
from unioning
group by 1, 2
)

select 
    days
    , value as LP_balance
    , sum(value) over (order by days) as cum_value
from all_trans
group by 1, 2