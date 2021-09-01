-- creating tables 
use Music_Academy_Management
go

create table Student								-- Honarjoo
(	First_Name nvarchar(20) not null,
	Last_Name nvarchar(30) not null,
	Birth_Date date null,
	National_Code char(10) not null unique,
	Phone char(11) not null unique,					-- Mobile Phone
	Tel char(11) not null unique,					-- home
	Address nvarchar(max) null,
	SID char(8) not null primary key				--Student Id
)

create table Employee								--info edari karmandan(shamel e asatid)
(	EID char(8) not null primary key,				--Employee Id
	Base_Salary varchar(10) not null,			
	Entrance_Date date not null,					--employment date
	Exit_Date date null,						
	Job nvarchar(15) not null,						-- ostad? monshi? ...?
	Overtime tinyint null,							--ezafe kar 
	Insurance_Num   int not null,					--shomare bime
);

create table Employee_Pv							--info shakhsi karmandan(shamel e asatid)
(	First_Name nvarchar(20) not null,
	Last_Name nvarchar(30) not null,
	Birth_Date date null,
	National_Code char(10) not null unique,			--code melli
	Phone char(11) not null unique,					--mobile phone
	Tel char(11) not null unique,					-- home 
	Address nvarchar(max) null,
	EID char(8) not null foreign key references Employee(EID) primary key , --on delete cascade 
	Marital bit not null							--vaziat e taahol
);

create table Teacher_Instr										--jadval e ostad-saz
(	EID char(8) not null foreign key references Employee(EID),
	Instr_Name nvarchar(20) not null,							-- name saz
	constraint PK_Teacher_Instr primary key (EID,Instr_Name)	--on delete cascade 
);

create table Class			
(	Number nvarchar(6) not null,
	day nvarchar(8) not null,
	hour nchar(5) not null,
	EID char(8) not null,
	Instr_Name nvarchar(20) not null,
	SID char(8) not null foreign key references Student(SID),	 --on delete cascade
	constraint FK_Class foreign key (EID,Instr_Name) references Teacher_Instr (EID,Instr_Name),  -- on delete cascade
	constraint PK_Class primary key (Number,day,hour)
); 

create table Term											-- doure ha
(	Term_ID tinyint identity(1,1) not null primary key,		-- id e doure(term)
	EID char(8) not null,
	Instr_Name nvarchar(20) not null,
	Session_Count integer not null,							--tedad e jalasat e doure 
	Session_Price integer not null,							--gheimat e har jalase 
	Session_Time nvarchar(3) not null,						--time e har jalase 
	constraint FK_Term foreign key (EID,Instr_Name) references Teacher_Instr (EID,Instr_Name)
);


create table Payment									--pardakht
(	Pay_ID varchar(10) not null primary key,
	Time datetime not null								--zaman e pardakht 
);

create table Student_Term								-- honarjoo_term
(	Term_Num tinyint identity(1,1) not null,
	Term_ID tinyint not null foreign key references Term(Term_ID),	--on delete cascade 
	Pay_ID varchar(10) null foreign key references Payment(Pay_ID),	--on delete cascade 
	SID char(8) not null foreign key references Student(SID),		--on delete cascade 
	Register_Date date not null,
	End_Date Date null,
	constraint PK_Student_Term primary key (Term_Num,Term_ID,SID)
);



create table Attendance						-- hozoor ghiab
(	SID char(8) not null foreign key references Student(SID),	-- on delete cascade
	Term_ID tinyint not null foreign key references Term(Term_ID), -- on delete cascade
	Date_Time datetime not null unique,		-- time class
	Attendance bit not null,				--hazer?
	Allowed bit null,						--gheibat e mojaz?
	constraint PK_Attendance primary key (SID,Term_ID,Date_Time)
)


create table academy							--info amoozeshgah
(	Name nvarchar(30) not null,
	Address nvarchar(max) not null,
	Tel char(11) not null,
	Website varchar(40) null,
	Email varchar(40) null,
	Founder_Name nvarchar(50) not null,			--name moasses
	Found_Date Date not null,					--tarikh e tasis
	Reg_Num varchar(25) not null primary key	--shomare sabt (javaz)	
)

create table USERS
(username varchar(25) not null primary key,
password varchar(22) not null,
manager bit,
)

	
backup database Music_Academy_Management					
to disk='D:\daneshga\terme 7\aze db\backup\MAM_27_azar.bak'		-- last backup: 27 azar



