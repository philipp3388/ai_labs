-- Create tables
CREATE TABLE "publisher" (
    "id" serial NOT NULL PRIMARY KEY,
    "name" text NOT NULL
);
CREATE TABLE "book" (
    "id" serial NOT NULL PRIMARY KEY,
    "name" text NOT NULL,
    "publisherId" integer NOT NULL REFERENCES publisher(id)
);
CREATE TABLE "school" (
    "id" serial NOT NULL PRIMARY KEY,
    "name" text NOT NULL
);
CREATE TABLE "room" (
    "id" serial NOT NULL PRIMARY KEY,
    "name" text NOT NULL
);
CREATE TABLE "teacher" (
    "id" serial NOT NULL PRIMARY KEY,
    "name" text NOT NULL,
    "schoolId" integer NOT NULL REFERENCES school(id),
    "roomId" integer NOT NULL REFERENCES room(id),
    "grade" smallint NOT NULL
);
CREATE TABLE "course" (
    "id" serial NOT NULL PRIMARY KEY,
    "name" text NOT NULL
);
CREATE TABLE "loan" (
    "id" serial NOT NULL PRIMARY KEY,
    "teacherId" integer NOT NULL REFERENCES teacher(id),
    "courseId" integer NOT NULL REFERENCES course(id),
    "bookId" integer NOT NULL REFERENCES book(id),
    "loanDate" date NOT NULL
);

-- Fill data
INSERT INTO "publisher" ("name")
VALUES ('BOA Editions'),
    ('Taylor & Francis Publishing'),
    ('Prentice Hall'),
    ('McGraw Hill');
INSERT INTO "book" ("name", "publisherId")
VALUES ('Learning and teaching in early childhood', 1),
    ('Preschool,N56', 2),
    ('Early Childhood Education N9', 3),
    ('Know how to educate: guide for Parents', 4);
INSERT INTO "school" ("name")
VALUES ('Horizon Education Institute'),
    ('Bright Institution');
INSERT INTO "room" ("name")
VALUES ('1.A01'),
    ('1.B01'),
    ('2.B01');
INSERT INTO "teacher" ("name", "schoolId", "roomId", "grade")
VALUES ('Chad Russell', 1, 1, 1),
    ('E.F.Codd', 1, 2, 1),
    ('Jones Smith', 1, 1, 2),
    ('Adam Baker', 2, 3, 1);
INSERT INTO "course" ("name")
VALUES ('Logical thinking'),
    ('Wrtting'),
    ('Numerical Thinking'),
    ('Spatial, Temporal and Causal Thinking'),
    ('English');
INSERT INTO "loan" ("teacherId", "courseId", "bookId", "loanDate")
VALUES (1, 1, 1, '09/09/2010'),
    (1, 2, 2, '05/05/2010'),
    (1, 3, 1, '05/05/2010'),
    (2, 4, 3, '06/05/2010'),
    (2, 3, 1, '06/05/2010'),
    (3, 2, 1, '09/09/2010'),
    (3, 5, 4, '05/05/2010'),
    (4, 1, 4, '05/05/2010'),
    (4, 3, 1, '05/05/2010');

-- 1st query
SELECT s.name AS "school",
    p.name AS "publisher",
    COUNT(*)
FROM loan as l
    JOIN teacher AS t ON t.id = l."teacherId"
    JOIN school AS s ON s.id = t."schoolId"
    JOIN book AS b ON b.id = l."bookId"
    JOIN publisher AS p ON p.id = b."publisherId"
GROUP BY (s.id, p.id);

--2nd query
SELECT s.name AS "school",
    b.name AS "book",
    t.name AS "teacher"
FROM loan as l
    JOIN teacher AS t ON t.id = l."teacherId"
    JOIN school AS s ON s.id = t."schoolId"
    JOIN book AS b ON b.id = l."bookId"
    JOIN publisher AS p ON p.id = b."publisherId"
    JOIN (
        SELECT s.id,
            MIN(l."loanDate")
        FROM loan as l
            JOIN teacher AS t ON t.id = l."teacherId"
            JOIN school AS s ON s.id = t."schoolId"
        GROUP BY s.id
    ) AS m ON m.id = s.id
WHERE l."loanDate" = m.min;
