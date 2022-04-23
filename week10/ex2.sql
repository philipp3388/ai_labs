CREATE TABLE users
(
    username   VARCHAR(40)  PRIMARY KEY  NOT NULL,
    fullname VARCHAR(100)    NOT NULL,
    balance INTEGER,
    group_id INTEGER NOT NULL

);


INSERT INTO accounts (username, fullname, balance, group_id) 
              VALUES ('jones', 'Alice Jones', 82, 1),
                     ('bitdiddle', 'Ben Bitdiddle', 65, 1),
                     ('mike', 'Michael Dole', 73, 2),
                     ('alyssa', 'Alyssa P. Hacker', 79, 3),
                     ('bbrown', 'Bob Brown', 100, 3);