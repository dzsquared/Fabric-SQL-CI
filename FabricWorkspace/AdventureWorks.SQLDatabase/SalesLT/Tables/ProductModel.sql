CREATE TABLE [SalesLT].[ProductModel] (
    [ProductModelID] INT              IDENTITY (1, 1) NOT NULL,
    [Name]           NVARCHAR (50)    NULL,
    [rowguid]        UNIQUEIDENTIFIER CONSTRAINT [DF_ProductModel_rowguid] DEFAULT (newid()) NOT NULL,
    [ModifiedDate]   DATETIME         CONSTRAINT [DF_ProductModel_ModifiedDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_ProductModel_ProductModelID] PRIMARY KEY CLUSTERED ([ProductModelID] ASC),
    CONSTRAINT [AK_ProductModel_Name] UNIQUE NONCLUSTERED ([Name] ASC),
    CONSTRAINT [AK_ProductModel_rowguid] UNIQUE NONCLUSTERED ([rowguid] ASC)
);


GO

