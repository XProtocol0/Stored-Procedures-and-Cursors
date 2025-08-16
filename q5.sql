DELIMITER $$

CREATE PROCEDURE SendAllWatchTimeReport()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE sub_id INT;
    DECLARE sub_name VARCHAR(100);

    DECLARE cur CURSOR FOR
        SELECT SubscriberID, SubscriberName FROM Subscribers;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    DROP TEMPORARY TABLE IF EXISTS tmp_watch_report;
    CREATE TEMPORARY TABLE tmp_watch_report (
        SubscriberID INT,
        SubscriberName VARCHAR(100),
        ShowID INT,
        ShowTitle VARCHAR(100),
        WatchTime INT
    );

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO sub_id, sub_name;
        IF done THEN
            LEAVE read_loop;
        END IF;

        INSERT INTO tmp_watch_report (SubscriberID, SubscriberName, ShowID, ShowTitle, WatchTime)
        SELECT 
            sub_id,
            sub_name,
            s.ShowID,
            s.Title,
            IFNULL(wh.WatchTime, 0)  -- replace NULL with 0
        FROM Shows s
        LEFT JOIN WatchHistory wh 
            ON s.ShowID = wh.ShowID 
            AND wh.SubscriberID = sub_id;
    END LOOP;

    CLOSE cur;

    SELECT * FROM tmp_watch_report;
END$$

DELIMITER ;

call SendAllWatchTimeReport;