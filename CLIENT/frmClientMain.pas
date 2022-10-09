unit frmClientMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, REST.Types, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, System.Rtti, FMX.Grid.Style, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FMX.ScrollBox, FMX.Grid, FMX.ListView,
  Data.FireDACJSONReflect,
  REST.Response.Adapter, System.Bindings.Outputs, FMX.Bind.Editors,
  Data.Bind.EngExt, FMX.Bind.DBEngExt, Data.Bind.DBScope, FMX.Bind.Grid,
  FMX.Layouts, Data.Bind.Grid, FMX.TabControl;

type
  TClientMain = class(TForm)
    Header: TToolBar;
    Footer: TToolBar;
    HeaderLabel: TLabel;
    RESTClientSess: TRESTClient;
    RESTRequestSess: TRESTRequest;
    RESTResponseSess: TRESTResponse;
    btnSession: TButton;
    FDMemSessions: TFDMemTable;
    RESTResponseAdapterSess: TRESTResponseDataSetAdapter;
    DSSessions: TDataSource;
    strGridSessions: TStringGrid;
    BindSourceSess: TBindSourceDB;
    BindingsList1: TBindingsList;
    FDMemSessionsSessionID: TWideStringField;
    FDMemSessionsCaption: TWideStringField;
    FDMemSessionsDateStr: TWideStringField;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    Layout1: TLayout;
    btnEvent: TButton;
    btnHeat: TButton;
    TabControl: TTabControl;
    tabSession: TTabItem;
    tabEvents: TTabItem;
    tabHeat: TTabItem;
    strGridEvents: TStringGrid;
    strGridHeats: TStringGrid;
    RESTClientEv: TRESTClient;
    RESTRequestEv: TRESTRequest;
    RESTResponseEv: TRESTResponse;
    FDMemEvents: TFDMemTable;
    DSEvents: TDataSource;
    RESTResponseDSAdapterEv: TRESTResponseDataSetAdapter;
    BindSourceEv: TBindSourceDB;
    LinkGridToDataSourceBindSourceDB12: TLinkGridToDataSource;
    RESTClientHeat: TRESTClient;
    RESTRequestHeat: TRESTRequest;
    RESTResponseHeat: TRESTResponse;
    FDMemHeats: TFDMemTable;
    DSHeats: TDataSource;
    RESTResponseAdapterHeat: TRESTResponseDataSetAdapter;
    BindSourceHeat: TBindSourceDB;
    LinkGridToDataSourceBindSourceDB13: TLinkGridToDataSource;
    procedure btnSessionClick(Sender: TObject);
    procedure btnEventClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnHeatClick(Sender: TObject);
  private
    { Private declarations }
    currSessionID, currEventID, currHeatID: integer;
    procedure GetSessions();
  public
    { Public declarations }
  end;

var
  ClientMain: TClientMain;

implementation

{$R *.fmx}
{ THeaderFooterForm }

procedure TClientMain.btnEventClick(Sender: TObject);
var
  i: integer;
begin
  case TabControl.TabIndex of
    0:
      begin
        // show all the events for the current selected session
        i := BindSourceSess.DataSet.FieldByName('SessionID').AsInteger;
        RESTRequestEv.Params.Clear;
        RESTRequestEv.Params.AddItem('sessionid', IntToStr(i));
        RESTRequestEv.Params.AddItem('eventid', '0');
        RESTRequestEv.Execute;
        TabControl.TabIndex := 1;
      end;
    1:
      begin
        // show all the heats for the current selected event
        i := BindSourceEv.DataSet.FieldByName('EventID').AsInteger;
        RESTRequestHeat.Params.Clear;
        RESTRequestHeat.Params.AddItem('eventid', IntToStr(i));
        RESTRequestHeat.Params.AddItem('heatid', '0');
        RESTRequestHeat.Execute;
        TabControl.TabIndex := 2;
      end;
    2:
      TabControl.TabIndex := 1;
  end;
end;

procedure TClientMain.btnHeatClick(Sender: TObject);
var
i: integer;
begin
  case TabControl.TabIndex of
    0:
      ;
    1, 2:
      begin
        i := BindSourceEv.DataSet.FieldByName('EventID').AsInteger;
        RESTRequestHeat.Params.Clear;
        RESTRequestHeat.Params.AddItem('eventid', IntToStr(i));
        RESTRequestHeat.Params.AddItem('heatid', '0');
        RESTRequestHeat.Execute;
        TabControl.TabIndex := 2;
      end;
  end;

end;

procedure TClientMain.btnSessionClick(Sender: TObject);
var
  i: integer;
begin
  case TabControl.TabIndex of
    0:
      begin
        if BindSourceSess.DataSet.IsEmpty then
        begin
          RESTRequestEv.Params.Clear;
          RESTRequestEv.Params.AddItem('sessionid=', '0');
          RESTRequestSess.Execute;
        end
        else
        begin
          i := BindSourceSess.DataSet.FieldByName('SessionID').AsInteger;
          RESTRequestEv.Params.Clear;
          RESTRequestEv.Params.AddItem('sessionid=', IntToStr(i));
          RESTRequestEv.Params.AddItem('eventid=', '0');
          RESTRequestSess.Execute;
          TabControl.TabIndex := 1;
        end;
      end;
    1, 2:
      TabControl.TabIndex := 1;
  end;
end;

procedure TClientMain.FormCreate(Sender: TObject);
begin
  currSessionID := 0;
  currEventID := 0;
  currHeatID := 0;
end;

procedure TClientMain.GetSessions;
// var
// To use this type you need to include a new unit in the uses section: Data.FireDACJSONReflect.
// LDataSetList: TFDJSONDataSets;
begin
  // It empties the memory table of any existing data before adding the new context.
  FDMemSessions.Close;
  // Get dataset list containing Employee names
  // LDataSetList := RESTClient.ServerMethods1Client.GetSessions;
  // Reads the first and only dataset, number 0.
  // FDMemSessions.AppendData(
  // TFDJSONDataSetsReader.GetListValue(LDataSetList, 0));
  // It uses a reader from The "TFDJSONDataSetsWriter" class to populate the memory table from the dataset list class.

  FDMemSessions.Open;
end;

end.
