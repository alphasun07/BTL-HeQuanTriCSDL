--VIEW

--Tạo view v_ChiTietNguoiDung để hiển thị chi tiết thông tin gồm UserID, UserName, UserPassword, UserEmail, UseStatus,  
--UserRole, ProPhone, ProAddress, Progender, ProBirth, ClassName,  
Create view v_ChiTietNguoiDung(UserID, UserName, UserPassword, UserEmail, UserStatus, UserCode,
						UserRole, ProPhone, ProAddress, Progender, ProBirth, ClassName)
as
	select u.UserID, u.UserName, u.UserPassword, u.UserEmail, u.UserStatus, u.UserCode, u.UserRole, p.ProPhone, p.ProAddress,
	p.Progender, p.ProBirth, c.ClassName
	from users as u, class as c, profiles as p
	where u.UserID=p.UserID and u.ClassID=c.ClassID

select * from v_ChiTietNguoiDung


--Tạo view v_lophoc để hiển thị thông tin của học sinh và môn học gồm UserID, UserName, ClassName, SubjectName, SubjectType,
-- cofe_one, Coef_two, Cofe_three, Summary, Conduct
create view v_lophoc(UserID, UserName, ClassName, SubjectName, SubjectType, Cofe_one, Coef_two, Cofe_three, Summary, Conduct)
as
	select u.UserID, u.UserName, ClassName, sb.SubjectName, sb.SubjectType, st.Coef_one, st.Coef_two, 
			st.Coef_three, st.Summary, st.Conduct
	from users as u, class as c, subjects as sb, study as st
	where u.ClassID=c.ClassID and st.UserID=u.UserID and st.SubjectID=sb.SubjectID

select * from v_lophoc


--FUNCTION

--Viết một hàm f_DiemTrungBinh trả về một bảng chi tiết họ tên, lớp, số điểm trung bình của 1 học sinh 
	--với DiemTrungBinh = ((Coef_one * 1 + Coef_two * 2 + Coef_three * 3)/6)
	--với UserID là tham số truyền vào
create function f_DiemTrungBinh (@UserID varchar(4))
returns float
as
	begin
		declare @DiemTrungBinh float
		select @DiemTrungBinh = ((Coef_one * 1 + Coef_two * 2 + Coef_three * 3)/6)
		from users, study where users.UserID=@UserID and users.UserID = study.UserID
		return @DiemTrungBinh
	end

select dbo.f_DiemTrungBinh('1001')


--Viết một hàm f_DiemTrungBinh trả về một bảng chi tiết họ tên, lớp, điểm số 1, điểm số 2, điểm số 3 và số điểm trung bình của 1 học sinh 
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

select * from dbo.f_Diem('1001')

-- Hàm đếm sĩ số của lớp tham số truyền vào là 1 ID lớp
-- Viết một thủ tục đếm số học sinh trong 1 lớp theo thứ tự tăng dần
-- CẦN SỬA ĐỔI

create function f_SiSoHocSinh()
returns @SiSo table(IDLop varchar(10), TenLop nvarchar(10), SiSo int)
as
begin
	insert into @SiSo
	select class.ClassID, class.ClassName, count(UserID) as SiSo from users, class 
	group by class.ClassID, ClassName 
	order by SiSo asc
	return
end
	
select * from dbo.f_SiSoHocSinh()



--PROCEDURE
--Viết 1 thủ tục sp_SiSoNhieu đưa ra danh sách các lớp có sĩ số nhiều 
--hơn một giá trị x, với x là tham số đưa vào. Danh sách sản phẩm được đưa ra dưới dạng con trỏ.
Create or alter procedure sp_SiSoNhieu
@SiSo int, @dsss cursor varying output
as begin
set @dsss=cursor for
	select class.ClassID, class.ClassName, count(UserID) as SiSo from users, class 
	group by class.ClassID, ClassName 
	having count(UserID)>@SiSo
open @dsss
end

declare @contro_sp cursor
exec sp_SiSoNhieu 30, @contro_sp out
Fetch Next from @contro_sp
while (@@FETCH_STATUS = 0)
begin
	Fetch Next from @contro_sp
end
close @contro_sp
deallocate @contro_sp

--Viết 1 thủ tục số lượng tin nhắn đã đc gửi đi & nhận về từ ngày nào đó -> ngày
Create proc sp_SoLuongTinNhan
 @NgayDau date, @NgayCuoi date, @TongTinNhan int out
 as begin
 Select @TongTinNhan = Sum(MessContent) from messenger where MessTime>=@ngaydau and MessTime<=@ngaycuoi
 end
 
 declare @tn1 int, @tn2 int
 exec sp_SoLuongTinNhan '2000-05-26', '2000-8-15', @tn1 out
 exec sp_SoLuongTinNhan '2000-08-15', '2000-11-01', @tn2 out

 drop proc sp_SoLuongTinNhan

