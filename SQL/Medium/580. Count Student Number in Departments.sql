select dept_name,count(student_name) as student_number from department d
left join student s on d.dept_id = s.dept_id
group by 1
order by student_number desc, dept_name