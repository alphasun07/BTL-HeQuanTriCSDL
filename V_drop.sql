use thpt_vap;
--V
drop view v_studentsOfTeachers;
drop view v_users_profiles;
drop view v_subjectsOfClass;
drop function get_subjectsOfClass;
drop function get_avgAllScore;
drop function f_evaluate;
drop trigger add_user;
drop trigger update_users;
drop procedure sp_searchMatchMess;
drop procedure sp_updateEvaluate_class;
drop procedure sp_updateEvaluate_user;

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

--P
drop FUNCTION TACHTEN;
drop FUNCTION DOCKHOINGUYEN;
drop PROCEDURE  INSERT_users;
drop PROCEDURE DiemTBcaonhat;
drop view v_users_messeger;
drop view v_user_teach_subject;
drop trigger InsertTeach;
drop trigger InsertStudy;