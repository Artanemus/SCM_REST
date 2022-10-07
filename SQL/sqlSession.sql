USE SwimClubMeet;

DECLARE @SessionID AS INTEGER;

SET @SESSIONID = 53;

IF @SESSIONID = 0
    SELECT [SessionID],
           [Caption],
           FORMAT([SessionStart],'dddd MMMM yyyy', 'eng-au') AS DateStr --,
    FROM [SwimClubMeet].[dbo].[Session]
    WHERE [SessionStatusID] <> 2
    ORDER BY SessionStart DESC;
ELSE
    SELECT [SessionID],
           [Caption],
           FORMAT([SessionStart],'dddd MMMM yyyy', 'eng-au') AS DateStr --,
    FROM [SwimClubMeet].[dbo].[Session]
    WHERE [SessionStatusID] <> 2 AND SessionID = @SessionID
    ORDER BY SessionStart DESC;

