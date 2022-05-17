--number of distinct depositors per day
select 
    date_trunc('day', "block_time") as day
    , count(distinct "from")
from optimism."transactions"
where "to" = '\x331Cf6E3E59B18a8bc776A0F652aF9E2b42781c5'
    and success = 'true'
    and "block_time" > now() - interval '{{Time frame}}'
group by 1