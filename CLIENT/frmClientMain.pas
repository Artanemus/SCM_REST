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
  FireDAC.Comp.Client, FMX.ScrollBox, FMX.Grid, FMX.ListView, Data.FireDACJSONReflect,
  REST.Response.Adapter, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, Data.Bind.DBScope, Fmx.Bind.Grid,
  FMX.Layouts, Data.Bind.Grid;

type
  THeaderFooterForm = class(TForm)
    Header: TToolBar;
    Footer: TToolBar;
    HeaderLabel: TLabel;
    RESTClient: TRESTClient;
    RESTRequest: TRESTRequest;
    RESTResponse: TRESTResponse;
    Button1: TButton;
    FDMemSessions: TFDMemTable;
    RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter;
    DataSource1: TDataSource;
    StringGrid2: TStringGrid;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    FDMemSessionsSessionID: TWideStringField;
    FDMemSessionsCaption: TWideStringField;
    FDMemSessionsDateStr: TWideStringField;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    Layout1: TLayout;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
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

procedure THeaderFooterForm.Button1Click(Sender: TObject);
begin
  RESTRequest.Execute;
end;

procedure THeaderFooterForm.Button2Click(Sender: TObject);
var
i: integer;
begin
  // get the session id from the string grid
  //StringGrid2.
  i  := BindSourceDB1.DataSet.FieldByName('SessionID').AsInteger;
  REST
end;

procedure THeaderFooterForm.GetSessions;
//var
    //To use this type you need to include a new unit in the uses section: Data.FireDACJSONReflect.
//    LDataSetList: TFDJSONDataSets;
begin
    // It empties the memory table of any existing data before adding the new context.
    FDMemSessions.Close;
    // Get dataset list containing Employee names
//    LDataSetList := RESTClient.ServerMethods1Client.GetSessions;
    // Reads the first and only dataset, number 0.
//    FDMemSessions.AppendData(
//      TFDJSONDataSetsReader.GetListValue(LDataSetList, 0));
      //It uses a reader from The "TFDJSONDataSetsWriter" class to populate the memory table from the dataset list class.

    FDMemSessions.Open;
end;

end.
