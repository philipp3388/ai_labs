CREATE TABLE accounts
(
    id     SERIAL PRIMARY KEY NOT NULL,
    name   VARCHAR(40)        NOT NULL,
    credit INTEGER            NOT NULL
);


INSERT INTO accounts (name, credit) VALUES ('Account 1', 1000),
                                            ('Account 2', 1000),
                                            ('Account 3', 1000);


-- Performing Transactions between accounts

BEGIN;

SAVEPOINT PART1;

-- Transaction T1
UPDATE accounts SET credit = credit - 500
    WHERE name = 'Account 1';

UPDATE accounts  SET credit = credit + 500
    WHERE name = 'Account 3';

SAVEPOINT T_2;
-- Transaction T2
UPDATE accounts SET credit = credit - 700
    WHERE name = 'Account 2';
UPDATE accounts SET credit = credit + 700
    WHERE name = 'Account 1';

SAVEPOINT T_3;
-- Transaction T3
UPDATE accounts SET credit = credit - 100
    WHERE name = 'Account 2';
UPDATE accounts SET credit = credit + 100
    WHERE name = 'Account 3';

-- I can go back to any transaction

-- ROLLBACK TO PART1, T_2 ... ;

-- To save
--COMMIT;


-- PART 2

-- Updating table
ALTER TABLE accounts
ADD bank_name VARCHAR(20) DEFAULT NULL;
UPDATE accounts SET bank_name = 'SberBank' WHERE name = 'Account 1' or name = 'Account 3';
UPDATE accounts SET bank_name = 'Tinkoff' WHERE name = 'Account 2';

-- Create new account to store fees
INSERT INTO accounts (name, credit, bank_name)
VALUES ('Account 4', 0, NULL);



BEGIN;

SAVEPOINT PART2;

-- Transaction T1
UPDATE accounts SET credit = credit - 500
    WHERE name = 'Account 1';
UPDATE accounts SET credit = credit + 500
    WHERE name = 'Account 3';

-- Transaction T2
UPDATE accounts SET credit = credit - 730
    WHERE name = 'Account 2';
UPDATE accounts SET credit = credit + 700
    WHERE name = 'Account 1';
UPDATE accounts SET credit = credit + 30
    WHERE name = 'Account 4';

-- Transaction T3
UPDATE accounts SET credit = credit - 130
    WHERE name = 'Account 2';
UPDATE accounts SET credit = credit + 100
    WHERE name = 'Account 3';
UPDATE accounts SET credit = credit + 30
    WHERE name = 'Account 4';

-- ROLLBACK TO PART2

-- COMMIT;

-- PART 3


CREATE TABLE ledger
(
    id SERIAL  PRIMARY KEY NOT NULL,
    from_id VARCHAR(40)  REFERENCES accounts(name),
    to_id VARCHAR(40) REFERENCES accounts(name),
	fee INTEGER,
	amount INTEGER NOT NULL,
	transaction_datetime TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);


-- Inserting values will be like this:

BEGIN;

SAVEPOINT PART3;

-- Transaction T1
UPDATE accounts SET credit = credit - 500
    WHERE name = 'Account 1';
UPDATE accounts SET credit = credit + 500
    WHERE name = 'Account 3';

INSERT INTO ledger (from_id, to_id, fee, amount)
                    VALUES (1, 3, 0, 500);

-- Transaction T2
UPDATE accounts SET credit = credit - 730
    WHERE name = 'Account 2';
UPDATE accounts SET credit = credit + 700
    WHERE name = 'Account 1';
UPDATE accounts SET credit = credit + 30
    WHERE name = 'Account 4';

INSERT INTO ledger (from_id, to_id, fee, amount)
                    VALUES (2, 1, 30, 700);


-- Transaction T3
UPDATE accounts SET credit = credit - 130
    WHERE name = 'Account 2';
UPDATE accounts SET credit = credit + 100
    WHERE name = 'Account 3';
UPDATE accounts SET credit = credit + 30
    WHERE name = 'Account 4';

INSERT INTO ledger (from_id, to_id, fee, amount)
                    VALUES (2, 3, 30, 100);