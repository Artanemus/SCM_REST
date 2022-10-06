unit frmClientMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, REST.Types, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, System.Rtti, FMX.Grid.Style, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FMX.ScrollBox, FMX.Grid, FMX.ListView, Data.FireDACJSONReflect;

type
  THeaderFooterForm = class(TForm)
    Header: TToolBar;
    Footer: TToolBar;
    HeaderLabel: TLabel;
    RESTClient: TRESTClient;
    RESTRequest: TRESTRequest;
    RESTResponse: TRESTResponse;
    Button1: TButton;
    ListView1: TListView;
    StringGrid1: TStringGrid;
    FDMemSessions: TFDMemTable;
    FDMemTable1: TFDMemTable;
  private
    { Private declarations }
    procedure GetSessions();
  public
    { Public declarations }
  end;

var
  HeaderFooterForm: THeaderFooterForm;

implementation

{$R *.fmx}

{ THeaderFooterForm }

procedure THeaderFooterForm.GetSessions;
var
    //To use this type you need to include a new unit in the uses section: Data.FireDACJSONReflect.
    LDataSetList: TFDJSONDataSets;
begin
    // It empties the memory table of any existing data before adding the new context.
    FDMemSessions.Close;
    // Get dataset list containing Employee names
    LDataSetList := RESTClient.ServerMethods1Client.GetSessions;
    // Reads the first and only dataset, number 0.
    FDMemSessions.AppendData(
      TFDJSONDataSetsReader.GetListValue(LDataSetList, 0));
      //It uses a reader from The "TFDJSONDataSetsWriter" class to populate the memory table from the dataset list class.

    FDMemSessions.Open;
end;

end.
