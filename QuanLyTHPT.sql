-- Tạo cơ sở dũ liệu, file dữ liệu + file nhật ký
create database thpt_vap
on primary (
Name=THPT_data,
Filename= 'D:\Hệ quản trị CSDL\btl\THPT_data.mdf',
size=10MB,
maxsize=50MB,
filegrowth =2MB)

log on (
Name=THPT_log,
Filename= 'D:\Hệ quản trị CSDL\btl\THPT_log.ldf',
size=5MB,
maxsize=20MB,
filegrowth =1MB);

use thpt_vap

--Tạo bảng class
CREATE TABLE class (
  ClassID varchar(10) NOT NULL,
  ClassName Nvarchar(10) NOT NULL,
  ClassGrade int NOT NULL,
  PRIMARY KEY (ClassID),
  UNIQUE  (ClassName)
)

--Tạo bảng users
CREATE TABLE users (
  UserID varchar(4) NOT NULL,
  UserName Nvarchar(60) NOT NULL,
  UserPassword varchar(255) NOT NULL,
  UserEmail varchar(100) DEFAULT NULL,
  UserStatus int NOT NULL DEFAULT 0,
  UserCode varchar(8) DEFAULT 00000000,
  UserRole Nvarchar(20) NOT NULL,
  ClassID varchar(10) DEFAULT NULL,
  PRIMARY KEY (UserID),
  UNIQUE (UserName),
  UNIQUE (UserEmail),
  FOREIGN KEY (ClassID) REFERENCES class (ClassID)
)

--Tạo bảng profiles
create table profiles(
	UserID varchar(4) NOT NULL,
	ProName Nvarchar(60) NOT NULL,
	ProPhone varchar(20),
	ProAddress Nvarchar(150),
	ProGender Nvarchar(20),
	ProBirth Date,
	ProAva varchar(60) DEFAULT 'ava.png',
	evaluate nvarchar(50) DEFAULT N'Chưa có đánh giá',
	primary key (UserID),
	foreign key (UserID) references users(UserID),
)

--Tạo bảng subjects
create table subjects(
	SubjectID varchar(10) NOT NULL,
	SubjectName Nvarchar(60) NOT NULL, 
	SubjectType Nvarchar(60),
	primary key (SubjectID),
)

--Tạo bảng teach
create table teach(
	UserID varchar(4) Not Null,
	SubjectID varchar(10) Not Null,
	ClassID varchar(10) Not Null,
	primary key (UserID, SubjectID, ClassID),
	foreign key (UserID) references users(UserID),
	foreign key (SubjectID) references subjects(SubjectID),
	foreign key (ClassID) references class(ClassID)
)

--Tạo bảng study
create table study(
	UserID varchar(4) Not Null,
	SubjectID varchar(10) Not Null,
	Coef_one float,
	Coef_two float,
	Coef_three float,
	Summary float,
	primary key (UserID, SubjectID),
	foreign key (UserID) references users(UserID),
	foreign key (SubjectID) references subjects(SubjectID),
)

--Tạo bảng messenger
CREATE TABLE messenger (
  MessID int NOT NULL IDENTITY(1,1),
  FromID varchar(4) NOT NULL,
  ToID varchar(4) NOT NULL,
  MessContent Nvarchar(255) NOT NULL,
  MessTime datetime NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (MessID,FromID,ToID),
  FOREIGN KEY (ToID) REFERENCES users(UserID),
  FOREIGN KEY (FromID) REFERENCES users(UserID)
)

--view

--1.View học sinh của lớp
create view v_studentsOfClass(CLassID, ClassName, UserID, Name, Birth, Gender, Address, Avatar)
as select c.CLassID, c.ClassName, u.UserID, p.ProName, p.ProBirth, p.ProGender, p.ProAddress, p.ProAva
from class as c, users as u, profiles as p 
where c.ClassID = u.ClassID and u.UserID = p.UserID

select * from v_studentsOfClass

select * from users
select * from class
select * from profiles

--2.Tạo view v_scoresOfStudent để hiển thị thông tin của học sinh và môn học gồm UserID, UserName, ClassName, SubjectName, SubjectType,
-- cofe_one, Coef_two, Cofe_three, Summary, Conduct
create view v_scoresOfStudent(UserID, UserName, ClassID, ClassName, SubjectID, SubjectName, SubjectType, Coef_one, Coef_two, Coef_three, Summary)
as
	select u.UserID, u.UserName, c.ClassID, ClassName, sb.SubjectID, sb.SubjectName, sb.SubjectType, st.Coef_one, st.Coef_two, 
			st.Coef_three, st.Summary
	from users as u, class as c, subjects as sb, study as st
	where u.ClassID=c.ClassID and st.UserID=u.UserID and st.SubjectID=sb.SubjectID


select * from v_scoresOfStudent

--3. View users x profiles
create view v_users_profiles(UserID, UserName, UserPassword, UserEmail, 
UserStatus, UserCode, UserRole, ClassID, UserID_, ProName, ProPhone, ProAddress, ProGender, ProBirth, ProAva, Evaluate)
as select * from users, profiles where users.UserID = profiles.UserID

select * from v_users_profiles


-- 4. View lấy ra môn học của một lớp
create view v_subjectsOfClass as
select ClassID, subjects.SubjectID, SubjectName, SubjectType from subjects, teach
where teach.SubjectID = subjects.subjectID


