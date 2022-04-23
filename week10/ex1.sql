CREATE TABLE accounts (
  id INT NOT NULL PRIMARY KEY,
  name VARCHAR(255),
  credit INT,
  currency VARCHAR(255)
);

INSERT INTO accounts (id, name, credit, currency)
VALUES (1, "Alice",   1000, "RUB"),
       (2, "BOB"  ,   1000, "RUB"),
       (3, "Charlie", 1000, "RUB");
       
-- Transactions:

START TRANSACTION;
SELECT @from = SUM(credit) FROM accounts WHERE id=1;
SELECT @to   = SUM(credit) FROM accounts WHERE id=3;
UPDATE accounts SET credit = @from - 500 WHERE id=1;
UPDATE accounts SET credit = @from + 500 WHERE id=3;
COMMIT;
ROLLBACK;

START TRANSACTION;
SELECT @from = SUM(credit) FROM accounts WHERE id=2;
SELECT @to   = SUM(credit) FROM accounts WHERE id=1;
UPDATE accounts SET credit = @from - 700 WHERE id=2;
UPDATE accounts SET credit = @from + 700 WHERE id=1;
COMMIT;
ROLLBACK;

START TRANSACTION;
SELECT @from = SUM(credit) FROM accounts WHERE id=2;
SELECT @to   = SUM(credit) FROM accounts WHERE id=3;
UPDATE accounts SET credit = @from - 100 WHERE id=2;
UPDATE accounts SET credit = @from + 100 WHERE id=3;
COMMIT;
ROLLBACK;
