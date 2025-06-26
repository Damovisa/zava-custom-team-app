-- Setup script for Zava Athletics Database
-- This script creates the database, schema, loads test data, and creates stored procedures

USE master;
GO

-- Create database if it doesn't exist
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'ZavaAthletics')
BEGIN
    CREATE DATABASE ZavaAthletics;
    PRINT 'ZavaAthletics database created successfully!';
END
ELSE
BEGIN
    PRINT 'ZavaAthletics database already exists.';
END
GO

PRINT 'Setting up Zava Athletics Database Schema...';
PRINT '';

-- Execute schema creation
PRINT 'Step 1: Creating database tables...';
:r "schema/01_create_tables.sql"

PRINT '';
PRINT 'Step 2: Loading test data...';
:r "data/test_data.sql"

PRINT '';
PRINT 'Step 3: Creating stored procedures...';
:r "procedures/sp_data_operations.sql"

PRINT '';
PRINT '=== Database Setup Complete ===';
PRINT 'Database: ZavaAthletics';
PRINT 'Tables: 10 tables created with relationships and constraints';
PRINT 'Test Data: Comprehensive test data loaded for all entities';
PRINT 'Stored Procedures: 12 stored procedures created for data operations';
PRINT '';
PRINT 'Next steps:';
PRINT '1. Run tests: sqlcmd -i "scripts/run_tests.sql"';
PRINT '2. Load additional data: sqlcmd -i "data/additional_data.sql"';
PRINT '3. View documentation: See README.md for schema details';
PRINT '';