--5. View học sinh giáo viên
create view v_studentsOfTeachers(teacherID, studentID, SubjectID, summary) as
select distinct teach.UserID as teacherID, users.UserID as studentID, study.SubjectID, study.Summary 
from teach, users, study where teach.ClassID = users.ClassID and users.UserID = study.UserID;
<<<<<<< HEAD
--6:tạo view user_messenger--
create view v_users_messeger(UserID, UserName, UserPassword, UserEmail, 
UserStatus, UserCode, UserRole, ClassID, MessID, FromID, ToID, MessContent, MessTime)
AS 
select * from users, messenger where users.UserID = messenger.FromID ;

SELECT * FROM v_users_messeger


--7:tạo view v_user_teach_subject--
create view v_user_teach_subject(UserID, UserName, UserPassword, UserEmail, 
UserStatus, UserCode, UserRole, ClassID, UserIDD, SubjectID, ClassIDD, SubjectIDD, SubjectName, SubjectType)
AS
SELECT * FROM users, teach, subjects where users.UserID = Teach.UserID and Teach.SubjectID = Subjects.SubjectID;
=======
>>>>>>> bc251909e72b9679bc64a47131ee81bf5e3bf79c


--FUNCTION
--1.Viết một hàm f_DiemTrungBinh trả về một bảng chi tiết họ tên, lớp, số điểm trung bình của 1 học sinh 
	--với DiemTrungBinh = ((Coef_one * 1 + Coef_two * 2 + Coef_three * 3)/6)
	--với UserID là tham số truyền vào
create function f_DiemTrungBinh (@UserID varchar(4), @SubjectID varchar(10))
returns float
as
	begin
		declare @DiemTrungBinh float
		select @DiemTrungBinh = ((Coef_one * 1 + Coef_two * 2 + Coef_three * 3)/6)
		from study where UserID=@UserID and SubjectID = @SubjectID
		return @DiemTrungBinh
	end

select dbo.f_DiemTrungBinh('1001', 'toan10') as DiemTrungBinh


--2.Viết một hàm f_DiemTrungBinh trả về một bảng chi tiết họ tên, lớp, điểm số 1, điểm số 2, điểm số 3 và số điểm trung bình của 1 học sinh 
	--với UserID là tham số truyền vào
create function f_Diem(@UserID nvarchar(4))
returns @Diem table(HoVaTen nvarchar(60), Mon nvarchar(20), Lop nvarchar(10), Coef_one float, Coef_tow float, Coef_three float, DiemTrungBinh float)
as
	begin
		insert into @Diem
		select UserName, SubjectID, ClassName, Coef_one, 
		Coef_two, Coef_three, dbo.f_DiemTrungBinh(UserID, SubjectID)
		from v_scoresOfStudent where UserID=@UserID;
		return
	end

select * from dbo.f_Diem('1001')

--3. Hàm đếm sĩ số của lớp tham số truyền vào là 1 ID lớp
create function f_SiSoHocSinh(@ClassID varchar(10))
returns int
as
begin
	declare @SiSo int;
	select @SiSo = count(*) from users where ClassID = @ClassID;
	return @SiSo
end
	
select dbo.f_SiSoHocSinh('2020A1') as SiSoHocSinh

select * from dbo.f_SiSoHocSinh()
drop function f_SiSoHocSinh


--4. Hàm tính điểm tổng kết đầu vào 1 UserID
create function get_avgAllScore(@UserID varchar(4))
returns float as
	begin
		declare @x float;
		select @x = (sum(Summary)/count(*)) from study where UserID = @UserID;
		return @x;
	end

select dbo.get_avgAllScore('1001')

--5. Hàm Đánh giá
create function f_evaluate(@UserID varchar(4))
returns nvarchar(50) as
	begin
		declare @eva nvarchar(50), @UserRole nvarchar(20);
		select @UserRole = UserRole from users where UserID = @UserID;
		declare @score float;
		if (@UserRole = N'Học sinh')
			begin
				set @score = dbo.get_avgAllScore(@UserID);
				select @eva = (case
					when (@score > 9.5 and not EXISTS(select * from study where UserID = @UserID and Summary < 9)) Then N'Học sinh xuất sắc'
					when (@score > 8.0 and not EXISTS(select * from study where UserID = @UserID and Summary < 7)) Then N'Học sinh giỏi'
					when (@score > 6.5 and not EXISTS(select * from study where UserID = @UserID and Summary < 5)) Then N'Học sinh tiên tiến'
					when (@score > 3.5 and not EXISTS(select * from study where UserID = @UserID and Summary < 0)) Then N'Học sinh trung bình'
					when (@score > 0) Then N'Học sinh yếu'
					else N'không đủ điều kiện đánh giá'
				end);
			end
		else if (@UserRole = N'Giáo viên')
			begin
				select @score =
					(select count(*) from v_studentsOfTeachers 
					where teacherID = @UserID and summary is not null and summary > 6.5) / count(*)
				from v_studentsOfTeachers where teacherID = @UserID;

				if(@score > 0.75 and 
				not EXISTS(select * from v_studentsOfTeachers 
				where teacherID = @UserID and summary < 3.5))
					begin
						set @eva = N'Giáo viên giỏi';
					end
				else set @eva = N'Giáo viên tiên tiến'
			end
		return @eva;
	end

select dbo.f_evaluate('0001')

<<<<<<< HEAD
--6: Viết hàm tách tên từ chuỗi Họ tên người dùng --
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

select dbo.TACHTEN(N'TRAN DUC') as TACHTEN
drop function tachten
/*7:Viết hàm đọc tên Khối ra thành chữ tương ứng */
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
=======

