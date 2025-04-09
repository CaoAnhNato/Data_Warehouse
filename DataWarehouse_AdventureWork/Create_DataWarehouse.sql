create database DataWarehouse_AdWork 
GO


USE [DataWarehouse_AdWork]
GO 

create schema Project;
Go


------- Tạo các bảng dimention
create table Project.[Dim_Year](
	[Year_key] [nvarchar](4) NOT NULL,
	[Year] [int] NOT NULL,
CONSTRAINT [PK_Dim_Year] PRIMARY KEY CLUSTERED
(
	[Year_Key] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


----------Tạo dim month
create table Project.[Dim_Month](
	[Month_Key] [nvarchar](6) NOT NULL,
	[Year_key] [nvarchar](4) NOT NULL,
	[Month] [int] NOT NULL,
CONSTRAINT [PK_Dim_Month] PRIMARY KEY CLUSTERED
(
	[Month_Key] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE Project.[Dim_Month] WITH CHECK ADD CONSTRAINT [FK_Dim_Month_Dim_Year] FOREIGN KEY([Year_key])
REFERENCES Project.[Dim_Year] ([Year_key])
GO
ALTER TABLE Project.[Dim_Month] CHECK CONSTRAINT [FK_Dim_Month_Dim_Year]
GO


----------------Tạo dim date
create table Project.[Dim_Date](
	[Date_Key] [nvarchar](8) NOT NULL,
	[Month_Key] [nvarchar](6) NOT NULL,
	[Date] [date] NOT NULL,
CONSTRAINT [PK_Dim_Date] PRIMARY KEY CLUSTERED
(
	[Date_Key] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE Project.[Dim_Date] WITH CHECK ADD CONSTRAINT [FK_Dim_Date_Dim_Month] FOREIGN KEY([Month_Key])
REFERENCES Project.[Dim_Month] ([Month_Key])
GO
ALTER TABLE Project.[Dim_Date] CHECK CONSTRAINT [FK_Dim_Date_Dim_Month]
GO


----------------Tạo sales Person Dim
create table Project.[Dim_SalesPerson](
	[SalesPerson_Key] [int] IDENTITY(1,1) NOT NULL,
	[SalesPersonId] [int] NOT NULL,
	[Full_Name] [nvarchar](500) NULL,
	[National_ID_Number] [nvarchar](15) NULL,
	[Gender] nchar(1) NULL,
	[HireDate] date NULL,
CONSTRAINT [PK_Dim_SalesPerson] PRIMARY KEY CLUSTERED
(
	[SalesPerson_Key] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

------------------ Tạo Dim Territory 

create table Project.[Dim_Territory](
	[Territory_Key] [int] IDENTITY(1,1) NOT NULL,
	[TerritoryId] [int] NOT NULL,
	[Name] [nvarchar](50) NULL,
	[Country_Region_Code] [nvarchar](5) NOT NULL,
CONSTRAINT [PK_Dim_Territory] PRIMARY KEY CLUSTERED
(
	[Territory_Key] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO



--------------------Tạo Dim product category
create table Project.[Dim_ProductCategory](
	[ProductCategory_Key] [int] IDENTITY(1,1) NOT NULL,
	[ProductCategory_Id] [int] NOT NULL,
	[Name] [nvarchar](50) NULL,
CONSTRAINT [PK_Dim_ProductCategory] PRIMARY KEY CLUSTERED
(
	[ProductCategory_Key] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


--------------------Tạo Dim pro-sub
create table Project.[Dim_Product_Sub_Category](
	[Product_Sub_Category_Key] [int] IDENTITY(1,1) NOT NULL,
	[Product_Sub_Category_Id] [int] NOT NULL,
	[Name] [nvarchar](50) NULL,
	[ProductCategory_Key] int NULL,
CONSTRAINT [PK_Dim_Product_Sub_Category] PRIMARY KEY CLUSTERED
(
	[Product_Sub_Category_Key] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE Project.[Dim_Product_Sub_Category] WITH CHECK ADD CONSTRAINT [FK_Dim_ProSubCategory_Dim_ProdCate] FOREIGN KEY([ProductCategory_Key])
REFERENCES Project.[Dim_ProductCategory] ([ProductCategory_Key])
GO
ALTER TABLE Project.[Dim_Product_Sub_Category] CHECK CONSTRAINT [FK_Dim_ProSubCategory_Dim_ProdCate]
GO

----------------------Tạo dim prod

create table Project.[Dim_Product](
	[Product_Key] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Product_Number] [nvarchar](25) NOT NULL,
	[Standard_Cost] money NOT NULL,
	[List_Price] money NOT NULL,
	[Weight] decimal(8,2) NULL,
	[Product_Sub_Category_Key] [int] NULL,
CONSTRAINT [PK_Dim_Product] PRIMARY KEY CLUSTERED
(
	[Product_Key] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE Project.[Dim_Product] WITH CHECK ADD CONSTRAINT [FK_Dim_Product_ProSubCategory] FOREIGN KEY([Product_Sub_Category_Key])
REFERENCES Project.[Dim_Product_Sub_Category] ([Product_Sub_Category_Key])
GO
ALTER TABLE Project.[Dim_Product] CHECK CONSTRAINT [FK_Dim_Product_ProSubCategory]
GO


--------------------Tạo Fact Sales order
create table Project.[Fact_SalesOrder](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Date_Key] [nvarchar](8) NOT NULL,
	[Territory_Key] int NULL,
	[SalesPerson_Key] int NOT NULL,
	[Revenue] [decimal](18, 4) NOT NULL,
	[Number_Order] int NULL,
CONSTRAINT [PK_Fact_SalesOrder] PRIMARY KEY CLUSTERED
(
	[Id] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE Project.[Fact_SalesOrder] WITH CHECK ADD CONSTRAINT [FK_Fact_SalesOrder_Dim_Date] FOREIGN KEY([Date_Key])
REFERENCES Project.[Dim_Date] ([Date_Key])
GO
ALTER TABLE Project.[Fact_SalesOrder] CHECK CONSTRAINT [FK_Fact_SalesOrder_Dim_Date]
GO

ALTER TABLE Project.[Fact_SalesOrder] WITH CHECK ADD CONSTRAINT [FK_Fact_SalesOrder_Dim_SalesPerson] FOREIGN KEY([SalesPerson_Key])
REFERENCES Project.[Dim_SalesPerson] ([SalesPerson_Key])
GO
ALTER TABLE Project.[Fact_SalesOrder] CHECK CONSTRAINT [FK_Fact_SalesOrder_Dim_SalesPerson]
GO

ALTER TABLE Project.[Fact_SalesOrder] WITH CHECK ADD CONSTRAINT [FK_Fact_SalesOrder_Dim_Territory] FOREIGN KEY([Territory_Key])
REFERENCES Project.[Dim_Territory] ([Territory_Key])
GO
ALTER TABLE Project.[Fact_SalesOrder] CHECK CONSTRAINT [FK_Fact_SalesOrder_Dim_Territory]
GO


------------------ Tạo Fact Product
create table Project.[Fact_Product](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Date_Key] [nvarchar](8) NOT NULL,
	[Product_Key] int NULL,
	[Territory_Key] int NOT NULL,
	[Quantity] int NULL,
CONSTRAINT [PK_Fact_Product] PRIMARY KEY CLUSTERED
(
	[Id] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE Project.[Fact_Product] WITH CHECK ADD CONSTRAINT [FK_Fact_Product_Dim_Date] FOREIGN KEY([Date_Key])
REFERENCES Project.[Dim_Date] ([Date_Key])
GO
ALTER TABLE Project.[Fact_Product] CHECK CONSTRAINT [FK_Fact_Product_Dim_Date]
GO

ALTER TABLE Project.[Fact_Product] WITH CHECK ADD CONSTRAINT [FK_Fact_Product_Dim_Product] FOREIGN KEY([Product_Key])
REFERENCES Project.[Dim_Product] ([Product_Key])
GO
ALTER TABLE Project.[Fact_Product] CHECK CONSTRAINT [FK_Fact_Product_Dim_Product]
GO

ALTER TABLE Project.[Fact_Product] WITH CHECK ADD CONSTRAINT [FK_Fact_Product_Dim_Territory] FOREIGN KEY([Territory_Key])
REFERENCES Project.[Dim_Territory] ([Territory_Key])
GO
ALTER TABLE Project.[Fact_Product] CHECK CONSTRAINT [FK_Fact_Product_Dim_Territory]
GO


