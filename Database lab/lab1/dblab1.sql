CREATE TABLE Departments
(
	[Name] varchar(20) NOT NULL ,
	ID	char(5)	PRIMARY KEY ,
	Budget	numeric(12, 2) ,
	Category	varchar(15) CHECK (Category in ('Engineering', 'Science'))
);

CREATE TABLE Teachers
(
	FirstName	varchar(20)	NOT NULL ,
	LastName	varchar(30) NOT NULL ,
	ID char(7)	,
	BirthYear int ,
	DepartmentID char(5) ,
	Salary numeric(7, 2) Default 10000.00 ,
	PRIMARY KEY (ID) ,
	FOREIGN KEY (DepartmentID) REFERENCES Departments(ID) ,
);

CREATE TABLE Students
(
	FirstName	varchar(20) NOT NULL ,
	LastName	varchar(30) NOT NULL ,
	StudentNumber	char(7)	PRIMARY KEY ,
	BirthYear	int ,
	DepartmentID	char(5) ,
	AdvisorID	char(7), 
	FOREIGN KEY (DepartmentID) REFERENCES Departments(ID), 
	FOREIGN KEY (AdvisorID) REFERENCES Teachers(ID)
);


/*///////////////////////////////////////////////////////////////////////////////////////////////////// */

/*q1-1*/

ALTER TABLE Students
ADD PassedUnits numeric(3, 0) DEFAULT 0 


/*q1-2*/

CREATE TABLE Courses
(
	ID	varchar(5) PRIMARY KEY ,
	Title	varchar(20) NOT NULL ,
	Credits	varchar(30) ,
	DepartmentID	char(5) ,
	FOREIGN KEY (DepartmentID) REFERENCES Departments(ID) 
);

CREATE TABLE Available_Courses
(
	CourseID	varchar(5) ,
	Semester	varchar(10) CHECK	(Semester in ('fall', 'spring')) ,
	[Year]	int ,
	TeacherID	char(7) ,
	PRIMARY KEY (TeacherID, [Year], Semester, CourseID),
	FOREIGN KEY (CourseID) REFERENCES Courses(ID) ,
	FOREIGN KEY (TeacherID) REFERENCES Teachers(ID)
);

CREATE TABLE Taken_Courses
(
	StudentID	char(7) ,
	CourseID	varchar(5) ,
	Semester	varchar(10) CHECK	(Semester in ('fall', 'spring')) ,
	[Year]	int ,
	Grade	numeric(4 ,2) ,
	PRIMARY KEY (StudentID, [Year], Semester, CourseID),
	FOREIGN KEY (CourseID) REFERENCES Courses(ID) ,
	FOREIGN KEY (StudentID) REFERENCES Students(StudentNumber),
);

CREATE TABLE Prerequisites
(
	CourseID	varchar(5) ,
	PrereqID	varchar(5) ,
	PRIMARY KEY (CourseID, PrereqID) ,
	FOREIGN KEY (CourseID) REFERENCES Courses(ID) ,
	FOREIGN KEY (PrereqID) REFERENCES Courses(ID)
);




/* q1-3 */

INSERT INTO dbo.Departments VALUES ('Computer', '11111', 70000.00, 'Engineering');
INSERT INTO dbo.Departments VALUES ('Math', '22222', 60000.00, 'Science');


INSERT INTO dbo.Teachers VALUES ('Nader', 'Karimi', '1111111', 1978, '11111', 1000.00);
INSERT INTO dbo.Teachers VALUES ('Mohammad Reza', 'Heidarpour', '2222222', 1982, '11111', 1200.00);


INSERT INTO dbo.Students VALUES ('erfan', 'bahrami', '1111111', 1998, '11111', '1111111', 76);
INSERT INTO dbo.Students VALUES ('nima', 'rezayi', '2222222', 1998, '11111', '1111111', 74);
INSERT INTO dbo.Students VALUES ('Mohammad', 'janati', '3333333', 1998, '22222', '2222222', 68);
INSERT INTO dbo.Students VALUES ('ali', 'ebrahimi', '4444444', 1999, '22222', '2222222', 59);
INSERT INTO dbo.Students VALUES ('Arman', 'teymori', '55555', 1999, '22222', '2222222', 65);


INSERT INTO dbo.Courses VALUES ('11111', 'DataBase', NULL, '11111');
INSERT INTO dbo.Courses VALUES ('22222', 'Algoeithm', NULL, '11111');
INSERT INTO dbo.Courses VALUES ('33333', 'Math_1', NULL, '22222');
INSERT INTO dbo.Courses VALUES ('44444', 'Math_2', NULL, '22222');


INSERT INTO dbo.Available_Courses VALUES ('11111', 'fall', 2019, '1111111');
INSERT INTO dbo.Available_Courses VALUES ('22222', 'spring', 2020, '1111111');
INSERT INTO dbo.Available_Courses VALUES ('33333', 'fall', 2019, '2222222');
INSERT INTO dbo.Available_Courses VALUES ('44444', 'spring', 2020, '2222222');


INSERT INTO dbo.Taken_Courses VALUES ('1111111', '11111', 'fall', 2020, 20);
INSERT INTO dbo.Taken_Courses VALUES ('1111111', '22222', 'fall', 2020, 19);
INSERT INTO dbo.Taken_Courses VALUES ('2222222', '11111', 'fall', 2020, 19);
INSERT INTO dbo.Taken_Courses VALUES ('2222222', '22222', 'fall', 2020, 20);
INSERT INTO dbo.Taken_Courses VALUES ('3333333', '33333', 'fall', 2020, 18);
INSERT INTO dbo.Taken_Courses VALUES ('3333333', '44444', 'fall', 2020, 15);
INSERT INTO dbo.Taken_Courses VALUES ('4444444', '33333', 'fall', 2020, 12);
INSERT INTO dbo.Taken_Courses VALUES ('4444444', '44444', 'fall', 2020, 14);


INSERT INTO dbo.Prerequisites VALUES ('11111', '22222');
INSERT INTO dbo.Prerequisites VALUES ('44444', '33333');



/*/////////////////////////////////////////////////////////////// */

/* q2-1 */

SELECT D.[name], D.ID, D.Budget, D.Category
FROM dbo.Students as S INNER JOIN dbo.Departments as D ON (S.DepartmentID = D.ID)
WHERE S.StudentNumber = '123'


/* q2-2 */

SELECT	T.CourseID, T.StudentID, T.Semester,  T.[Year], T.Grade+1
From	dbo.Taken_Courses as  T

/* q2-3 */

SELECT DISTINCT S.FirstName, S.LastName, S.StudentNumber, S.BirthYear, S.DepartmentID, S.AdvisorID
FROM dbo.Students as S 

EXCEPT

SELECT DISTINCT S.FirstName, S.LastName, S.StudentNumber, S.BirthYear, S.DepartmentID, S.AdvisorID
FROM dbo.Students as S INNER JOIN dbo.Taken_Courses as T ON (S.StudentNumber = T.StudentID) INNER JOIN dbo.Courses as C ON (T.CourseID = C.ID)
WHERE C.Title = 'DataBase'