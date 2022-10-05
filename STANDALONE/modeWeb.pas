unit modeWeb;

interface

uses
  System.SysUtils, System.Classes, Web.HTTPApp, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TscmWeb = class(TWebModule)
    scmConnection: TFDConnection;
    qrySessions: TFDQuery;
    procedure WebModDefaultHandlerAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModscmSessionsAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
  private
    { Private declarations }
  procedure SessionsGet( Request: TWebRequest; Response: TWebResponse);
  public
    { Public declarations }
  end;

var
  WebModuleClass: TComponentClass = TscmWeb;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TscmWeb.SessionsGet(Request: TWebRequest; Response: TWebResponse);
var
a: TJSONArray;
c: TJSONObject;
begin
  // load query parameters
  if Request.QueryFields.Count > 0 then
  begin
    qrySessions.SQL.Text := 'Select * from Session';
    qrySessions.Params.ParamByName('SessionID').AsInteger := Request.QueryFields.Values['sessID'];
  end
  else begin
    qrySessions.SQL.Text := 'Select * from Session';
  end;

end;

procedure TscmWeb.WebModDefaultHandlerAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Response.Content :=
    '<html>' +
    '<head><title>SCM REST Server</title></head>' +
    '<body>SwimClubMeet - Web Server Application</body>' +
    '</html>';
end;

procedure TscmWeb.WebModscmSessionsAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Handled := true;
  case Request.MethodType of
//    mtAny: ;
    mtGet: SessionsGet(Request, Response);
//    mtPut: SessionsPut(Request, Response);
//    mtPost: ;
//    mtHead: ;
//    mtDelete: ;
//    mtPatch: ;
else begin
  Response.StatusCode := 400; // bad request error code
  Response.SendResponse;
end;
  end;


end;

end.
