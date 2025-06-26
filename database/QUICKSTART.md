# Zava Athletics Database - Quick Start Guide

## Overview
This directory contains a complete database solution for the Zava Athletics Clothing Customizer application with comprehensive test data and unit tests.

## 🚀 Quick Setup

### Option 1: Automated Setup (Recommended)
```bash
# Run the automated setup script
./database/scripts/setup_and_test.sh
```

### Option 2: Manual Setup
```sql
-- 1. Create database and schema
sqlcmd -S your_server -d master -i database/scripts/setup_database.sql

-- 2. Load additional test data  
sqlcmd -S your_server -d ZavaAthletics -i database/data/additional_data.sql

-- 3. Run unit tests
sqlcmd -S your_server -d ZavaAthletics -i database/scripts/run_tests.sql
```

## 📊 What's Included

### Database Schema
- **10 tables** with full referential integrity
- **1,270+ lines** of SQL code
- **13 stored procedures** for data operations
- **27 comprehensive unit tests**

### Test Data Coverage
- **8 sports** (Basketball, Soccer, Football, Baseball, Hockey, Tennis, Golf, Motorsports)
- **20+ leagues** (NBA, NFL, Premier League, La Liga, IPL, etc.)
- **80+ teams** with authentic branding colors
- **16 product types** (t-shirts, hoodies, jackets, caps, etc.)
- **50+ color options** for products and text
- **Sample orders and customizations**

### Key Features
✅ **Complete schema** based on existing TypeScript data  
✅ **Production-ready** with proper constraints and indexes  
✅ **Comprehensive test coverage** (27 unit tests)  
✅ **Data integrity validation** built-in  
✅ **Performance optimized** with strategic indexes  
✅ **Well documented** with usage examples  
✅ **Cross-platform** setup scripts  

## 🔍 Example Usage

```sql
-- Get all basketball leagues
EXEC sp_GetLeaguesBySport @SportCode = 'basketball';

-- Search for Lakers teams
EXEC sp_SearchTeams @SearchTerm = 'Lakers';

-- Create a customization
DECLARE @CustomizationID INT;
EXEC sp_CreateCustomization 
    @CustomerEmail = 'fan@example.com',
    @ProductCode = 't-shirt',
    @TeamCode = 'lakers',
    @ProductColorName = 'Black',
    @TextColorName = 'Gold',
    @CustomText = 'LAKERS FAN',
    @CustomizationID = @CustomizationID OUTPUT;

-- Get popular teams
EXEC sp_GetPopularTeams @TopCount = 10;
```

## 📁 Directory Structure
```
database/
├── README.md                    # This file
├── docs/
│   └── schema_documentation.md  # Detailed schema docs
├── schema/
│   └── 01_create_tables.sql     # Database schema
├── data/
│   ├── test_data.sql           # Initial test data
│   └── additional_data.sql     # Extended test data
├── procedures/
│   └── sp_data_operations.sql  # Stored procedures
├── tests/
│   └── unit_tests.sql          # Comprehensive unit tests
└── scripts/
    ├── setup_database.sql      # Complete setup
    ├── run_tests.sql           # Test runner
    └── setup_and_test.sh       # Automated setup
```

## 🧪 Testing
The test suite includes:
- **Stored procedure validation** - All procedures tested with valid/invalid inputs
- **Data integrity checks** - Referential integrity, constraints, data quality
- **Performance benchmarks** - Query execution time validation
- **Business logic validation** - Custom validation rules

## 📚 Documentation
- **README.md** - This quick start guide
- **docs/schema_documentation.md** - Detailed schema documentation with examples
- **Inline comments** - Comprehensive code documentation

## 🔧 Integration
The database schema is designed to integrate seamlessly with the existing TypeScript application. All data structures match the current `src/lib/data.ts` format while providing the benefits of a proper relational database.

---
*For detailed technical documentation, see `docs/schema_documentation.md`*