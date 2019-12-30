/* CREATE DATABASE */

PRINT 'Creating Database...'
GO

USE master;
GO

IF DB_ID('TestDB') IS NOT NULL
    DROP DATABASE TestDB;
GO

CREATE DATABASE TestDB;
GO

PRINT 'Done.
    '
GO

PRINT 'Switching to database...'
GO

USE TestDB;
GO

PRINT 'Done.
    '
GO
/* /CREATE DATABASE */
--------------------------------------------------------------------
/* CREATE TABLES */

-- -- /* FIRST DROP TABLES*/
PRINT 'Performing cleanup...'
GO

DROP TABLE IF EXISTS [dbo].[Brands] ;
GO

DROP TABLE IF EXISTS [dbo].[Cart Details] ;
GO

DROP TABLE IF EXISTS [dbo].[Carts] ;
GO

DROP TABLE IF EXISTS [dbo].[Customers] ;
GO

DROP TABLE IF EXISTS [dbo].[Categories] ;
GO

DROP TABLE IF EXISTS [dbo].[Subcategories] ;
GO

DROP TABLE IF EXISTS [dbo].[Products] ;
GO

DROP TABLE IF EXISTS [dbo].[Suppliers] ;
GO

DROP TABLE IF EXISTS [dbo].[Resupplies] ;
GO

DROP TABLE IF EXISTS [dbo].[Resupply Details] ;
GO

DROP TABLE IF EXISTS [dbo].[Orders] ;
GO

DROP TABLE IF EXISTS dbo.[Order Details] ;
GO

DROP TABLE IF EXISTS [dbo].[Reviews] ;
GO

DROP TABLE IF EXISTS [dbo].[Review Ratings] ;
GO

DROP TABLE IF EXISTS [dbo].[Departments] ;
GO

DROP TABLE IF EXISTS [dbo].[Employees] ;
GO

DROP TABLE IF EXISTS [dbo].[Storage] ;
GO

PRINT 'Done.
    '
GO
-- -- /* /FIRST DROP TABLES*/

PRINT 'Creating tables...'
GO

-- Customers
CREATE TABLE [dbo].[Customers]
    ( 
        [CustomerID] INT IDENTITY(1,1) NOT NULL
        , CONSTRAINT [PK_Customers] PRIMARY KEY (CustomerID) 
        , [Name] NVARCHAR(40) NOT NULL
    )
;
GO

-- Categories
CREATE TABLE [dbo].[Categories]
    (
        [CategoryID] TINYINT NOT NULL
        , CONSTRAINT [PK_Categories] PRIMARY KEY (CategoryID)
        , [Category Name] NVARCHAR(20) NOT NULL
    )   
;
GO

-- Subcategories
CREATE TABLE [dbo].[Subcategories]
    (
        [CategoryID] TINYINT NOT NULL
        , CONSTRAINT [FK_Subcategories_Categories] FOREIGN KEY (CategoryID)
          REFERENCES [dbo].[Categories] (CategoryID)
          ON DELETE CASCADE
          ON UPDATE CASCADE
        , [SubcategoryID] TINYINT IDENTITY(1,1) NOT NULL UNIQUE
        , [Subcategory Name] NVARCHAR(40) NOT NULL
        , CONSTRAINT [PK_Subcategories] PRIMARY KEY (CategoryID, SubcategoryID)
    )
;
GO

-- Brands
CREATE TABLE [dbo].[Brands]
    (
        [BrandID] INT IDENTITY(1,1)
        , CONSTRAINT [PK_Brands] PRIMARY KEY (BrandID)
        , [Brand Name] NVARCHAR(20) NOT NULL
    )
;
GO

-- Products
CREATE TABLE [dbo].[Products]
    ( 
        [ProductID] INT IDENTITY(1,1) NOT NULL
        , CONSTRAINT [PK_Products] PRIMARY KEY (ProductID) 
        , [Product Name] NVARCHAR(40) NOT NULL
        -- , [BrandID] INT -- TODO NOT NULL, TRIGGER FOR ASSIGNING BrandID to product
        , [Product Description] NVARCHAR(100)
        , [CategoryID] TINYINT
        , CONSTRAINT [FK_Products_Categories] FOREIGN KEY (CategoryID)
          REFERENCES [dbo].[Categories] (CategoryID)
          ON DELETE SET NULL
          ON UPDATE CASCADE 
        , [SubcategoryID] TINYINT
        , CONSTRAINT [FK_Products_Subcategories] FOREIGN KEY (SubcategoryID)
          REFERENCES [dbo].[Subcategories] (SubcategoryID)
        , [Wholesale Price] MONEY NOT NULL  -- TODO trigger: price >=0
        , [Retail Price] MONEY NOT NULL  -- TODO trigger
    )
