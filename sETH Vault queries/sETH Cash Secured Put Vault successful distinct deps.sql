-- number of distinct depositors into the vault, total and per day
-- number of deposit transactions
-- how many deposits per hour

-- number of total distinct depositors
select 
    count(*)
from optimism."transactions"
where "to" = '\xFa923AA6b4DF5bea456DF37FA044B37F0FDDCdb4'
and "block_time" > now() - interval '{{Time frame}}'
and success = 'true'