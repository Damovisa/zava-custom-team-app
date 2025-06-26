# Database Schema Documentation

## Overview
The Zava Athletics database schema is designed to support a comprehensive sports apparel customization system. The schema handles sports data, team information, product catalogs, customer customizations, and order management.

## Table Structure

### Core Sports Data
- **Sports** - Master table for sports categories (Basketball, Soccer, Football, etc.)
- **Leagues** - Sports leagues within each sport (NBA, NFL, Premier League, etc.)
- **Teams** - Teams within each league with branding information

### Product Catalog
- **Products** - Available product types (t-shirt, hoodie, cap, jacket, etc.)
- **ProductColors** - Available colors for products
- **TextColors** - Available colors for text customization

### Customer and Orders
- **Customers** - Customer information
- **Customizations** - Individual design configurations
- **Orders** - Customer orders
- **OrderItems** - Items within orders linking to customizations

## Entity Relationships

```
Sports (1:N) Leagues (1:N) Teams
Products (1:N) Customizations (N:1) Customers
ProductColors (1:N) Customizations
TextColors (1:N) Customizations
Teams (1:N) Customizations
Orders (1:N) OrderItems (N:1) Customizations
```

## Data Integrity Rules

1. **Color Values**: All color fields must be valid 6-digit hex codes (e.g., #FF0000)
2. **Active Records**: Most tables include IsActive flag for soft deletion
3. **Unique Constraints**: 
   - Team codes must be unique within leagues
   - League codes must be unique within sports
   - Product codes must be globally unique
4. **Price Validation**: All prices must be non-negative
5. **Referential Integrity**: All foreign key relationships are enforced

## Stored Procedures

### Data Retrieval
- `sp_GetSportsWithLeagueCount` - Returns all sports with count of active leagues
- `sp_GetLeaguesBySport(@SportCode)` - Returns leagues for a specific sport
- `sp_GetTeamsByLeague(@LeagueCode)` - Returns teams for a specific league
- `sp_SearchTeams(@SearchTerm)` - Search teams by name or code
- `sp_GetProducts()` - Returns all active products
- `sp_GetProductColors()` - Returns all active product colors
- `sp_GetTextColors()` - Returns all active text colors

### Customization Management
- `sp_CreateCustomization(...)` - Creates a new customization with validation
- `sp_GetCustomization(@CustomizationID)` - Returns detailed customization info

### Analytics and Reporting
- `sp_GetPopularTeams(@TopCount)` - Returns most frequently customized teams
- `sp_ValidateDataIntegrity()` - Runs comprehensive data validation checks

## Test Data Coverage

The database includes comprehensive test data:

### Sports and Teams
- **8 Sports**: Basketball, Soccer, Football, Baseball, Hockey, Tennis, Golf, Motorsports
- **20+ Leagues**: Major professional and collegiate leagues
- **80+ Teams**: Teams from major leagues worldwide including:
  - NBA: Lakers, Celtics, Warriors, Bulls, etc.
  - NFL: Chiefs, Cowboys, Packers, Patriots, etc.
  - Premier League: Manchester United, Liverpool, Arsenal, etc.
  - La Liga: Real Madrid, Barcelona, Atletico Madrid
  - IPL: Mumbai Indians, Chennai Super Kings, RCB, etc.

### Products and Colors
- **16 Product Types**: From basic t-shirts to varsity jackets
- **35 Product Colors**: Full spectrum of colors with hex values
- **15 Text Colors**: Optimized for visibility and design

### Sample Data
- **5 Test Customers** with realistic email addresses
- **Sample Customizations** showing different product/team combinations
- **Sample Orders** demonstrating the order workflow

## Usage Examples

### Get all basketball leagues
```sql
EXEC sp_GetLeaguesBySport @SportCode = 'basketball';
```

### Find Lakers-related teams
```sql
EXEC sp_SearchTeams @SearchTerm = 'Lakers';
```

### Create a new customization
```sql
DECLARE @CustomizationID INT;
EXEC sp_CreateCustomization 
    @CustomerEmail = 'fan@example.com',
    @ProductCode = 't-shirt',
    @TeamCode = 'lakers',
    @ProductColorName = 'Black',
    @TextColorName = 'Gold',
    @CustomText = 'LAKERS FAN',
    @CustomizationID = @CustomizationID OUTPUT;
```

### Get popular teams
```sql
EXEC sp_GetPopularTeams @TopCount = 10;
```

## Performance Considerations

1. **Indexes**: Strategic indexes on foreign keys and search fields
2. **Query Optimization**: Stored procedures use efficient JOIN patterns
3. **Data Types**: Appropriate data types for optimal storage
4. **Constraints**: Database-level validation for data integrity

## Security Features

1. **Parameterized Queries**: All stored procedures use parameters to prevent SQL injection
2. **Input Validation**: Server-side validation for all user inputs
3. **Error Handling**: Comprehensive error handling with meaningful messages
4. **Access Control**: Designed for role-based database permissions

## Extension Points

The schema is designed for future expansion:

1. **Additional Sports**: Easy to add new sports categories
2. **Product Attributes**: DesignData field supports JSON for complex customizations
3. **Pricing Models**: BasePrice supports dynamic pricing strategies
4. **Internationalization**: Structure supports multiple markets/regions
5. **Analytics**: Schema supports advanced reporting and analytics queries