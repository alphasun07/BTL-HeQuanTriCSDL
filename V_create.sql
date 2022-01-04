use master
use thpt_vap



-- View users x profiles
create view v_users_profiles(UserID, UserName, UserPassword, UserEmail, 
UserStatus, UserCode, UserRole, ClassID, UserID_, ProName, ProPhone, ProAddress, ProGender, ProBirth, ProAva)
as select * from users, profiles where users.UserID = profiles.UserID

select * from v_users_profiles



-- Hàm lấy ra tất cả các môn học được dạy trong một lớp (tham số đầu vào là ID lớp)
create function get_subjectsOfClass(@UserID varchar(4), @ClassID varchar(10))
returns @subjectOfClass table
(UserID varchar(4), SubjectID varchar(10), SubjectName Nvarchar(60), SubjectType Nvarchar(60))
as
	begin
		insert into @subjectOfClass
		select UserID = @UserID, subjects.SubjectID, SubjectName, SubjectType from subjects, teach
		where ClassID = @ClassID and teach.SubjectID = subjects.subjectID
		return
	end



-- Thêm account mới -> thêm 1 profile mới
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
				from dbo.get_subjectsOfClass(@UserID, @ClassID);
			end
	end

insert into v_users_profiles(UserID, UserName, UserPassword, UserEmail, UserCode, UserRole, ClassID, ProName) 
values ('1001', N'haicaiten', 'abc', 'haicaimail@gmail.com', '00000000', N'Học sinh', '2021A1', N'Hai Cái Tên')

insert into v_users_profiles(UserID, UserName, UserPassword, UserEmail, UserCode, UserRole, ProName) 
values ('0001', N'motcaiten', 'abc', 'motcaimail@gmail.com', '00000000', N'Giáo viên',  N'Một Cái Tên')



-- Xóa user -> xóa profile, xóa message
-- Học sinh -> xóa điểm
-- Giáo viên -> xóa teach
create trigger del_user
on users
instead of delete as
	begin
		declare @UserID varchar(4), @Role Nvarchar(20);
		select @UserID = UserID, @Role = UserRole from deleted;

		delete from profiles where UserID = @UserID;
		delete from messenger where FromID = @UserID or ToID = @UserID;
		if @Role = N'Học sinh'
			begin
				delete from study where UserID = @UserID;
			end
		else if @Role = N'Giáo viên'
			begin
				delete from teach where UserID = @UserID;
			end
		delete from users where UserID = @UserID;
	end

delete from users where UserName = 'motcaiten'



-- Sua diem -> sua lai tong diem

select * from users
select * from profiles
select * from study


