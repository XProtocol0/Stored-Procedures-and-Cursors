DELIMITER $$

CREATE PROCEDURE SendWatchTimeReport()
BEGIN
    -- Declare variables
    DECLARE done INT DEFAULT FALSE;
    DECLARE sub_id INT;
    DECLARE sub_name VARCHAR(100);

    -- Declare cursor
    DECLARE cur CURSOR FOR
        SELECT DISTINCT sb.SubscriberID, sb.SubscriberName
        FROM Subscribers sb
        JOIN WatchHistory wh ON sb.SubscriberID = wh.SubscriberID
        JOIN Shows sh ON sh.ShowID = wh.ShowID;

    -- Declare handler
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Create temporary table
    CREATE TEMPORARY TABLE IF NOT EXISTS tmp_watch_report (
        SubscriberID INT,
        SubscriberName VARCHAR(100),
        ShowID INT,
        ShowTitle VARCHAR(100),
        WatchTime INT
    );

    -- Clear old data
    TRUNCATE tmp_watch_report;

    -- Open cursor
    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO sub_id, sub_name;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Insert subscriber details + their watch history
        INSERT INTO tmp_watch_report (SubscriberID, SubscriberName, ShowID, ShowTitle, WatchTime)
        SELECT sub_id, sub_name, wh.ShowID, sh.Title, wh.WatchTime
        FROM WatchHistory wh
        JOIN Shows sh ON sh.ShowID = wh.ShowID
        WHERE wh.SubscriberID = sub_id;
    END LOOP;

    -- Close cursor
    CLOSE cur;

    -- Output final single table
    SELECT * FROM tmp_watch_report;
END$$

DELIMITER ;

call SendWatchTimeReport;
