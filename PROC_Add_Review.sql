IF OBJECT_ID('dbo.AddReview', 'P') IS NOT NULL
DROP PROC dbo.AddReview
GO

CREATE PROC dbo.AddReview

@CustomerID INT = NULL,
@ProductID INT = NULL,
@Content NTEXT = NULL,
@Rating TINYINT = NULL

AS

	DECLARE @error AS NVARCHAR(100);
	
	IF @CustomerID IS NULL OR @ProductID IS NULL OR @Rating IS NULL
	BEGIN
		SET @error = 'Error! Rating invalid! Adding aborted.';
		RAISERROR(@error, 16,1);
		RETURN;
	END

	INSERT INTO dbo.[Reviews] VALUES
	(@CustomerID, @ProductID, @Content, @Rating)


GO

EXEC dbo.AddReview 1, 1, NULL, 5
GO