object scmWeb: TscmWeb
  OldCreateOrder = False
  OnCreate = WebModuleCreate
  Actions = <
    item
      Default = True
      Name = 'DefaultHandler'
      PathInfo = '/'
      OnAction = WebModDefaultHandlerAction
    end
    item
      Name = 'actnSessions'
      PathInfo = '/sessions'
      OnAction = WebSessionsAction
    end
    item
      Name = 'actnEvents'
      PathInfo = '/events'
      OnAction = WebEventsAction
    end
    item
      Name = 'actnHeats'
      PathInfo = '/heats'
      OnAction = WebHeatsAction
    end>
  Height = 524
  Width = 531
  object qrySession: TFDQuery
    Connection = scmConnection
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate]
    UpdateOptions.EnableDelete = False
    UpdateOptions.EnableInsert = False
    UpdateOptions.EnableUpdate = False
    SQL.Strings = (
      'USE SwimClubMeet;'
      ''
      'DECLARE @SessionID AS INTEGER;'
      ''
      'SET @SESSIONID = :SESSIONID; --53;'
      ''
      'IF @SESSIONID = 0'
      '    SELECT [SessionID],'
      '           [Caption],'
      
        '           FORMAT([SessionStart],'#39'dddd MMMM yyyy'#39', '#39'eng-au'#39') AS ' +
        'DateStr --,'
      '           --[SwimClubID],'
      '           --[SessionStatusID]'
      '    FROM [SwimClubMeet].[dbo].[Session]'
      '    WHERE [SessionStatusID] <> 2'
      '    order by SessionStart DESC;'
      'ELSE'
      '    SELECT [SessionID],'
      '           [Caption],'
      
        '           FORMAT([SessionStart],'#39'dddd MMMM yyyy'#39', '#39'eng-au'#39') AS ' +
        'DateStr --,'
      '           --[SwimClubID],'
      '           --[SessionStatusID]'
      '    FROM [SwimClubMeet].[dbo].[Session]'
      '    WHERE [SessionStatusID] <> 2 AND SessionID = @SessionID'
      '    order by SessionStart DESC;'
      '')
    Left = 80
    Top = 152
    ParamData = <
      item
        Name = 'SESSIONID'
        DataType = ftInteger
        ParamType = ptInput
        Value = 53
      end>
  end
  object qryEvent: TFDQuery
    Connection = scmConnection
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate]
    UpdateOptions.EnableDelete = False
    UpdateOptions.EnableInsert = False
    UpdateOptions.EnableUpdate = False
    SQL.Strings = (
      'USE SwimClubMeet;'
      ''
      'DECLARE @SessionID AS INTEGER;'
      'DECLARE @EventID AS INTEGER;'
      ''
      'SET @SessionID = :SESSIONID -- 53'
      'SET @EventID = :EVENTID -- 741'
      ''
      ''
      'IF @EventID = 0'
      '    SELECT [EventID]'
      '         , EventNum'
      '         , [Event].[Caption] AS EventStr'
      
        '         , CONCAT([Distance].[Caption], '#39' '#39', [Stroke].[Caption])' +
        ' AS DistStrokeStr'
      '    FROM [SwimClubMeet].[dbo].[Event]'
      '        LEFT JOIN Stroke'
      '            ON Event.StrokeID = Stroke.StrokeID'
      '        LEFT JOIN Distance'
      '            ON Event.DistanceID = Distance.DistanceID'
      '    WHERE SessionID = @SessionID'
      '    ORDER BY EventNum ASC;'
      ''
      'ELSE'
      '    SELECT [EventID]'
      '         , EventNum'
      '         , [Event].[Caption] AS EventStr'
      
        '         , CONCAT([Distance].[Caption], '#39' '#39', [Stroke].[Caption])' +
        ' AS DistStrokeStr'
      '    FROM [SwimClubMeet].[dbo].[Event]'
      '        LEFT JOIN Stroke'
      '            ON Event.StrokeID = Stroke.StrokeID'
      '        LEFT JOIN Distance'
      '            ON Event.DistanceID = Distance.DistanceID'
      '    WHERE SessionID = @SessionID'
      '          AND EventID = @EventID'
      '    ORDER BY EventNum ASC;')
    Left = 80
    Top = 216
    ParamData = <
      item
        Name = 'SESSIONID'
        DataType = ftInteger
        ParamType = ptInput
        Value = 53
      end
      item
        Name = 'EVENTID'
        DataType = ftInteger
        ParamType = ptInput
        Value = 0
      end>
  end
  object scmConnection: TFDConnection
    Params.Strings = (
      'Database=SwimClubMeet'
      'DriverID=MSSQL'
      'ApplicationName=SwimClubMeet'
      'MetaDefSchema=dbo'
      'OSAuthent=Yes'
      'Server=localhost\SQLEXPRESS'
      'Workstation=localhost\SQLEXPRESS')
    Connected = True
    LoginPrompt = False
    Left = 80
    Top = 96
  end
  object qryHeat: TFDQuery
    Connection = scmConnection
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate]
    UpdateOptions.EnableDelete = False
    UpdateOptions.EnableInsert = False
    UpdateOptions.EnableUpdate = False
    SQL.Strings = (
      'USE SwimClubMeet;'
      ''
      'DECLARE @EventID AS INTEGER;'
      'DECLARE @HeatID AS INTEGER;'
      ''
      'SET @EventID = :EVENTID; --53;'
      'SET @HeatID = :HEATID; --0; -- 126'
      ''
      'IF @HeatID = 0'
      '    SELECT [HeatIndividual].[HeatID]'
      '         , [HeatNum]'
      '         , Lane'
      '         , Entrant.MemberID'
      
        '         , CONCAT(Member.FirstName, '#39' '#39', UPPER(Member.LastName))' +
        ' AS FName'
      '         , dbo.SwimTimeToString(Entrant.RaceTime) AS RaceTime'
      '    FROM [SwimClubMeet].[dbo].[HeatIndividual]'
      '        LEFT JOIN Entrant'
      '            ON HeatIndividual.HeatID = Entrant.HeatID'
      '        LEFT JOIN Member'
      '            ON Entrant.MemberID = Member.MemberID'
      '    WHERE EventID = @EventID'
      '    ORDER BY HeatNum DESC, Lane ASC;'
      'ELSE'
      '    SELECT [HeatIndividual].[HeatID]'
      '         , [HeatNum]'
      '         , Lane'
      '         , Entrant.MemberID'
      
        '         , CONCAT(Member.FirstName, '#39' '#39', UPPER(Member.LastName))' +
        ' AS FName'
      '         , dbo.SwimTimeToString(Entrant.RaceTime) AS RaceTime'
      '    FROM [SwimClubMeet].[dbo].[HeatIndividual]'
      '        LEFT JOIN Entrant'
      '            ON HeatIndividual.HeatID = Entrant.HeatID'
      '        LEFT JOIN Member'
      '            ON Entrant.MemberID = Member.MemberID'
      '    WHERE EventID = @EventID'
      '          AND [HeatIndividual].[HeatID] = @HeatID'
      '    ORDER BY HeatNum DESC, Lane ASC;')
    Left = 80
    Top = 288
    ParamData = <
      item
        Name = 'EVENTID'
        DataType = ftInteger
        ParamType = ptInput
        Value = 53
      end
      item
        Name = 'HEATID'
        DataType = ftInteger
        ParamType = ptInput
        Value = 126
      end>
  end
end
