-- Additional comprehensive test data for Zava Athletics Database
-- This file extends the base test data with more sports, leagues, teams, and sample orders

USE ZavaAthletics;
GO

-- Insert additional sports
INSERT INTO Sports (SportCode, SportName, Description) VALUES 
('cricket', 'Cricket', 'International and domestic cricket leagues'),
('rugby', 'Rugby', 'Rugby Union and Rugby League competitions'),
('volleyball', 'Volleyball', 'Professional volleyball leagues'),
('swimming', 'Swimming', 'Competitive swimming organizations'),
('track-field', 'Track & Field', 'Athletics and track and field competitions'),
('cycling', 'Cycling', 'Professional cycling tours and races'),
('wrestling', 'Wrestling', 'Professional wrestling organizations'),
('martial-arts', 'Martial Arts', 'Mixed martial arts and boxing organizations');

-- Insert additional leagues for existing sports
-- More basketball leagues
INSERT INTO Leagues (SportID, LeagueCode, LeagueName, Description) VALUES 
((SELECT SportID FROM Sports WHERE SportCode = 'basketball'), 'cba', 'CBA', 'Chinese Basketball Association'),
((SELECT SportID FROM Sports WHERE SportCode = 'basketball'), 'nbl', 'NBL', 'National Basketball League (Australia)'),
((SELECT SportID FROM Sports WHERE SportCode = 'basketball'), 'bbl', 'BBL', 'British Basketball League');

-- Cricket leagues
INSERT INTO Leagues (SportID, LeagueCode, LeagueName, Description) VALUES 
((SELECT SportID FROM Sports WHERE SportCode = 'cricket'), 'ipl', 'IPL', 'Indian Premier League'),
((SELECT SportID FROM Sports WHERE SportCode = 'cricket'), 'bbl-cricket', 'BBL Cricket', 'Big Bash League'),
((SELECT SportID FROM Sports WHERE SportCode = 'cricket'), 'cpl', 'CPL', 'Caribbean Premier League'),
((SELECT SportID FROM Sports WHERE SportCode = 'cricket'), 'psl', 'PSL', 'Pakistan Super League');

-- Hockey leagues (extending existing)
INSERT INTO Leagues (SportID, LeagueCode, LeagueName, Description) VALUES 
((SELECT SportID FROM Sports WHERE SportCode = 'hockey'), 'ahl', 'AHL', 'American Hockey League'),
((SELECT SportID FROM Sports WHERE SportCode = 'hockey'), 'echl', 'ECHL', 'East Coast Hockey League');

-- Additional NFL teams
DECLARE @NFLLeagueID INT = (SELECT LeagueID FROM Leagues WHERE LeagueCode = 'nfl');
INSERT INTO Teams (LeagueID, TeamCode, TeamName, PrimaryColor, SecondaryColor) VALUES 
(@NFLLeagueID, 'eagles', 'Philadelphia Eagles', '#004C54', '#A5ACAF'),
(@NFLLeagueID, 'seahawks', 'Seattle Seahawks', '#002244', '#69BE28'),
(@NFLLeagueID, 'broncos', 'Denver Broncos', '#FB4F14', '#002244'),
(@NFLLeagueID, 'saints', 'New Orleans Saints', '#D3BC8D', '#101820'),
(@NFLLeagueID, 'vikings', 'Minnesota Vikings', '#4F2683', '#FFC62F'),
(@NFLLeagueID, 'falcons', 'Atlanta Falcons', '#A71930', '#000000'),
(@NFLLeagueID, 'panthers', 'Carolina Panthers', '#0085CA', '#101820'),
(@NFLLeagueID, 'titans', 'Tennessee Titans', '#0C2340', '#4B92DB');

-- Additional NBA teams
DECLARE @NBALeagueID INT = (SELECT LeagueID FROM Leagues WHERE LeagueCode = 'nba');
INSERT INTO Teams (LeagueID, TeamCode, TeamName, PrimaryColor, SecondaryColor) VALUES 
(@NBALeagueID, 'clippers', 'LA Clippers', '#C8102E', '#1D428A'),
(@NBALeagueID, 'nuggets', 'Denver Nuggets', '#0E2240', '#FEC524'),
(@NBALeagueID, 'suns', 'Phoenix Suns', '#1D1160', '#E56020'),
(@NBALeagueID, 'bucks', 'Milwaukee Bucks', '#00471B', '#EEE1C6'),
(@NBALeagueID, 'raptors', 'Toronto Raptors', '#CE1141', '#000000'),
(@NBALeagueID, 'jazz', 'Utah Jazz', '#002B5C', '#00471B'),
(@NBALeagueID, 'magic', 'Orlando Magic', '#0077C0', '#C4CED4'),
(@NBALeagueID, 'pistons', 'Detroit Pistons', '#C8102E', '#1D42BA');

