-- inserting data 
use Music_Academy_Management
go

insert into Employee values (10010101,7000000,'10/12/2015',null,'teacher',null,120001);
insert into Employee values (10010302,1500000,'01/25/2016',null,'teacher',null,120002);
insert into Employee values (10040103,4000000,'10/12/2015',null,'teacher',25,120003);
insert into Employee values (10040104,3000000,'12/12/2015',null,'teacher',25,120004);
-------------------------------------------------------------------------------------------
select * from Employee
-------------------------------------------------------------------------------------------
insert into Employee_Pv
 values ('داود','بحری نژاد','05/20/1980','1250614458','09132454897'
 ,'03145723145','تهران-خیابان نکویی -کوچه‌ی علی اکبر مالکی',10010101,1);
insert into Employee_Pv
 values ('نادر','شایگان','09/22/1975','1212564826','09220456789'
 ,'03125468791','اصفهان-خیابان مدرس-کوچه ی شهید مسعود خداوردیان هفتم',10010302,1);
 insert into Employee_Pv
 values ('علی','کاظمی','07/03/1985','1250482842','09375946077'
 ,'03157843615','کاشان-بلوار مدرس -کوچه‌ی بهار دهم',10040103,0);
 insert into Employee_Pv
 values ('سعید','پیلتن','05/13/1986','1284796365','09125148022'
 ,'06127896134','تهران-خیابان آفتاب -کوچه‌ی علی اکبر قمیشی',10040104,0);
-------------------------------------------------------------------------------------------
select * from Employee_Pv
-------------------------------------------------------------------------------------------
 insert into Student 
 values ('سحر','تابیده','10/12/1998','1546378985','09152641534','03132456817',
 'تهران - قیطریه-خیابان نور -کوچه‌ی امیر محمد بارانی',20010001);  
  insert into Student 
 values ('محسن','جوادیان','11/06/1998','1250413254','09220467942','03155789634',
 'کاشان - بلوار شهید میثاق پور - کوچه‌ی محسنی',10030002);			
  insert into Student 
 values ('مسعود','خداوردیان','01/02/2000','1547864254','09132468465','03135463152',
 'اصفهان - مظفریه -خیابان بهشتی -کوچه‌ی خداوردیان پنجم',40020003);	
  insert into Student 
 values ('اکبر','مخبری','08/13/1999','1453691945','09124578934','03125642845',
 'تهران - ولیعصر -خیابان فرشته -کوچه‌ی گلی ششم',40050004);		

 insert into Student 
 values ('Amin','Dadgar','10/11/1999','4546377035','09152641565','03132456888',
 'Iran-Kahan',30010001); 
 	
-------------------------------------------------------------------------------------------
select * from Student
-------------------------------------------------------------------------------------------
 insert into Teacher_Instr values(10010101,'گیتار پاپ');
insert into Teacher_Instr values(10010302,'سه تار');
insert into Teacher_Instr values(10040103,'درامز');
insert into Teacher_Instr values(10040104,'درامز');
-------------------------------------------------------------------------------------------
select * from Teacher_Instr
-------------------------------------------------------------------------------------------
insert into class values ('1','شنبه','08 am',10010101,'گیتار پاپ',20010001);
insert into class values ('2','شنبه','08 am',10010302,'سه تار',10030002);
insert into class values ('3','شنبه','08 am',10040103,'درامز',40020003);
insert into class values ('1','شنبه','12 am',10040104,'درامز',40050004);
-------------------------------------------------------------------------------------------
select * from Class
-------------------------------------------------------------------------------------------
insert into Term values (10010101,'گیتار پاپ',10,'1200000','45');
insert into Term values (10010302,'سه تار',10,'900000','45');
insert into Term values (10040103,'درامز',12,'1200000','30');
insert into Term values (10040104,'درامز',8,'700000','45');
-------------------------------------------------------------------------------------------
select * from Term
-------------------------------------------------------------------------------------------

insert into Attendance values (10030002,1,'2020-06-24 12:23:03',1,0)
 insert into Attendance values (10030002,1,'2020-07-01 12:20:05',1,0)
 insert into Attendance values (10030002,1,'2020-07-08 12:21:03',1,0)
 insert into Attendance values (10030002,1,'2020-07-15 12:22:12',0,1)

  insert into Attendance values (40050004,3,'2020-06-24 12:20:00',1,0)
  insert into Attendance values (40050004,3,'2020-07-01 12:21:00',1,0)
  insert into Attendance values (40050004,3,'2020-07-08 12:23:20',1,0)
  insert into Attendance values (40050004,3,'2020-07-15 12:19:07',1,0)

 insert into Attendance values (20010001,4,'2020-06-26 12:19:07',1,0)
 insert into Attendance values (20010001,4,'2020-07-02 12:21:19',1,0)
 insert into Attendance values (20010001,4,'2020-07-09 12:22:00',1,0)
 insert into Attendance values (20010001,4,'2020-07-16 12:21:18',1,0)


insert into Attendance values (40020003,1,'2020-06-27 12:19:07',1,0)
insert into Attendance values (40020003,1,'2020-07-03 12:19:07',1,0)
insert into Attendance values (40020003,1,'2020-07-10 12:21:23',1,0)
insert into Attendance values (40020003,1,'2020-07-17 12:25:00',1,0)


insert into Attendance values (30010001,1,'2020-06-27 12:21:01',1,0)
 insert into Attendance values (30010001,1,'2020-07-01 12:20:04',1,0)
 insert into Attendance values (30010001,1,'2020-07-08 12:21:01',0,1)
 insert into Attendance values (30010001,1,'2020-07-15 12:22:45',1,0)

 insert into Payment values ('598476834','10/11/2019')
 insert into Payment values ('598476832','10/05/2019')
 insert into Payment values ('598476833','10/07/2019')
 insert into Payment values ('598476831','05/11/2019')
 insert into Payment values ('598476855','05/11/2019')

  insert into Student_Term(Term_ID,Pay_ID,SID,Register_Date) values(1,'598476834',20010001,'05/11/2019')
 insert into Student_Term(Term_ID,Pay_ID,SID,Register_Date) values(4,'598476832',10030002,'05/11/2019')
 insert into Student_Term(Term_ID,Pay_ID,SID,Register_Date) values(3,'598476833',20010001,'03/11/2019')
 insert into Student_Term(Term_ID,Pay_ID,SID,Register_Date) values(2,'598476831',40020003,'03/10/2019')
 insert into Student_Term(Term_ID,Pay_ID,SID,Register_Date) values(2,'598476855',40050004,'03/09/2019')
 
 insert into USERS values('Admin','Admin',1)

