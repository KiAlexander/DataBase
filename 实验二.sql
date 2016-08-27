--创建数据库
CREATE DATABASE teaching
ON
(	NAME=teaching_data,
	FILENAME='E:\我的北邮\上机\大二下\teaching.mdf',
	SIZE=5,
	MAXSIZE=10,
	FILEGROWTH=10%)
LOG ON
(	NAME=teaching_log,
	FILENAME='E:\我的北邮\上机\大二下\teaching.ldf',
	SIZE=1,
	MAXSIZE=2,
	FILEGROWTH=10%)
	
use teaching

DROP DATABASE  teaching

--创建用户定义的数据类型
EXEC sp_addtype student_no,'CHAR(10)','NOT NULL'
EXEC sp_addtype member_no,'BIGINT','NOT NULL'
EXEC sp_addtype shortstring,'VARCHAR(15)'
EXEC sp_addtype 学号,'NUMERIC（10,0）'
EXEC sp_addtype 联系电话,'NUMERIC（11,0）'


--创建表
DROP TABLE Student
CREATE TABLE Student
(   Sex CHAR(2),
    Age INT,
    MAJOR VARCHAR(20),
	ClassNo CHAR(7)
	)

DROP TABLE Course 
CREATE TABLE Course
(   CourseNo CHAR(5),
    CourseName CHAR(20),
    CT INT)

DROP TABLE SC
CREATE TABLE SC
(  SNo CHAR(9) NOT NULL,
   CourseNo CHAR(5) NOT NULL,
   Score NUMERIC(4,1)
  )

SELECT * FROM Student
SELECT * FROM Course
SELECT * FROM SC
SELECT * FROM SC_CLASS
SELECT * FROM SCHEDULE

ALTER TABLE Student 
ADD
SNo student_no

ALTER TABLE Student 
DROP COLUMN	ClassNo 

--实现数据完整性

DROP TABLE Student
CREATE TABLE Student
(   SNo CHAR(9) CONSTRAINT S_Prim PRIMARY KEY,
    SN CHAR(8) UNIQUE,
    Sex CHAR(2) DEFAULT '男',
    Age INT,
    MAJOR VARCHAR(20))

DROP TABLE Course 
CREATE TABLE Course
(   CourseNo CHAR(5) CONSTRAINT C_Prim PRIMARY KEY,
    CourseName CHAR(20) UNIQUE,
    CT INT)

DROP TABLE SC
--主键
CREATE TABLE SC
(	SNo CHAR(5) NOT NULL,
   CourseNo CHAR(5) NOT NULL,
   Score NUMERIC(4,1),
   CONSTRAINT SC_Prim PRIMARY KEY(SNo,CourseNo)
   )
--外键
Create table SC(Sno char(9),CourseNo char(5),Score smallint,
		Primary key(Sno,CourseNo),
		Foreign key(Sno) REFERENCES Student(SNo),
		Foreign key(CourseNo) REFERENCES Course(CourseNo))


ALTER TABLE Student 
ADD
STelephone 联系电话

GO
Create default telephone_defult as 'unknown'
GO
sp_bindefault 'telephone_defult ', 'Student.[STelephone]'
--------------------------------------------------------------
--根据题目所插数据对表进行修改
DROP TABLE Student
CREATE TABLE Student
(   SNO CHAR(9)CONSTRAINT S_Prim PRIMARY KEY,
    SNAME VARCHAR(15)UNIQUE,
	SSex CHAR(3)DEFAULT '男',
	ClassNo CHAR(7) NOT NULL,
    SBIRTH DATE,
	SSTATUS VARCHAR(10),
	HOMETOWN VARCHAR(15),
	ENROLLMENT DATE,
	TELEPHONE CHAR(11)UNIQUE,
	SRESUME VARCHAR(20),
   	)


DROP TABLE SClass
CREATE TABLE SClass
(   CLASSNO CHAR(7)CONSTRAINT SCl_Prim PRIMARY KEY,
    SCLassNAME CHAR(7)UNIQUE,
	MAJOR VARCHAR(20),
	GRADE CHAR(8),
	NUMBER INT,
	ADVISOR CHAR(20)
	)

ALTER TABLE Course 
ADD
StartTM shortstring

DROP TABLE Course 
CREATE TABLE Course
(   CourseNo CHAR(2)CONSTRAINT C_Prim PRIMARY KEY,
    CourseName VARCHAR(20)UNIQUE,
	CATEGORY CHAR(6),
	MAJOR VARCHAR(20),
	GRADE CHAR(8),
	StartTM VARCHAR(8),
    CREDITS INT,
	WEEKHOURS INT
	)

