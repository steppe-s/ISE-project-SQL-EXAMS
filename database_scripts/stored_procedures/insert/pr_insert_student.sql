USE HAN_SQL_EXAM_DATABASE
GO
CREATE OR ALTER PROCEDURE pr_insert_student
	@student_no	INT,
	@class VARCHAR(20),
	@first_name	VARCHAR(30),
	@last_name	VARCHAR(50),
	@is_dyslexic bit

AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @startTC INT = @@TRANCOUNT;
    DECLARE @savepoint VARCHAR(128) = CAST(OBJECT_NAME(@@PROCID) AS VARCHAR(125)) + CAST(@@NESTLEVEL AS VARCHAR(3));
    BEGIN TRY
        BEGIN TRANSACTION
            SAVE TRANSACTION @savepoint;
			IF @student_no IS NULL
				THROW 60012, 'student_no cannot be NULL', 1;
			IF @class IS NULL
				THROW 60011, 'class cannot be NULL', 1;
			IF @first_name IS NULL
				THROW 60013, 'first_name cannot be NULL', 1;
			IF @last_name IS NULL
				THROW 60014, 'last_name cannot be NULL', 1;
			IF @is_dyslexic IS NULL
				THROW 60031, 'is_dyslexic cannot be null', 1;

			INSERT INTO dbo.STUDENT (student_no, class, first_name, last_name, is_dyslexic)
			VALUES (@student_no, @class, @first_name, @last_name, @is_dyslexic)

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