>>>>>>> bc251909e72b9679bc64a47131ee81bf5e3bf79c
--PROCEDURE

--1. Thủ tục lấy ra sĩ số của các lớp có sĩ số < x(với x là đầu vào) dưới dạng con trỏ
Create procedure sp_SiSoNhieu
@SiSo int, @dsss cursor varying output
as begin
set @dsss=cursor for
	select ClassID, ClassName, ClassGrade, SiSo = dbo.f_SiSoHocSinh(ClassID) from Class where dbo.f_SiSoHocSinh(ClassID) <= @SiSo
open @dsss
end

declare @contro_sp cursor;
exec sp_SiSoNhieu 6, @contro_sp out;
Fetch Next from @contro_sp
while(@@FETCH_STATUS = 0)
begin
	Fetch Next from @contro_sp
end
close @contro_sp
deallocate @contro_sp


--2.Viết 1 thủ tục số lượng tin nhắn đã đc gửi đi & nhận về từ ngày nào đó -> ngày
Create proc sp_SoLuongTinNhan
 @UserID nvarchar(4), @NgayDau date, @NgayCuoi date, @TongTinNhan int out
 as 
	begin
		Select @TongTinNhan = Count(*) from messenger 
		where FromID = @UserID and MessTime>=@ngaydau and MessTime<=@ngaycuoi
	end
 
 declare @tn1 int;
 exec sp_SoLuongTinNhan '1007', '2021-12-12', '2022-1-14', @tn1 out
 print N'Số lượng tin nhắn là: ' +  cast(@tn1 as Nvarchar )

 drop proc sp_SoLuongTinNhan

 --3. Thủ tục cập nhật đánh giá cho Học sinh theo lớp
create proc sp_updateEvaluate_class @ClassID varchar(10) as
	begin
		update profiles set evaluate = dbo.f_evaluate(profiles.UserID) from users
		where (users.ClassID = @ClassID) and profiles.UserID = users.UserID
	end

exec sp_updateEvaluate_class '2021A1'

--4. Thủ tục cập nhật đánh giá người dùng
create proc sp_updateEvaluate_user @UserID varchar(4) as
	begin
		update profiles set evaluate = dbo.f_evaluate(profiles.UserID)
		where (profiles.UserID = @UserID)
	end

exec sp_updateEvaluate_user '0001'

--5. Thủ tục lấy ra tin nhắn với đầu vào là một chuỗi
create proc sp_searchMatchMess @search Nvarchar(50), @count int output, @matchedList cursor varying output
as	begin
		set @matchedList = cursor for
		select * from messenger where MessContent like '%'+@search+'%';
		select @count = count(*) from messenger where MessContent like '%'+@search+'%';
		open @matchedList;
	end

declare @count int, @matchedList cursor;
exec sp_searchMatchMess N'a', @count out, @matchedList out;
print @count;
fetch next from @matchedList
while (@@FETCH_STATUS = 0)
	begin
		fetch next from @matchedList
	end
close @matchedList;
deallocate @matchedList;
<<<<<<< HEAD
--6:Tạo thủ tục bổ sung dữ liệu cho bảng users--

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

--7: Tạo thủ tục của học sinh có điểm trung bình cao nhất với tham số truyền vào là môn học
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
=======

>>>>>>> bc251909e72b9679bc64a47131ee81bf5e3bf79c

--TRIGGER
 
--1. Tạo trigger Xóa user -> xóa profile, xóa message
-- Học sinh -> xóa điểm
-- Giáo viên -> xóa teach
create trigger del_user
on v_users_profiles
instead of delete as
	begin
	
		declare @UserID varchar(4), @Role Nvarchar(20);
		select @UserID = UserID, @Role = UserRole from deleted;

		delete from profiles where UserID in (select UserID from deleted);
		delete from messenger where FromID in (select UserID from deleted) or ToID in (select UserID from deleted);
		if @Role = N'Học sinh'
			begin
				delete from study where UserID in (select UserID from deleted);
			end
		else if @Role = N'Giáo viên'
			begin
				delete from teach where UserID in (select UserID from deleted);
			end
		delete from users where UserID in (select UserID from deleted);
		print 'Xóa thành công';
	end
	

delete from v_users_profiles where UserName = 'haicaiten'


--2. Trigger Sua diem của học sinh thì sẽ cập nhật trường tong diem
create trigger update_scores
on study
after update as
	begin
	if (update(Coef_one) or update(Coef_two) or update(Coef_three) or update(summary))
		update study set summary = dbo.f_DiemTrungBinh(inserted.UserID, inserted.SubjectID) 
		from inserted where study.UserID = inserted.UserID and study.SubjectID = inserted.SubjectID;

	end

update study set coef_one = 10 where UserID = '1002' and SubjectID = 'van12'

select * from study where UserID ='1001'


--3. Thêm account mới -> thêm 1 profile mới
-- Thêm Account học sinh mới -> thêm tất cả bảng điểm
create trigger add_user
on v_users_profiles
instead of insert as
	begin
		declare @UserID varchar(4), @ClassID varchar(10), @UserRole Nvarchar(20);
		select @UserID = UserID, @ClassID = ClassID, @UserRole = UserRole from inserted;

		insert into users(UserID, UserName, UserPassword, UserEmail, UserCode, UserRole, ClassID)
		select UserID, UserName, UserPassword, UserEmail, UserCode, UserRole, ClassID from inserted;
		insert into profiles (UserID, ProName, ProPhone, ProAddress, ProGender, ProBirth, ProAva)
		select UserID, ProName, ProPhone, ProAddress, ProGender, ProBirth, ProAva from inserted;
		
		if(@UserRole = N'Học sinh')
			begin
				insert into study(UserID, SubjectID) select UserID, SubjectID 
				from v_subjectsOfClass as sc, inserted where inserted.ClassID = sc.ClassID;
			end
	end

