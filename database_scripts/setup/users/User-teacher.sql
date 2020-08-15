USE HAN_SQL_EXAM_DATABASE
GO

--setup
drop login teacher_login
create login teacher_login with password = 'teacherpass' 

drop user teacher_user
create user teacher_user from login teacher_login

drop role teacher_role
create role teacher_role 

alter role teacher_role add member teacher_user

--delete
grant exec on object::dbo.pr_delete_answer_criteria to teacher_role;
grant exec on object::dbo.pr_delete_correct_answer to teacher_role;
grant exec on object::dbo.pr_delete_exam to teacher_role;
grant exec on object::dbo.pr_delete_question to teacher_role;
grant exec on object::dbo.pr_disconnect_question_from_exam to teacher_role;
grant exec on object::dbo.pr_remove_student_from_exam to teacher_role;

--insert
grant exec on object::dbo.pr_add_student_to_exam to teacher_role;
grant exec on object::dbo.pr_connect_question_to_exam to teacher_role;
grant exec on object::dbo.pr_insert_all_students_from_a_class_in_exam_for_student to teacher_role;
grant exec on object::dbo.pr_insert_answer_criteria to teacher_role;
grant exec on object::dbo.pr_insert_class to teacher_role;
grant exec on object::dbo.pr_insert_correct_answer to teacher_role;
grant exec on object::dbo.pr_insert_exam to teacher_role;
grant exec on object::dbo.pr_insert_exam_database to teacher_role;
grant exec on object::dbo.pr_insert_exam_group to teacher_role;
grant exec on object::dbo.pr_insert_exam_group_in_exam to teacher_role;
grant exec on object::dbo.pr_insert_question to teacher_role;
grant exec on object::dbo.pr_insert_stand_alone_question to teacher_role;
grant exec on object::dbo.pr_insert_student to teacher_role;
-- grant exec on object::dbo.pr_insert_student_to_exam to teacher_role;

--update
grant exec on object::dbo.pr_update_answer_criteria to teacher_role;
grant exec on object::dbo.pr_update_class to teacher_role;
grant exec on object::dbo.pr_update_correct_answer to teacher_role;
grant exec on object::dbo.pr_update_ddl to teacher_role;
grant exec on object::dbo.pr_update_dml to teacher_role;
grant exec on object::dbo.pr_update_exam to teacher_role;
grant exec on object::dbo.pr_update_exam_database to teacher_role;
grant exec on object::dbo.pr_update_exam_for_student to teacher_role;
grant exec on object::dbo.pr_update_exam_group to teacher_role;
grant exec on object::dbo.pr_update_exam_group_in_exam to teacher_role;
grant exec on object::dbo.pr_update_question to teacher_role;
grant exec on object::dbo.pr_update_student to teacher_role;

--select
grant exec on object::dbo.pr_select_all_answers_for_exam to teacher_role;
grant exec on object::dbo.pr_select_all_question_assignments_from_exam to teacher_role;
grant exec on object::dbo.pr_select_answers_for_exam_per_student to teacher_role;
grant exec on object::dbo.pr_select_correct_answer_from_question to teacher_role;
grant exec on object::dbo.pr_select_pending_correct_answers_for_exam to teacher_role;
grant exec on object::dbo.pr_select_question_in_exam to teacher_role;
grant exec on object::dbo.pr_select_results_for_student_answer to teacher_role;
grant exec on object::dbo.pr_select_student_from_class to teacher_role;
grant exec on object::dbo.pr_select_students_from_group to teacher_role;

--overig
grant exec on object::dbo.pr_create_database to teacher_role;
grant exec on object::dbo.pr_drop_ddl to teacher_role;
grant exec on object::dbo.pr_drop_exam_database_population to teacher_role;
grant exec on object::dbo.pr_execute_ddl to teacher_role;
grant exec on object::dbo.pr_execute_dml to teacher_role;
grant exec on object::dbo.pr_prepare_exam_databases to teacher_role;
grant exec on object::dbo.pr_schedule_exam_job to teacher_role;
grant exec on object::dbo.pr_set_pending_correct_answer_to_false to teacher_role;
grant exec on object::dbo.pr_set_pending_correct_answer_to_true to teacher_role;

--grading
grant exec on object::dbo.ft_execute_statement_into_json to teacher_role;
grant exec on object::dbo.pr_check_all_answers_for_exam to teacher_role;
grant exec on object::dbo.pr_check_all_answers_in_exam_without_group to teacher_role;
grant exec on object::dbo.pr_check_answer to teacher_role;
grant exec on object::dbo.pr_manipulate_population_of_current_database to teacher_role;
grant exec on object::dbo.pr_manipulate_population_of_other_database to teacher_role;
