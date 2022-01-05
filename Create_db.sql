use master
drop database thpt_vap
create database thpt_vap
use thpt_vap


CREATE TABLE class (
  ClassID varchar(10) NOT NULL,
  ClassName Nvarchar(10) NOT NULL,
  ClassGrade int NOT NULL,
  PRIMARY KEY (ClassID),
  UNIQUE  (ClassName)
)

CREATE TABLE users (
  UserID varchar(4) NOT NULL,
  UserName Nvarchar(60) NOT NULL,
  UserPassword varchar(255) NOT NULL,
  UserEmail varchar(100) DEFAULT NULL,
  UserStatus int NOT NULL DEFAULT 0,
  UserCode varchar(8) NOT NULL,
  UserRole Nvarchar(20) NOT NULL,
  ClassID varchar(10) DEFAULT NULL,
  PRIMARY KEY (UserID),
  UNIQUE (UserName),
  UNIQUE (UserEmail),
  FOREIGN KEY (ClassID) REFERENCES class (ClassID)
)

create table profiles(
	UserID varchar(4) NOT NULL,
	ProName Nvarchar(60) NOT NULL,
	ProPhone varchar(20),
	ProAddress Nvarchar(150),
	ProGender Nvarchar(20),
	ProBirth Date,
	ProAva varchar(60),
	evaluate nvarchar(50) DEFAULT N'Chưa có đánh giá',
	primary key (UserID),
	foreign key (UserID) references users(UserID),
)

create table subjects(
	SubjectID varchar(10) NOT NULL,
	SubjectName Nvarchar(60) NOT NULL, 
	SubjectType Nvarchar(60),
	primary key (SubjectID),
)

create table teach(
	UserID varchar(4) Not Null,
	SubjectID varchar(10) Not Null,
	ClassID varchar(10) Not Null,
	primary key (UserID, SubjectID, ClassID),
	foreign key (UserID) references users(UserID),
	foreign key (SubjectID) references subjects(SubjectID),
	foreign key (ClassID) references class(ClassID)
)

create table study(
	UserID varchar(4) Not Null,
	SubjectID varchar(10) Not Null,
	Coef_one float,
	Coef_two float,
	Coef_three float,
	Summary float,
	primary key (UserID, SubjectID),
	foreign key (UserID) references users(UserID),
	foreign key (SubjectID) references subjects(SubjectID),
)

CREATE TABLE messenger (
  MessID int NOT NULL IDENTITY(1,1),
  FromID varchar(4) NOT NULL,
  ToID varchar(4) NOT NULL,
  MessContent Nvarchar(255) NOT NULL,
  MessTime datetime NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (MessID,FromID,ToID),
  FOREIGN KEY (ToID) REFERENCES users(UserID),
  FOREIGN KEY (FromID) REFERENCES users(UserID)
)