insert into v_users_profiles(UserID, UserName, UserPassword, UserEmail, UserCode, UserRole, ClassID, ProName) 
values ('1001', N'haicaiten', 'abc', 'haicaimail@gmail.com', '00000000', N'Học sinh', '2021A1', N'Hai Cái Tên')

insert into v_users_profiles(UserID, UserName, UserPassword, UserEmail, UserCode, UserRole, ProName) 
values ('0001', N'motcaiten', 'abc', 'motcaimail@gmail.com', '00000000', N'Giáo viên',  N'Một Cái Tên')

--4. Tay đổi tên tài khoản -> không thể thay đổi
create trigger update_users
on users
for update as
	begin
		if update(UserName)
			begin
				print N'Không thể thay đổi tên tài khoản';
				rollback transaction
			end
	end

update users set UserName = 'iamveoveo' where UserID = '0001';
<<<<<<< HEAD
--5: Viết trigger insert bảng teach, 
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
--6: Viết trigger insert bảng teach, 
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
=======
>>>>>>> bc251909e72b9679bc64a47131ee81bf5e3bf79c


--BẢO MẬT, PHÂN QUYỀN
exec sp_addlogin 'connect_sa','123456'

drop login connect_sa

use thpt_vap

exec sp_grantdbaccess 'connect_sa','SA'

exec sp_addrolemember 'db_owner','SA'

INSERT INTO class (ClassID, ClassName, ClassGrade) VALUES
('2021A1', N'10A1', 10),
('2020A1', N'11A1', 11),
('2019A1', N'12A1', 12),
('2019A2', N'12A2', 12),
('2019A3', N'12A3', 12),
('2021A2', N'10A2', 10),
('2021A3', N'10A3', 10),
('2020A3', N'11A3', 11),
('2020A2', N'11A2', 11);

insert into subjects (SubjectID, SubjectName, SubjectType) values
('van10', N'Văn 10', N'Khoa học xã hội'),
('toan10', N'Toán 10', N'Khoa học tự nhiên'),
('anh10', N'Anh 10', N'Khoa ngoại ngữ'),
('phap10', N'Pháp 10', N'Khoa ngoại ngữ'),
('van11', N'Văn 11', N'Khoa học xã hội'),
('toan11', N'Toán 11', N'Khoa học tự nhiên'),
('anh11', N'Anh 11', N'Khoa ngoại ngữ'),
('phap11', N'Pháp 11', N'Khoa ngoại ngữ'),
('van12', N'Văn 12', N'Khoa học xã hội'),
('toan12', N'Toán 12', N'Khoa học tự nhiên'),
('anh12', N'Anh 12', N'Khoa ngoại ngữ'),
('phap12', N'Pháp 12', N'Khoa ngoại ngữ');

insert into v_users_profiles(UserID, UserName, UserPassword, UserEmail, 
UserRole, ProName, ProPhone, ProAddress, ProGender, ProBirth) values
('0001', 'motcaiten', '$2y$10$5Z6VpblYSLXR6qAoLr9K4edSYpDYUPtAJ9CWjNkai7ne0Xz2uMigW', '0001@e.vap.edu.vn', N'Giáo viên', N'Một Cái Tên', '987568976', N'Hà Nội', N'Nữ', '1996-10-17'),
('0002', 'vungocnguyen301', '$2y$10$5Z6VpblYSLXR6qAoLr9K4edSYpDYUPtAJ9CWjNkai7ne0Xz2uMigW', '0002@e.vap.edu.vn', N'Giáo viên', N'Vũ Ngọc Nguyên', '987568976', N'Hà Nội', N'Nam', '1996-10-17'),
('0003', 'nguyenhanhphuc302', '$2y$10$wYgO5zxpFLE70lkjfWoOLudc1PFUVL2fw31fk4sY7spwDwcBzb75.', '0003@e.vap.edu.vn', N'Giáo viên', N'Nguyễn Hạnh Phúc', '543211232', N'Hà Nội', N'Nam', '1976-01-05'),
('0004', 'vuvanngoc304', '$2y$10$wjp4G9cq0Aot2Dyw.k0F7ONFhk7VOTSa6VSAEZEqwzx6ILzh3Fg.C', '0004@e.vap.edu.vn', N'Giáo viên', N'Vũ Văn Ngọc', '987567654', N'Hà Nội', N'Nam', '1986-12-14'),
('0005', 'lemylinh305', '$2y$10$TjPut1bWSIuUyJUSCVFW1O6WVkWs3B5XZCnHcFSBA/w3uLWX.E6aW', '0005@e.vap.edu.vn', N'Giáo viên', N'Lê Mỹ Linh', '376856788', N'Hà Nội', N'Nữ', '1970-05-19'),
('0006', 'nguyenthaotrang306', '$2y$10$tbteHkL2V4BsHH0FLdG6ReFTALBZc0tmQzGpzflmAqwhfz1b0N8xi', '0006@e.vap.edu.vn', N'Giáo viên', N'Nguyễn Thảo Trang', '945678754', N'Hà Nội', N'Nữ', '1980-06-01'),
('0007', 'laihainam307', '$2y$10$BUvjjKwGfQvWA/7H/RRvBeGODk.Q0mHlOa/Ufr675CuCKW1OS5sxO', '0007@e.vap.edu.vn', N'Giáo viên', N'Lại Hải Nam', '988767654', N'Vĩnh Phúc', N'Nam', '1989-3-22'),
('0008', 'vulinhtruc308', '$2y$10$y7gpIhnc84xlmM2US2Ga3.JquLpQ6mapEzQtaI0Yeypi/bkpmgN3u', '0008@e.vap.edu.vn', N'Giáo viên', N'Vũ Linh Trúc', '987876564', N'Hà Nội', N'Nữ', '1982-10-15'),
('0009', 'nguyenbahanh309', '$2y$10$YkqzOS47AolZJek2JwSWSunK.mHl.8wQY1o.Yxjd2zgunLBCnqVyi', '0009@e.vap.edu.vn', N'Giáo viên', N'Nguyễn Bá Hạnh', '934565433', N'Hà Nội', N'Nam', '1979-02-28');