;
GO


-- Suppliers
CREATE TABLE [dbo].[Suppliers]
    (
        [SupplierID] INT IDENTITY(1,1) NOT NULL
        , CONSTRAINT [PK_Suppliers] PRIMARY KEY (SupplierID)
        , [SupplierName] NVARCHAR(40) NOT NULL
        , [Country] NVARCHAR(20)
        , [City] NVARCHAR(20)
        , [Address] NVARCHAR(40)
        , [PostalCode] NVARCHAR(6)
        , [EmailAddress] NVARCHAR(30)
        , [Phone] NVARCHAR(20)
    )
;
GO

-- Resupplies
CREATE TABLE [dbo].[Resupplies]
    (
        [ResupplyID] INT IDENTITY(1,1) NOT NULL
        , CONSTRAINT [PK_Resupplies] PRIMARY KEY (ResupplyID)
        , [SupplierID] INT NOT NULL
        , CONSTRAINT [FK_Resupplies_Suppliers] FOREIGN KEY (SupplierID)
          REFERENCEs [dbo].[Suppliers] (SupplierID)
          ON DELETE CASCADE
          ON UPDATE CASCADE         
    )
;
GO

-- ResupplyDetails
CREATE TABLE [dbo].[Resupply Details]
    (
        [ResupplyID] INT NOT NULL
        , CONSTRAINT [FK_ResupplyDetails_Resupplies] FOREIGN KEY (ResupplyID)
          REFERENCEs [dbo].[Resupplies] (ResupplyID)
          ON DELETE CASCADE
          ON UPDATE CASCADE
        , [ProductID] INT NOT NULL
        , CONSTRAINT [FK_ResupplyDetails_Products] FOREIGN KEY (ProductID)
          REFERENCEs [dbo].[Products] (ProductID)
          ON DELETE CASCADE
          ON UPDATE CASCADE
        , [Quantity] SMALLINT NOT NULL
    )
;
GO

-- Orders
CREATE TABLE [dbo].[Orders]
    ( 
        [OrderID] INT IDENTITY(1,1) NOT NULL
        , CONSTRAINT [PK_Orders] PRIMARY KEY (OrderID)
        , [CustomerID] INT
        , CONSTRAINT [FK_Orders_Customers] FOREIGN KEY (CustomerID)
          REFERENCES [dbo].[Customers] (CustomerID)
          ON DELETE CASCADE
          ON UPDATE CASCADE
        , [Order Date] DATETIME NOT NULL
        , [Recieved Date] DATETIME
    )
;
GO

-- Order Details
CREATE TABLE [dbo].[Order Details]
    ( 
        [OrderID] INT NOT NULL
        , CONSTRAINT [FK_OrderDetails_Orders] FOREIGN KEY (OrderID)
          REFERENCES [dbo].[Orders] (OrderID)
          ON DELETE CASCADE
          ON UPDATE CASCADE
        , [ProductID] INT NOT NULL
        , CONSTRAINT [FK_OrderDetails_Products] FOREIGN KEY (ProductID)
          REFERENCES [dbo].[Products] (ProductID)
          ON DELETE CASCADE
          ON UPDATE CASCADE
        , [UnitPrice] MONEY NOT NULL
        , [Quantity] SMALLINT NOT NULL
        , [Discount] REAL NOT NULL
        , CONSTRAINT [PK_OrderDetails] PRIMARY KEY (OrderID, ProductID)
    )
;
GO

-- Reviews
CREATE TABLE [dbo].[Reviews]
    (
        [ReviewID] INT IDENTITY(1,1) NOT NULL UNIQUE
        , [CustomerID] INT NOT NULL
        , CONSTRAINT [FK_Reviews_Customers] FOREIGN KEY (CustomerID)
          REFERENCES [dbo].[Customers] (CustomerID)
          ON DELETE CASCADE
          ON UPDATE CASCADE
        , [ProductID] INT NOT NULL
        , CONSTRAINT [FK_Reviews_Products] FOREIGN KEY (ProductID)
          REFERENCES [dbo].[Products] (ProductID)
          ON DELETE CASCADE
          ON UPDATE CASCADE
        , [Content] NTEXT
        , [Rating] TINYINT NOT NULL
        , CONSTRAINT [CK_Reviews_ValidRating] CHECK 
          (Rating >= 1 AND Rating <= 5)   
        , CONSTRAINT [PK_Reviews] PRIMARY KEY (CustomerID, ProductID)
    )
;
GO

