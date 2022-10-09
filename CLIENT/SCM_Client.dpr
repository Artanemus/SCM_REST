program SCM_Client;

uses
  System.StartUpCopy,
  FMX.Forms,
  frmClientMain in 'frmClientMain.pas' {ClientMain};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TClientMain, ClientMain);
  Application.Run;
end.
