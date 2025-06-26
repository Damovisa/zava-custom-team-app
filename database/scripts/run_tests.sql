-- Test Runner for Zava Athletics Database
-- This script executes all unit tests and provides comprehensive reporting

PRINT '=== Zava Athletics Database Test Suite ===';
PRINT 'Executing comprehensive unit tests for database schema and stored procedures';
PRINT '';

USE ZavaAthletics;
GO

-- Check if database exists and is accessible
IF DB_NAME() != 'ZavaAthletics'
BEGIN
    PRINT 'ERROR: Unable to access ZavaAthletics database';
    PRINT 'Please ensure the database has been created and you have appropriate permissions';
    RETURN;
END

-- Verify essential tables exist
DECLARE @MissingTables TABLE (TableName VARCHAR(100));

INSERT INTO @MissingTables (TableName)
SELECT TableName FROM (
    VALUES 
        ('Sports'), ('Leagues'), ('Teams'), ('Products'), 
        ('ProductColors'), ('TextColors'), ('Customers'), 
        ('Customizations'), ('Orders'), ('OrderItems')
) AS ExpectedTables(TableName)
WHERE NOT EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.TABLES 
    WHERE TABLE_NAME = ExpectedTables.TableName 
    AND TABLE_SCHEMA = 'dbo'
);

IF EXISTS (SELECT 1 FROM @MissingTables)
BEGIN
    PRINT 'ERROR: Missing required tables:';
    SELECT TableName FROM @MissingTables;
    PRINT 'Please run setup_database.sql first';
    RETURN;
END

PRINT 'Database validation passed. Starting unit tests...';
PRINT '';

-- Execute unit tests
:r "tests/unit_tests.sql"

PRINT '';
PRINT '=== Additional Validation ===';

-- Check data counts
PRINT 'Data Count Validation:';
SELECT 'Sports' as Entity, COUNT(*) as RecordCount FROM Sports WHERE IsActive = 1
UNION ALL
SELECT 'Leagues' as Entity, COUNT(*) as RecordCount FROM Leagues WHERE IsActive = 1  
UNION ALL
SELECT 'Teams' as Entity, COUNT(*) as RecordCount FROM Teams WHERE IsActive = 1
UNION ALL
SELECT 'Products' as Entity, COUNT(*) as RecordCount FROM Products WHERE IsActive = 1
UNION ALL
SELECT 'ProductColors' as Entity, COUNT(*) as RecordCount FROM ProductColors WHERE IsActive = 1
UNION ALL
SELECT 'TextColors' as Entity, COUNT(*) as RecordCount FROM TextColors WHERE IsActive = 1
UNION ALL
SELECT 'Customers' as Entity, COUNT(*) as RecordCount FROM Customers
UNION ALL
SELECT 'Customizations' as Entity, COUNT(*) as RecordCount FROM Customizations
UNION ALL
SELECT 'Orders' as Entity, COUNT(*) as RecordCount FROM Orders
UNION ALL
SELECT 'OrderItems' as Entity, COUNT(*) as RecordCount FROM OrderItems;

PRINT '';
PRINT 'Database Relationships Validation:';

-- Check relationship integrity
SELECT 'Sports -> Leagues' as Relationship, 
       COUNT(DISTINCT s.SportID) as ParentRecords,
       COUNT(DISTINCT l.LeagueID) as ChildRecords
FROM Sports s
LEFT JOIN Leagues l ON s.SportID = l.SportID
WHERE s.IsActive = 1

UNION ALL

SELECT 'Leagues -> Teams' as Relationship,
       COUNT(DISTINCT l.LeagueID) as ParentRecords, 
       COUNT(DISTINCT t.TeamID) as ChildRecords
FROM Leagues l
LEFT JOIN Teams t ON l.LeagueID = t.LeagueID  
WHERE l.IsActive = 1

UNION ALL

SELECT 'Customers -> Customizations' as Relationship,
       COUNT(DISTINCT c.CustomerID) as ParentRecords,
       COUNT(DISTINCT cu.CustomizationID) as ChildRecords
FROM Customers c
LEFT JOIN Customizations cu ON c.CustomerID = cu.CustomerID;

PRINT '';
PRINT 'Performance Benchmarks:';

-- Performance test for complex query
DECLARE @StartTime DATETIME2 = GETDATE();
SELECT COUNT(*) FROM Teams t
INNER JOIN Leagues l ON t.LeagueID = l.LeagueID
INNER JOIN Sports s ON l.SportID = s.SportID
WHERE t.IsActive = 1 AND l.IsActive = 1 AND s.IsActive = 1;
DECLARE @EndTime DATETIME2 = GETDATE();
DECLARE @Duration INT = DATEDIFF(MILLISECOND, @StartTime, @EndTime);
PRINT 'Complex JOIN query execution time: ' + CAST(@Duration AS VARCHAR(10)) + 'ms';

PRINT '';
PRINT '=== Test Suite Complete ===';
PRINT 'Review the TestResults table for detailed test outcomes';
PRINT 'Check failed tests for any issues that need attention';
PRINT '';