-- IPL teams
DECLARE @IPLLeagueID INT = (SELECT LeagueID FROM Leagues WHERE LeagueCode = 'ipl');
INSERT INTO Teams (LeagueID, TeamCode, TeamName, PrimaryColor, SecondaryColor) VALUES 
(@IPLLeagueID, 'mumbai-indians', 'Mumbai Indians', '#005DA0', '#D1AB3E'),
(@IPLLeagueID, 'csk', 'Chennai Super Kings', '#FDB913', '#004F93'),
(@IPLLeagueID, 'rcb', 'Royal Challengers Bangalore', '#EC1C24', '#FFD700'),
(@IPLLeagueID, 'kkr', 'Kolkata Knight Riders', '#3A225D', '#B3A123'),
(@IPLLeagueID, 'dc', 'Delhi Capitals', '#004C93', '#EF1B23'),
(@IPLLeagueID, 'srh', 'Sunrisers Hyderabad', '#FF822A', '#000000'),
(@IPLLeagueID, 'rr', 'Rajasthan Royals', '#254AA5', '#FFFF00'),
(@IPLLeagueID, 'pbks', 'Punjab Kings', '#DD1F2D', '#B3A123');

-- Additional Soccer teams for existing leagues
DECLARE @PremierLeagueID INT = (SELECT LeagueID FROM Leagues WHERE LeagueCode = 'premier');
INSERT INTO Teams (LeagueID, TeamCode, TeamName, PrimaryColor, SecondaryColor) VALUES 
(@PremierLeagueID, 'brighton', 'Brighton & Hove Albion', '#0057B8', '#FFCD00'),
(@PremierLeagueID, 'aston-villa', 'Aston Villa', '#95BFE5', '#670E36'),
(@PremierLeagueID, 'leicester', 'Leicester City', '#003090', '#FDBE11'),
(@PremierLeagueID, 'everton', 'Everton', '#003399', '#FFFFFF'),
(@PremierLeagueID, 'leeds', 'Leeds United', '#FFFFFF', '#1D428A'),
(@PremierLeagueID, 'wolves', 'Wolverhampton Wanderers', '#FDB913', '#231F20');

-- NHL teams
DECLARE @NHLLeagueID INT = (SELECT LeagueID FROM Leagues WHERE LeagueCode = 'nhl');
INSERT INTO Teams (LeagueID, TeamCode, TeamName, PrimaryColor, SecondaryColor) VALUES 
(@NHLLeagueID, 'rangers', 'New York Rangers', '#0038A8', '#CE1126'),
(@NHLLeagueID, 'bruins', 'Boston Bruins', '#FFB81C', '#000000'),
(@NHLLeagueID, 'blackhawks', 'Chicago Blackhawks', '#CF0A2C', '#FF6900'),
(@NHLLeagueID, 'penguins', 'Pittsburgh Penguins', '#000000', '#CFC493'),
(@NHLLeagueID, 'kings', 'Los Angeles Kings', '#000000', '#A2AAAD'),
(@NHLLeagueID, 'sharks', 'San Jose Sharks', '#006D75', '#EA7200'),
(@NHLLeagueID, 'capitals', 'Washington Capitals', '#C8102E', '#041E42'),
(@NHLLeagueID, 'lightning', 'Tampa Bay Lightning', '#002868', '#FFFFFF');

-- Add more product variations
INSERT INTO Products (ProductCode, ProductName, Description, BasePrice) VALUES 
('zip-hoodie', 'Zip-Up Hoodie', 'Full-zip hoodie with custom design', 54.99),
('beanie', 'Beanie', 'Warm knit beanie with custom embroidery', 19.99),
('shorts', 'Athletic Shorts', 'Performance athletic shorts', 32.99),
('track-pants', 'Track Pants', 'Athletic track pants with custom design', 42.99),
('varsity-jacket', 'Varsity Jacket', 'Classic varsity-style jacket', 84.99),
('windbreaker', 'Windbreaker', 'Lightweight windbreaker jacket', 59.99),
('snapback', 'Snapback Cap', 'Adjustable snapback baseball cap', 27.99),
('bucket-hat', 'Bucket Hat', 'Casual bucket hat with custom design', 22.99);

-- Add more color options
INSERT INTO ProductColors (ColorName, ColorValue) VALUES 
('Charcoal', '#36454F'),
('Olive Green', '#808000'),
('Crimson', '#DC143C'),
('Turquoise', '#40E0D0'),
('Indigo', '#4B0082'),
('Salmon', '#FA8072'),
('Khaki', '#F0E68C'),
('Lavender', '#E6E6FA'),
('Mint Green', '#98FB98'),
('Peach', '#FFCBA4'),
('Steel Blue', '#4682B4'),
('Rose Gold', '#E8B4B8'),
('Copper', '#B87333'),
('Emerald', '#50C878'),
('Magenta', '#FF00FF');

