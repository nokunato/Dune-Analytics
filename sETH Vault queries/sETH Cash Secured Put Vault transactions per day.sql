-- number of transactions per day
with dep_value as (
select 
    count(*) as No_of_transactions,
    date_trunc('day', "evt_block_time") as days
from polynomial_protocol."PolynomialCoveredPut_evt_Deposit"
group by 2
union all
select
    count(*) as No_of_transactions, 
    date_trunc('day', evt_block_time) as days
    from polynomial_protocol."PolynomialCoveredPut_evt_CompleteWithdraw"
group by 2
),

Trans_count as (select 
    days
    , No_of_transactions
    , sum(No_of_transactions) as No_of_trans
    , sum(No_of_transactions) over (order by days) as cum_trans_count
from dep_value
where days > now() - interval '{{Time frame}}'
group by 1, 2
order by days desc)

select 
    days
    , sum(No_of_trans)
    , cum_trans_count
from Trans_count
group by 1, 3
order by 1 desc