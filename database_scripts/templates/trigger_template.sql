--Version 2 
CREATE OR ALTER TRIGGER tr_template
    ON dbo.template
    FOR UPDATE, INSERT, DELETE
    AS
BEGIN
    IF @@ROWCOUNT = 0
        RETURN;

    SET NOCOUNT ON;

    BEGIN TRY
		--Logic
            BEGIN
                ;THROW --Logic
            END
    END TRY
    BEGIN CATCH
		--Error table?
        ;THROW
    END CATCH
END
GO