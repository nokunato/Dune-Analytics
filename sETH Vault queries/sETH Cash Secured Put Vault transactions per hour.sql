
-- number of deposit transactions per hour
select 
    date_trunc('hour', "block_time") as hour
    , count(*)
from optimism."transactions"
where "to" = '\xFa923AA6b4DF5bea456DF37FA044B37F0FDDCdb4'
and success = 'true'
and "block_time" > now() - interval '{{Time frame}}'
group by 1