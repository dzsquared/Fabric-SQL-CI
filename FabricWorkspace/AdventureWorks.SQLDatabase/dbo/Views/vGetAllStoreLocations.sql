CREATE VIEW vGetAllStoreLocations AS
SELECT SL.*
FROM SalesLT.StoreLocation SL
WHERE SL.StoreID IS NOT NULL

GO

