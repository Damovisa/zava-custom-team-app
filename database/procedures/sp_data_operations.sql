-- Stored Procedures for Zava Athletics Database
-- This file contains all stored procedures for data operations

USE ZavaAthletics;
GO

-- Procedure to get all sports with their leagues count
CREATE OR ALTER PROCEDURE sp_GetSportsWithLeagueCount
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        s.SportID,
        s.SportCode,
        s.SportName,
        s.Description,
        COUNT(l.LeagueID) as LeagueCount,
        s.IsActive,
        s.CreatedDate,
        s.UpdatedDate
    FROM Sports s
    LEFT JOIN Leagues l ON s.SportID = l.SportID AND l.IsActive = 1
    WHERE s.IsActive = 1
    GROUP BY s.SportID, s.SportCode, s.SportName, s.Description, s.IsActive, s.CreatedDate, s.UpdatedDate
    ORDER BY s.SportName;
END
GO

-- Procedure to get leagues for a specific sport
CREATE OR ALTER PROCEDURE sp_GetLeaguesBySport
    @SportCode VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        l.LeagueID,
        l.LeagueCode,
        l.LeagueName,
        l.Description,
        COUNT(t.TeamID) as TeamCount,
        l.IsActive,
        l.CreatedDate,
        l.UpdatedDate
    FROM Leagues l
    INNER JOIN Sports s ON l.SportID = s.SportID
    LEFT JOIN Teams t ON l.LeagueID = t.LeagueID AND t.IsActive = 1
    WHERE s.SportCode = @SportCode 
        AND s.IsActive = 1 
        AND l.IsActive = 1
    GROUP BY l.LeagueID, l.LeagueCode, l.LeagueName, l.Description, l.IsActive, l.CreatedDate, l.UpdatedDate
    ORDER BY l.LeagueName;
END
GO

-- Procedure to get teams for a specific league
CREATE OR ALTER PROCEDURE sp_GetTeamsByLeague
    @LeagueCode VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        t.TeamID,
        t.TeamCode,
        t.TeamName,
        t.PrimaryColor,
        t.SecondaryColor,
        t.LogoURL,
        t.Description,
        l.LeagueName,
        s.SportName,
        t.IsActive,
        t.CreatedDate,
        t.UpdatedDate
    FROM Teams t
    INNER JOIN Leagues l ON t.LeagueID = l.LeagueID
    INNER JOIN Sports s ON l.SportID = s.SportID
    WHERE l.LeagueCode = @LeagueCode 
        AND t.IsActive = 1 
        AND l.IsActive = 1 
        AND s.IsActive = 1
    ORDER BY t.TeamName;
END
GO

-- Procedure to search teams by name
CREATE OR ALTER PROCEDURE sp_SearchTeams
    @SearchTerm VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        t.TeamID,
        t.TeamCode,
        t.TeamName,
        t.PrimaryColor,
        t.SecondaryColor,
        l.LeagueName,
        s.SportName,
        t.IsActive
    FROM Teams t
    INNER JOIN Leagues l ON t.LeagueID = l.LeagueID
    INNER JOIN Sports s ON l.SportID = s.SportID
    WHERE (t.TeamName LIKE '%' + @SearchTerm + '%' 
           OR t.TeamCode LIKE '%' + @SearchTerm + '%')
        AND t.IsActive = 1 
        AND l.IsActive = 1 
        AND s.IsActive = 1
    ORDER BY t.TeamName;
END
GO

-- Procedure to get all available products
CREATE OR ALTER PROCEDURE sp_GetProducts
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        ProductID,
        ProductCode,
        ProductName,
        Description,
        BasePrice,
        IsActive,
        CreatedDate,
        UpdatedDate
    FROM Products
    WHERE IsActive = 1
    ORDER BY ProductName;
END
GO

-- Procedure to get all product colors
CREATE OR ALTER PROCEDURE sp_GetProductColors
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        ColorID,
        ColorName,
        ColorValue,
        IsActive,
        CreatedDate,
        UpdatedDate
    FROM ProductColors
    WHERE IsActive = 1
    ORDER BY ColorName;
END
GO

-- Procedure to get all text colors
CREATE OR ALTER PROCEDURE sp_GetTextColors
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        TextColorID,
        ColorName,
        ColorValue,
        IsActive,
        CreatedDate,
        UpdatedDate
    FROM TextColors
    WHERE IsActive = 1
    ORDER BY ColorName;
END
GO

