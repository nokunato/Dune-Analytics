
-- cummulative transactions per hour
select 
    date_trunc('hour', "block_time") as hour
    , count(*) over (order by block_time)
from optimism."transactions"
where "to" = '\x331Cf6E3E59B18a8bc776A0F652aF9E2b42781c5'
and success = 'true'
and "block_time" > now() - interval '{{Time frame}}'
-- group by 1
