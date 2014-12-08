set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go
-- =============================================
-- Author:   David.Yan
-- Create date: 2007.12.17
-- Description:

-- =============================================
Create PROC iPage
-- Add the parameters for the stored procedure here
@TableName VARCHAR(200),     --����
@FieldList VARCHAR(2000),    --��ʾ�����������ȫ���ֶ���Ϊ*
@PrimaryKey VARCHAR(100),    --��һ������Ψһֵ��
@Where VARCHAR(2000),        --��ѯ���� ����'where'�ַ�����id>10 and len(userid)>9
@Order VARCHAR(1000),        --���� ����'order by'�ַ�����id asc,userid desc������ָ��asc��desc
--ע�⵱@SortType=3ʱ��Ч����סһ��Ҫ�����������������������Ƚ�����
@SortType INT,               --������� 1:����asc 2:����desc 3:�������򷽷�
@RecorderCount INT,          --��¼���� 0:�᷵���ܼ�¼
@PageSize INT,               --ÿҳ����ļ�¼��
@PageIndex INT,              --��ǰҳ��
@TotalCount INT OUTPUT,      --�Ƿ����ܼ�¼
@TotalPageCount INT OUTPUT   --������ҳ��
AS
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON
IF ISNULL(@TotalCount,'') = '' SET @TotalCount = 0
SET @Order = RTRIM(LTRIM(@Order))
SET @PrimaryKey = RTRIM(LTRIM(@PrimaryKey))
SET @FieldList = REPLACE(RTRIM(LTRIM(@FieldList)),' ','')
WHILE CHARINDEX(', ',@Order) > 0 OR CHARINDEX(' ,',@Order) > 0
BEGIN
SET @Order = REPLACE(@Order,', ',',')
SET @Order = REPLACE(@Order,' ,',',')
END
IF ISNULL(@TableName,'') = '' OR ISNULL(@FieldList,'') = ''
OR ISNULL(@PrimaryKey,'') = ''
OR @SortType < 1 OR @SortType >3
OR @RecorderCount < 0 OR @PageSize < 0 OR @PageIndex < 0
BEGIN
   PRINT('ERR_00��������')
   RETURN
END
IF @SortType = 3
BEGIN
IF (UPPER(RIGHT(@Order,4))!=' ASC' AND UPPER(RIGHT(@Order,5))!=' DESC')
BEGIN
   PRINT('ERR_02�������') RETURN END
END
DECLARE @new_where1 VARCHAR(1000)
DECLARE @new_where2 VARCHAR(1000)
DECLARE @new_order1 VARCHAR(1000)
DECLARE @new_order2 VARCHAR(1000)
DECLARE @new_order3 VARCHAR(1000)
DECLARE @Sql VARCHAR(8000)
DECLARE @SqlCount NVARCHAR(4000)
IF ISNULL(@where,'') = ''
BEGIN
SET @new_where1 = ' '
SET @new_where2 = ' WHERE '
END
ELSE
BEGIN
SET @new_where1 = ' WHERE ' + @where
SET @new_where2 = ' WHERE ' + @where + ' AND '
END
IF ISNULL(@order,'') = '' OR @SortType = 1 OR @SortType = 2
BEGIN
IF @SortType = 1
   BEGIN
   SET @new_order1 = ' ORDER BY ' + @PrimaryKey + ' ASC'
   SET @new_order2 = ' ORDER BY ' + @PrimaryKey + ' DESC'
   END
IF @SortType = 2
   BEGIN
   SET @new_order1 = ' ORDER BY ' + @PrimaryKey + ' DESC'
   SET @new_order2 = ' ORDER BY ' + @PrimaryKey + ' ASC'
   END
END
ELSE
BEGIN
SET @new_order1 = ' ORDER BY ' + @Order
END
IF @SortType = 3 AND CHARINDEX(','+@PrimaryKey+' ',','+@Order)>0
BEGIN
SET @new_order1 = ' ORDER BY ' + @Order
SET @new_order2 = @Order + ','
SET @new_order2 = REPLACE(REPLACE(@new_order2,'ASC,','{ASC},'),'DESC,','{DESC},')
SET @new_order2 = REPLACE(REPLACE(@new_order2,'{ASC},','DESC,'),'{DESC},','ASC,')
SET @new_order2 = ' ORDER BY ' + SUBSTRING(@new_order2,1,LEN(@new_order2)-1)
IF @FieldList <> '*'
   BEGIN
   SET @new_order3 = REPLACE(REPLACE(@Order + ',','ASC,',','),'DESC,',',')
   SET @FieldList = ',' + @FieldList
   WHILE CHARINDEX(',',@new_order3)>0
    BEGIN
    IF CHARINDEX(SUBSTRING(','+@new_order3,1,CHARINDEX(',',@new_order3)),','+@FieldList+',')>0
     BEGIN
     SET @FieldList =
     @FieldList + ',' + SUBSTRING(@new_order3,1,CHARINDEX(',',@new_order3))
     END
    SET @new_order3 = SUBSTRING(@new_order3,CHARINDEX(',',@new_order3)+1,LEN(@new_order3))
    END
   SET @FieldList = SUBSTRING(@FieldList,2,LEN(@FieldList))
   END
