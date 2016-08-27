--ʵ����	SQL Server���ݿ���Ƹ߼�����

--һ��ʹ�ò�ѯ������ʵ�����²�ѯ
use teaching
--(1) ͳ����ѧ��ѡ�޵Ŀγ������� 
select count(CourseNo) as 'ѡ�޵Ŀγ�����'
from SC 

--(2) ��ѡ�����������ϵ�ѧ����ѡ�γ̵�ƽ���ɼ�(��ͳ�Ʋ�����Ŀγ�)��
--    ��󰴽����г�ƽ���ɼ������������� 
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

select sno,count(*) as 'ѡ������',AVG(score)as 'ƽ����' 
from sc 
group by sno
having count(*)>=4
order by AVG(score) desc

--(3) ͳ��ÿ��ָѡ�γ̵�ѧ��ѡ������(����10�˵Ŀγ̲�ͳ��),Ҫ������γ̺�,
--   �γ�����ѡ������,��ѯ�����������������,��������ͬ,���γ̺��������С�
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

select sc.courseno,coursename,count(sc.sno) as 'ѡ������'
from sc,course
where course.courseno=sc.courseno
group by sc.courseno,coursename
having count(sc.sno)>10
order by count(sc.sno) desc,courseno


--(4) ������ѧ�γ̰�����s3��ѡ���пγ̵�ѧ��������
--ע��������ѯ�����õĿγ̺ź�ѧ�ŵ�ֵ�����Ը����Լ����е��������޸ģ�
--    Ϊ����֤��ѯ����ȷ�����ܻ���Ҫ������޸ı��е�ʾ�����ݣ�
select *from student

insert into Student values('200815101','��־ǿ','��','2008123','1990-04-05','��Ա','����','2008-09-01','13812345633','���繤��')
insert into Student values('200815102','�','��','2008125','1990-04-06','��Ա','�㽭','2008-09-01','13812345631','ͨ�Ź���')

insert into SC values('200815101','s3',77)
insert into SC values('200815102','s3',85.5)

select sname
from student,sc
where student.sno=sc.sno and sc.courseno='s3'

select sname
from student
where( 's3' in (select courseno from sc where student.sno=sc.sno))

--����	ʵ������������
--��1��	����checkԼ��
--checkԼ�����������û������ĳһ�����ݣ�
--���磺�ɼ������ֵӦ������Ϊ0-100֮�����ֵ

alter table sc
add constraint chk_score check(score between 0 and 100)

insert into SC values('200815100','s3',185.5)

--��2��	�������rule��
--ruleҲ�������������û���������ݣ�����ֻ����һ�Σ����԰󶨵�һ�л���У�
--���磺����һ�����򣬱�ֻ֤��������ָ���Ŀγ���𣺡����ޡ�������ѡ������ָѡ����
--      Ȼ��Ѵ˹���󶨵����γ���𡱣�
create rule categoryrule as @category in('����','��ѡ','ָѡ')
go
exec sp_bindrule 'categoryrule','course.category'

insert into Course values('C0','���ݿ�','ָͷѡ','ͨ�Ź���','���','��2ѧ��',2,2)

--��3��	��������Լ������ϰ�޸�Լ���Ĳ������������ӣ��޸ĺ�ɾ������Լ������
alter table sc
drop constraint chk_score 

go
exec sp_unbindrule 'course.category'
go

drop rule categoryrule
--����	����ҵ���������������ݵ��룬��������ϰ���ݵĵ��뵼������ÿ�����е����ݵ�����ָ�����ı��ļ��У�


--�ġ�	����ҵ�������У���ϰ���ݿ�������Ա��ݺͻָ���
--�塢	�洢���̺ʹ�������ʵ��
--1��	�洢����
--��1��ʹ��CREATE PROCEDURE������洢����
--��1������洢���̣�ʵ��ѧ��ѧ�ţ��������γ����ͳɼ��Ĳ�ѯ��
create procedure myproc as
select  sc.sno,sname,coursename,score
from student,course,sc
where student.sno=sc.sno and sc.courseno=course.courseno

exec myproc

drop procedure myproc
--��2������洢���̣�ʵ�ְ�ĳ��ָ���γ̵ĳɼ���
create procedure myproc2 
@sname  varchar(15),
@coursename  varchar(20)
as
select sname,coursename,score
from sc,student,course
where sc.sno=student.sno and sc.courseno=course.courseno and sname=@sname and coursename=@coursename


exec myproc2 '����','ͨ��ԭ��'

drop procedure myproc2

--��3������洢���̣��ڲ�ѯĳ����ѡ�޵Ŀγ̺ͳɼ���ָ������ʱ������ֻ�����գ�
create procedure myproc3 
@sname  varchar(15)='%'
as
select sname,coursename,score
from sc,student,course
where sc.sno=student.sno and sc.courseno=course.courseno and sname like @sname 


exec myproc3 '��%'

drop procedure myproc3
--��4������洢���̣����㲢�鿴ָ��ѧ������ѧ��
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
exec myproc4 '����',@total output
select '�ܷ�'=@total

drop procedure myproc4
--��2��ʹ��EXEC����ִ�������洢����
--�鿴�洢���� 
exec sp_help myproc4
exec sp_helptext myproc4

--���������洢���� 
exec sp_rename myproc, myproc1 

--2��������
--��1��ʹ��CREATE TRIGGER�����ѧ��ѡ����Ϣ�������봥������ʵ�ֵĹ����ǣ�
--     ����ѧ��ѡ����Ϣ���в���һ��¼ʱ�����ü�¼��ѧ����ѧ�������Ƿ���ڣ�
--     ���ü�¼�Ŀγ̱���Ƿ��ڿγ̱��д��ڣ�����һ��Ϊ������ʾ��Υ������
--     ��һ���ԡ�������Ϣ�����Ҳ�������롣
create trigger checkinsert
on sc
after insert
as 
if not exists
(select  *from student,course,inserted
where Student.sno=inserted.sno and course.courseno=inserted.courseno)
begin
raiserror( 'Υ�����ݵ�һ����',16,1)
rollback 
--delete from sc
--where sc.sno in (select sno from inserted)
end
else
begin
print '�ɹ�����'
end

insert into SC values('200815001','C0',59.5)

delete from sc
where sno='200815001'

select *from sc

drop trigger checkinsert

--��2��ʹ��CREATE TRIGGER �����ѧ����Ϣ����ɾ����������ʵ�ֵĹ����ǣ�
--     ����ѧ����Ϣ����ɾ��һ����¼ʱ��ͬʱɾ��ѧ��ѡ����Ϣ������Ӧ�ļ�¼��
create trigger checkdelete
on student
after delete
as 
delete from sc
where sc.sno = (select sno from deleted)

insert into Student values('200815001','����','��','2008125','1990-04-06','��Ա','�㽭','2008-09-01','13812345611','ͨ�Ź���')
insert into SC values('200815001','s3',77)

delete from student
where sno='200815001'

select *from student
where sno='200815001'
select *from sc
where sno='200815001'

drop trigger checkdelete

--��2����γ���Ϣ��������ݣ���ѧ����Ϣ��ɾ����¼����֤��������ִ�У�

--����	��ʵ����ʦ�������е���Ŀ��ɾ�������������ݿ�, ��ʵ�������ɵĽű��ļ���
--      ���ݵ������ı��ļ��Լ����ݿ�ı����ļ����Ƶ�U���У���ͨ�����ա�

