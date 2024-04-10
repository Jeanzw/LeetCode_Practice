select user_id from Loans
where loan_type in ('Mortgage','Refinance')
group by 1
having count(distinct loan_type) = 2
order by 1