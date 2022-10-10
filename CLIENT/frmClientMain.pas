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
  FMX.Layouts, Data.Bind.Grid, FMX.TabControl, FMX.Edit, System.ImageList,
  FMX.ImgList, FMX.Objects;

type
  TClientMain = class(TForm)
    Header: TToolBar;
    HeaderLabel: TLabel;
    RESTClientSess: TRESTClient;
    RESTRequestSess: TRESTRequest;
    RESTResponseSess: TRESTResponse;
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
    edtBaseURL: TEdit;
    ImageList1: TImageList;
    imgRefresh: TImage;
    procedure FormCreate(Sender: TObject);
    procedure imgRefreshClick(Sender: TObject);
    procedure tabSessionClick(Sender: TObject);
    procedure tabEventsClick(Sender: TObject);
    procedure tabHeatClick(Sender: TObject);
    procedure strGridSessionsSelChanged(Sender: TObject);
    procedure strGridEventsSelChanged(Sender: TObject);
    procedure edtBaseURLKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
  private
    { Private declarations }
    currSessionID, currEventID, currHeatID, lastTabIndex: integer;
    rowSessChanged, rowEvChanged: boolean;

    // procedure GetSessions();

  public
    { Public declarations }
  end;

var
  ClientMain: TClientMain;

  // --------------------------------------------------------
  // Example web query:
  // --------------------------------------------------------
  // sessions?sessionid=0  - for all sessions
  // sessions?sessionid=53 - for a specific session
  //
  // events?sessionid=53&eventid=126   - for a specific event
  // events?sesionid=53&eventid=0   - for all event
  //
  // heats?eventid=53&heatid=126   - for a specific heat
  // heats?eventid=53&heatid=0   - for all heats in event

implementation

{$R *.fmx}
{$R *.LgXhdpiTb.fmx ANDROID}
{$R *.Windows.fmx MSWINDOWS}

{ THeaderFooterForm }

uses
  System.StrUtils;

procedure TClientMain.edtBaseURLKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkReturn then
  begin
    imgRefreshClick(Self);
    Key := 0;
    KeyChar := #0;
  end;
end;

procedure TClientMain.FormCreate(Sender: TObject);
begin
  currSessionID := 0;
  currEventID := 0;
  currHeatID := 0;
  lastTabIndex := 0;
  TabControl.TabIndex := 0;
  rowSessChanged := false;
  rowEvChanged := false;
  width := 458;
end;

// procedure TClientMain.GetSessions;
// var
// To use this type you need to include a new unit in the uses section: Data.FireDACJSONReflect.
// LDataSetList: TFDJSONDataSets;
// begin
// It empties the memory table of any existing data before adding the new context.
// FDMemSessions.Close;
// Get dataset list containing Employee names
// LDataSetList := RESTClient.ServerMethods1Client.GetSessions;
// Reads the first and only dataset, number 0.
// FDMemSessions.AppendData(
// TFDJSONDataSetsReader.GetListValue(LDataSetList, 0));
// It uses a reader from The "TFDJSONDataSetsWriter" class to populate the memory table from the dataset list class.
// FDMemSessions.Open;
// end;

procedure TClientMain.imgRefreshClick(Sender: TObject);
var
  urlBaseStr: string;

begin
  //
  urlBaseStr := edtBaseURL.Text;
  if (RightStr(edtBaseURL.Text, 1) <> '/') then
    urlBaseStr := urlBaseStr + '/';

  // ASSERT
  RESTClientSess.BaseURL := urlBaseStr + 'sessions';
  RESTClientEv.BaseURL := urlBaseStr + 'events';
  RESTClientHeat.BaseURL := urlBaseStr + 'heats';

  RESTRequestEv.Params.Clear;
  RESTRequestHeat.Params.Clear;

  FDMemSessions.DisableControls;
  TabControl.TabIndex := 0;
  RESTRequestSess.Params.Clear;
  RESTRequestSess.Params.AddItem('sessionid=', '0');
  RESTRequestSess.Execute;
  FDMemSessions.EnableControls;

end;

procedure TClientMain.strGridEventsSelChanged(Sender: TObject);
begin
  rowEvChanged := true;
end;

procedure TClientMain.strGridSessionsSelChanged(Sender: TObject);
begin
  rowSessChanged := true;
end;

procedure TClientMain.tabEventsClick(Sender: TObject);
var
  i: integer;
begin
  if (lastTabIndex = 0) or (rowSessChanged) then
  begin
    i := BindSourceSess.DataSet.FieldByName('SessionID').AsInteger;
    FDMemEvents.DisableControls;
    RESTRequestEv.Params.Clear;
    RESTRequestEv.Params.AddItem('sessionid', IntToStr(i));
    RESTRequestEv.Params.AddItem('eventid', '0');
    RESTRequestEv.Execute;
    FDMemEvents.EnableControls;
  end;
  lastTabIndex := TabControl.TabIndex;
  rowSessChanged := false;
  rowEvChanged := false;

end;

procedure TClientMain.tabHeatClick(Sender: TObject);
var
  i: integer;
begin
  if (lastTabIndex = 1) or (rowEvChanged) then
  begin
    i := BindSourceEv.DataSet.FieldByName('EventID').AsInteger;
    FDMemHeats.DisableControls;
    RESTRequestHeat.Params.Clear;
    RESTRequestHeat.Params.AddItem('eventid', IntToStr(i));
    RESTRequestHeat.Params.AddItem('heatid', '0');
    RESTRequestHeat.Execute;
    FDMemHeats.EnableControls;
  end;
  lastTabIndex := TabControl.TabIndex;
  rowSessChanged := false;
  rowEvChanged := false;

end;

procedure TClientMain.tabSessionClick(Sender: TObject);
begin
  if BindSourceEv.DataSet.IsEmpty then
    imgRefreshClick(Self)
  else
  begin
    lastTabIndex := TabControl.TabIndex;
    rowSessChanged := false;
    rowEvChanged := false;
  end;

end;

end.
