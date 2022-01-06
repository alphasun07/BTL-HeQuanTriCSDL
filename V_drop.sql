use thpt_vap;
--V
drop view v_studentsOfTeachers;
drop view v_users_profiles;
drop function get_subjectsOfClass;
drop function get_avgAllScore;
drop function f_evaluate;
drop trigger add_user;
drop trigger del_profile;
drop procedure sp_searchMatchMess;
drop procedure sp_updateEvaluate;

--A
drop view v_studentsOfClass;
drop view v_scoresOfStudent;
drop function f_DiemTrungBinh;
drop function f_SiSoHocSinh;
drop function f_Diem;
drop trigger update_scores;
drop trigger del_user;
drop procedure sp_SiSoNhieu;
drop procedure sp_SoLuongTinNhan;