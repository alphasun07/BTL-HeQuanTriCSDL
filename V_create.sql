use master
use thpt_vap



-- View users x profiles
create view v_users_profiles(UserID, UserName, UserPassword, UserEmail, 
UserStatus, UserCode, UserRole, ClassID, UserID_, ProName, ProPhone, ProAddress, ProGender, ProBirth, ProAva, Evaluate)
as select * from users, profiles where users.UserID = profiles.UserID

select * from v_users_profiles



-- Hàm lấy ra tất cả các môn học được dạy trong một lớp (tham số đầu vào là ID lớp)
create function get_subjectsOfClass(@ClassID varchar(10))
returns @subjectOfClass table
(ClassID varchar(10), SubjectID varchar(10), SubjectName Nvarchar(60), SubjectType Nvarchar(60))
as
	begin
		insert into @subjectOfClass
		select ClassID, subjects.SubjectID, SubjectName, SubjectType from subjects, teach
		where ClassID = @ClassID and teach.SubjectID = subjects.subjectID
		return
	end



-- View lấy ra môn học của một lớp
create view v_subjectsOfClass as
select ClassID, subjects.SubjectID, SubjectName, SubjectType from subjects, teach
where teach.SubjectID = subjects.subjectID



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
				from v_subjectsOfClass as sc, inserted where inserted.ClassID = sc.ClassID;
			end
	end

insert into v_users_profiles(UserID, UserName, UserPassword, UserEmail, UserCode, UserRole, ClassID, ProName) 
values ('1001', N'haicaiten', 'abc', 'haicaimail@gmail.com', '00000000', N'Học sinh', '2021A1', N'Hai Cái Tên')

insert into v_users_profiles(UserID, UserName, UserPassword, UserEmail, UserCode, UserRole, ProName) 
values ('0001', N'motcaiten', 'abc', 'motcaimail@gmail.com', '00000000', N'Giáo viên',  N'Một Cái Tên')

insert into v_users_profiles(UserID, UserName, UserPassword, UserEmail, UserCode, UserRole, ProName) 
values ('0002', N'bacaiten', 'abc', 'bacaimail@gmail.com', '00000000', N'Giáo viên',  N'Ba Cái Tên')


alter table Profiles Add Constraint KTGioiTinh Check (ProGender=N'Nam' or ProGender = N'Nữ')

-- Xóa user -> xóa profile, xóa message
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
	end

delete from v_users_profiles where UserName = 'haicaiten'



-- Sua diem -> sua lai tong diem
create trigger update_scores
on study
after update as
	begin
	if (update(Coef_one) or update(Coef_two) or update(Coef_three) or update(summary))
		update study set summary = dbo.f_DiemTrungBinh(inserted.UserID, inserted.SubjectID) 
		from inserted where study.UserID = inserted.UserID and study.SubjectID = inserted.SubjectID;
	end

update study set summary = 10 where UserID = '1001'

select * from study where UserID ='1001'

-- Tay đổi tên tài khoản -> không thể thay đổi
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



-- Hàm tính điểm tổng kết đầu vào 1 UserID
create function get_avgAllScore(@UserID varchar(4))
returns float as
	begin
		declare @x float;
		select @x = (sum(Summary)/count(*)) from study where UserID = @UserID;
		return @x;
	end

select dbo.get_avgAllScore('1001')



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

select dbo.f_evaluate('0001')



-- View học sinh giáo viên
create view v_studentsOfTeachers(teacherID, studentID, SubjectID, summary) as
select distinct teach.UserID as teacherID, users.UserID as studentID, study.SubjectID, study.Summary 
from teach, users, study where teach.ClassID = users.ClassID and users.UserID = study.UserID;



-- Thủ tục cập nhật đánh giá cho Học sinh theo lớp
create proc sp_updateEvaluate_class @ClassID varchar(10) as
	begin
		update profiles set evaluate = dbo.f_evaluate(profiles.UserID) from users
		where (users.ClassID = @ClassID) and profiles.UserID = users.UserID
	end

exec sp_updateEvaluate_class '2021A1'



-- Thủ tục cập nhật đánh giá người dùng
create proc sp_updateEvaluate_user @UserID varchar(4) as
	begin
		update profiles set evaluate = dbo.f_evaluate(profiles.UserID)
		where (profiles.UserID = @UserID)
	end

exec sp_updateEvaluate_user '0001'



-- Thủ tục lấy ra tin nhắn với đầu vào là một chuỗi
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

--View học sinh của lớp
create view v_studentsOfClass(CLassID, ClassName, UserID, Name, Birth, Gender, Address, Avatar)
as select c.CLassID, c.ClassName, u.UserID, p.ProName, p.ProBirth, p.ProGender, p.ProAddress, p.ProAva
from class as c, users as u, profiles as p 
where c.ClassID = u.ClassID and u.UserID = p.UserID

select * from users;
select * from profiles;
select * from study;


