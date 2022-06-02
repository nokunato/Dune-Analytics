--number of distinct depositors per day
with price as (select * from prices."approx_prices_from_dex_data"
where "symbol" like 'sETH'),

dep_value as (
select 
    user as address,
    date_trunc('hour', "evt_block_time") as hours,
    (amt/1e18) as sETH
from polynomial_protocol."PolynomialCoveredCall_evt_Deposit"
-- group by 1
union all
select
    user as address,
    date_trunc('hour', evt_block_time) as hours,
    -1*(funds/1e18) as sETH
    from polynomial_protocol."PolynomialCoveredCall_evt_CompleteWithdraw"
-- group by 1
),

all_trans as (
select 
    address,
    hours,
    sum(sETH) as sETH
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
    , at.sETH as sETH_tx_balance
    , dt.Trans_count
    , max(price.median_price) as median_price
    , SUM(sETH*price.median_price) as sETH_USD_amt
    , sum(sETH) over (order by at.hours) as cum_sETH_deposits
    , sum(sETH) over (order by at.hours) * max(price.median_price) as cum_USD_deposits
    , sum(Trans_count) over (order by at.hours) as cum_transactions_count
from all_trans at
left join dep_trans dt on at.hours = dt.hours
join price on at.hours = price.hour
where at.hours > now() - interval '{{Time frame}}'
group by 1, 2, 3
order by 1 desc
