--TASK 1
USE AdventureWorks2012
GO
DECLARE @XML XML
SET @XML =(
SELECT TOP 100 FirstName, LastName, 
			   Password.ModifiedDate AS 'Password/Date',
			   Password.BusinessEntityID AS 'Password/ID'
FROM Person.Person Person
JOIN Person.Password Password
ON Person.BusinessEntityID = Password.BusinessEntityID
FOR XML PATH('Person'), ROOT('Persons')
)
SELECT @XML

--PROCEDURE CALL
EXECUTE dbo.PasswordToXML @XML

--TASK 2
GO
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'PasswordToXML') 
DROP PROCEDURE PasswordToXML
GO
CREATE PROCEDURE PasswordToXML
@XML XML
AS
BEGIN
	SELECT Password.query('.')
	FROM @XML.nodes('/Persons/Person/Password') as T(Password)
RETURN
END