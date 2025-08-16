DELIMITER //

CREATE PROCEDURE GetWatchHistoryBySubscriber(IN p_sub_id INT)
BEGIN
    SELECT 
        sh.ShowID,
        sh.Title,
        sh.Genre,
        sh.ReleaseYear,
        wh.WatchTime
    FROM WatchHistory AS wh
    INNER JOIN Shows AS sh 
        ON wh.ShowID = sh.ShowID
    WHERE wh.SubscriberID = p_sub_id;
END //

DELIMITER ;

call GetWatchHistoryBySubscriber(1);