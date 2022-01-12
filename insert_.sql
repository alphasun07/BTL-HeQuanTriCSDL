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

