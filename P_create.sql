
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

select dbo.TACHTEN(N'TRẦN đức bo') as táchten
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

-- Tạo thủ tục của học sinh có điểm trung bình cao nhất với tham số truyền vào là môn học
create proc DiemTBcaonhat @tenmon nvarchar(10) , @diem float output, @ten nvarchar(30) output
as 
begin
    select @diem = max(summary) from study,subjects
    where study.SubjectID=subjects.subjectid
    and subjects.subjectname = @tenmon
    select @ten = (select proname from profiles,study
    where profiles.userid = study.userid
    and study.Summary=@diem)
end

declare @DTB float
declare @hoten nvarchar(30)
exec DiemTBcaonhat N'anh 10' , @dtb out , @hoten out
print N'Học sinh ' + cast(@hoten as nvarchar(30)) + N' có DTB cao nhất môn là: ' + cast(@dtb as char(4))

select*from subjects

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
--1: Viết trigger insert bảng teach, 
--nếu người dùng có mã userrole là giáo viên thì thông báo insert thành công
--còn không thì thông báo lỗi.
create or alter trigger InsertTeach
on teach 
for insert 
as
begin
    declare @userrole nvarchar(10)
    select @userrole = users.userrole from users,inserted
    where users.userid = inserted.userid
    if(@userrole like N'Giáo viên')
	begin
        print N'thêm giáo viên thành công'
	end
    else
	begin
        print N'Người dùng không phải giáo viên'
        rollback transaction
	end
end
select* from users
select* from profiles
insert into teach values ('0002', 'van11', '2021A2')
, ('1002', 'van11', '2021A2')
delete from teach
select* from teach
--2: Viết trigger insert bảng teach, 
--nếu người dùng có mã userrole là giáo viên thì thông báo insert thành công
--còn không thì thông báo lỗi.
create or alter trigger InsertStudy
on study
for insert 
as
begin
	if(not exists(select * from users where UserID in (select UserID from inserted) and UserRole = N'Học sinh'))
	begin
		print N'Người dùng không phải là học sinh';
		rollback transaction
	end
  else
	begin
		print N'Thêm học sinh thành công';
	end
end		

select * from study
insert into study values ( '1007','anh10', '7', '2', '5', '8.3'),
( '1005','anh10', '7', '2', '5', '4.3'),( '1006','anh10', '7', '2', '5', '9.3')
delete from study