DROP TABLE SCHEDULE
CREATE TABLE SCHEDULE
(
  CourseNo CHAR(2)CONSTRAINT SCH_Prim PRIMARY KEY,
  StartYear CHAR(15),
  ClassNo CHAR(7),
  TEACHER CHAR(20)
)

DROP TABLE SC
CREATE TABLE SC
(  SNo CHAR(9) NOT NULL,
   CourseNo CHAR(2) NOT NULL,
   --CLASSNAME VARCHAR(15),
   Score NUMERIC(3,1),
   --CONSTRAINT SC_Prim PRIMARY KEY(SNo,CourseNo)
   CONSTRAINT SC_Prim PRIMARY KEY(SNo)
      )


--插入stuent
insert into Student values('200815126','张三','男','2008123','1990-04-05','团员','北京','2008-09-01','13812345678','网络工程')
insert into Student values('200815127','李四','男','2008125','1990-04-06','团员','浙江','2008-09-01','13812345679','通信工程')
insert into Student values('200815128','王五','女','2008127','1991-04-15','团员','贵州','2008-09-01','13812345670','软件工程')
insert into Student values('200815129','张三丰','女','2008122','1992-04-25','党员','江西','2008-09-01','13812345672','电子信息工程')
insert into Student values('200815130','臧志强','男','2008121','1993-04-09','团员','安徽','2008-09-01','13812345671','通信工程')

--插入Course
insert into Course values('C1','数据库技术','指选','通信工程','大二','第2学期',2,2)
insert into Course values('C2','通信原理','必修','计算机科学与技术','大三','第1学期',3,3)
insert into Course values('C3','数字电路与逻辑设计','必修','信息工程','大二','第1学期',4,4)
insert into Course values('C4','通信电子电路','必修','通信工程','大二','第2学期',2,2)
insert into Course values('C5','随机信号分析','必修','通信工程','大二','第2学期',2,2)


--插入SC
insert into SC(Sno,CourseNo) values('200815126','C1')
insert into SC values('200815127','C2',90.5)
insert into SC values('200815128','C3',59.5)
insert into SC values('200815129','C4',77)
insert into SC values('200815130','C5',85.5)
insert into SC values('200815122','C1',85.5)

--插入SClass
insert into SClass values('2008123','23班','网络工程','大二',28,'张琳')
insert into SClass values('2008125','25班','通信工程','大二',25,'张平')
insert into SClass values('2008127','27班','软件工程','大二',29,'郭军')
insert into SClass values('2008122','22班','电子信息工程','大二',28,'乔建永')
insert into SClass values('2008121','21班','通信工程','大二',30,'杨鸿文')


SELECT*from Course
update Course set StartTM= '第1学期' where CourseNo = 'C1'
update SC set Score = 90 where Sno ='200815126' and CourseNo ='C1'
delete from SC where Sno ='200815126' and CourseNo ='C1'


DROP TABLE stu

Select SNO,SNAME,SSex into stu from Student

truncate table Student
--------------------------------------------------
--使用查询分析器实现以下查询
--检索选修了课程号为C1或C2课程，且成绩高于或等于70分的学生的姓名，课程名和成绩。
SELECT SNAME,CourseName,Score FROM Student,Course,SC
  WHERE student.sno = SC.SNO and SC.CourseNo=Course.CourseNo and (SC.CourseNo='C1' or SC.CourseNo='C2') and Score >= 70

--检索姓“王”的所有学生的姓名和年龄。
SELECT sname, year(GETDATE()) - YEAR(SBIRTH) AS　AGE FROM Student 
WHERE sname LIKE '王%'

--检索没有考试成绩的学生姓名和课程名。
SELECT sname,CourseName FROM student,SC,course WHERE Student.SNO=SC.SNO and SC.CourseNo =course.CourseNo and score is null

--检索年龄大于女同学平均年龄的男学生姓名和年龄。
SELECT SNAME,year(GETDATE()) - YEAR(SBIRTH) age 
FROM student 
WHERE ssex ='男' and year(GETDATE()) - YEAR(SBIRTH) > (SELECT AVG(year(GETDATE()) - YEAR(SBIRTH)) 
                                                      FROM Student WHERE SSex ='女')

--上述查询中所用的课程号和学号的值，可以根据自己表中的数据作修改；为了验证查询的正确，可能还需要输入或修改表中的示例数据；
------------------------------------------------------------
--使用企业管理器创建和管理索引
--利用表的属性对话框，观察每个表已经自动创建的索引；
--针对学生选课信息表创建如下索引
--按学号+课程编号建立主键索引，索引组织方式为聚簇索引；
ALTER TABLE SC
DROP SC_Prim 
create clustered index PK_SC ON SC(Sno DESC,CourseNo)

DROP INDEX SC.PK_SC
--按学号建立索引，考虑是否需要创建唯一索引，索引组织方式为非聚簇索引；
CREATE UNIQUE NONCLUSTERED INDEX SCI ON SC(SNo)

