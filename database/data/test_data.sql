-- Comprehensive test data for Zava Athletics Database
-- This script populates the database with extensive test data

USE ZavaAthletics;
GO

-- Insert Sports
INSERT INTO Sports (SportCode, SportName, Description) VALUES 
('basketball', 'Basketball', 'Professional and collegiate basketball leagues'),
('soccer', 'Soccer', 'Football/Soccer leagues from around the world'),
('football', 'Football', 'American football leagues including NFL and college'),
('baseball', 'Baseball', 'Professional baseball leagues'),
('hockey', 'Hockey', 'Professional and collegiate hockey leagues'),
('tennis', 'Tennis', 'Professional tennis tours and tournaments'),
('golf', 'Golf', 'Professional golf tours and tournaments'),
('motorsports', 'Motorsports', 'Racing leagues and series');

-- Insert Leagues for Basketball
INSERT INTO Leagues (SportID, LeagueCode, LeagueName, Description) VALUES 
((SELECT SportID FROM Sports WHERE SportCode = 'basketball'), 'nba', 'NBA', 'National Basketball Association'),
((SELECT SportID FROM Sports WHERE SportCode = 'basketball'), 'wnba', 'WNBA', 'Women''s National Basketball Association'),
((SELECT SportID FROM Sports WHERE SportCode = 'basketball'), 'euroleague', 'EuroLeague', 'European Basketball League'),
((SELECT SportID FROM Sports WHERE SportCode = 'basketball'), 'ncaa', 'NCAA Basketball', 'National Collegiate Athletic Association Basketball');

-- Insert Leagues for Soccer
INSERT INTO Leagues (SportID, LeagueCode, LeagueName, Description) VALUES 
((SELECT SportID FROM Sports WHERE SportCode = 'soccer'), 'premier', 'Premier League', 'English Premier League'),
((SELECT SportID FROM Sports WHERE SportCode = 'soccer'), 'la-liga', 'La Liga', 'Spanish Primera División'),
((SELECT SportID FROM Sports WHERE SportCode = 'soccer'), 'mls', 'MLS', 'Major League Soccer'),
((SELECT SportID FROM Sports WHERE SportCode = 'soccer'), 'serie-a', 'Serie A', 'Italian Serie A'),
((SELECT SportID FROM Sports WHERE SportCode = 'soccer'), 'bundesliga', 'Bundesliga', 'German Bundesliga'),
((SELECT SportID FROM Sports WHERE SportCode = 'soccer'), 'ligue-1', 'Ligue 1', 'French Ligue 1');

-- Insert Leagues for Football
INSERT INTO Leagues (SportID, LeagueCode, LeagueName, Description) VALUES 
((SELECT SportID FROM Sports WHERE SportCode = 'football'), 'nfl', 'NFL', 'National Football League'),
((SELECT SportID FROM Sports WHERE SportCode = 'football'), 'ncaa', 'NCAA Football', 'National Collegiate Athletic Association Football'),
((SELECT SportID FROM Sports WHERE SportCode = 'football'), 'cfl', 'CFL', 'Canadian Football League');

-- Insert Leagues for Baseball
INSERT INTO Leagues (SportID, LeagueCode, LeagueName, Description) VALUES 
((SELECT SportID FROM Sports WHERE SportCode = 'baseball'), 'mlb', 'MLB', 'Major League Baseball'),
((SELECT SportID FROM Sports WHERE SportCode = 'baseball'), 'npb', 'NPB', 'Nippon Professional Baseball'),
((SELECT SportID FROM Sports WHERE SportCode = 'baseball'), 'kbo', 'KBO', 'Korea Baseball Organization');

-- Insert Leagues for Hockey
INSERT INTO Leagues (SportID, LeagueCode, LeagueName, Description) VALUES 
((SELECT SportID FROM Sports WHERE SportCode = 'hockey'), 'nhl', 'NHL', 'National Hockey League'),
((SELECT SportID FROM Sports WHERE SportCode = 'hockey'), 'khl', 'KHL', 'Kontinental Hockey League'),
((SELECT SportID FROM Sports WHERE SportCode = 'hockey'), 'shl', 'SHL', 'Swedish Hockey League');

