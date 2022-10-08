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
    qrySession: TFDQuery;
    qryEvent: TFDQuery;
    scmRAW: TFDConnection;
    qryHeat: TFDQuery;
    procedure WebModDefaultHandlerAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WebSessionsAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WebEventsAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WebHeatsAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
  private
    { Private declarations }
    function GetDataSetSessions(const SessionID: integer): TFDJSONDataSets;
    function GetDataSetEvents(const SessionID: integer;
      const EventID: integer): TFDJSONDataSets;
    function GetDataSetHeats(const EventID: integer; const HeatID: integer)
      : TFDJSONDataSets;

    procedure SessionsGet(Request: TWebRequest; Response: TWebResponse);
    procedure EventsGet(Request: TWebRequest; Response: TWebResponse);
    procedure HeatsGet(Request: TWebRequest; Response: TWebResponse);
  public
    { Public declarations }
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
  sEvents = 'Events';
  sHeats = 'Heats';

procedure TscmWeb.EventsGet(Request: TWebRequest; Response: TWebResponse);
var
  a: TJSONArray;
  o: TJSONObject;
  i: integer;
begin
  if qryEvent.Active then
    qryEvent.Close;
  i := 0;

  // --------------------------------------------------------
  // Example web query:
  // --------------------------------------------------------
  // events?sessionid=53&eventid=126   - for a specific event
  // events?sesionid=53&eventid=0   - for all event

  // load query parameters
  if Request.QueryFields.Count > 0 then
  begin
    // asked for a specific Event
    i := StrToIntDef(Request.QueryFields.Values['sessionid'], 0);
    if (i = 0) then
    begin
      // ERROR ....
      // TODO: offer a explanation for the error to the caller
      Response.StatusCode := 400; // bad request error code
      Response.SendResponse;
      exit;
    end
    else
      qryEvent.Params.ParamByName('SESSIONID').AsInteger := i;
  end;

  if Request.QueryFields.Count > 1 then
  begin
    i := StrToIntDef(Request.QueryFields.Values['eventid'], 0);
    // if no heatid is given - get all heats for event.
    qryEvent.Params.ParamByName('EVENTID').AsInteger := i;
  end
  else
    qryEvent.Params.ParamByName('EVENTID').AsInteger := 0;


  qryEvent.Prepare;
  qryEvent.Open;
  if qryEvent.Active then
  begin
    if qryEvent.RecordCount > 0 then
    begin
      a := TJSONArray.Create;
      try
        qryEvent.First;
        while (not qryEvent.Eof) do
        begin
          o := TJSONObject.Create;
          o.AddPair('EventID',
            TJSONNumber.Create(qryEvent.FieldByName('EventID').AsInteger));
          o.AddPair('EventStr',
            TJSONString.Create(qryEvent.FieldByName('EventStr').AsString));
          o.AddPair('DistStrokeStr',
            TJSONString.Create(qryEvent.FieldByName('DistStrokeStr').AsString));
          a.AddElement(o);
          qryEvent.Next;
        end;
      finally
        Response.ContentType := 'application/json';
        Response.Content := a.ToString;
      end;
    end;
  end
end;

function TscmWeb.GetDataSetEvents(const SessionID: integer;
  const EventID: integer): TFDJSONDataSets;
begin
  // Clear active so that query will reexecute.
  qryEvent.Active := False;
  // valid ID required else empty dataset
  qryEvent.ParamByName('SESSIONID').AsInteger := SessionID;
  // EventID=0 ... show all events
  qryEvent.ParamByName('EVENTID').AsInteger := EventID;
  // Create dataset list
  Result := TFDJSONDataSets.Create;
  // Add session(s) dataset
  TFDJSONDataSetsWriter.ListAdd(Result, sSessions, qryEvent);
end;

function TscmWeb.GetDataSetHeats(const EventID: integer;
  const HeatID: integer): TFDJSONDataSets;
begin
  // Clear active so that query will reexecute.
  qryHeat.Active := False;
  // valid ID required else empty dataset
  qryHeat.ParamByName('EVENTID').AsInteger := EventID;
  // HeatID=0 ... show all heats
  qryHeat.ParamByName('HEATID').AsInteger := HeatID;
  // Create dataset list
  Result := TFDJSONDataSets.Create;
  // Add session(s) dataset
  TFDJSONDataSetsWriter.ListAdd(Result, sSessions, qryHeat);

end;

function TscmWeb.GetDataSetSessions(const SessionID: integer)
  : TFDJSONDataSets;
begin
  // Clear active so that query will reexecute.
  qrySession.Active := False;
  // SessionID=0 ... show all sessions
  qrySession.ParamByName('SESSIONID').AsInteger := SessionID;
  // Create dataset list
  Result := TFDJSONDataSets.Create;
  // Add session(s) dataset
  TFDJSONDataSetsWriter.ListAdd(Result, sSessions, qrySession);
