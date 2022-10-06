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
      OnAction = WebModscmSessionsAction
    end>
  Height = 524
  Width = 675
  object scmConnection: TFDConnection
    Params.Strings = (
      'ConnectionDef=MSSQL_SwimClubMeet')
    Connected = True
    LoginPrompt = False
    Left = 80
    Top = 80
  end
  object qrySessions: TFDQuery
    Active = True
    Connection = scmConnection
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
      '    WHERE [SessionStatusID] <> 2;'
      'ELSE'
      '    SELECT [SessionID],'
      '           [Caption],'
      
        '           FORMAT([SessionStart],'#39'dddd MMMM yyyy'#39', '#39'eng-au'#39') AS ' +
        'DateStr --,'
      '           --[SwimClubID],'
      '           --[SessionStatusID]'
      '    FROM [SwimClubMeet].[dbo].[Session]'
      '    WHERE [SessionStatusID] <> 2 AND SessionID = @SessionID;'
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
end
