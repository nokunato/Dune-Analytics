-- number of deposit transactions per day
with optimism as (
select * from optimism."transactions"
),
ser as (
select generate_series((SELECT min("block_time") FROM optimism)::timestamptz, now(), '1 hour')
)
select 
    date_trunc('day', "block_time") as day
    , count(*)
from optimism."transactions" o 
left join ser s on generate_series = o.block_time
where "to" = '\x331Cf6E3E59B18a8bc776A0F652aF9E2b42781c5'
and success = 'true'
and block_time > now() - interval '1 week'
group by 1

-- number of deposit transactions per hour
select 
    date_trunc('hour', "block_time") as hour
    , count(*)
from optimism."transactions"
where "to" = '\x331Cf6E3E59B18a8bc776A0F652aF9E2b42781c5'
and success = 'true'
group by 1