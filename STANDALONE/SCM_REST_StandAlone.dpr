program SCM_REST_StandAlone;
{$APPTYPE GUI}

uses
  Vcl.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  frmMain in 'frmMain.pas' {Main},
  modWeb in 'modWeb.pas' {scmWeb: TWebModule};

{$R *.res}

begin
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  Application.CreateForm(TMain, Main);
  Application.Run;
end.
