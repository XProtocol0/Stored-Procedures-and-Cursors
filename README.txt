To Run scripts

1. Open MySQL Workbench
2. Connect to your database instance
3. use <your database name>
4. Open any of q1,q2,q3,q4,q5 scripts
5. Execute them

q1.sql
- Returns all subscribers names
To use: call ListAllSubscribers;

q2.sql
- Returns shows watched by a subscriber along with their watch time.
To use: call GetWatchHistoryBySubscriber(1); 
        - 1 is SubscriberID
q3.sql
- Adds new subscriber in subscriber table
To use: call AddSubscriberIfNotExists('Ram');

q4.sql
- Returns only subscribers who have watched some show along with show title and duration
To use: call SendWatchTimeReport;

q5.sql
- Returns subscriber along with watch time details of each show on database
To use: call SendAllWatchTimeReport;

Git Repo Link: https://github.com/XProtocol0/Stored-Procedures-and-Cursors