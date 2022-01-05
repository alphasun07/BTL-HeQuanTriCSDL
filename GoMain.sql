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

--FUNCTION
-----------------------------------------------------------------------------------------------------------------------------
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

-- Hàm tính điểm tổng kết đầu vào 1 UserID
create function get_avgAllScore(@UserID varchar(4))
returns float as
	begin
		declare @x float;
		select @x = (sum(Summary)/count(*)) from study where UserID = @UserID;
		return @x;
	end

-- Hàm Đánh giá
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

--2.Viết một hàm f_DiemTrungBinh trả về một bảng chi tiết họ tên, lớp, điểm số 1, điểm số 2, điểm số 3 và số điểm trung bình của 1 học sinh 
	--với UserID là tham số truyền vào
create function f_Diem(@UserID nvarchar(4))
returns @Diem table(HoVaTen nvarchar(60), Lop nvarchar(10), Coef_one float, Coef_tow float, Coef_three float, DiemTrungBinh float)
as
	begin
		insert into @Diem
		select users.UserName, class.ClassName, st.Coef_one, st.Coef_two, st.Coef_three, ((Coef_one * 1 + Coef_two * 2 + Coef_three * 3)/6)
		from users, study as st, class where users.UserID=@UserID and users.UserID = st.UserID and users.ClassID = class.ClassID;
		return
	end


-- Đếm số học sinh
create function f_SiSoHocSinh(@ClassID varchar(10))
returns int
as
begin
	declare @SiSo int;
	select @SiSo = count(*) from users where ClassID = @ClassID;
	return @SiSo
end

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

-- PROCEDURE
-----------------------------------------------------------------------------------------------------------------------------

-- Thủ tục lấy ra các lớp có sĩ số > x đầu ra là một con trỏ
Create procedure sp_SiSoNhieu
@SiSo int, @dsss cursor varying output
as begin
set @dsss=cursor for
	select ClassID, ClassName, ClassGrade, SiSo = dbo.f_SiSoHocSinh(ClassID) from Class where dbo.f_SiSoHocSinh(ClassID) >= @SiSo order by SiSo asc
open @dsss
end

--2.Viết 1 thủ tục số lượng tin nhắn đã đc gửi đi & nhận về từ ngày nào đó -> ngày
Create proc sp_SoLuongTinNhan
 @UserID nvarchar(4), @NgayDau date, @NgayCuoi date, @TongTinNhan int out
 as 
	begin
		Select @TongTinNhan = Count(*) from messenger 
		where FromID = @UserID and MessTime>=@ngaydau and MessTime<=@ngaycuoi
	end

-- Thủ tục cập nhật đánh giá cho người dùng
create proc sp_updateEvaluate @UserID varchar(4), @ClassID varchar(10) as
	begin
		update profiles set evaluate = dbo.f_evaluate(profiles.UserID) from users
		where (profiles.UserID = @UserID or users.ClassID = @ClassID) and profiles.UserID = users.UserID
	end

-- Thủ tục lấy ra tin nhắn với đầu vào là một chuỗi
create proc sp_searchMatchMess @search Nvarchar(50), @count int output, @matchedList cursor varying output
as	begin
		set @matchedList = cursor for
		select * from messenger where MessContent like '%'+@search+'%';
		select @count = count(*) from messenger where MessContent like '%'+@search+'%';
		open @matchedList;
	end

-----------------------------------------------------------------------------------------------------------------------------