-- Insert Teams for NBA
DECLARE @NBALeagueID INT = (SELECT LeagueID FROM Leagues WHERE LeagueCode = 'nba');
INSERT INTO Teams (LeagueID, TeamCode, TeamName, PrimaryColor, SecondaryColor) VALUES 
(@NBALeagueID, 'lakers', 'Los Angeles Lakers', '#552583', '#FDB927'),
(@NBALeagueID, 'celtics', 'Boston Celtics', '#007A33', '#BA9653'),
(@NBALeagueID, 'warriors', 'Golden State Warriors', '#1D428A', '#FFC72C'),
(@NBALeagueID, 'bulls', 'Chicago Bulls', '#CE1141', '#000000'),
(@NBALeagueID, 'nets', 'Brooklyn Nets', '#000000', '#FFFFFF'),
(@NBALeagueID, 'knicks', 'New York Knicks', '#006BB6', '#F58426'),
(@NBALeagueID, 'heat', 'Miami Heat', '#98002E', '#F9A01B'),
(@NBALeagueID, 'spurs', 'San Antonio Spurs', '#C4CED4', '#000000'),
(@NBALeagueID, 'mavs', 'Dallas Mavericks', '#00538C', '#002B5E'),
(@NBALeagueID, 'sixers', 'Philadelphia 76ers', '#006BB6', '#ED174C');

-- Insert Teams for WNBA
DECLARE @WNBALeagueID INT = (SELECT LeagueID FROM Leagues WHERE LeagueCode = 'wnba');
INSERT INTO Teams (LeagueID, TeamCode, TeamName, PrimaryColor, SecondaryColor) VALUES 
(@WNBALeagueID, 'liberty', 'New York Liberty', '#6ECEB2', '#000000'),
(@WNBALeagueID, 'sparks', 'Los Angeles Sparks', '#FFC72C', '#702F8A'),
(@WNBALeagueID, 'storm', 'Seattle Storm', '#2C5234', '#FFF200'),
(@WNBALeagueID, 'aces', 'Las Vegas Aces', '#000000', '#C8102E'),
(@WNBALeagueID, 'sky', 'Chicago Sky', '#5091CC', '#FFC72C');

-- Insert Teams for Premier League
DECLARE @PremierLeagueID INT = (SELECT LeagueID FROM Leagues WHERE LeagueCode = 'premier');
INSERT INTO Teams (LeagueID, TeamCode, TeamName, PrimaryColor, SecondaryColor) VALUES 
(@PremierLeagueID, 'manchester-united', 'Manchester United', '#DA291C', '#FFF200'),
(@PremierLeagueID, 'liverpool', 'Liverpool FC', '#C8102E', '#00B2A9'),
(@PremierLeagueID, 'arsenal', 'Arsenal', '#EF0107', '#9C824A'),
(@PremierLeagueID, 'chelsea', 'Chelsea', '#034694', '#DBA111'),
(@PremierLeagueID, 'manchester-city', 'Manchester City', '#6CABDD', '#1C2C5B'),
(@PremierLeagueID, 'tottenham', 'Tottenham Hotspur', '#132257', '#FFFFFF'),
(@PremierLeagueID, 'newcastle', 'Newcastle United', '#241F20', '#FFFFFF'),
(@PremierLeagueID, 'west-ham', 'West Ham United', '#7A263A', '#1BB1E7');

-- Insert Teams for La Liga
DECLARE @LaLigaLeagueID INT = (SELECT LeagueID FROM Leagues WHERE LeagueCode = 'la-liga');
INSERT INTO Teams (LeagueID, TeamCode, TeamName, PrimaryColor, SecondaryColor) VALUES 
(@LaLigaLeagueID, 'real-madrid', 'Real Madrid', '#FFFFFF', '#00529F'),
(@LaLigaLeagueID, 'barcelona', 'FC Barcelona', '#004D98', '#A50044'),
(@LaLigaLeagueID, 'atletico', 'Atletico Madrid', '#CB3524', '#FFFFFF'),
(@LaLigaLeagueID, 'sevilla', 'Sevilla FC', '#FFFFFF', '#D4002A'),
(@LaLigaLeagueID, 'valencia', 'Valencia CF', '#FFFFFF', '#FF7900');

-- Insert Teams for NFL
DECLARE @NFLLeagueID INT = (SELECT LeagueID FROM Leagues WHERE LeagueCode = 'nfl');
INSERT INTO Teams (LeagueID, TeamCode, TeamName, PrimaryColor, SecondaryColor) VALUES 
(@NFLLeagueID, 'chiefs', 'Kansas City Chiefs', '#E31837', '#FFB612'),
(@NFLLeagueID, 'cowboys', 'Dallas Cowboys', '#003594', '#041E42'),
(@NFLLeagueID, 'packers', 'Green Bay Packers', '#203731', '#FFB612'),
(@NFLLeagueID, 'patriots', 'New England Patriots', '#002244', '#C60C30'),
(@NFLLeagueID, '49ers', 'San Francisco 49ers', '#AA0000', '#B3995D'),
(@NFLLeagueID, 'steelers', 'Pittsburgh Steelers', '#FFB612', '#101820'),
(@NFLLeagueID, 'rams', 'Los Angeles Rams', '#003594', '#FFA300'),
(@NFLLeagueID, 'bills', 'Buffalo Bills', '#00338D', '#C60C30');

