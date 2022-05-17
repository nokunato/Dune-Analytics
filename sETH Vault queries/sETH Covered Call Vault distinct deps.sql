-- number of distinct depositors into the vault, total and per day
-- number of deposit transactions
-- how many deposits per hour

-- number of total distinct depositors
select 
    count(distinct "from")
from optimism."transactions"
where "to" = '\x331Cf6E3E59B18a8bc776A0F652aF9E2b42781c5'
and "block_time" > now() - interval '{{Time frame}}'
and success = 'true'