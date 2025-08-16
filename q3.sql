DELIMITER //

CREATE PROCEDURE AddSubscriberIfNotExists(IN subName VARCHAR(100))
BEGIN
    DECLARE existing_count INT;

    SELECT COUNT(*) INTO existing_count
    FROM Subscribers
    WHERE SubscriberName = subName;

    IF existing_count = 0 THEN
        INSERT INTO Subscribers (SubscriberName, SubscriptionDate)
        VALUES (subName, CURDATE());
    END IF;
END //

DELIMITER ;

call AddSubscriberIfNotExists('Ram');