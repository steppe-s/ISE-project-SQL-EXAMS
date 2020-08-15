use HAN_SQL_EXAM_DATABASE
go

drop login student_login
create login student_login with password = 'studentpass' 

drop user student_user
create user student_user from login student_login

drop role student_role
create role student_role 

alter role student_role add member student_user

-- insert
grant exec on object::dbo.pr_insert_answer to student_role;  

-- update
grant exec on object::dbo.pr_update_answer to student_role;  

-- select
grant exec on object::dbo.pr_select_all_question_assignments_from_exam to student_role;  

-- overig
grant exec on object::dbo.pr_hand_in_exam to student_role;  