-- Review Ratings
-- customer can 'thumbUp' a review to mark it as helpful
CREATE TABLE [dbo].[Review Ratings]
    (
        [ReviewID] INT NOT NULL
        , CONSTRAINT [FK_ReviewRatings_Reviews] FOREIGN KEY (ReviewID)
          REFERENCES [dbo].[Reviews] (ReviewID)
          ON DELETE CASCADE
          ON UPDATE CASCADE
        , [CustomerID] INT NOT NULL
        , CONSTRAINT [FK_ReviewRatings_Customers] FOREIGN KEY (CustomerID)
          REFERENCES [dbo].[Customers] (CustomerID)
    )
;
GO

-- Departments
-- Employee can be assigned to a department
CREATE TABLE [dbo].[Departments]
    (
        [DepartmentID] TINYINT NOT NULL
        , CONSTRAINT [PK_Departments] PRIMARY KEY (DepartmentID)
        , [DepartmentName] VARCHAR(20) NOT NULL
    )
;
GO

-- Employees
CREATE TABLE [dbo].[Employees]
    (
        [EmployeeID] INT IDENTITY(1,1) NOT NULL
        , CONSTRAINT [PK_Employees] PRIMARY KEY (EmployeeID)
        , [Name] NVARCHAR(40) NOT NULL UNIQUE
        , [DepartmentID] TINYINT DEFAULT NULL
        , CONSTRAINT [FK_Employees_Departments] FOREIGN KEY (DepartmentID)
          REFERENCES [dbo].[Departments] (DepartmentID)
          ON DELETE SET NULL
          ON UPDATE CASCADE
    )
;
GO

-- Storage
-- every item has to be stored in Storage
CREATE TABLE [dbo].[Storage]
    (
        -- every product has only one spot in storage
        [ProductID] INT NOT NULL UNIQUE
        , CONSTRAINT [FK_Storage_Products] FOREIGN KEY (ProductID)
          REFERENCES [dbo].[Products] (ProductID)
          ON DELETE CASCADE
          ON UPDATE CASCADE
        , [StockMax] INT NOT NULL
        , CONSTRAINT [CK_Storage_StockMaxValid] CHECK ( StockMax > 0 )  -- TODO trigger
        , [Stock] INT NOT NULL
        , CONSTRAINT [CK_Storage_StockValid] CHECK ( Stock BETWEEN 0 AND StockMax ) -- TODO trigger
    )

;
GO

-- Carts
-- every user, while shopping, adds items to Cart.
-- Orders are made by ordering what is currently in a Cart
CREATE TABLE [dbo].[Carts]
    (
        [CartID] INT IDENTITY(1,1)
        , CONSTRAINT [PK_Carts] PRIMARY KEY (CartID)
        -- every customer can have only one cart at the time
        , [CustomerID] INT NOT NULL UNIQUE
        , CONSTRAINT [FK_Carts_Customers] FOREIGN KEY (CustomerID)
          REFERENCES [dbo].[Customers] (CustomerID)
          ON DELETE CASCADE
          ON UPDATE CASCADE
    )
;
GO

-- Cart Details
CREATE TABLE [dbo].[Cart Details]
    (
        [CartID] INT NOT NULL
        , CONSTRAINT [FK_CartDetails_Carts] FOREIGN KEY (CartID)
          REFERENCES [dbo].[Carts] (CartID)
          ON DELETE CASCADE
          ON UPDATE CASCADE
        , [ProductID] INT NOT NULL
        , CONSTRAINT [FK_CartDetails_Products] FOREIGN KEY (ProductID)
          REFERENCES [dbo].[Products] (ProductID)
          ON DELETE CASCADE
          ON UPDATE CASCADE
        , CONSTRAINT [PK_CartDetails] PRIMARY KEY (CartID, ProductID)
    )
;
GO

PRINT 'Done.
    '
GO
/* /CREATE TABLES */
--------------------------------------------------------------------
/* FILL TABLES */
DECLARE @FillTables BIT = 'true'

