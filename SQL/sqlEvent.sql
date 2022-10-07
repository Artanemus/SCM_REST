USE SwimClubMeet;

DECLARE @SessionID AS INTEGER;

SET @SessionID = 53; -- :SESSIONID

SELECT [EventID],
       EventNum,
       [Event].[Caption] AS EventStr,
       CONCAT([Distance].[Caption], ' ', [Stroke].[Caption]) AS DistStrokeStr
FROM [SwimClubMeet].[dbo].[Event]
    LEFT JOIN Stroke
        ON Event.StrokeID = Stroke.StrokeID
    LEFT JOIN Distance
        ON Event.DistanceID = Distance.DistanceID
WHERE SessionID = @SessionID
ORDER BY EventNum ASC;

