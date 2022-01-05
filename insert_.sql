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

INSERT INTO messenger(FromID, ToID, MessContent) VALUES
('0001', '1001', N'Thông báo hoãn thi do covid 19'),
('1001', '0001', N'Cập nhật thời khóa biểu'),
('0001', '1001', N'alo alo'),
('1001', '0001', N't nè'),
('0001', '1001', N'hsi hí ');

insert into teach values 
('0001', 'Van10', '2021A1'),
('0001', 'toan10', '2021A1'),
('0001', 'anh10', '2021A1'),
('0001', 'phap10', '2021A1');