insert into teach values 
('0001', 'van10', '2021A1'),
('0001', 'van11', '2020A1'),
('0001', 'van12', '2019A1'),
('0001', 'van12', '2019A2'),
('0002', 'toan10', '2021A1'),
('0002', 'toan10', '2021A2'),
('0002', 'toan11', '2020A1'),
('0002', 'toan12', '2019A3'),
('0003', 'anh10', '2021A1'),
('0003', 'anh11', '2020A1'),
('0003', 'anh11', '2020A2'),
('0003', 'anh12', '2019A1'),
('0004', 'phap10', '2021A1'),
('0004', 'phap11', '2020A1'),
('0004', 'phap12', '2019A1'),
('0004', 'phap12', '2019A3'),
('0005', 'van10', '2021A2'),
('0005', 'van10', '2021A3'),
('0005', 'van11', '2020A2'),
('0005', 'van12', '2019A3'),
('0006', 'toan10', '2021A3'),
('0006', 'toan11', '2020A2'),
('0006', 'toan11', '2020A3'),
('0006', 'toan12', '2019A1'),
('0007', 'anh10', '2021A2'),
('0007', 'anh11', '2020A3'),
('0007', 'anh12', '2019A2'),
('0007', 'anh12', '2019A3'),
('0008', 'phap10', '2021A3'),
('0008', 'phap10', '2021A2'),
('0008', 'phap11', '2020A2'),
('0008', 'phap12', '2019A2'),
('0009', 'van11', '2020A3'),
('0009', 'toan12', '2019A2'),
('0009', 'anh10', '2021A3'),
('0009', 'phap11', '2020A3');

