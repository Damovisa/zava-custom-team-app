-- Zava Athletics Database Schema
-- This script creates the complete database schema for the Zava Athletics Clothing Customizer

-- Create database if it doesn't exist
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'ZavaAthletics')
BEGIN
    CREATE DATABASE ZavaAthletics;
END
GO

USE ZavaAthletics;
GO

-- Drop tables if they exist (for clean setup)
IF OBJECT_ID('OrderItems', 'U') IS NOT NULL DROP TABLE OrderItems;
IF OBJECT_ID('Orders', 'U') IS NOT NULL DROP TABLE Orders;
IF OBJECT_ID('Customizations', 'U') IS NOT NULL DROP TABLE Customizations;
IF OBJECT_ID('Teams', 'U') IS NOT NULL DROP TABLE Teams;
IF OBJECT_ID('Leagues', 'U') IS NOT NULL DROP TABLE Leagues;
IF OBJECT_ID('Sports', 'U') IS NOT NULL DROP TABLE Sports;
IF OBJECT_ID('TextColors', 'U') IS NOT NULL DROP TABLE TextColors;
IF OBJECT_ID('ProductColors', 'U') IS NOT NULL DROP TABLE ProductColors;
IF OBJECT_ID('Products', 'U') IS NOT NULL DROP TABLE Products;
IF OBJECT_ID('Customers', 'U') IS NOT NULL DROP TABLE Customers;
GO

-- Create Sports table
CREATE TABLE Sports (
    SportID INT IDENTITY(1,1) PRIMARY KEY,
    SportCode VARCHAR(50) UNIQUE NOT NULL,
    SportName VARCHAR(100) NOT NULL,
    Description TEXT,
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    UpdatedDate DATETIME2 DEFAULT GETDATE()
);

-- Create Leagues table
CREATE TABLE Leagues (
    LeagueID INT IDENTITY(1,1) PRIMARY KEY,
    SportID INT NOT NULL,
    LeagueCode VARCHAR(50) NOT NULL,
    LeagueName VARCHAR(100) NOT NULL,
    Description TEXT,
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    UpdatedDate DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (SportID) REFERENCES Sports(SportID),
    UNIQUE (SportID, LeagueCode)
);

-- Create Teams table
CREATE TABLE Teams (
    TeamID INT IDENTITY(1,1) PRIMARY KEY,
    LeagueID INT NOT NULL,
    TeamCode VARCHAR(50) NOT NULL,
    TeamName VARCHAR(100) NOT NULL,
    PrimaryColor VARCHAR(7), -- Hex color code
    SecondaryColor VARCHAR(7), -- Hex color code
    LogoURL VARCHAR(500),
    Description TEXT,
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    UpdatedDate DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (LeagueID) REFERENCES Leagues(LeagueID),
    UNIQUE (LeagueID, TeamCode)
);

-- Create Products table
CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductCode VARCHAR(50) UNIQUE NOT NULL,
    ProductName VARCHAR(100) NOT NULL,
    Description TEXT,
    BasePrice DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    UpdatedDate DATETIME2 DEFAULT GETDATE()
);

-- Create ProductColors table
CREATE TABLE ProductColors (
    ColorID INT IDENTITY(1,1) PRIMARY KEY,
    ColorName VARCHAR(50) NOT NULL,
    ColorValue VARCHAR(7) NOT NULL, -- Hex color code
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    UpdatedDate DATETIME2 DEFAULT GETDATE()
);

-- Create TextColors table
CREATE TABLE TextColors (
    TextColorID INT IDENTITY(1,1) PRIMARY KEY,
    ColorName VARCHAR(50) NOT NULL,
    ColorValue VARCHAR(7) NOT NULL, -- Hex color code
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    UpdatedDate DATETIME2 DEFAULT GETDATE()
);

-- Create Customers table
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerEmail VARCHAR(255) UNIQUE,
    CustomerName VARCHAR(200),
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    UpdatedDate DATETIME2 DEFAULT GETDATE()
);

-- Create Customizations table
CREATE TABLE Customizations (
    CustomizationID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT,
    ProductID INT NOT NULL,
    TeamID INT,
    ProductColorID INT,
    TextColorID INT,
    CustomText VARCHAR(500),
    CustomImageURL VARCHAR(500),
    DesignData TEXT, -- JSON data for complex customizations
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    UpdatedDate DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (TeamID) REFERENCES Teams(TeamID),
    FOREIGN KEY (ProductColorID) REFERENCES ProductColors(ColorID),
    FOREIGN KEY (TextColorID) REFERENCES TextColors(TextColorID)
);

-- Create Orders table
CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT,
    OrderNumber VARCHAR(50) UNIQUE NOT NULL,
    OrderStatus VARCHAR(50) DEFAULT 'Pending',
    TotalAmount DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    OrderDate DATETIME2 DEFAULT GETDATE(),
    UpdatedDate DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Create OrderItems table
CREATE TABLE OrderItems (
    OrderItemID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    CustomizationID INT NOT NULL,
    Quantity INT NOT NULL DEFAULT 1,
    UnitPrice DECIMAL(10,2) NOT NULL,
    TotalPrice AS (Quantity * UnitPrice) PERSISTED,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (CustomizationID) REFERENCES Customizations(CustomizationID)
);

-- Create indexes for better performance
CREATE INDEX IX_Leagues_SportID ON Leagues(SportID);
CREATE INDEX IX_Teams_LeagueID ON Teams(LeagueID);
CREATE INDEX IX_Customizations_CustomerID ON Customizations(CustomerID);
CREATE INDEX IX_Customizations_ProductID ON Customizations(ProductID);
CREATE INDEX IX_Customizations_TeamID ON Customizations(TeamID);
CREATE INDEX IX_Orders_CustomerID ON Orders(CustomerID);
CREATE INDEX IX_OrderItems_OrderID ON OrderItems(OrderID);
CREATE INDEX IX_OrderItems_CustomizationID ON OrderItems(CustomizationID);

-- Add check constraints
ALTER TABLE ProductColors ADD CONSTRAINT CK_ProductColors_ColorValue 
    CHECK (ColorValue LIKE '#[0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F]');

ALTER TABLE TextColors ADD CONSTRAINT CK_TextColors_ColorValue 
    CHECK (ColorValue LIKE '#[0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F]');

ALTER TABLE Teams ADD CONSTRAINT CK_Teams_PrimaryColor 
    CHECK (PrimaryColor IS NULL OR PrimaryColor LIKE '#[0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F]');

ALTER TABLE Teams ADD CONSTRAINT CK_Teams_SecondaryColor 
    CHECK (SecondaryColor IS NULL OR SecondaryColor LIKE '#[0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F]');

ALTER TABLE OrderItems ADD CONSTRAINT CK_OrderItems_Quantity CHECK (Quantity > 0);
ALTER TABLE OrderItems ADD CONSTRAINT CK_OrderItems_UnitPrice CHECK (UnitPrice >= 0);

PRINT 'Zava Athletics database schema created successfully!';