object scmWeb: TscmWeb
  OldCreateOrder = False
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
      PathInfo = '/sessid'
      OnAction = WebEventAction
    end>
  Height = 524
  Width = 675
  object qrySessions: TFDQuery
    Active = True
    Connection = scmRAW
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
  object qryEvents: TFDQuery
    Active = True
    Connection = scmRAW
    SQL.Strings = (
      'USE SwimClubMeet;'
      ''
      'DECLARE @SessionID AS INTEGER;'
      ''
      'SET @SessionID = :SESSIONID; -- 53; -- '
      ''
      'SELECT [EventID],'
      '       EventNum,'
      '       [Event].[Caption] AS EventStr,'
      
        '       CONCAT([Distance].[Caption], '#39' '#39', [Stroke].[Caption]) AS ' +
        'DistStrokeStr'
      'FROM [SwimClubMeet].[dbo].[Event]'
      '    LEFT JOIN Stroke'
      '        ON Event.StrokeID = Stroke.StrokeID'
      '    LEFT JOIN Distance'
      '        ON Event.DistanceID = Distance.DistanceID'
      'WHERE SessionID = @SessionID'
      'ORDER BY EventNum ASC;')
    Left = 80
    Top = 216
    ParamData = <
      item
        Name = 'SESSIONID'
        DataType = ftInteger
        ParamType = ptInput
        Value = 53
      end>
  end
  object scmRAW: TFDConnection
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
end
