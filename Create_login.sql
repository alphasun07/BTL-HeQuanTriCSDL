use thpt_vap

--Tạo login cho admin với quyền là người sở hữu cơ sở dữ liệu(toàn quyền với cơ sở dữ liệu)
exec sp_addlogin 'connect_sa','123456'

exec sp_grantdbaccess 'connect_sa','SA'

exec sp_addrolemember 'db_owner','SA'

--Tạo login cho giáo viên với quyền là người có thể thêm sửa xóa vào cơ sở dữ liệu
exec sp_addlogin 'sa_guest','qwưer'

exec sp_grantdbaccess 'sa_guest','teacher'

exec sp_addrole 'teachers'

grant execute on get_avgAllScore to teachers
grant execute on f_evaluate to teachers
grant execute on sp_searchMatchMess to teachers
grant execute on sp_updateEvaluate_class to teachers
grant execute on sp_updateEvaluate_user to teachers
grant execute on f_DiemTrungBinh to teachers
grant execute on f_SiSoHocSinh to teachers
grant execute on sp_SiSoNhieu to teachers
grant execute on sp_SoLuongTinNhan to teachers
grant execute on TACHTEN to teachers
grant execute on DOCKHOINGUYEN to teachers
grant execute on INSERT_users to teachers
grant execute on DiemTBcaonhat to teachers

exec sp_addrolemember 'db_datawriter','teacher'
exec sp_addrolemember 'teachers','teacher'

exec sp_droprolemember 'teachers','teacher'
exec sp_revokedbaccess 'teacher'
exec sp_droprole 'teachers' 

--Tạo login cho học sinh với quyền là người truy suất dữ liệu từ cơ sở dữ liệu
exec sp_addlogin 'sa_guest1','qwưer'

exec sp_grantdbaccess 'sa_guest1','student'

exec sp_addrole 'students'

grant all on users to students
grant all on profiles to students
grant all on messenger to students
grant select on study to students
grant select on class to students
grant select on subjects to students
grant select on teach to students

grant select on v_studentsOfTeachers to students
grant all on v_users_profiles to students
grant select on v_subjectsOfClass to students
grant select on v_studentsOfClass to students
grant select on v_scoresOfStudent to students
grant all on v_users_messeger to students
grant select on v_user_teach_subject to students

grant execute on sp_searchMatchMess to students
grant execute on sp_SoLuongTinNhan to students
grant execute on sp_SiSoNhieu to students
grant execute on f_DiemTrungBinh to students
grant execute on DOCKHOINGUYEN to students
grant execute on TACHTEN to students

exec sp_addrolemember 'students','student'

exec sp_droprolemember 'students','student'
exec sp_revokedbaccess 'student'
exec sp_droprole 'students' 