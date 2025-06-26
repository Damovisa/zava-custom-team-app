-- Unit Tests for Zava Athletics Database
-- This script contains comprehensive unit tests for stored procedures and data validation

USE ZavaAthletics;
GO

-- Create test results table
IF OBJECT_ID('TestResults', 'U') IS NOT NULL DROP TABLE TestResults;
CREATE TABLE TestResults (
    TestID INT IDENTITY(1,1) PRIMARY KEY,
    TestName VARCHAR(200) NOT NULL,
    TestStatus VARCHAR(10) NOT NULL, -- PASS or FAIL
    ErrorMessage TEXT,
    ExecutionTime DATETIME2 DEFAULT GETDATE()
);
GO

-- Test procedure template
CREATE OR ALTER PROCEDURE sp_RunTest
    @TestName VARCHAR(200),
    @TestSQL NVARCHAR(MAX),
    @ExpectedResult NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @ErrorMessage NVARCHAR(MAX) = NULL;
    DECLARE @TestStatus VARCHAR(10) = 'PASS';
    
    BEGIN TRY
        EXEC sp_executesql @TestSQL;
    END TRY
    BEGIN CATCH
        SET @TestStatus = 'FAIL';
        SET @ErrorMessage = ERROR_MESSAGE();
    END CATCH
    
    INSERT INTO TestResults (TestName, TestStatus, ErrorMessage)
    VALUES (@TestName, @TestStatus, @ErrorMessage);
    
    PRINT @TestName + ': ' + @TestStatus + CASE WHEN @ErrorMessage IS NOT NULL THEN ' - ' + @ErrorMessage ELSE '' END;
END
GO

-- Start test execution
PRINT '=== Starting Unit Tests for Zava Athletics Database ===';
PRINT '';

-- Test 1: sp_GetSportsWithLeagueCount
EXEC sp_RunTest 
    @TestName = 'Test sp_GetSportsWithLeagueCount - Basic Execution',
    @TestSQL = N'DECLARE @Count INT; SELECT @Count = COUNT(*) FROM (EXEC sp_GetSportsWithLeagueCount) AS Results; IF @Count = 0 RAISERROR(''No sports returned'', 16, 1);';

-- Test 2: sp_GetLeaguesBySport with valid sport
EXEC sp_RunTest 
    @TestName = 'Test sp_GetLeaguesBySport - Valid Sport (basketball)',
    @TestSQL = N'DECLARE @Count INT; SELECT @Count = COUNT(*) FROM (EXEC sp_GetLeaguesBySport @SportCode = ''basketball'') AS Results; IF @Count = 0 RAISERROR(''No leagues returned for basketball'', 16, 1);';

-- Test 3: sp_GetLeaguesBySport with invalid sport
EXEC sp_RunTest 
    @TestName = 'Test sp_GetLeaguesBySport - Invalid Sport',
    @TestSQL = N'DECLARE @Count INT; SELECT @Count = COUNT(*) FROM (EXEC sp_GetLeaguesBySport @SportCode = ''invalid_sport'') AS Results; IF @Count > 0 RAISERROR(''Unexpected results for invalid sport'', 16, 1);';

-- Test 4: sp_GetTeamsByLeague with valid league
EXEC sp_RunTest 
    @TestName = 'Test sp_GetTeamsByLeague - Valid League (nba)',
    @TestSQL = N'DECLARE @Count INT; SELECT @Count = COUNT(*) FROM (EXEC sp_GetTeamsByLeague @LeagueCode = ''nba'') AS Results; IF @Count = 0 RAISERROR(''No teams returned for NBA'', 16, 1);';

-- Test 5: sp_GetTeamsByLeague with invalid league
EXEC sp_RunTest 
    @TestName = 'Test sp_GetTeamsByLeague - Invalid League',
    @TestSQL = N'DECLARE @Count INT; SELECT @Count = COUNT(*) FROM (EXEC sp_GetTeamsByLeague @LeagueCode = ''invalid_league'') AS Results; IF @Count > 0 RAISERROR(''Unexpected results for invalid league'', 16, 1);';

-- Test 6: sp_SearchTeams with valid search term
EXEC sp_RunTest 
    @TestName = 'Test sp_SearchTeams - Valid Search (Lakers)',
    @TestSQL = N'DECLARE @Count INT; SELECT @Count = COUNT(*) FROM (EXEC sp_SearchTeams @SearchTerm = ''Lakers'') AS Results; IF @Count = 0 RAISERROR(''No teams found for Lakers search'', 16, 1);';