DROP INDEX SC.SCI 
--按课程编号建立索引，考虑是否需要创建唯一索引，索引组织方式为非聚簇索引；
CREATE UNIQUE NONCLUSTERED INDEX SN_SC ON SC(CourseNo)

DROP INDEX SC.SN_SC
--再针对学生选课信息表输入一些数据，观察表中记录位置的变化；通过观察比较非聚簇索引和聚簇索引的不同之处；
INSERT INTO SC VALUES('200815111','C9',90.5)

SELECT*FROM SC
--针对其它表，练习创建索引；（考虑：是否对每个列都应创建索引？应该从哪些方面考虑是否应为此列创建索引？）
--1、表的主键、外键必须有索引；
--2、数据量超过300的表应该有索引；
--3、经常与其他表进行连接的表,在连接字段上应该建立索引；
--4、经常出现在Where子句中的字段,特别是大表的字段,应该建立索引；
--5、索引应该建在选择性高的字段上；
--6、索引应该建在小字段上,对于大的文本字段甚至超长字段,不要建索引；
--7、复合索引的建立需要进行仔细分析；尽量考虑用单字段索引代替：
--A、正确选择复合索引中的主列字段,一般是选择性较好的字段；
--B、复合索引的几个字段是否经常同时以AND方式出现在Where子句中?单字段查询是否极少甚至没有?如果是,则可以建立复合索引；否则考虑单字段索引；
--C、如果复合索引中包含的字段经常单独出现在Where子句中,则分解为多个单字段索引；
--D、如果复合索引所包含的字段超过3个,那么仔细考虑其必要性,考虑减少复合的字段；
--E、如果既有单字段索引,又有这几个字段上的复合索引,一般可以删除复合索引；
--8、频繁进行数据操作的表,不要建立太多的索引；
--9、删除无用的索引,避免对执行计划造成负面影响；

--练习索引的修改和删除操作
------------------------------------------------------------
--创建视图： 使用企业管理器或使用CREATE VIEW命令
--创建视图，包含所有通信工程专业的学生的信息；
DROP　VIEW TX_Student

CREATE VIEW TX_Student  AS
		SELECT * FROM Student 
		WHERE SRESUME = '通信工程' 

INSERT INTO TX_Student VALUES ('200815222','马云云','男','2008121','1980-04-05','团员','北京','2008-09-01','13812365328','网络工程')
	
SELECT* FROM TX_Student
--创建视图，包含所有学生的学号，姓名，选课的课程名和成绩；
DROP VIEW SC_Grade

CREATE VIEW SC_Grade  AS
		SELECT Student.SNo,sname,CourseName,score 
		FROM Student,Course,SC
WHERE Student.sno=SC.sno and Course.CourseNo=SC.CourseNo 

exec sp_helptext SC_Grade

SELECT* FROM SC_Grade

--创建视图，包含所有课程的课程号，名，班级名称及每班选课的人数；
--练习修改视图的定义
--第一个视图，包括with check option 
DROP　VIEW TX_Student

CREATE VIEW TX_Student  AS
		SELECT * FROM Student 
		WHERE SRESUME = '通信工程' 
		WITH CHECK OPTION

--无法插入不符合条件的数据
INSERT INTO TX_Student VALUES ('200815222','马云云','男','2008121','1980-04-05','团员','北京','2008-09-01','13812365328','网络工程')

DELETE FROM Student WHERE SNo='200815222'


SELECT*FROM TX_Student
SELECT*FROM Student
-- 第二个视图，包括with encryption选项；（查看视图的属性，观察和以前有和不同）
DROP VIEW SC_Grade

CREATE VIEW SC_Grade WITH ENCRYPTION AS
		SELECT Student.SNo,sname,CourseName,score 
		FROM Student,Course,SC
        WHERE Student.sno=SC.sno and Course.CourseNo=SC.CourseNo 
		

--当使用"exec sp_helptext 触发器名"时,查看不了语句
exec sp_helptext SC_Grade

SELECT* FROM SC_Grade

--利用已经创建的视图进行查询；
SELECT*FROM TX_Student WHERE HOMETOWN='安徽'

--练习删除视图
DROP VIEW SC_Grade

--利用已经创建的视图修改数据（观察是否所有通过视图的修改都能实现？)
--不是，只支持单表  无统计的
INSERT INTO  TX_Student
VALUES ('200815120','张博','男','2008131','1990-05-05','团员','北京','2010-09-01','13812342378','通信工程')

SELECT* FROM TX_Student

UPDATE TX_Student
SET HOMETOWN = '湖南'
WHERE  SNAME ='李四' 

DELETE 
FROM TX_Student
WHERE SNO='200815120'




 