-- Procedure to create a new customization
CREATE OR ALTER PROCEDURE sp_CreateCustomization
    @CustomerEmail VARCHAR(255),
    @ProductCode VARCHAR(50),
    @TeamCode VARCHAR(50) = NULL,
    @ProductColorName VARCHAR(50) = NULL,
    @TextColorName VARCHAR(50) = NULL,
    @CustomText VARCHAR(500) = NULL,
    @CustomImageURL VARCHAR(500) = NULL,
    @DesignData TEXT = NULL,
    @CustomizationID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @CustomerID INT, @ProductID INT, @TeamID INT, @ProductColorID INT, @TextColorID INT;
    
    -- Get or create customer
    SELECT @CustomerID = CustomerID FROM Customers WHERE CustomerEmail = @CustomerEmail;
    IF @CustomerID IS NULL
    BEGIN
        INSERT INTO Customers (CustomerEmail) VALUES (@CustomerEmail);
        SET @CustomerID = SCOPE_IDENTITY();
    END
    
    -- Get Product ID
    SELECT @ProductID = ProductID FROM Products WHERE ProductCode = @ProductCode AND IsActive = 1;
    IF @ProductID IS NULL
    BEGIN
        RAISERROR('Invalid product code: %s', 16, 1, @ProductCode);
        RETURN;
    END
    
    -- Get Team ID (optional)
    IF @TeamCode IS NOT NULL
    BEGIN
        SELECT @TeamID = TeamID FROM Teams WHERE TeamCode = @TeamCode AND IsActive = 1;
        IF @TeamID IS NULL
        BEGIN
            RAISERROR('Invalid team code: %s', 16, 1, @TeamCode);
            RETURN;
        END
    END
    
    -- Get Product Color ID (optional)
    IF @ProductColorName IS NOT NULL
    BEGIN
        SELECT @ProductColorID = ColorID FROM ProductColors WHERE ColorName = @ProductColorName AND IsActive = 1;
        IF @ProductColorID IS NULL
        BEGIN
            RAISERROR('Invalid product color: %s', 16, 1, @ProductColorName);
            RETURN;
        END
    END
    
    -- Get Text Color ID (optional)
    IF @TextColorName IS NOT NULL
    BEGIN
        SELECT @TextColorID = TextColorID FROM TextColors WHERE ColorName = @TextColorName AND IsActive = 1;
        IF @TextColorID IS NULL
        BEGIN
            RAISERROR('Invalid text color: %s', 16, 1, @TextColorName);
            RETURN;
        END
    END
    
    -- Create customization
    INSERT INTO Customizations (
        CustomerID, ProductID, TeamID, ProductColorID, TextColorID, 
        CustomText, CustomImageURL, DesignData
    ) VALUES (
        @CustomerID, @ProductID, @TeamID, @ProductColorID, @TextColorID,
        @CustomText, @CustomImageURL, @DesignData
    );
    
    SET @CustomizationID = SCOPE_IDENTITY();
END
GO

-- Procedure to get customization details
CREATE OR ALTER PROCEDURE sp_GetCustomization
    @CustomizationID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        c.CustomizationID,
        c.CustomText,
        c.CustomImageURL,
        c.DesignData,
        cust.CustomerEmail,
        cust.CustomerName,
        p.ProductCode,
        p.ProductName,
        p.BasePrice,
        t.TeamCode,
        t.TeamName,
        t.PrimaryColor as TeamPrimaryColor,
        t.SecondaryColor as TeamSecondaryColor,
        pc.ColorName as ProductColorName,
        pc.ColorValue as ProductColorValue,
        tc.ColorName as TextColorName,
        tc.ColorValue as TextColorValue,
        l.LeagueName,
        s.SportName,
        c.CreatedDate,
        c.UpdatedDate
    FROM Customizations c
    INNER JOIN Customers cust ON c.CustomerID = cust.CustomerID
    INNER JOIN Products p ON c.ProductID = p.ProductID
    LEFT JOIN Teams t ON c.TeamID = t.TeamID
    LEFT JOIN Leagues l ON t.LeagueID = l.LeagueID
    LEFT JOIN Sports s ON l.SportID = s.SportID
    LEFT JOIN ProductColors pc ON c.ProductColorID = pc.ColorID
    LEFT JOIN TextColors tc ON c.TextColorID = tc.TextColorID
    WHERE c.CustomizationID = @CustomizationID;
END
GO

-- Procedure to get popular teams (most customized)
CREATE OR ALTER PROCEDURE sp_GetPopularTeams
    @TopCount INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT TOP (@TopCount)
        t.TeamID,
        t.TeamCode,
        t.TeamName,
        t.PrimaryColor,
        l.LeagueName,
        s.SportName,
        COUNT(c.CustomizationID) as CustomizationCount
    FROM Teams t
    INNER JOIN Leagues l ON t.LeagueID = l.LeagueID
    INNER JOIN Sports s ON l.SportID = s.SportID
    LEFT JOIN Customizations c ON t.TeamID = c.TeamID
    WHERE t.IsActive = 1 AND l.IsActive = 1 AND s.IsActive = 1
    GROUP BY t.TeamID, t.TeamCode, t.TeamName, t.PrimaryColor, l.LeagueName, s.SportName
    ORDER BY CustomizationCount DESC, t.TeamName;
END
GO

-- Procedure to validate data integrity
CREATE OR ALTER PROCEDURE sp_ValidateDataIntegrity
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Check for orphaned leagues
    SELECT 'Orphaned Leagues' as IssueType, COUNT(*) as Count
    FROM Leagues l
    LEFT JOIN Sports s ON l.SportID = s.SportID
    WHERE s.SportID IS NULL;
    
    -- Check for orphaned teams
    SELECT 'Orphaned Teams' as IssueType, COUNT(*) as Count
    FROM Teams t
    LEFT JOIN Leagues l ON t.LeagueID = l.LeagueID
    WHERE l.LeagueID IS NULL;
    
    -- Check for invalid color values
    SELECT 'Invalid Product Colors' as IssueType, COUNT(*) as Count
    FROM ProductColors
    WHERE ColorValue NOT LIKE '#[0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F]';
    
    SELECT 'Invalid Text Colors' as IssueType, COUNT(*) as Count
    FROM TextColors
    WHERE ColorValue NOT LIKE '#[0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F]';
    
    -- Check for duplicate team codes within leagues
    SELECT 'Duplicate Team Codes' as IssueType, COUNT(*) as Count
    FROM (
        SELECT LeagueID, TeamCode, COUNT(*) as DuplicateCount
        FROM Teams
        GROUP BY LeagueID, TeamCode
        HAVING COUNT(*) > 1
    ) as Duplicates;
END
GO

PRINT 'Stored procedures created successfully!';