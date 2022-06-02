--number of distinct depositors per day
with dep_value as (
select 
    user as address,
    date_trunc('hour', "evt_block_time") as hours,
    (amt/1e18) as sUSD
from polynomial_protocol."PolynomialCoveredPut_evt_Deposit"
-- group by 1
union all
select
    user as address,
    date_trunc('hour', evt_block_time) as hours,
    -1*(funds/1e18) as sUSD
    from polynomial_protocol."PolynomialCoveredPut_evt_CompleteWithdraw"
-- group by 1
),

all_trans as (
select 
    address,
    hours,
    sum(sUSD) as sUSD
from dep_value
group by 1, 2
),

dep_trans as (
select count(*) as Trans_count, hours
from dep_value
group by 2
)

select 
    at.hours
    , at.sUSD as sUSD_balance
    , dt.Trans_count
    , sum(sUSD) over (order by at.hours) as cum_sUSD_Balance
    , sum(Trans_count) over (order by dt.hours) as cum_transactions
    -- , sum(sUSD) as sUSD_de
from all_trans at
left join dep_trans dt on at.hours = dt.hours
where at.hours > now() - interval '{{Time frame}}'
-- group by 1, 2, 3
order by 1 desc
