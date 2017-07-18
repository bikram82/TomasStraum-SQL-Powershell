USE [database]
GO

/****** Object:  StoredProcedure [dbo].[SendDBSizeWarning]    Script Date: 5/15/2017 11:13:19 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Straum, Tomas>
-- Create date: <12.05.2017>
-- Description:	<Description,,>
-- =============================================

CREATE PROCEDURE [dbo].[SendDBSizeWarning]
AS
BEGIN

declare @db_size int
declare @msg varchar(2000)
DECLARE @body VARCHAR(MAX)

select @db_size = sum(size)/128
from dbo.sysfiles
where fileid  <> 2

if (@db_size > 9*1024)
begin
	-- send email using sp_send_dbmail
	set @msg =  'DB size is = ' + cast(@db_size as varchar(15)) + ' MB.'
	print @msg

SET @body ='<html><body>

<H3>Action needed, Store Database size getting close to the limit".
</H3>
<H3> This is a system generated email, please do not respond to it
</H3>  
'

SET @body = @body +'</body></html>'+ @msg

-----------------------------------------------------------------------------
EXEC msdb.dbo.sp_send_dbmail
@profile_name = 'SQLProfile',
@recipients = 'email address',
@body = @body,
@body_format ='HTML',
@subject = 'Warning!! DBname';

END

END
GO


