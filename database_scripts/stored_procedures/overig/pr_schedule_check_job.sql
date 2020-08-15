USE HAN_SQL_EXAM_DATABASE
GO
CREATE OR ALTER PROCEDURE pr_schedule_check_job
	@exam_id varchar(20),
    @end_date DATETIME
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @startTC INT = @@TRANCOUNT;
    DECLARE @savepoint VARCHAR(128) = CAST(OBJECT_NAME(@@PROCID) AS VARCHAR(125)) + CAST(@@NESTLEVEL AS VARCHAR(3));
    BEGIN TRY
        BEGIN TRANSACTION
            SAVE TRANSACTION @savepoint;

            IF(@exam_id IS NULL) THROW 60001, 'exam_id cannot be null', 1;
            IF(@end_date IS NULL) THROW 60035, 'end_date cannot be null', 1;
            IF(@end_date < GETDATE()) THROW 60036, 'scheduled date cannot be in the past', 1;

            DECLARE @job_name NVARCHAR(29) = N'jb_' + @exam_id + '_check'
            DECLARE @schedule_name NVARCHAR(29) = N'sd_' + @exam_id + '_check'
            DECLARE @start_date INT = cast(format(@end_date,'yyyyMMdd') as int)
            DECLARE @start_time INT = cast(format(@end_date,'HHmmss') as int)
            DECLARE @command VARCHAR(40) = 'exec pr_check_all_answers_in_exam_without_group ''' + @exam_id + ''''

                IF EXISTS(SELECT job_id FROM msdb.dbo.sysjobs WHERE (name = @job_name))
                BEGIN
                    EXEC msdb.dbo.sp_delete_job
                        @job_name = @job_name;
                END

                EXEC msdb.dbo.sp_add_job  
                    @job_name = @job_name,   
                    @enabled = 1,   
                    @description = N'job for auto grading of answers.'; 

                EXEC msdb.dbo.sp_add_jobstep  
                    @job_name = @job_name,   
                    @step_name = N'Run Procedure',   
                    @subsystem = N'TSQL',
                    @database_name='HAN_SQL_EXAM_DATABASE',    
                    @command = @command;

                EXEC msdb.dbo.sp_add_schedule  
                    @schedule_name = @schedule_name,   
                    @freq_type = 1,
                    @freq_interval = 1,
                    @active_start_date = @start_date,
                    @active_start_time = @start_time;

                EXEC msdb.dbo.sp_attach_schedule  
                    @job_name = @job_name,  
                    @schedule_name = @schedule_name ;

                EXEC msdb.dbo.sp_add_jobserver  
                    @job_name = @job_name,  
                    @server_name = @@servername;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() = -1 AND @startTC = 0
            ROLLBACK TRANSACTION;
        ELSE
            IF XACT_STATE() = 1
                BEGIN
                    ROLLBACK TRANSACTION @savepoint;
                    COMMIT TRANSACTION;
                END;
        DECLARE @errormessage VARCHAR(2000) =
                'Error occured in sproc ''' + OBJECT_NAME(@@procid) + '''. Original message: ''' + ERROR_MESSAGE() +
                '''';
        THROW 50000, @errormessage, 1;
    END CATCH;
END