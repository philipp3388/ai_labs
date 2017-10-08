
DROP TABLE IF EXISTS loan;
DROP TABLE IF EXISTS book;
DROP TABLE IF EXISTS teacher;

DROP TABLE IF EXISTS publisher;
DROP TABLE IF EXISTS room;
DROP TABLE IF EXISTS school;
DROP TABLE IF EXISTS course;

--Making NF3 Tables
CREATE TABLE publisher (
    id serial NOT NULL PRIMARY KEY,
    name text NOT NULL
);

CREATE TABLE room (
    id serial NOT NULL PRIMARY KEY,
    name text NOT NULL
);

CREATE TABLE school (
    id serial NOT NULL PRIMARY KEY,
    name text NOT NULL
);


CREATE TABLE course (
    id serial NOT NULL PRIMARY KEY,
    name text NOT NULL
);

CREATE TABLE book (
    id serial NOT NULL PRIMARY KEY,
    name text NOT NULL,
    publisherId integer NOT NULL REFERENCES publisher(id)
);

CREATE TABLE teacher (
    id serial NOT NULL PRIMARY KEY,
    name text NOT NULL,
    schoolId integer NOT NULL REFERENCES school(id),
    roomId integer NOT NULL REFERENCES room(id),
    grade smallint NOT NULL
);


CREATE TABLE loan (
    id serial NOT NULL PRIMARY KEY,
    teacherId integer NOT NULL REFERENCES teacher(id),
    courseId integer NOT NULL REFERENCES course(id),
    bookId integer NOT NULL REFERENCES book(id),
    loanDate date NOT NULL
);

-- Fill data
INSERT INTO publisher (name)
VALUES 
('BOA Editions'),
('Taylor & Francis Publishing'),
('Prentice Hall'),
('McGraw Hill');
INSERT INTO book (name, publisherId)
VALUES 
('Learning and teaching in early childhood', 1),
('Preschool,N56', 2),
('Early Childhood Education N9', 3),
('Know how to educate: guide for Parents', 4);
INSERT INTO school (name)
VALUES 
('Horizon Education Institute'),
('Bright Institution');
INSERT INTO room (name)
VALUES 
('1.A01'),
('1.B01'),
('2.B01');
INSERT INTO teacher (name, schoolId, roomId, grade)
VALUES 
('Chad Russell', 1, 1, 1),
('E.F.Codd', 1, 2, 1),
('Jones Smith', 1, 1, 2),
('Adam Baker', 2, 3, 1);
INSERT INTO course (name)
VALUES 
('Logical thinking'),
('Wrtting'),
('Numerical Thinking'),
('Spatial, Temporal and Causal Thinking'),
('English');
INSERT INTO loan (teacherId, courseId, bookId, loanDate)
VALUES 
(1, 1, 1, '09/09/2010'),
(1, 2, 2, '05/05/2010'),
(1, 3, 1, '05/05/2010'),
(2, 4, 3, '06/05/2010'),
(2, 3, 1, '06/05/2010'),
(3, 2, 1, '09/09/2010'),
(3, 5, 4, '05/05/2010'),
(4, 1, 4, '05/05/2010'),
(4, 3, 1, '05/05/2010');

--Task 2.1
SELECT _school.name AS school, _publisher.name AS publisher, COUNT(*) FROM loan as _loan
    JOIN teacher AS _teacher ON _teacher.id = _loan.teacherId
    JOIN school AS _school ON _school.id = _teacher.schoolId
    JOIN book AS _book ON _book.id = _loan.bookId
    JOIN publisher AS _publisher ON _publisher.id = _book.publisherId
GROUP BY (_school.id, _publisher.id);
--Task 2.2
SELECT _school.name AS school, _book.name AS book, _teacher.name AS teacher FROM loan as _loan
    JOIN teacher AS _teacher ON _teacher.id = _loan.teacherId
    JOIN school AS _school ON _school.id = _teacher.schoolId
    JOIN book AS _book ON _book.id = _loan.bookId
    JOIN publisher AS _publisher ON _publisher.id = _book.publisherId
    JOIN (SELECT _school.id, MIN(_loan.loanDate) FROM loan as _loan 
			JOIN teacher AS _teacher ON _teacher.id = _loan.teacherId
            JOIN school AS _school ON _school.id = _teacher.schoolId
        GROUP BY _school.id
    ) AS m ON m.id = _school.id WHERE _loan.loanDate = m.min;