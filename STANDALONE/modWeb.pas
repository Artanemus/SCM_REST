unit modWeb;

interface

uses
  System.SysUtils, System.Classes, Web.HTTPApp, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Data.FireDACJSONReflect;

type
  TscmWeb = class(TWebModule)
    qrySessions: TFDQuery;
    qryEvents: TFDQuery;
    scmRAW: TFDConnection;
    procedure WebModDefaultHandlerAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WebSessionsAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WebEventAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
  private
    { Private declarations }
    procedure SessionsGet(Request: TWebRequest; Response: TWebResponse);
    procedure EventsGet(Request: TWebRequest; Response: TWebResponse);
  public
    { Public declarations }
    function GetSessions(const AID: string): TFDJSONDataSets;
  end;

var
  WebModuleClass: TComponentClass = TscmWeb;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

uses
  System.jSON, REST.jSON;

const
  sSessions = 'Sessions';

procedure TscmWeb.EventsGet(Request: TWebRequest; Response: TWebResponse);
var
  a: TJSONArray;
  o: TJSONObject;
  i: integer;
begin
  if qryEvents.Active then
    qryEvents.Close;
  i := 0;
  // load query parameters
  if Request.QueryFields.Count > 0 then
  begin
    // asked for a specific Event
    i := StrToIntDef(Request.QueryFields.Values['sessid'], 0);
    qryEvents.Params.ParamByName('SESSIONID').AsInteger := i;
  end;

  if (i = 0) then
  begin
    // ERROR ....
      Response.StatusCode := 400; // bad request error code
      Response.SendResponse;
  end;

  qryEvents.Prepare;
  qryEvents.Open;
  if qryEvents.Active then
  begin
    if qryEvents.RecordCount > 0 then
    begin
      a := TJSONArray.Create;
      try
        qryEvents.First;
        while (not qryEvents.Eof) do
        begin
          o := TJSONObject.Create;
          o.AddPair('EventID',
            TJSONNumber.Create(qryEvents.FieldByName('EventID').AsInteger));
          o.AddPair('EventStr',
            TJSONString.Create(qryEvents.FieldByName('EventStr').AsString));
          o.AddPair('DistStrokeStr',
            TJSONString.Create(qryEvents.FieldByName('DistStrokeStr').AsString));
          a.AddElement(o);
          qryEvents.Next;
        end;
      finally
        Response.ContentType := 'application/json';
        Response.Content := a.ToString;
      end;
    end;
  end
end;

function TscmWeb.GetSessions(const AID: string): TFDJSONDataSets;
begin
  // Clear active so that query will reexecute.
  qrySessions.Active := False;
  qrySessions.ParamByName('SESSIONID').AsInteger := StrToIntDef(AID, 0);

  // Create dataset list
  Result := TFDJSONDataSets.Create;
  // Add session(s) dataset
  TFDJSONDataSetsWriter.ListAdd(Result, sSessions, qrySessions);
end;

procedure TscmWeb.WebSessionsAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Handled := true;
  case Request.MethodType of
    // mtAny: ;
    mtGet:
      SessionsGet(Request, Response);
    // mtPut: SessionsPut(Request, Response);
    // mtPost: ;
    // mtHead: ;
    // mtDelete: ;
    // mtPatch: ;
  else
    begin
      Response.StatusCode := 400; // bad request error code
      Response.SendResponse;
    end;
  end;
end;

procedure TscmWeb.SessionsGet(Request: TWebRequest; Response: TWebResponse);
var
  a: TJSONArray;
  o: TJSONObject;
  i: integer;
begin
  if qrySessions.Active then
    qrySessions.Close;
  i := 0;
  // load query parameters
  if Request.QueryFields.Count > 0 then
  begin
    // asked for a specific session
    // i := StrToIntDef(Request.QueryFields.Values['sessid'], 0);
    qrySessions.Params.ParamByName('SESSIONID').AsInteger := i;
  end
  else
  begin
    // asked to show all sessions
    qrySessions.Params.ParamByName('SESSIONID').AsInteger := 0;
  end;

  qrySessions.Prepare;
  qrySessions.Open;
  if qrySessions.Active then
  begin
    if qrySessions.RecordCount > 0 then
    begin
      a := TJSONArray.Create;
      try
        qrySessions.First;
        while (not qrySessions.Eof) do
        begin
          o := TJSONObject.Create;
          o.AddPair('SessionID',
            TJSONNumber.Create(qrySessions.FieldByName('SessionID').AsInteger));
          o.AddPair('Caption',
            TJSONString.Create(qrySessions.FieldByName('Caption').AsString));
          o.AddPair('DateStr',
            TJSONString.Create(qrySessions.FieldByName('DateStr').AsString));
          a.AddElement(o);
          qrySessions.Next;
        end;
      finally
        Response.ContentType := 'application/json';
        Response.Content := a.ToString;
      end;
    end;
  end
end;

procedure TscmWeb.WebEventAction(Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean);
begin
  Handled := true;
  case Request.MethodType of
    // mtAny: ;
    mtGet:
      EventsGet(Request, Response);
    // mtPut: SessionsPut(Request, Response);
    // mtPost: ;
    // mtHead: ;
    // mtDelete: ;
    // mtPatch: ;
  else
    begin
      Response.StatusCode := 400; // bad request error code
      Response.SendResponse;
    end;
  end;
end;

procedure TscmWeb.WebModDefaultHandlerAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Response.Content := '<html>' + '<head><title>SCM REST Server</title></head>' +
    '<body>SwimClubMeet - Web Server Application</body>' + '</html>';
end;

end.