-- Insert Teams for MLB
DECLARE @MLBLeagueID INT = (SELECT LeagueID FROM Leagues WHERE LeagueCode = 'mlb');
INSERT INTO Teams (LeagueID, TeamCode, TeamName, PrimaryColor, SecondaryColor) VALUES 
(@MLBLeagueID, 'yankees', 'New York Yankees', '#0C2340', '#C4CED4'),
(@MLBLeagueID, 'dodgers', 'Los Angeles Dodgers', '#005A9C', '#EF3E42'),
(@MLBLeagueID, 'red-sox', 'Boston Red Sox', '#BD3039', '#0C2340'),
(@MLBLeagueID, 'cubs', 'Chicago Cubs', '#0E3386', '#CC3433'),
(@MLBLeagueID, 'giants', 'San Francisco Giants', '#FD5A1E', '#27251F'),
(@MLBLeagueID, 'astros', 'Houston Astros', '#002D62', '#EB6E1F'),
(@MLBLeagueID, 'braves', 'Atlanta Braves', '#CE1141', '#13274F'),
(@MLBLeagueID, 'mets', 'New York Mets', '#002D72', '#FF5910');

-- Insert Products
INSERT INTO Products (ProductCode, ProductName, Description, BasePrice) VALUES 
('t-shirt', 'T-Shirt', 'Classic fit cotton t-shirt with custom design', 29.99),
('hoodie', 'Hoodie', 'Comfortable pullover hoodie with custom design', 49.99),
('cap', 'Baseball Cap', 'Adjustable baseball cap with custom embroidery', 24.99),
('jacket', 'Jacket', 'Lightweight jacket with custom design', 69.99),
('tank-top', 'Tank Top', 'Sleeveless athletic tank top', 24.99),
('long-sleeve', 'Long Sleeve Shirt', 'Long sleeve cotton shirt with custom design', 34.99),
('polo', 'Polo Shirt', 'Classic polo shirt with custom embroidery', 39.99),
('sweatshirt', 'Sweatshirt', 'Comfortable crew neck sweatshirt', 44.99);

-- Insert Product Colors
INSERT INTO ProductColors (ColorName, ColorValue) VALUES 
('Black', '#000000'),
('White', '#FFFFFF'),
('Navy', '#0A2342'),
('Red', '#D80032'),
('Royal Blue', '#0047AB'),
('Forest Green', '#228B22'),
('Gray', '#808080'),
('Gold', '#FFD700'),
('Purple', '#6A0DAD'),
('Orange', '#FF7F00'),
('Maroon', '#800000'),
('Kelly Green', '#4CBB17'),
('Sky Blue', '#87CEEB'),
('Pink', '#FFC0CB'),
('Yellow', '#FFFF00'),
('Brown', '#964B00'),
('Lime Green', '#32CD32'),
('Burgundy', '#800020'),
('Teal', '#008080'),
('Coral', '#FF7F50');

-- Insert Text Colors
INSERT INTO TextColors (ColorName, ColorValue) VALUES 
('White', '#FFFFFF'),
('Black', '#000000'),
('Gold', '#FFD700'),
('Silver', '#C0C0C0'),
('Red', '#D80032'),
('Royal Blue', '#0047AB'),
('Navy', '#0A2342'),
('Green', '#228B22'),
('Orange', '#FF7F00'),
('Purple', '#6A0DAD'),
('Yellow', '#FFFF00'),
('Pink', '#FFC0CB'),
('Brown', '#964B00'),
('Gray', '#808080'),
('Lime Green', '#32CD32');

-- Insert Sample Customers
INSERT INTO Customers (CustomerEmail, CustomerName) VALUES 
('john.doe@email.com', 'John Doe'),
('jane.smith@email.com', 'Jane Smith'),
('mike.johnson@email.com', 'Mike Johnson'),
('sarah.williams@email.com', 'Sarah Williams'),
('test.user@email.com', 'Test User');

PRINT 'Test data loaded successfully!';