DELIMITER $$

CREATE PROCEDURE ListAllSubscribers()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE sub_name VARCHAR(100);

    -- Cursor to fetch all subscriber names
    DECLARE cur CURSOR FOR
        SELECT SubscriberName
        FROM Subscribers;

    -- Handler to detect end of cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Create a temporary table for output
    CREATE TEMPORARY TABLE IF NOT EXISTS tmp_subscribers (
        SubscriberName VARCHAR(100)
    );

    -- Clear old data if the table already exists in this session
    TRUNCATE tmp_subscribers;

    -- Open the cursor
    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO sub_name;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Insert into the temporary table
        INSERT INTO tmp_subscribers (SubscriberName) VALUES (sub_name);
    END LOOP;

    -- Close the cursor
    CLOSE cur;

    -- Output single table
    SELECT * FROM tmp_subscribers;
END$$

DELIMITER ;

call ListAllSubscribers;
