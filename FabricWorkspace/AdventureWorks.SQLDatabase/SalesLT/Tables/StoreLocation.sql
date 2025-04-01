CREATE TABLE [SalesLT].[StoreLocation] (
    [StoreID]       INT              IDENTITY (1, 1) NOT NULL,
    [AddressLine1]  NVARCHAR (60)    NOT NULL,
    [AddressLine2]  NVARCHAR (60)    NULL,
    [City]          NVARCHAR (30)    NOT NULL,
    [StateProvince] NVARCHAR (50)    NULL,
    [CountryRegion] NVARCHAR (50)    NULL,
    [PostalCode]    NVARCHAR (15)    NOT NULL,
    [rowguid]       UNIQUEIDENTIFIER CONSTRAINT [DF_Store_rowguid] DEFAULT (newid()) NOT NULL,
    [ModifiedDate]  DATETIME         CONSTRAINT [DF_Store_ModifiedDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_Store_StoreID] PRIMARY KEY CLUSTERED ([StoreID] ASC),
    CONSTRAINT [AK_Store_rowguid] UNIQUE NONCLUSTERED ([rowguid] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_StoreLocation_AddressLine1_AddressLine2_City_StateProvince_PostalCode_CountryRegion]
    ON [SalesLT].[StoreLocation]([AddressLine1] ASC, [AddressLine2] ASC, [City] ASC, [StateProvince] ASC, [PostalCode] ASC, [CountryRegion] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_StoreLocation_StateProvince]
    ON [SalesLT].[StoreLocation]([StateProvince] ASC);


GO

