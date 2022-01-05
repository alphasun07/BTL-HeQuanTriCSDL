use master
use thpt_vap

--VIEW
-----------------------------------------------------------------------------------------------------------------------------

-- View users x profiles
create view v_users_profiles(UserID, UserName, UserPassword, UserEmail, 
UserStatus, UserCode, UserRole, ClassID, UserID_, ProName, ProPhone, ProAddress, ProGender, ProBirth, ProAva, Evaluate)
as select * from users, profiles where users.UserID = profiles.UserID

-- View học sinh giáo viên
create view v_studentsOfTeachers(teacherID, studentID, SubjectID, summary) as
select distinct teach.UserID as teacherID, users.UserID as studentID, study.SubjectID, study.Summary 
from teach, users, study where teach.ClassID = users.ClassID and users.UserID = study.UserID;

--Tạo view v_ChiTietNguoiDung để hiển thị chi tiết thông tin gồm UserID, UserName, UserPassword, UserEmail, UseStatus,  
--UserRole, ProPhone, ProAddress, Progender, ProBirth, ClassName,  
Create view v_ChiTietNguoiDung(UserID, UserName, UserPassword, UserEmail, UserStatus, UserCode,
						UserRole, ProPhone, ProAddress, Progender, ProBirth, ClassName)
as
	select u.UserID, u.UserName, u.UserPassword, u.UserEmail, u.UserStatus, u.UserCode, u.UserRole, p.ProPhone, p.ProAddress,
	p.Progender, p.ProBirth, c.ClassName
	from users as u, class as c, profiles as p
	where u.UserID=p.UserID and u.ClassID=c.ClassID

--Tạo view v_lophoc để hiển thị thông tin của học sinh và môn học gồm UserID, UserName, ClassName, SubjectName, SubjectType,
-- cofe_one, Coef_two, Cofe_three, Summary, Conduct
create view v_lophoc(UserID, UserName, ClassName, SubjectName, SubjectType, Cofe_one, Coef_two, Cofe_three, Summary)
as
	select u.UserID, u.UserName, ClassName, sb.SubjectName, sb.SubjectType, st.Coef_one, st.Coef_two, 
			st.Coef_three, st.Summary
	from users as u, class as c, subjects as sb, study as st
	where u.ClassID=c.ClassID and st.UserID=u.UserID and st.SubjectID=sb.SubjectID

-----------------------------------------------------------------------------------------------------------------------------

--TRIGGER
-----------------------------------------------------------------------------------------------------------------------------
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

-- Sua diem -> sua lai tong diem
create trigger update_scores
on study
after update as
	begin
		update study set summary = dbo.f_DiemTrungBinh(inserted.UserID, inserted.SubjectID) 
		from inserted where study.UserID = inserted.UserID and study.SubjectID = inserted.SubjectID;
	end

-- Xóa Thông tin cá nhân -> không thể xóa
create trigger del_profile
on profiles
instead of delete as
	begin
		print N'Không thể xóa thông tin cá nhân của người dùng';
	end

-----------------------------------------------------------------------------------------------------------------------------