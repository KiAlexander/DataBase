--实验三	SQL Server数据库设计高级内容

--一、使用查询分析器实现以下查询
use teaching
--(1) 统计有学生选修的课程门数。 
select count(CourseNo) as '选修的课程门数'
from SC 

--(2) 求选课在四门以上的学生所选课程的平均成绩(不统计不及格的课程)。
--    最后按降序列出平均成绩名次名单来。 
ALTER TABLE sc
DROP CONSTRAINT SC_Prim 

select *from sc
where sno='200815127'

insert into SC values('200815127','C2',90.5)
insert into SC values('200815127','C3',59.5)
insert into SC values('200815127','C4',77)
insert into SC values('200815122','C5',85.5)
insert into SC values('200815122','C2',83.5)
insert into SC values('200815122','C1',85.5)

select sno,count(*) as '选课门数',AVG(score)as '平均分' 
from sc 
group by sno
having count(*)>=4
order by AVG(score) desc

--(3) 统计每门指选课程的学生选修人数(超过10人的课程才统计),要求输出课程号,
--   课程名和选修人数,查询结果按人数降序排列,若人数相同,按课程号升序排列。
select * from sc
select * from student

insert into SC values('200815127','C2',90.5)
insert into SC values('200815112','C2',59.5)
insert into SC values('200815111','C2',77)
insert into SC values('200815118','C2',85.5)
insert into SC values('200815109','C2',83.5)
insert into SC values('200815107','C2',85.5)
insert into SC values('200815117','C2',90.5)
insert into SC values('200815120','C2',59.5)
insert into SC values('200815119','C2',77)
insert into SC values('200815118','C2',85.5)
insert into SC values('200815117','C2',83.5)
insert into SC values('200815116','C2',85.5)
insert into SC values('200815127','C2',90.5)
insert into SC values('200815112','C1',59.5)
insert into SC values('200815111','C1',77)
insert into SC values('200815118','C1',85.5)
insert into SC values('200815109','C1',83.5)
insert into SC values('200815107','C1',85.5)
insert into SC values('200815117','C1',90.5)
insert into SC values('200815120','C1',59.5)
insert into SC values('200815119','C1',77)
insert into SC values('200815118','C1',85.5)

select sc.courseno,coursename,count(sc.sno) as '选修人数'
from sc,course
where course.courseno=sc.courseno
group by sc.courseno,coursename
having count(sc.sno)>10
order by count(sc.sno) desc,courseno


--(4) 检索所学课程包含了s3所选所有课程的学生姓名。
--注：上述查询中所用的课程号和学号的值，可以根据自己表中的数据作修改；
--    为了验证查询的正确，可能还需要输入或修改表中的示例数据；
select *from student

insert into Student values('200815101','张志强','男','2008123','1990-04-05','团员','北京','2008-09-01','13812345633','网络工程')
insert into Student values('200815102','李博','男','2008125','1990-04-06','团员','浙江','2008-09-01','13812345631','通信工程')

insert into SC values('200815101','s3',77)
insert into SC values('200815102','s3',85.5)

select sname
from student,sc
where student.sno=sc.sno and sc.courseno='s3'

select sname
from student
where( 's3' in (select courseno from sc where student.sno=sc.sno))

--二、	实现数据完整性
--（1）	定义check约束
--check约束用来限制用户输入的某一列数据；
--例如：成绩输入的值应该限制为0-100之间的数值

alter table sc
add constraint chk_score check(score between 0 and 100)

insert into SC values('200815100','s3',185.5)

--（2）	定义规则（rule）
--rule也可以用来限制用户输入的数据，但它只定义一次，可以绑定到一列或多列；
--例如：创建一个规则，保证只允许输入指定的课程类别：“必修”，“任选”，“指选”，
--      然后把此规则绑定到“课程类别”；
create rule categoryrule as @category in('必修','任选','指选')
go
exec sp_bindrule 'categoryrule','course.category'