insert into v_users_profiles(UserID, UserName, ProName, UserPassword, UserEmail, 
ProPhone, ProAddress, ProGender, ProBirth, UserRole, ClassID) values
('1001', 'haicaiten', N'Hai Cái Tên', '$2y$10$XTlO2yj.YPUFVxt.H.ZAyORpJAPFYK.Pz5zHLMvFz8ytNcd3aybd6', '1001@e.vap.edu.vn', '00000000', N'Hà Nội', N'Nam', '2006-03-05', N'Học sinh', '2021A1'),
('1003', 'phanhongminh109', N'Phan Hồng Minh', '$2y$10$XTlO2yj.YPUFVxt.H.ZAyORpJAPFYK.Pz5zHLMvFz8ytNcd3aybd6', '1003@e.vap.edu.vn', '976653434', N'Hà Nội', N'Nam', '2006-03-05', N'Học sinh', '2021A1'),
('1004', 'dangbaophuc112', N'Đặng Bảo Phúc', '$2y$10$Tmo3vJu6oK9A6KE7Vwj3xOiOIk3h99RDq3pEofGJspaVmrpVsaWXq', '1004@e.vap.edu.vn', '345432322', N'Hà Nội', N'Nam', '2006-03-30', N'Học sinh', '2021A1'),
('1005', 'nguyenngochoanganh115', N'Nguyễn Ngọc Hoàng Anh', '$2y$10$KesW6PB08Aoxgea7V2OGpexw.bM7gb1XxSb1hMvc48eato3E4mvbS', '1005@e.vap.edu.vn', '7865432343', N'Hà Nội', N'Nam', '2006-03-05', N'Học sinh', '2021A1'),
('1006', 'dominhbaochau118', N'Đỗ Minh Bảo Châu', '$2y$10$WRtustJXq1flFGOtUghRfez/zp1NXlCZR7thwqmRGMzbzrJ0/kEvW', '1006@e.vap.edu.vn', '809876543', N'Hà Nội', N'Nam', '2006-09-05', N'Học sinh', N'2021A2'),
('1007', 'nguyenthihuonggiang127', N'Nguyễn Thị Hương Giang', '$2y$10$8GlNTaUoESbhJh0x5jqmD.Q65GKXDVvmWHGFNSIoWVe1/pEZfLhze', '1007@e.vap.edu.vn', '987654321', N'Hà Nội', N'Nữ', '2006-10-15', N'Học sinh', '2021A2'),
('1008', 'chuquocanh128', N'Chu Quốc Anh', '$2y$10$v5Fuablcy9L9gGIaaM6pau3LXApvXlz9U0xHL7SjycMLNisrdJXrS', '1008@e.vap.edu.vn', '765432137', N'Hà Nội', N'Nam', '2005-02-15', N'Học sinh', '2020A1'),
('1009', 'phanvannam129', N'Phan Văn Nam', '$2y$10$Zo6TAgeaYwz5HL5Jowz4Z.s66ZXTFNIZ7r.SDq6QTOiQfsi9tIw.W', '1009@e.vap.edu.vn', '765432135', N'Hà Nội', N'Nam', '2005-05-15', N'Học sinh', '2020A1'),
('1010', 'phamlinhtrang130', N'Phạm Linh Trang', '$2y$10$T2svJ.ok1cCufnWIa/rBGuiSekCJU1KVasYSW6iSH6J3LtPtux0XK', '1010@e.vap.edu.vn', '765432243', N'Hà Nội', N'Nữ', '2005-12-30', N'Học sinh', '2020A1'),
('1011', 'duongchiphat131', N'Dương Chi Phát', '$2y$10$bJRi.BBlpXE0Eka.NVYdsOPA7XOWtdWRORYplptT40VkPjAGJD.K.', '1011@e.vap.edu.vn', '985678422', N'Hà Nội', N'Nam', '2005-09-15', N'Học sinh', '2020A1'),
('1012', 'laitrucmy132', N'Lại Trúc Mỹ', '$2y$10$enCcNCpH1JI4pO.fguw0W.DavB8llxLrT8uzzLV9gF/MgkRjkNeLW', '1012@e.vap.edu.vn', '985678556', N'Hà Nội', N'Nữ', '2005-08-08', N'Học sinh', '2020A2'),
('1013', 'truonggiaky133', N'Trương Gia Kỳ', '$2y$10$NNdEEcd3dk2A6ChLgEVvxeNiy7PaJAG0jRvwU37sXBTrFoo2UiDxq', '1013@e.vap.edu.vn', '985678690', N'Thái Bình', N'Nữ', '2005-04-01', N'Học sinh', '2020A2'),
('1014', 'letrongduong134', N'Lê Trọng Dương', '$2y$10$IYcn.yhNtJi8ZHLhkkacdOjzHHxOnSTUo5DSffRq4pharx739IXX2', '1014@e.vap.edu.vn', '985678824', N'Hà Nội', N'Nam', '2004-02-15', N'Học sinh', '2019A1'),
('1015', 'lygiahan135', N'Lý Gia Hân', '$2y$10$PIyHCWnSicvZd/SAiWZl8OLU5W59/tDNDs9dIcSy3obvVUVxpJA6a', '1015@e.vap.edu.vn', '985678958', N'Hà Nội', N'Nữ', '2004-02-07', N'Học sinh', '2019A1'),
('1016', 'letuyetlinh136', N'Lê Tuyết Linh', '$2y$10$7VkvVc2azk.2PRYAN2UTuuGzDgZ63oDjlJHw7gM77QLSFtp9G56SC', '1016@e.vap.edu.vn', '985679092', N'Hà Nội', N'Nữ', '2004-06-07', N'Học sinh', '2019A1'),
('1017', 'nguyennhunganh137', N'Nguyễn Nhung Anh', '$2y$10$ViURYJZAEkiRFyLYbZPFo.JD.3bBuK934TJSO7DQyUo7wR993gV9S', '1017@e.vap.edu.vn', '987654324', N'Hà Nội', N'Nữ', '2004-10-17', N'Học sinh', '2019A1'),
('1002', 'trannamphong108', N'Trần Nam Phong', '$2y$10$SCYAxXjNgv3J6d7OiDOIXOeuQwrYldzEjcI2uNlCBIH.dXx4Dmv2K', '1002@e.vap.edu.vn', '965432345', N'Hà Nội', N'Nam', '2004-01-01', N'Học sinh', '2019A2'),
('1018', 'laihoanghiepquang138', N'Lại Hoàng Hiệp Quang', '$2y$10$9LHOzFEvqLS1P/KaPtkMheeBazSYM9bQhxkeZd6/unignDMPPIF8.', '1018@e.vap.edu.vn', '987654578', N'Hà Nội', N'Nam', '2004-07-27', N'Học sinh', '2019A2');

update study set Coef_one = 5, Coef_two = 7, Coef_three = 6 where UserID = '1001' and SubjectID = 'van10';
update study set Coef_one = 6, Coef_two = 8, Coef_three = 8 where UserID = '1001' and SubjectID = 'toan10';
update study set Coef_one = 7, Coef_two = 2, Coef_three = 5 where UserID = '1001' and SubjectID = 'anh10';
update study set Coef_one = 8, Coef_two = 10, Coef_three = 9 where UserID = '1001' and SubjectID = 'phap10';

update study set Coef_one = 8, Coef_two = 9, Coef_three = 8 where UserID = '1003' and SubjectID = 'van10';
update study set Coef_one = 9, Coef_two = 8, Coef_three = 6 where UserID = '1003' and SubjectID = 'toan10';
update study set Coef_one = 10, Coef_two = 7, Coef_three = 8 where UserID = '1003' and SubjectID = 'anh10';
update study set Coef_one = 10, Coef_two = 6, Coef_three = 9 where UserID = '1003' and SubjectID = 'phap10';

update study set Coef_one = 5, Coef_two = 5, Coef_three = 5 where UserID = '1004' and SubjectID = 'van10';
update study set Coef_one = 6, Coef_two = 6, Coef_three = 6 where UserID = '1004' and SubjectID = 'toan10';
update study set Coef_one = 6, Coef_two = 7, Coef_three = 8 where UserID = '1004' and SubjectID = 'anh10';
update study set Coef_one = 6, Coef_two = 8, Coef_three = 9 where UserID = '1004' and SubjectID = 'phap10';

