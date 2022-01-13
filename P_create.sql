
--1: Viết hàm tách tên từ chuỗi Họ tên người dùng --
CREATE  FUNCTION  TACHTEN(@ProName nvarchar(60))
RETURNS  nvarchar(30) 
AS 
BEGIN 
DECLARE  @ten varchar(10), @L int, @i int,@j int,@kt varchar(10) 
SET @L=LEN(@ProName) 
SET @i=1 
WHILE  @i<=@L 
BEGIN 
SET @kt=SUBSTRING(@ProName,@i,1) 
IF @kt=''  SET  @j=@i 
SET @i=@i+1 
END 
SET @ten=SUBSTRING(@ProName,@j+1,10) 
RETURN  @ten 
END 

select dbo.TACHTEN(N'Đặng Quang Vinh')
drop function tachten
/*2:Viết hàm đọc tên Khối ra thành chữ tương ứng */
CREATE FUNCTION DOCKHOINGUYEN(@ClassGrade int)  
RETURNS nvarchar(20) 
AS 
BEGIN 
DECLARE @khoichu nvarchar(20) 
SET @khoichu=CASE  
WHEN @ClassGrade=10 THEN N'Khối mười'  
WHEN @ClassGrade=11 THEN N'Khối mười một'
WHEN @ClassGrade=12 THEN N'Khối mười hai' 
END 
RETURN  @khoichu
end


DROP FUNCTION DOCKHOINGUYEN
--Tạo thủ tục bổ sung dữ liệu cho bảng users--

select*from Users

CREATE PROCEDURE  INSERT_users
@UserID varchar(4), @UserName Nvarchar(60),  @UserPassword varchar(255), @UserEmail varchar(100), @UserStatus int, 
@UserCode varchar(8), @UserRole Nvarchar(20), @ClassID varchar(10) 
AS 
BEGIN 
IF EXISTS(SELECT * FROM users WHERE UserID = @UserID ) 
BEGIN 
PRINT N'users này đã có, nhập mã khác' 
RETURN  -1 
END 
IF NOT EXISTS (SELECT * FROM users
                WHERE ClassID=@ClassID) 
BEGIN 
PRINT N'Mã lớp này không tồn tại' 
RETURN  -1 
END 


INSERT INTO  users 
VALUES (@UserID, @UserName, @UserPassword, @UserEmail, @UserStatus, @UserCode, @UserRole, @ClassID) 
END 

 exec INSERT_users '1000', N'bacaiten', N'TRẦN THỊ PHÚC', 'Tranphucnm@gmail.com', 1, NULL, N' học sinh', '2020A2'

 select * from users where UserID= '1000'
 --viết thủ tục xóa giáo viên, khi thực hiện xóa giáo viên thì bảng điểm của học sinh vẫn còn--
CREATE PROCEDURE DELETE_USERID
@USERID varchar(11) 
as 
BEGIN 
IF NOT EXISTS (SELECT * FROM USERS  
               WHERE USERID=@USERID) 
BEGIN 
PRINT N'Không tìm thấy giáo viên' 
RETURN  -1 
END 
DELETE FROM USERS WHERE USERID=@USERID
PRINT N'Xoá thành công' 
END 

EXEC DELETE_USERID '0001'
select * from users where UserID ='0001'
--view--
--tạo view user_messenger--
create view v_users_messeger(UserID, UserName, UserPassword, UserEmail, 
UserStatus, UserCode, UserRole, ClassID, MessID, FromID, ToID, MessContent, MessTime)
AS 
select * from users, messenger where users.UserID = messenger.FromID ;

SELECT * FROM v_users_messeger


--tạo view v_user_teach_subject--
create view v_user_teach_subject(UserID, UserName, UserPassword, UserEmail, 
UserStatus, UserCode, UserRole, ClassID, UserIDD, SubjectID, ClassIDD, SubjectIDD, SubjectName, SubjectType)
AS
SELECT * FROM users, teach, subjects where users.UserID = Teach.UserID and Teach.SubjectID = Subjects.SubjectID;



--TRIGGER--
--1:Viết trigger để tự động cập nhật lại Mã lớp của tất cả học sinh của 1 lớp  
--khi Update lại mã lớp của bản ghi tương ứng với lớp đó ở bảng Lop.
 CREATE TRIGGER capnhatmalop
 ON class
 FOR UPDATE 
 AS
 IF UPDATE (ClassID)
 
 BEGIN
	DECLARE @ClassID varchar(10)
	DECLARE @ClassGrade int
	DECLARE contro CURSOR FOR
	SELECT inserted.ClassID
	FROM INSERTED INNER JOIN DELETED
	ON INSERTED.ClassID=DELETED.ClassID
	OPEN contro
	FETCH NEXT FROM contro INTO @ClassID,@ClassGrade
	WHILE @@FETCH_STATUS=0
	BEGIN 
	UPDATE class.ClassID SET ClassID=@ClassID
	WHERE Class.ClassID=@ClassID
	FETCH NEXT FROM contro INTO @ClassID,@ClassGrade

	END
	CLOSE contro
	DEALLOCATE contro
 END


--Tạo Trigger để  kiểm tra tính hợp lệ của dữ liệu được nhập vào một bảng user là dữ liệu usersID là không rỗng.  --

CREATE TRIGGER  INSERTUSERS 
ON users
	FOR INSERT  
AS 
	IF ((SELECT UserID FROM INSERTED) = '') 
BEGIN 
	PRINT N'Mã người dùng phải được nhập' 
	ROLLBACK TRANSACTION 
END
-- Tạo trigger không cho phép xóa học sinh ở lớp 12a1--
CREATE TRIGGER DELETEHS
ON users 
FOR DELETE 
AS 
	IF EXISTS(SELECT * FROM users, class where users.ClassID = class.ClassID  AND ClassName= '12A1') 
BEGIN 
	PRINT  N'Bạn không thể xoá học sinh lớp 12a1' 
	ROLLBACK TRANSACTION 
END 


DELETE FROM class where ClassName= '12A1'
SELECT* FROM class