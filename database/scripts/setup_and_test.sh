#!/bin/bash

# Zava Athletics Database Setup and Test Script
# This script sets up the database and runs comprehensive tests

set -e

echo "=== Zava Athletics Database Setup and Test Script ==="
echo ""

# Check if SQL Server is available (this is for local testing)
# In production, this would connect to your actual SQL Server instance
SQLCMD_AVAILABLE=$(command -v sqlcmd >/dev/null 2>&1 && echo "yes" || echo "no")

if [ "$SQLCMD_AVAILABLE" = "no" ]; then
    echo "⚠️  sqlcmd not available - generating setup instructions instead"
    echo ""
    echo "To set up the Zava Athletics database:"
    echo ""
    echo "1. Ensure you have SQL Server installed and accessible"
    echo "2. Run the following commands in order:"
    echo ""
    echo "   # Setup database schema and initial data:"
    echo "   sqlcmd -S your_server -d master -i database/scripts/setup_database.sql"
    echo ""
    echo "   # Load additional comprehensive test data:"
    echo "   sqlcmd -S your_server -d ZavaAthletics -i database/data/additional_data.sql"
    echo ""
    echo "   # Run comprehensive unit tests:"
    echo "   sqlcmd -S your_server -d ZavaAthletics -i database/scripts/run_tests.sql"
    echo ""
    echo "3. Alternative: Use SQL Server Management Studio (SSMS) to execute the scripts"
    echo ""
    echo "Schema includes:"
    echo "✅ 10 database tables with proper relationships"
    echo "✅ Comprehensive test data (8 sports, 20+ leagues, 80+ teams)"
    echo "✅ 12 stored procedures for data operations"
    echo "✅ 27 unit tests covering all functionality"
    echo "✅ Data integrity and performance tests"
    echo ""
    exit 0
fi

echo "🔍 SQL Server detected - proceeding with database setup..."
echo ""

# Set default server if not provided
SERVER=${SQL_SERVER:-"localhost"}
DATABASE="ZavaAthletics"

echo "📊 Database Server: $SERVER"
echo "📋 Database Name: $DATABASE"
echo ""

# Function to run SQL script
run_sql_script() {
    local script_path=$1
    local description=$2
    
    echo "⏳ $description..."
    
    if sqlcmd -S "$SERVER" -E -i "$script_path" > /dev/null 2>&1; then
        echo "✅ $description completed successfully"
    else
        echo "❌ $description failed"
        echo "   Please check the SQL script: $script_path"
        exit 1
    fi
}

# Check if we're in the correct directory
if [ ! -d "database" ]; then
    echo "❌ Error: database directory not found"
    echo "   Please run this script from the root of the zava-custom-team-app directory"
    exit 1
fi

echo "🚀 Starting database setup process..."
echo ""

# Step 1: Setup database schema and load initial data
echo "📋 Step 1: Setting up database schema and loading initial data"
run_sql_script "database/scripts/setup_database.sql" "Database schema creation and initial data load"

echo ""

# Step 2: Load additional comprehensive test data
echo "📋 Step 2: Loading additional comprehensive test data"
run_sql_script "database/data/additional_data.sql" "Additional comprehensive test data load"

echo ""

# Step 3: Run comprehensive unit tests
echo "📋 Step 3: Running comprehensive unit tests"
echo "⏳ Executing unit tests..."

# Run tests and capture output
TEST_OUTPUT=$(sqlcmd -S "$SERVER" -d "$DATABASE" -i "database/scripts/run_tests.sql" 2>&1)
TEST_EXIT_CODE=$?

if [ $TEST_EXIT_CODE -eq 0 ]; then
    echo "✅ Unit tests executed successfully"
    
    # Extract test summary from output
    echo ""
    echo "📊 Test Results Summary:"
    echo "$TEST_OUTPUT" | grep -A 10 "Test Summary"
    
    # Show any failed tests
    FAILED_TESTS=$(echo "$TEST_OUTPUT" | grep -A 20 "Failed Tests")
    if [ -n "$FAILED_TESTS" ]; then
        echo ""
        echo "⚠️  Failed Tests:"
        echo "$FAILED_TESTS"
    fi
else
    echo "❌ Unit tests failed"
    echo "Test output:"
    echo "$TEST_OUTPUT"
    exit 1
fi

echo ""
echo "🎉 Zava Athletics Database Setup Complete!"
echo ""
echo "📈 Database Statistics:"

# Get database statistics
sqlcmd -S "$SERVER" -d "$DATABASE" -Q "
SELECT 'Sports' as Entity, COUNT(*) as Count FROM Sports WHERE IsActive = 1
UNION ALL SELECT 'Leagues', COUNT(*) FROM Leagues WHERE IsActive = 1  
UNION ALL SELECT 'Teams', COUNT(*) FROM Teams WHERE IsActive = 1
UNION ALL SELECT 'Products', COUNT(*) FROM Products WHERE IsActive = 1
UNION ALL SELECT 'Colors', COUNT(*) FROM ProductColors WHERE IsActive = 1
UNION ALL SELECT 'Customers', COUNT(*) FROM Customers
UNION ALL SELECT 'Customizations', COUNT(*) FROM Customizations
" -h-1

echo ""
echo "🛠️  Available Stored Procedures:"
echo "   • sp_GetSportsWithLeagueCount - Get all sports with league counts"
echo "   • sp_GetLeaguesBySport - Get leagues for a specific sport"
echo "   • sp_GetTeamsByLeague - Get teams for a specific league"
echo "   • sp_SearchTeams - Search teams by name"
echo "   • sp_GetProducts - Get all available products"
echo "   • sp_CreateCustomization - Create new customization"
echo "   • sp_GetCustomization - Get customization details"
echo "   • sp_GetPopularTeams - Get most popular teams"
echo "   • sp_ValidateDataIntegrity - Run data integrity checks"
echo ""
echo "📝 Next Steps:"
echo "   1. Connect to the $DATABASE database"
echo "   2. Execute stored procedures to interact with data"
echo "   3. Review test results in the TestResults table"
echo "   4. Integrate with your application using the stored procedures"
echo ""
echo "📚 Documentation: See database/README.md for detailed schema information"
echo ""