update study set Coef_one = 1, Coef_two = 8, Coef_three = 1 where UserID = '1005' and SubjectID = 'van10';
update study set Coef_one = 10, Coef_two = 5, Coef_three = 5 where UserID = '1005' and SubjectID = 'toan10';
update study set Coef_one = 10, Coef_two = 8, Coef_three = 8 where UserID = '1005' and SubjectID = 'anh10';
update study set Coef_one = 10, Coef_two = 9, Coef_three = 9 where UserID = '1005' and SubjectID = 'phap10';

update study set Coef_one = 8, Coef_two = 9, Coef_three = 7 where UserID = '1006' and SubjectID = 'van10';
update study set Coef_one = 9, Coef_two = 9, Coef_three = 5 where UserID = '1006' and SubjectID = 'toan10';
update study set Coef_one = 8, Coef_two = 8, Coef_three = 6 where UserID = '1006' and SubjectID = 'anh10';
update study set Coef_one = 7, Coef_two = 9, Coef_three = 7 where UserID = '1006' and SubjectID = 'phap10';

update study set Coef_one = 5, Coef_two = 4, Coef_three = 6 where UserID = '1007' and SubjectID = 'van10';
update study set Coef_one = 8, Coef_two = 5, Coef_three = 7 where UserID = '1007' and SubjectID = 'toan10';
update study set Coef_one = 5, Coef_two = 8, Coef_three = 9 where UserID = '1007' and SubjectID = 'anh10';
update study set Coef_one = 5, Coef_two = 7, Coef_three = 8 where UserID = '1007' and SubjectID = 'phap10';

update study set Coef_one = 7, Coef_two = 5, Coef_three = 6 where UserID = '1008' and SubjectID = 'van11';
update study set Coef_one = 8, Coef_two = 5, Coef_three = 6 where UserID = '1008' and SubjectID = 'toan11';
update study set Coef_one = 8, Coef_two = 8, Coef_three = 8 where UserID = '1008' and SubjectID = 'anh11';
update study set Coef_one = 7, Coef_two = 8, Coef_three = 8 where UserID = '1008' and SubjectID = 'phap11';

update study set Coef_one = 6, Coef_two = 7, Coef_three = 8 where UserID = '1009' and SubjectID = 'van11';
update study set Coef_one = 7, Coef_two = 6, Coef_three = 8 where UserID = '1009' and SubjectID = 'toan11';
update study set Coef_one = 6, Coef_two = 7, Coef_three = 8 where UserID = '1009' and SubjectID = 'anh11';
update study set Coef_one = 8, Coef_two = 5, Coef_three = 9 where UserID = '1009' and SubjectID = 'phap11';

update study set Coef_one = 9, Coef_two = 9, Coef_three = 9 where UserID = '1010' and SubjectID = 'van11';
update study set Coef_one = 10, Coef_two = 8, Coef_three = 8 where UserID = '1010' and SubjectID = 'toan11';
update study set Coef_one = 10, Coef_two = 9, Coef_three = 8 where UserID = '1010' and SubjectID = 'anh11';
update study set Coef_one = 10, Coef_two = 8, Coef_three = 7 where UserID = '1010' and SubjectID = 'phap11';

update study set Coef_one = 5, Coef_two = 10, Coef_three = 8 where UserID = '1011' and SubjectID = 'van11';
update study set Coef_one = 5, Coef_two = 7, Coef_three = 7 where UserID = '1011' and SubjectID = 'toan11';
update study set Coef_one = 6, Coef_two = 8, Coef_three = 8 where UserID = '1011' and SubjectID = 'anh11';
update study set Coef_one = 7, Coef_two = 8, Coef_three = 7 where UserID = '1011' and SubjectID = 'phap11';

update study set Coef_one = 9, Coef_two = 8, Coef_three = 6 where UserID = '1012' and SubjectID = 'van11';
update study set Coef_one = 5, Coef_two = 7, Coef_three = 5 where UserID = '1012' and SubjectID = 'toan11';
update study set Coef_one = 4, Coef_two = 8, Coef_three = 6 where UserID = '1012' and SubjectID = 'anh11';
update study set Coef_one = 3, Coef_two = 6, Coef_three = 8 where UserID = '1012' and SubjectID = 'phap11';

update study set Coef_one = 1, Coef_two = 3, Coef_three = 2 where UserID = '1013' and SubjectID = 'van11';
update study set Coef_one = 2, Coef_two = 3, Coef_three = 3 where UserID = '1013' and SubjectID = 'toan11';
update study set Coef_one = 3, Coef_two = 1, Coef_three = 3 where UserID = '1013' and SubjectID = 'anh11';
update study set Coef_one = 3, Coef_two = 1, Coef_three = 2 where UserID = '1013' and SubjectID = 'phap11';

update study set Coef_one = 10, Coef_two = 10, Coef_three = 10 where UserID = '1014' and SubjectID = 'van12';
update study set Coef_one = 10, Coef_two = 10, Coef_three = 10 where UserID = '1014' and SubjectID = 'toan12';
update study set Coef_one = 10, Coef_two = 10, Coef_three = 10 where UserID = '1014' and SubjectID = 'anh12';
update study set Coef_one = 10, Coef_two = 10, Coef_three = 10 where UserID = '1014' and SubjectID = 'phap12';