insert into Course values('C0','数据库','指头选','通信工程','大二','第2学期',2,2)

--（3）	创建以上约束后，练习修改约束的操作（包括增加，修改和删除以上约束）；
alter table sc
drop constraint chk_score 

go
exec sp_unbindrule 'course.category'
go

drop rule categoryrule
--三、	在企业管理器中利用数据导入，导出向导练习数据的导入导出；把每个表中的数据导出到指定的文本文件中；


--四、	在企业管理器中，练习数据库的完整性备份和恢复；
--五、	存储过程和触发器的实现
--1．	存储过程
--（1）使用CREATE PROCEDURE命令创建存储过程
--例1：定义存储过程，实现学生学号，姓名，课程名和成绩的查询；
create procedure myproc as
select  sc.sno,sname,coursename,score
from student,course,sc
where student.sno=sc.sno and sc.courseno=course.courseno

exec myproc

drop procedure myproc
--例2：定义存储过程，实现按某人指定课程的成绩；
create procedure myproc2 
@sname  varchar(15),
@coursename  varchar(20)
as
select sname,coursename,score
from sc,student,course
where sc.sno=student.sno and sc.courseno=course.courseno and sname=@sname and coursename=@coursename


exec myproc2 '李四','通信原理'

drop procedure myproc2

--例3：定义存储过程，在查询某人所选修的课程和成绩，指定姓名时，可以只给出姓；
create procedure myproc3 
@sname  varchar(15)='%'
as
select sname,coursename,score
from sc,student,course
where sc.sno=student.sno and sc.courseno=course.courseno and sname like @sname 


exec myproc3 '李%'

drop procedure myproc3
--例4：定义存储过程，计算并查看指定学生的总学分
create procedure myproc4
@sname  varchar(15),
@total integer output
as
select @total=sum(credits)
from sc,student,course
where sc.sno=student.sno and sc.courseno=course.courseno 
      and sname =@sname
--group by sname

declare @total integer
exec myproc4 '李四',@total output
select '总分'=@total

drop procedure myproc4
--（2）使用EXEC命令执行上述存储过程
--查看存储过程 
exec sp_help myproc4
exec sp_helptext myproc4

--重新命名存储过程 
exec sp_rename myproc, myproc1 

--2．触发器
--（1）使用CREATE TRIGGER命令对学生选课信息表创建插入触发器，实现的功能是：
--     当向学生选课信息表中插入一记录时，检查该记录的学号在学生表中是否存在，
--     检查该记录的课程编号是否在课程表中存在，若有一项为否，则提示“违背数据
--     的一致性”错误信息，并且不允许插入。
create trigger checkinsert
on sc
after insert
as 
if not exists
(select  *from student,course,inserted
where Student.sno=inserted.sno and course.courseno=inserted.courseno)
begin
raiserror( '违背数据的一致性',16,1)
rollback 
--delete from sc
--where sc.sno in (select sno from inserted)
end
else
begin
print '成功插入'
end

insert into SC values('200815001','C0',59.5)

delete from sc
where sno='200815001'

select *from sc

drop trigger checkinsert

--（2）使用CREATE TRIGGER 命令对学生信息表创建删除触发器，实现的功能是：
--     当在学生信息表中删除一条记录时，同时删除学生选课信息表中相应的记录。
create trigger checkdelete
on student
after delete
as 
delete from sc
where sc.sno = (select sno from deleted)

insert into Student values('200815001','李亿','男','2008125','1990-04-06','团员','浙江','2008-09-01','13812345611','通信工程')
insert into SC values('200815001','s3',77)

delete from student
where sno='200815001'

select *from student
where sno='200815001'
select *from sc
where sno='200815001'

drop trigger checkdelete

--（2）向课程信息表插入数据，在学生信息表删除记录，验证触发器的执行；

--六、	在实验老师验收所有的项目后，删除所创建的数据库, 把实验中生成的脚本文件，
--      数据导出的文本文件以及数据库的备份文件复制到U盘中，并通过验收。

