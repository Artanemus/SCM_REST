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
    Left = 128
    Top = 64
  end
  object qrySessions: TFDQuery
    Connection = scmConnection
    Left = 128
    Top = 136
  end
end
