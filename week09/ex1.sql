CREATE OR REPLACE FUNCTION addr_lookup(substr VARCHAR(256), city_id_from INT, city_id_to int) RETURNS TABLE(address_id INT, address Address.address % type)

AS $$ DECLARE addr_regex VARCHAR(256):= '%' || substr || '%'; 
BEGIN
	ALTER TABLE Address ADD COLUMN IF NOT EXISTS latitude REAL;
	ALTER TABLE Address ADD COLUMN IF NOT EXISTS longitude REAL;

	RETURN QUERY SELECT A.address_id, A.address FROM Address A WHERE A.address LIKE addr_regex AND A.address_id BETWEEN city_id_from AND city_id_to;
END; $$ language plpgsql;

SELECT * FROM addr_lookup('11', 400, 600);

UPDATE ADDRESS SET latitude=34, longitude=999 WHERE address_id = 1;