IF @FillTables = 'true' BEGIN

    SET NOCOUNT ON

    PRINT 'Initialising Customers...'
    INSERT INTO [dbo].[Customers]
    VALUES
      ('Celina Johansen')
    , ('Cyryl Jensen')
    , ('Cameron Moller')
    , ('Carolina Moller')
    , ('Cyryl Andersen')
    , ('Cataleya Pedersen')
    , ('Chanell Moller')
    , ('Carmen Moller')
    , ('Carla Christiansen')
    , ('Cyprian Moller')
    ;
    PRINT 'Done.
    '

    PRINT 'Initialising Categories...'
    INSERT INTO [dbo].[Categories] VALUES
      (1, 'Twarz')
    , (2, 'Usta')
    , (3, 'Oczy')
    , (4, 'Brwi')
    , (5, 'Paznokcie')
    , (6, 'Akcesoria')
    , (7, 'Dermokosmetyki')
    , (8, 'Zestawy')
    ;
    PRINT 'Done.
    '

    PRINT 'Initialising Subcategories...'
    INSERT INTO [dbo].[Subcategories] VALUES
    -- Twarz
      (1, 'Podkłady')
    , (1, 'Pudry')
    , (1, 'Korektory')
    , (1, 'Rozświetlacze i bronzery')
    , (1, 'Róże')
    , (1, 'Kremy BB i CC')
    , (1, 'Bazy pod makijaż')
    , (1, 'Spraye utrwalające makijaż')
    , (1, 'Pędzle do makijażu')
    , (1, 'Akcesoria')
    -- Usta
    , (2, 'Błyszczyki')
    , (2, 'Pomadki do ust')
    , (2, 'Konturówki do ust')
    , (2, 'Pędzle do ust')
    -- Oczy
    , (3, 'Tusze do rzęs')
    , (3, 'Bazy i cienie do powiek')
    , (3, 'Paletki cieni')
    , (3, 'Kredki do oczu i eyelinery')
    , (3, 'Sztuczne rzęsy')
    , (3, 'Odżywki do rzęs')
    , (3, 'Pędzle do oczu')
    , (3, 'Akcesoria')
    -- Brwi
    , (4, 'Kredki do brwi')
    , (4, 'Cienie')
    , (4, 'Korektory do brwi')
    , (4, 'Maskary, żele, woski, pomady, henna')
    , (4, 'Pędzle do brwi')
    , (4, 'Akcesoria')
    -- Paznokcie
    , (5, 'Lakiery do paznokci')
    , (5, 'Lakiery hybrydowe')
    , (5, 'Pielęgnacja')
    , (5, 'Zmywacze')
    , (5, 'Zdobienie paznokci')
    , (5, 'Bazy i utwardzanie, top coat')
    , (5, 'Sztuczne paznokcie')
    , (5, 'Akcesoria')
    -- Akcesoria
    , (6, 'Do twarzy')
    , (6, 'Do ust')
    , (6, 'Do oczu')
    , (6, 'Do paznokci')
    , (6, 'Pędzle do makijażu')
    , (6, 'Kosmetyczki')
    -- Dermokosmetyki nie mają podkategorii
    -- Zestawy też    nie mają podkategorii
    ;
    PRINT 'Done.
    '

    PRINT 'Initialising Products...'
    INSERT INTO [dbo].[Products] VALUES
      ('Colorstay', 'podkład z pompką do cery tłustej i mieszanej, 30 ml', 1, 1, 24, 48.99) -- Brand=Revlon
    , ('X-CEPTIONAL WEAR', 'kryjący podkład do twarzy w kremie do twarzy, 35 ml', 1, 1, 21, 41.99) --Gosh
    , ('MINERALS GOLDEN FAIREST', 'podkład matujący do twarzy, 4 g', 1, 1, 22, 44.99) -- Annabelle
    , ('HD LIQUID COVERAGE', 'podkład do twarzy, 30 ml', 1, 1, 10, 23.19) -- Catrice
    PRINT 'Done.
    '

    PRINT 'Initialising Departments...'
    INSERT INTO [dbo].[Departments] VALUES
      (1, 'Management')
    , (2, 'IT')
    , (3, 'Sales')
    , (4, 'Packaging')
    ;
    PRINT 'Done.
    '

    PRINT 'Initialising Employees...'
    INSERT INTO [dbo].[Employees] VALUES
      ('Eryk Sorensen', 4)
    , ('Elif Jensen', 3)
    , ('Eliza Moller', 2)
    , ('Elisabeth Christiansen', 1)
    , ('Edward Larsen', 1)
    , ('Emanuel Poulsen', 3)
    , ('Eugeniusz Johansen', 3)
    , ('Eryk Pedersen', 4)
    , ('Elif Olsen', 4)
    , ('Elzna Jorgensen', 4)
    PRINT 'Done.
    '

    PRINT 'Initialising Storage...'
    INSERT INTO [dbo].[Storage] VALUES
      (1, 1000, 1000)
    , (2, 1000, 1000)
    , (3, 1000, 1000)
    PRINT 'Done.
    '

    SET NOCOUNT OFF

    PRINT 'Tables filled successfully.'

END

GO
/* /FILL TABLES */
--------------------------------------------------------------------
/* CREATE TRIGGERS */
-- heh
/* /CREATE TRIGGERS */