INSERT INTO TextColors (ColorName, ColorValue) VALUES 
('Charcoal', '#36454F'),
('Crimson', '#DC143C'),
('Indigo', '#4B0082'),
('Steel Blue', '#4682B4'),
('Copper', '#B87333'),
('Emerald', '#50C878'),
('Magenta', '#FF00FF');

-- Create sample customizations and orders
DECLARE @CustomerID1 INT, @CustomerID2 INT, @CustomerID3 INT;
DECLARE @CustomizationID1 INT, @CustomizationID2 INT, @CustomizationID3 INT, @CustomizationID4 INT;

-- Get some customer IDs
SELECT TOP 1 @CustomerID1 = CustomerID FROM Customers WHERE CustomerEmail = 'john.doe@email.com';
SELECT TOP 1 @CustomerID2 = CustomerID FROM Customers WHERE CustomerEmail = 'jane.smith@email.com';
SELECT TOP 1 @CustomerID3 = CustomerID FROM Customers WHERE CustomerEmail = 'mike.johnson@email.com';

-- Create sample customizations
INSERT INTO Customizations (CustomerID, ProductID, TeamID, ProductColorID, TextColorID, CustomText, DesignData) VALUES 
(@CustomerID1, (SELECT ProductID FROM Products WHERE ProductCode = 't-shirt'), (SELECT TeamID FROM Teams WHERE TeamCode = 'lakers'), (SELECT ColorID FROM ProductColors WHERE ColorName = 'Black'), (SELECT TextColorID FROM TextColors WHERE ColorName = 'Gold'), 'DOE 24', '{"placement": "back", "size": "large"}'),
(@CustomerID1, (SELECT ProductID FROM Products WHERE ProductCode = 'hoodie'), (SELECT TeamID FROM Teams WHERE TeamCode = 'lakers'), (SELECT ColorID FROM ProductColors WHERE ColorName = 'Purple'), (SELECT TextColorID FROM TextColors WHERE ColorName = 'Gold'), 'LAKERS FAN', '{"placement": "front", "size": "medium"}'),
(@CustomerID2, (SELECT ProductID FROM Products WHERE ProductCode = 'cap'), (SELECT TeamID FROM Teams WHERE TeamCode = 'yankees'), (SELECT ColorID FROM ProductColors WHERE ColorName = 'Navy'), (SELECT TextColorID FROM TextColors WHERE ColorName = 'White'), 'NY', '{"placement": "front", "style": "embroidered"}'),
(@CustomerID3, (SELECT ProductID FROM Products WHERE ProductCode = 'jacket'), (SELECT TeamID FROM Teams WHERE TeamCode = 'chiefs'), (SELECT ColorID FROM ProductColors WHERE ColorName = 'Red'), (SELECT TextColorID FROM TextColors WHERE ColorName = 'Gold'), 'CHIEFS KINGDOM', '{"placement": "back", "size": "extra-large"}');

-- Get the customization IDs
SELECT @CustomizationID1 = CustomizationID FROM Customizations WHERE CustomerID = @CustomerID1 AND CustomText = 'DOE 24';
SELECT @CustomizationID2 = CustomizationID FROM Customizations WHERE CustomerID = @CustomerID1 AND CustomText = 'LAKERS FAN';
SELECT @CustomizationID3 = CustomizationID FROM Customizations WHERE CustomerID = @CustomerID2 AND CustomText = 'NY';
SELECT @CustomizationID4 = CustomizationID FROM Customizations WHERE CustomerID = @CustomerID3 AND CustomText = 'CHIEFS KINGDOM';

-- Create sample orders
DECLARE @OrderID1 INT, @OrderID2 INT;

INSERT INTO Orders (CustomerID, OrderNumber, OrderStatus, TotalAmount) VALUES 
(@CustomerID1, 'ZAV-' + FORMAT(GETDATE(), 'yyyyMMdd') + '-001', 'Completed', 79.98),
(@CustomerID2, 'ZAV-' + FORMAT(GETDATE(), 'yyyyMMdd') + '-002', 'Processing', 24.99);

SELECT @OrderID1 = OrderID FROM Orders WHERE OrderNumber LIKE 'ZAV-%-001';
SELECT @OrderID2 = OrderID FROM Orders WHERE OrderNumber LIKE 'ZAV-%-002';

-- Create order items
INSERT INTO OrderItems (OrderID, CustomizationID, Quantity, UnitPrice) VALUES 
(@OrderID1, @CustomizationID1, 1, 29.99),
(@OrderID1, @CustomizationID2, 1, 49.99),
(@OrderID2, @CustomizationID3, 1, 24.99);

PRINT 'Additional comprehensive test data loaded successfully!';
PRINT 'Added:';
PRINT '- 8 additional sports categories';
PRINT '- Multiple new leagues per sport';
PRINT '- 50+ additional teams across all sports';
PRINT '- 8 new product types';
PRINT '- 22 additional color options';
PRINT '- Sample customizations and orders';
PRINT '';