-- create DB
PRINT 'Creating Database...'
:r C:\Users\Mateusz\Desktop\DB-Project\CreateDB.sql
GO
PRINT 'Database created.
	'

	
PRINT 'Deploying Views...'
:r C:\Users\Mateusz\Desktop\DB-Project\VIEW_Products_Bought.sql
:r C:\Users\Mateusz\Desktop\DB-Project\VIEW_Storage_Status.sql
:r C:\Users\Mateusz\Desktop\DB-Project\VIEW_Hot_Brands.sql
:r C:\Users\Mateusz\Desktop\DB-Project\VIEW_Category_Organisation.sql
GO
PRINT 'Views deployed.
	'


PRINT 'Deploying Procedures...'
:r C:\Users\Mateusz\Desktop\DB-Project\PROC_Add_Customer.sql
:r C:\Users\Mateusz\Desktop\DB-Project\PROC_Add_Review.sql
:r C:\Users\Mateusz\Desktop\DB-Project\PROC_Add_Review_Rating.sql
:r C:\Users\Mateusz\Desktop\DB-Project\PROC_Add_To_Cart.sql
:r C:\Users\Mateusz\Desktop\DB-Project\PROC_Buy.sql
:r C:\Users\Mateusz\Desktop\DB-Project\PROC_Delete_From_Cart.sql
:r C:\Users\Mateusz\Desktop\DB-Project\PROC_New_Mail.sql
:r C:\Users\Mateusz\Desktop\DB-Project\PROC_Confirm_Account.sql
GO
PRINT 'Procedures deployed.
	'


PRINT 'Deploying Functions...'
:r C:\Users\Mateusz\Desktop\DB-Project\FUNC_Generate_Note.sql
:r C:\Users\Mateusz\Desktop\DB-Project\FUNC_Product_Bought.sql
:r C:\Users\Mateusz\Desktop\DB-Project\FUNC_Product_Lookup.sql
:r C:\Users\Mateusz\Desktop\DB-Project\FUNC_Get_Review_Ratings.sql
:r C:\Users\Mateusz\Desktop\DB-Project\FUNC_Get_Reviews.sql
GO
PRINT 'Functions deployed.
	'


PRINT 'Deploying Triggers...'
:r C:\Users\Mateusz\Desktop\DB-Project\TRIG_AssignBrandID.sql
:r C:\Users\Mateusz\Desktop\DB-Project\TRIG_Guard_Categories.sql
:r C:\Users\Mateusz\Desktop\DB-Project\TRIG_New_Product_Notification.sql
:r C:\Users\Mateusz\Desktop\DB-Project\TRIG_Confirmation_Email.sql
:r C:\Users\Mateusz\Desktop\DB-Project\TRIG_Stock_Alert.sql
GO
PRINT 'Triggers deployed.
	'
	

PRINT 'Filling Tables...'
:r C:\Users\Mateusz\Desktop\DB-Project\FillDB.sql
GO
PRINT '
Tables Filled.
	'
GO