update study set Coef_one = 6, Coef_two = 6, Coef_three = 6 where UserID = '1015' and SubjectID = 'van12';
update study set Coef_one = 8, Coef_two = 4, Coef_three = 5 where UserID = '1015' and SubjectID = 'toan12';
update study set Coef_one = 7, Coef_two = 6, Coef_three = 7 where UserID = '1015' and SubjectID = 'anh12';
update study set Coef_one = 8, Coef_two = 6, Coef_three = 8 where UserID = '1015' and SubjectID = 'phap12';

update study set Coef_one = 9, Coef_two = 10, Coef_three = 9 where UserID = '1016' and SubjectID = 'van12';
update study set Coef_one = 9, Coef_two = 10, Coef_three = 10 where UserID = '1016' and SubjectID = 'toan12';
update study set Coef_one = 9, Coef_two = 7, Coef_three = 8 where UserID = '1016' and SubjectID = 'anh12';
update study set Coef_one = 9, Coef_two = 8, Coef_three = 9 where UserID = '1016' and SubjectID = 'phap12';

update study set Coef_one = 10, Coef_two = 5, Coef_three = 7 where UserID = '1017' and SubjectID = 'van12';
update study set Coef_one = 5, Coef_two = 7, Coef_three = 6 where UserID = '1017' and SubjectID = 'toan12';
update study set Coef_one = 7, Coef_two = 8, Coef_three = 7 where UserID = '1017' and SubjectID = 'anh12';
update study set Coef_one = 8, Coef_two = 7, Coef_three = 8 where UserID = '1017' and SubjectID = 'phap12';

update study set Coef_one = 4, Coef_two = 9, Coef_three = 7 where UserID = '1018' and SubjectID = 'van12';
update study set Coef_one = 8, Coef_two = 7, Coef_three = 7 where UserID = '1018' and SubjectID = 'toan12';
update study set Coef_one = 6, Coef_two = 8, Coef_three = 7 where UserID = '1018' and SubjectID = 'anh12';
update study set Coef_one = 8, Coef_two = 5, Coef_three = 6 where UserID = '1018' and SubjectID = 'phap12';

update study set Coef_one = 5, Coef_two = 8, Coef_three = 8 where UserID = '1002' and SubjectID = 'van12';
update study set Coef_one = 8, Coef_two = 8, Coef_three = 6 where UserID = '1002' and SubjectID = 'toan12';
update study set Coef_one = 7, Coef_two = 7, Coef_three = 7 where UserID = '1002' and SubjectID = 'anh12';
update study set Coef_one = 9, Coef_two = 6, Coef_three = 5 where UserID = '1002' and SubjectID = 'phap12';

INSERT INTO messenger(FromID, ToID, MessContent) VALUES
('0001', '1001', N'Thông báo hoãn thi do covid 19'),
('1001', '0001', N'Cập nhật thời khóa biểu'),
('0002', '1002', N'Mẹ ơi con mới xong việc, đã lâu con chưa gọi về'),
('1002', '0002', N'Nhà ta thế nào? Cha có đỡ đau ốm hơn không?'),
('1003', '0003', N'Mùa đông đã sang rồi, mẹ nhóm than ấm cha ngồi'),
('0003', '1003', N'Để vơi gió rét bên trời'),
('1004', '0004', N'Mẹ, bên đây tuyết rơi nhiều, lê chân về sau ca chiều'),
('0004', '1004', N'Ở nơi xứ người cũng may sống chung mấy anh em'),
('1005', '0005', N'Chỉ lúc chẳng yên bình bạn con nó khóc một mình'),
('0005', '1005', N'Làm ai cũng nhớ gia đình'),
('1006', '0006', N'Ngày chưa biết quê ta nghèo, chỉ mơ bước đi muôn nẻo'),
('0006', '1006', N'Thả đôi cánh bay xa hoài ô ô nước ngoài'),
('1007', '0007', N'Giờ con đã ở nơi này, cuộc sống khác xa quá vậy'),
('0007', '1007', N'Chỉ mong bớt lo tương lai'),
('0008', '1008', N'Vì con đi kiếm đồng tiền cho thôi ngày sau bần tiện'),
('1008', '0008', N'Nên xin mẹ chớ buồn phiền'),
('0009', '1009', N'Vì khi biết quê ta nghèo, rủ nhau bước đi muôn nẻo'),
('1009', '0009', N'Tìm đất khách mong làm giàu, mai sau ngẩng đầu'),
('0001', '1010', N'Mà đâu biết trong đêm dài, người không muốn ta ở lại'),
('1010', '0001', N'Chạy trong giá băng mệt nhoài, tâm tư hoang mang'),
('0002', '1011', N'Dù nghe lắm nỗi bi hài, người ta vẫn đi nước ngoài'),
('1011', '0002', N'Rời xa bữa cơm ở nhà qua nơi khác lạ'),
('0003', '1012', N'Và trong lớp thanh niên làng, người may mắn đi vững vàng'),
('1012', '1003', N'Còn ai trắng tay quay về'),
('0004', '1013', N'Mẹ nghe không tiếng ồn ào, anh em họ gửi lời chào'),
('1013', '0004', N'Mẹ chớ nghĩ ngợi bên này chúng con mến thương nhau'),
('0005', '1014', N'Một mai nắng xanh trời, rời nơi nương náu một thời'),
('1014', '0005', N'Về trong đôi mắt rạng ngời');


