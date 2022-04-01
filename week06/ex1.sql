--DROP TABLE Catalog;
--DROP TABLE Parts;
--DROP TABLE Suppliers;

CREATE TABLE Parts (
	pid INT NOT NULL PRIMARY KEY,
	pname VARCHAR(255),
	color VARCHAR(255)
);

CREATE TABLE Suppliers (
	sid INT NOT NULL PRIMARY KEY,
	sname VARCHAR(255),
	address VARCHAR(255)
);

CREATE TABLE Catalog (
	sid INT NOT NULL,
	FOREIGN KEY(sid) references Suppliers(sid),
	pid INT NOT NULL, 
	FOREIGN KEY (pid) references Parts(pid),
	cost REAL
);

INSERT INTO Suppliers (sid, sname, address)
VALUES (1, 'Yosemite Sham',     E'Devil\'s canyon, AZ'),
       (2, 'Wiley E.Coyote',    'RR Asylum, NV'),
       (3, 'Elmer Fudd',        'Carrot Patch, MN');

INSERT INTO Parts (pid, pname, color)
VALUES (1, 'Red1',      'Red'),
       (2, 'Red2',      'Red'),
       (3, 'Green1',    'Green'),
       (4, 'Blue1',     'Blue'),
       (5, 'Red3',      'Red');

INSERT INTO Catalog (sid, pid, cost)
VALUES (1, 1, 10), 
	   (1, 2, 20), 
	   (1, 3, 30), 
	   (1, 4, 40), 
	   (1, 5, 50), 
	   (2, 1, 9), 
	   (2, 3, 34), 
	   (2, 5, 48);
	
	
--TASK 1   
SELECT DISTINCT S.sname FROM Suppliers S, Parts P, Catalog C 
WHERE P.color = 'Red' AND C.pid = P.pid AND C.sid = S.sid;	   

--TASK 2
SELECT DISTINCT C.sid 
FROM Catalog C, Parts P 
WHERE (P.color = 'Red' OR P.color = 'Green') AND P.pid = C.pid;

--TASK 3
SELECT DISTINCT S.sid 
FROM Suppliers S 
WHERE S.address = '221 Packer street' OR S.sid IN (
    SELECT C.sid FROM Parts P, Catalog C 
    WHERE P.color = 'Red' AND P.pid = C.pid
);

--TASK 4
SELECT DISTINCT C.sid 
FROM Catalog C 
WHERE NOT EXISTS (
    SELECT P.pid FROM Parts P WHERE 
      (P.color = 'Red' OR P.color = 'Green') 
      AND (NOT EXISTS (SELECT 
      	C1.sid FROM Catalog C1 
          WHERE C1.sid = C.sid AND C1.pid = P.pid
        )
      )
);

--TASK 5
SELECT DISTINCT C.sid FROM Catalog C 
WHERE (NOT EXISTS (SELECT P.pid FROM Parts P WHERE P.color = 'Red' AND (NOT EXISTS (
            SELECT C1.sid FROM Catalog C1 
            WHERE C1.sid = C.sid AND C1.pid = P.pid)))) 
  OR (NOT EXISTS (SELECT P1.pid 
      FROM Parts P1 
      WHERE P1.color = 'Green' AND (NOT EXISTS (SELECT C2.sid FROM Catalog C2 WHERE C2.sid = C.sid AND C2.pid = P1.pid))));
      
SELECT DISTINCT C1.sid, C2.sid 
FROM Catalog C1, Catalog C2 
WHERE C1.pid = C2.pid AND C1.sid != C2.sid AND C1.cost > C2.cost;

--TASK 6
SELECT DISTINCT C.pid 
FROM Catalog C 
WHERE EXISTS (SELECT C1.sid 
    FROM Catalog C1 
    WHERE C1.pid = C.pid AND C1.sid != C.sid);
    
--TASK 7
SELECT F.sid, F.color, AVG(F.cost) as avg_cost 
FROM (
SELECT p.color, C.cost, C.sid 
FROM Catalog C INNER JOIN parts p ON p.pid = C.pid 
    WHERE p.color = 'Red' OR p.color = 'Green'
) AS F 
GROUP BY F.sid, F.color;

--TASK 8
SELECT DISTINCT C1.sid FROM Catalog C1 WHERE (C1.cost >= 50);
