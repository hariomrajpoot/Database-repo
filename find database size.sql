select sum(datalength(yourfield))
from yourtable


SELECT 'SUM(DATALENGTH('+Column_name+')) / (1024*1024) as '+Column_name+'_MB,'
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = '--TABLE_NAME--'




USE [YourDatabase]
IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
CREATE TABLE #temp (tablename varchar(max), columnname varchar(max), sizeinkb float)

DECLARE MY_CURSOR Cursor LOCAL FAST_FORWARD 
FOR SELECT table_name, column_name, table_schema FROM INFORMATION_SCHEMA.COLUMNS

Open My_Cursor 
DECLARE @table varchar(max), @column varchar(max), @schema varchar(max)
Fetch NEXT FROM MY_Cursor INTO @table, @column, @schema
While (@@FETCH_STATUS <> -1)
BEGIN
    DECLARE @sql varchar(1000) = 'INSERT #temp SELECT ''' + @schema + '.' + @table + ''', ''' + @column + ''', sum(isnull(datalength([' + @column + ']), 0)) / 1024.0 FROM [' + @schema + '].[' + @table + '] (NOLOCK)'
    EXEC (@sql)

    FETCH NEXT FROM MY_CURSOR INTO @table, @column, @schema
END
CLOSE MY_CURSOR
DEALLOCATE MY_CURSOR
GO

SELECT *, sizeinkb / 1024.0 sizeinmb FROM #temp ORDER BY 3 DESC
Share
Follow
