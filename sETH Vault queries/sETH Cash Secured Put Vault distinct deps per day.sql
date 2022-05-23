--number of distinct depositors per day
select 
    date_trunc('day', "block_time") as day
    , count(distinct "from")
from optimism."transactions"
where "to" = '\xFa923AA6b4DF5bea456DF37FA044B37F0FDDCdb4'
    and success = 'true'
    and "block_time" > now() - interval '{{Time frame}}'
group by 1