-- Test 7: sp_SearchTeams with empty search term
EXEC sp_RunTest 
    @TestName = 'Test sp_SearchTeams - Empty Search Term',
    @TestSQL = N'EXEC sp_SearchTeams @SearchTerm = '''';';

-- Test 8: sp_GetProducts
EXEC sp_RunTest 
    @TestName = 'Test sp_GetProducts - Basic Execution',
    @TestSQL = N'DECLARE @Count INT; SELECT @Count = COUNT(*) FROM (EXEC sp_GetProducts) AS Results; IF @Count = 0 RAISERROR(''No products returned'', 16, 1);';

-- Test 9: sp_GetProductColors
EXEC sp_RunTest 
    @TestName = 'Test sp_GetProductColors - Basic Execution',
    @TestSQL = N'DECLARE @Count INT; SELECT @Count = COUNT(*) FROM (EXEC sp_GetProductColors) AS Results; IF @Count = 0 RAISERROR(''No product colors returned'', 16, 1);';

-- Test 10: sp_GetTextColors
EXEC sp_RunTest 
    @TestName = 'Test sp_GetTextColors - Basic Execution',
    @TestSQL = N'DECLARE @Count INT; SELECT @Count = COUNT(*) FROM (EXEC sp_GetTextColors) AS Results; IF @Count = 0 RAISERROR(''No text colors returned'', 16, 1);';

-- Test 11: sp_CreateCustomization with valid data
EXEC sp_RunTest 
    @TestName = 'Test sp_CreateCustomization - Valid Data',
    @TestSQL = N'DECLARE @CustomizationID INT; EXEC sp_CreateCustomization @CustomerEmail = ''test@example.com'', @ProductCode = ''t-shirt'', @TeamCode = ''lakers'', @ProductColorName = ''Black'', @TextColorName = ''Gold'', @CustomText = ''Test Player'', @CustomizationID = @CustomizationID OUTPUT; IF @CustomizationID IS NULL RAISERROR(''Customization not created'', 16, 1);';

-- Test 12: sp_CreateCustomization with invalid product
EXEC sp_RunTest 
    @TestName = 'Test sp_CreateCustomization - Invalid Product',
    @TestSQL = N'DECLARE @CustomizationID INT; EXEC sp_CreateCustomization @CustomerEmail = ''test@example.com'', @ProductCode = ''invalid_product'', @CustomizationID = @CustomizationID OUTPUT;';

-- Test 13: sp_CreateCustomization with invalid team
EXEC sp_RunTest 
    @TestName = 'Test sp_CreateCustomization - Invalid Team',
    @TestSQL = N'DECLARE @CustomizationID INT; EXEC sp_CreateCustomization @CustomerEmail = ''test@example.com'', @ProductCode = ''t-shirt'', @TeamCode = ''invalid_team'', @CustomizationID = @CustomizationID OUTPUT;';

-- Test 14: sp_GetCustomization with valid ID
EXEC sp_RunTest 
    @TestName = 'Test sp_GetCustomization - Valid ID',
    @TestSQL = N'DECLARE @CustomizationID INT; SELECT TOP 1 @CustomizationID = CustomizationID FROM Customizations; IF @CustomizationID IS NOT NULL BEGIN DECLARE @Count INT; SELECT @Count = COUNT(*) FROM (EXEC sp_GetCustomization @CustomizationID = @CustomizationID) AS Results; IF @Count = 0 RAISERROR(''No customization data returned'', 16, 1); END';

-- Test 15: sp_GetCustomization with invalid ID
EXEC sp_RunTest 
    @TestName = 'Test sp_GetCustomization - Invalid ID',
    @TestSQL = N'DECLARE @Count INT; SELECT @Count = COUNT(*) FROM (EXEC sp_GetCustomization @CustomizationID = 999999) AS Results; IF @Count > 0 RAISERROR(''Unexpected results for invalid ID'', 16, 1);';

-- Test 16: sp_GetPopularTeams
EXEC sp_RunTest 
    @TestName = 'Test sp_GetPopularTeams - Basic Execution',
    @TestSQL = N'EXEC sp_GetPopularTeams @TopCount = 5;';

-- Test 17: sp_ValidateDataIntegrity
EXEC sp_RunTest 
    @TestName = 'Test sp_ValidateDataIntegrity - Basic Execution',
    @TestSQL = N'EXEC sp_ValidateDataIntegrity;';

-- Data Integrity Tests
PRINT '';
PRINT '=== Data Integrity Tests ===';

-- Test 18: Check for required sports
EXEC sp_RunTest 
    @TestName = 'Data Integrity - Required Sports Exist',
    @TestSQL = N'IF NOT EXISTS (SELECT 1 FROM Sports WHERE SportCode IN (''basketball'', ''soccer'', ''football'', ''baseball'')) RAISERROR(''Required sports missing'', 16, 1);';

-- Test 19: Check all teams have valid colors
EXEC sp_RunTest 
    @TestName = 'Data Integrity - Valid Team Colors',
    @TestSQL = N'IF EXISTS (SELECT 1 FROM Teams WHERE PrimaryColor IS NOT NULL AND PrimaryColor NOT LIKE ''#[0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F]'') RAISERROR(''Invalid team primary colors found'', 16, 1);';

-- Test 20: Check all product colors are valid hex
EXEC sp_RunTest 
    @TestName = 'Data Integrity - Valid Product Color Hex Values',
    @TestSQL = N'IF EXISTS (SELECT 1 FROM ProductColors WHERE ColorValue NOT LIKE ''#[0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F]'') RAISERROR(''Invalid product color hex values found'', 16, 1);';

-- Test 21: Check all text colors are valid hex
EXEC sp_RunTest 
    @TestName = 'Data Integrity - Valid Text Color Hex Values',
    @TestSQL = N'IF EXISTS (SELECT 1 FROM TextColors WHERE ColorValue NOT LIKE ''#[0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F]'') RAISERROR(''Invalid text color hex values found'', 16, 1);';

-- Test 22: Check for orphaned records
EXEC sp_RunTest 
    @TestName = 'Data Integrity - No Orphaned Leagues',
    @TestSQL = N'IF EXISTS (SELECT 1 FROM Leagues l LEFT JOIN Sports s ON l.SportID = s.SportID WHERE s.SportID IS NULL) RAISERROR(''Orphaned leagues found'', 16, 1);';

-- Test 23: Check for orphaned teams
EXEC sp_RunTest 
    @TestName = 'Data Integrity - No Orphaned Teams',
    @TestSQL = N'IF EXISTS (SELECT 1 FROM Teams t LEFT JOIN Leagues l ON t.LeagueID = l.LeagueID WHERE l.LeagueID IS NULL) RAISERROR(''Orphaned teams found'', 16, 1);';

-- Test 24: Check for duplicate team codes within leagues
EXEC sp_RunTest 
    @TestName = 'Data Integrity - No Duplicate Team Codes',
    @TestSQL = N'IF EXISTS (SELECT LeagueID, TeamCode FROM Teams GROUP BY LeagueID, TeamCode HAVING COUNT(*) > 1) RAISERROR(''Duplicate team codes found within leagues'', 16, 1);';

-- Test 25: Check product prices are positive
EXEC sp_RunTest 
    @TestName = 'Data Integrity - Positive Product Prices',
    @TestSQL = N'IF EXISTS (SELECT 1 FROM Products WHERE BasePrice < 0) RAISERROR(''Negative product prices found'', 16, 1);';

-- Performance Tests
PRINT '';
PRINT '=== Performance Tests ===';

-- Test 26: Large dataset query performance
EXEC sp_RunTest 
    @TestName = 'Performance - sp_GetSportsWithLeagueCount Execution Time',
    @TestSQL = N'DECLARE @StartTime DATETIME2 = GETDATE(); EXEC sp_GetSportsWithLeagueCount; DECLARE @EndTime DATETIME2 = GETDATE(); IF DATEDIFF(MILLISECOND, @StartTime, @EndTime) > 1000 RAISERROR(''Query took longer than 1 second'', 16, 1);';

-- Test 27: Search performance
EXEC sp_RunTest 
    @TestName = 'Performance - sp_SearchTeams Execution Time',
    @TestSQL = N'DECLARE @StartTime DATETIME2 = GETDATE(); EXEC sp_SearchTeams @SearchTerm = ''Lakers''; DECLARE @EndTime DATETIME2 = GETDATE(); IF DATEDIFF(MILLISECOND, @StartTime, @EndTime) > 500 RAISERROR(''Search took longer than 500ms'', 16, 1);';

-- Display test summary
PRINT '';
PRINT '=== Test Summary ===';
SELECT 
    TestStatus,
    COUNT(*) as TestCount,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(5,2)) as Percentage
FROM TestResults 
GROUP BY TestStatus
ORDER BY TestStatus;

PRINT '';
PRINT '=== Failed Tests ===';
SELECT TestName, ErrorMessage, ExecutionTime
FROM TestResults 
WHERE TestStatus = 'FAIL'
ORDER BY ExecutionTime;

PRINT '';
PRINT '=== Test Execution Complete ===';

-- Cleanup test procedure
DROP PROCEDURE sp_RunTest;
GO