end;

procedure TscmWeb.HeatsGet(Request: TWebRequest; Response: TWebResponse);
var
  a: TJSONArray;
  o: TJSONObject;
  i: integer;
begin
  if qryHeat.Active then
    qryHeat.Close;
  i := 0;
  // --------------------------------------------------------
  // Example web query:
  // --------------------------------------------------------
  // heats?eventid=53&heatid=126   - for a specific heat
  // heats?eventid=53&heatid=0   - for all heats in event

  // PART 1 :find  SwimClubMeet.dbo.Event.EventID
  if Request.QueryFields.Count > 0 then
  begin
    // Asked for a specific Event. If the named value is empty, i = 0;
    i := StrToIntDef(Request.QueryFields.Values['eventid'], 0);
    // if no eventid is given - then the request can't be performed.
    if (i = 0) then
    begin
      // ERROR ....
      // TODO: offer a explanation for the error to the caller
      Response.StatusCode := 400; // bad request error code
      Response.SendResponse;
      exit;
    end
    else
      qryHeat.Params.ParamByName('EVENTID').AsInteger := i;
  end;

  // PART TWO :find  SwimClubMeet.dbo.Heat.HeatID
  // Asked for a specific Heat :: if the named value is empty, i = 0;
  if Request.QueryFields.Count > 1 then
  begin
    i := StrToIntDef(Request.QueryFields.Values['heatid'], 0);
    // if no heatid is given - get all heats for event.
    qryHeat.Params.ParamByName('HEATID').AsInteger := i;
  end
  else
    qryHeat.Params.ParamByName('HEATID').AsInteger := 0;

  qryHeat.Prepare;
  qryHeat.Open;
  if qryHeat.Active then
  begin
    if qryHeat.RecordCount > 0 then
    begin
      a := TJSONArray.Create;
      try
        qryHeat.First;
        while (not qryHeat.Eof) do

(*
  SELECT [HeatIndividual].[HeatID]
         , [HeatNum]
         , Lane
         --, Entrant.MemberID
         , dbo.SwimTimeToString(Entrant.RaceTime) AS RaceTime
         , CONCAT(Member.FirstName, ' ', UPPER(Member.LastName)) AS FName
*)
        begin
          o := TJSONObject.Create;
          o.AddPair('HeatID', TJSONNumber.Create(qryHeat.FieldByName('HeatID')
            .AsInteger));
          o.AddPair('HeatNum', TJSONNumber.Create(qryHeat.FieldByName('HeatNum')
            .AsInteger));
          o.AddPair('FName',
            TJSONString.Create(qryHeat.FieldByName('FName').AsString));
          o.AddPair('RaceTime',
            TJSONString.Create(qryHeat.FieldByName('RaceTime').AsString));
          a.AddElement(o);
          qryHeat.Next;
        end;
      finally
        Response.ContentType := 'application/json';
        Response.Content := a.ToString;
      end;
    end;
  end
end;

procedure TscmWeb.WebSessionsAction(Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean);
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
  if qrySession.Active then
    qrySession.Close;
  i := 0;

  // --------------------------------------------------------
  // Example web query:
  // --------------------------------------------------------
  // sessions?sessionid=53 - for a specific session
  // sessions?sessionid=0  - for all sessions

  // load query parameters
  if Request.QueryFields.Count > 0 then
  begin
    // asked for a specific session
    i := StrToIntDef(Request.QueryFields.Values['sessionid'], 0);
    qrySession.Params.ParamByName('SESSIONID').AsInteger := i;
  end
  else
  begin
    // asked to show all sessions
    qrySession.Params.ParamByName('SESSIONID').AsInteger := 0;
  end;

  qrySession.Prepare;
  qrySession.Open;
  if qrySession.Active then
  begin
    if qrySession.RecordCount > 0 then
    begin
      a := TJSONArray.Create;
      try
        qrySession.First;
        while (not qrySession.Eof) do
        begin
          o := TJSONObject.Create;
          o.AddPair('SessionID',
            TJSONNumber.Create(qrySession.FieldByName('SessionID').AsInteger));
          o.AddPair('Caption',
            TJSONString.Create(qrySession.FieldByName('Caption').AsString));
          o.AddPair('DateStr',
            TJSONString.Create(qrySession.FieldByName('DateStr').AsString));
          a.AddElement(o);
          qrySession.Next;
        end;
      finally
        Response.ContentType := 'application/json';
        Response.Content := a.ToString;
      end;
    end;
  end
end;

procedure TscmWeb.WebEventsAction(Sender: TObject; Request: TWebRequest;
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

procedure TscmWeb.WebHeatsAction(Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean);
begin
  Handled := true;
  case Request.MethodType of
    // mtAny: ;
    mtGet:
      HeatsGet(Request, Response);
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
