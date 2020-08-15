USE VerifyPrototype
GO
CREATE OR ALTER PROC proc_prototype  
	@queryNo int, 
    @correctQuery VARCHAR(MAX)
AS
BEGIN
	DECLARE @startTC INT = @@TRANCOUNT
    DECLARE @savepoint VARCHAR(128) = CAST(OBJECT_NAME(@@PROCID) AS VARCHAR(125)) + CAST(@@NESTLEVEL AS VARCHAR(3))
    BEGIN TRY
        BEGIN TRAN
            SAVE TRAN @savepoint
            BEGIN TRY
                DECLARE @query VARCHAR(MAX)
                SELECT @query = query FROM SQLqueries WHERE queryNo = @queryNo

                --Check if syntax is correct by executing query.
                BEGIN TRY
                    --werkt voor select statements. voor CRUD statements moet er nog een extra transaction worden toegevoegd.
                    EXEC (@query)
                END TRY
                BEGIN CATCH
					THROW 51001, 'Statement not executable', 1;
                END CATCH

                BEGIN TRY
                    DECLARE @query2 NVARCHAR(MAX) = @query + ' Except ' + @correctQuery + ' union ' + @correctQuery + ' Except ' + @Query
                    EXEC sp_executesql @query2
                    if(@@rowcount > 0)
                        THROW 51003, 'Queries do not return same rows', 1;
                END TRY
                BEGIN CATCH
                    IF(ERROR_NUMBER() = 51003)
                        THROW;
                    THROW
                END CATCH

                INSERT INTO results (queryNo, correct) VALUES (@queryNo, 1)

            END TRY
            BEGIN CATCH
                INSERT INTO results (queryNo, correct) VALUES (@queryNo, 0)
            END CATCH
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        IF xact_state() = -1 AND @startTC = 0
            ROLLBACK TRAN
        IF xact_state() = 1
            BEGIN
                ROLLBACK TRAN @savepoint
                COMMIT TRAN
            END;
        THROW
    END CATCH
END