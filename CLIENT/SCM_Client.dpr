program SCM_Client;

uses
  System.StartUpCopy,
  FMX.Forms,
  frmClientMain in 'frmClientMain.pas' {HeaderFooterForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(THeaderFooterForm, HeaderFooterForm);
  Application.Run;
end.
