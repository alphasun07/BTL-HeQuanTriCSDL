use thpt_vap;
drop trigger add_user;
drop trigger del_user;
drop trigger update_scores;
drop trigger del_profile

drop view v_users_profiles;
drop view v_lophoc;
drop view v_ChiTietNguoiDung;
drop view v_studentsOfTeachers;

drop function get_subjectsOfClass;
drop function f_DiemTrungBinh;
drop function f_Diem;
drop function f_SiSoHocSinh;
drop function f_evaluate;
drop function get_avgAllScore;

drop procedure sp_SiSoNhieu;
drop procedure sp_SoLuongTinNhan;
drop procedure sp_updateEvaluate;
drop procedure sp_searchMatchMess;