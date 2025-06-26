# Zava Database Schema and Tests

This directory contains the complete database schema, test data, stored procedures, and unit tests for the Zava Athletics Clothing Customizer application.

## Structure

- `schema/` - Database schema definition files
- `data/` - Test data and sample data files
- `procedures/` - Stored procedures for data operations
- `tests/` - Unit tests for stored procedures and data validation
- `scripts/` - Utility scripts for database setup and testing

## Setup

1. Run `scripts/setup_database.sql` to create the database schema
2. Run `scripts/load_test_data.sql` to populate with test data
3. Run `scripts/run_tests.sql` to execute all unit tests

## Schema Overview

The database schema includes the following main entities:

- **Sports** - Different sports categories (Basketball, Soccer, Football, Baseball, etc.)
- **Leagues** - Sports leagues within each sport (NBA, NFL, Premier League, etc.)
- **Teams** - Teams within each league with branding information
- **Products** - Available product types (t-shirt, hoodie, cap, jacket)
- **Colors** - Available colors for products and text
- **Customizations** - Customer design configurations
- **Orders** - Customer orders with customization details

## Testing

The test suite includes:
- Data integrity tests
- Stored procedure unit tests
- Performance tests
- Business logic validation tests