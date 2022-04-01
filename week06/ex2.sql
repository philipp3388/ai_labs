
--DROP TABLE AuthorPub;
--DROP TABLE Pub;
--DROP TABLE Book;
--DROP TABLE Author;

CREATE TABLE Author (
	author_id INT NOT NULL PRIMARY KEY,
	first_name VARCHAR(255),
	last_name VARCHAR(255)
);

CREATE TABLE Book (
	book_id INT NOT NULL PRIMARY KEY,
	book_title VARCHAR(255),
	month VARCHAR(255), 
	year INT,
	editor INT,
	FOREIGN KEY (editor) REFERENCES Author(author_id)
);

CREATE TABLE Pub (
	pub_id INT NOT NULL PRIMARY KEY,
	title VARCHAR(255),
	book_id INT,
	FOREIGN KEY (book_id) REFERENCES Book(book_id)
);

CREATE TABLE AuthorPub (
	author_id INT,
	FOREIGN KEY (author_id) REFERENCES Author(author_id),
	pub_id INT,
	FOREIGN KEY (pub_id) REFERENCES Pub(pub_id),
	author_position INT
);



INSERT INTO Author(author_id, first_name, last_name) VALUES
(1, 'John', 'McCarthy'),
(2, 'Dennis', 'Ritchie'),
(3, 'Ken', 'Thompson'),
(4, 'Claude', 'Shannon'),
(5, 'Alan', 'Turing'),
(6, 'Alonzo', 'Church'),
(7, 'Perry', 'White'),
(8, 'Moshe', 'Vardi'),
(9, 'Roy', 'Batty');

INSERT INTO Book(book_id, book_title, month, year, editor) VALUES
(1, 'CACM', 'April', 1960, 8),
(2, 'CACM', 'July', 1974, 8),
(3, 'BTS' , 'July', 1936, 2),
(4, 'MLS' , 'November', 1936, 7),
(5, 'Mind', 'October', 1950, NULL),
(6, 'AMS' , 'Month', 1941, NULL),
(7, 'AAAI', 'July', 2012, 9),
(8, 'NIPS', 'July', 2012, 9);

INSERT INTO Pub(pub_id, title, book_id) VALUES
(1, 'LISP', 1),
(2, 'Unix', 2),
(3, 'Info Theory', 3),
(4, 'Turing Machines', 4),
(5, 'Turing Test', 5),
(6, 'Lambda Calculus', 6);

INSERT INTO AuthorPub(author_id, pub_id, author_position) VALUES
(1, 1, 1),
(2, 2, 1),
(3, 2, 2),
(4, 3, 1),
(5, 4, 1),
(5, 5, 1),
(6, 6, 1);

--TASK 1
SELECT * FROM Author INNER JOIN Book ON Author.author_id=Book.editor;

--TASK 2-- For some reason NOT IN is not working properly. Hence why I am using IN (NOT IN) construction.
SELECT first_name, last_name FROM Author WHERE author_id NOT IN (SELECT author_id FROM Author WHERE author_id IN (SELECT editor FROM Book));

--TASK 3
SELECT author_id FROM Author WHERE author_id NOT IN 
(SELECT author_id FROM Author WHERE author_id IN (SELECT editor FROM Book));

