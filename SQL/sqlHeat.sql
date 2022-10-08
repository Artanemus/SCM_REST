USE SwimClubMeet;

DECLARE @EventID AS INTEGER;
DECLARE @HeatID AS INTEGER;

SET @EventID = 53;
SET @HeatID = 0; -- 126

IF @HeatID = 0
    SELECT [HeatIndividual].[HeatID]
         , [HeatNum]
         , Lane
         --, Entrant.MemberID
         , CONCAT(Member.FirstName, ' ', UPPER(Member.LastName)) AS FName
         , dbo.SwimTimeToString(Entrant.RaceTime) AS RaceTime
    FROM [SwimClubMeet].[dbo].[HeatIndividual]
        LEFT JOIN Entrant
            ON HeatIndividual.HeatID = Entrant.HeatID
        LEFT JOIN Member
            ON Entrant.MemberID = Member.MemberID
    WHERE EventID = @EventID
    ORDER BY HeatNum DESC, Lane ASC;
ELSE
    SELECT [HeatIndividual].[HeatID]
         , [HeatNum]
         , Lane
         --, Entrant.MemberID
         , Entrant.MemberID
         , CONCAT(Member.FirstName, ' ', UPPER(Member.LastName)) AS FName
         , dbo.SwimTimeToString(Entrant.RaceTime) AS RaceTime
    FROM [SwimClubMeet].[dbo].[HeatIndividual]
        LEFT JOIN Entrant
            ON HeatIndividual.HeatID = Entrant.HeatID
        LEFT JOIN Member
            ON Entrant.MemberID = Member.MemberID
    WHERE EventID = @EventID
          AND [HeatIndividual].[HeatID] = @HeatID
    ORDER BY HeatNum DESC, Lane ASC;