END
SET @SqlCount = 'SELECT @TotalCount=COUNT(*),@TotalPageCount=CEILING((COUNT(*)+0.0)/'
+ CAST(@PageSize AS VARCHAR)+') FROM ' + @TableName + @new_where1
IF @RecorderCount = 0
BEGIN
EXEC SP_EXECUTESQL @SqlCount,N'@TotalCount INT OUTPUT,@TotalPageCount INT OUTPUT',
@TotalCount OUTPUT,@TotalPageCount OUTPUT
END
ELSE
BEGIN
SELECT @TotalCount = @RecorderCount
END
IF @PageIndex > CEILING((@TotalCount+0.0)/@PageSize)
BEGIN
SET @PageIndex = CEILING((@TotalCount+0.0)/@PageSize)
END
IF @PageIndex = 1 OR @PageIndex >= CEILING((@TotalCount+0.0)/@PageSize)
BEGIN
IF @PageIndex = 1 --���ص�һҳ����
   BEGIN
   SET @Sql = 'SELECT TOP ' + STR(@PageSize) + ' ' + @FieldList + ' FROM '
   + @TableName + @new_where1 + @new_order1
   END
IF @PageIndex >= CEILING((@TotalCount+0.0)/@PageSize) --�������һҳ����
   BEGIN
   SET @Sql = 'SELECT TOP ' + STR(@PageSize) + ' ' + @FieldList + ' FROM ('
   + 'SELECT TOP ' + STR(ABS(@PageSize*@PageIndex-@TotalCount-@PageSize))
   + ' ' + @FieldList + ' FROM '
   + @TableName + @new_where1 + @new_order2 + ' ) AS TMP '
   + @new_order1
   END
END
ELSE
BEGIN
IF @SortType = 1 --��������������
   BEGIN
   IF @PageIndex <= CEILING((@TotalCount+0.0)/@PageSize)/2 --�������
    BEGIN
    SET @Sql = 'SELECT TOP ' + STR(@PageSize) + ' ' + @FieldList + ' FROM '
    + @TableName + @new_where2 + @PrimaryKey + ' > '
    + '(SELECT MAX(' + @PrimaryKey + ') FROM (SELECT TOP '
    + STR(@PageSize*(@PageIndex-1)) + ' ' + @PrimaryKey
    + ' FROM ' + @TableName
    + @new_where1 + @new_order1 +' ) AS TMP) '+ @new_order1
    END
   ELSE --�������
    BEGIN
    SET @Sql = 'SELECT TOP ' + STR(@PageSize) + ' ' + @FieldList + ' FROM ('
    + 'SELECT TOP ' + STR(@PageSize) + ' '
    + @FieldList + ' FROM '
    + @TableName + @new_where2 + @PrimaryKey + ' < '
    + '(SELECT MIN(' + @PrimaryKey + ') FROM (SELECT TOP '
    + STR(@TotalCount-@PageSize*@PageIndex) + ' ' + @PrimaryKey
    + ' FROM ' + @TableName
    + @new_where1 + @new_order2 +' ) AS TMP) '+ @new_order2
    + ' ) AS TMP ' + @new_order1
    END
   END
IF @SortType = 2 --��������������
   BEGIN
   IF @PageIndex <= CEILING((@TotalCount+0.0)/@PageSize)/2 --�������
    BEGIN
    SET @Sql = 'SELECT TOP ' + STR(@PageSize) + ' ' + @FieldList + ' FROM '
    + @TableName + @new_where2 + @PrimaryKey + ' < '
    + '(SELECT MIN(' + @PrimaryKey + ') FROM (SELECT TOP '
    + STR(@PageSize*(@PageIndex-1)) + ' ' + @PrimaryKey
    +' FROM '+ @TableName
    + @new_where1 + @new_order1 + ') AS TMP) '+ @new_order1
    END
   ELSE --�������
    BEGIN
    SET @Sql = 'SELECT TOP ' + STR(@PageSize) + ' ' + @FieldList + ' FROM ('
    + 'SELECT TOP ' + STR(@PageSize) + ' '
    + @FieldList + ' FROM '
    + @TableName + @new_where2 + @PrimaryKey + ' > '
    + '(SELECT MAX(' + @PrimaryKey + ') FROM (SELECT TOP '
    + STR(@TotalCount-@PageSize*@PageIndex) + ' ' + @PrimaryKey
    + ' FROM ' + @TableName
    + @new_where1 + @new_order2 +' ) AS TMP) '+ @new_order2
    + ' ) AS TMP ' + @new_order1
    END
   END
IF @SortType = 3 --�������򣬱�������������ҷ�����󣬷��򲻴���
   BEGIN
   IF CHARINDEX(',' + @PrimaryKey + ' ',',' + @Order) = 0
    BEGIN
    PRINT('ERR_02') RETURN
    END
   IF @PageIndex <= CEILING((@TotalCount+0.0)/@PageSize)/2 --�������
    BEGIN
    SET @Sql = 'SELECT TOP ' + STR(@PageSize) + ' ' + @FieldList + ' FROM ( '
    + 'SELECT TOP ' + STR(@PageSize) + ' ' + @FieldList + ' FROM ( '
    + ' SELECT TOP ' + STR(@PageSize*@PageIndex) + ' ' + @FieldList
    + ' FROM ' + @TableName + @new_where1 + @new_order1 + ' ) AS TMP '
    + @new_order2 + ' ) AS TMP ' + @new_order1
    END
   ELSE --�������
    BEGIN
    SET @Sql = 'SELECT TOP ' + STR(@PageSize) + ' ' + @FieldList + ' FROM ( '
    + 'SELECT TOP ' + STR(@PageSize) + ' ' + @FieldList + ' FROM ( '
    + ' SELECT TOP ' + STR(@TotalCount-@PageSize *@PageIndex+@PageSize) + ' ' + @FieldList
    + ' FROM ' + @TableName + @new_where1 + @new_order2 + ' ) AS TMP '
    + @new_order1 + ' ) AS TMP ' + @new_order1
    END
   END
END
EXEC(@Sql)
GO