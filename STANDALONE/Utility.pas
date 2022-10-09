unit Utility;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.Win.Registry, shlobj;

function CreateSCMPrefFileName(AFileName: TFileName): boolean;
function DeleteSCMPrefFileName(AFileName: TFileName): boolean;
function GetSCMAppDataDir(): string;
function GetSCMCommonAppDataDir(): string;
function ExistsSCMConnectionDefs(): boolean; deprecated;
function GetSCMPreferenceFileName(AName: String): string; overload;
function GetSCMPreferenceFileName(): string; overload;
function GetSCMTempDir(): string;
function GetSCMHelpPrefFileName(): string;
function GetSCMDocumentDir(): string;
function GetRegAppPath(appName: string): string;
function GetRegArtanemusAppPath(appName: string): string;

const
  PrefFileName = 'SCM_RESTPref.ini';
  HelpPrefFileName = 'SCM_RESTHelpPref.ini';
  SCMSubFolder = '\Artanemus\SCM\';
  // DEPRECIATED
  SCMConnectionDefsFileName = 'SCMConnectionDefs.ini';
  SCMConnectionDefsName = 'MSSQL_SwimClubMeet';

implementation

function CreateSCMPrefFileName(AFileName: TFileName): boolean;
var
  filehandle: NativeUInt;
begin
  result := false;
  // create the Help Preference file in 'APPDATA'
  filehandle := FileCreate(AFileName);
  // if NOT 'file already exists'
  if not (filehandle = INVALID_HANDLE_VALUE) then
  begin
    FileClose(filehandle); // close.
    result := true;
  end;
end;

function DeleteSCMPrefFileName(AFileName: TFileName): boolean;
begin
  result := false;
  // delete the Help Preference file in 'APPDATA'
  if (FileExists(AFileName)) then
    result := DeleteFile(AFileName);
end;


// Short:
// Get the SCM application data directory.
// Long:
// All Artanemus applications have there application-specific information and
// settings stored in TIniFiles files. The location is given as...
// $APPDATA$\\Artanemus\\$APPLICATIONNAME$\\$DATADILENAME$.ini
// Path that is returned always contains trailing back-slash
// Out:
// $APPDATA$\\Artanemus\\SCM\\ if successful else return a NULL (empty) string.
// this returns 'C:\Users\USERNAME\AppData\Roaming\'

function GetSCMAppDataDir(): string;
var
  str: string;
begin

  result := '';
  str := GetEnvironmentVariable('APPDATA');
  str := IncludeTrailingPathDelimiter(str);
  // Append product-specific path
  str := str + SCMSubFolder;
  if not DirectoryExists(str) then
  begin
    { *
      ForceDirectories creates a new directory as specified in Dir, which must be
      a fully-qualified path name. If the directories given in the path do not yet
      exist, ForceDirectories attempts to create them. ForceDirectories returns
      True if it successfully creates all necessary directories, False if it could
      not create a needed directory.
      Note: Do not call ForceDirectories with an empty string. Doing so causes
      ForceDirectories to raise an exception.
      * }
    if not System.SysUtils.ForceDirectories(str) then
      // FAILED! - Use alternative default document directory...
      exit;
  end;
  result := str;
end;

function GetSCMCommonAppDataDir(): string;
var
  str: string;
  szPath: array [0 .. Max_Path] of Char;
begin
  result := '';
  if (SUCCEEDED(SHGetFolderPath(null, CSIDL_COMMON_APPDATA, 0, 0, szPath))) then
  begin
    str := String(szPath);
    str := IncludeTrailingPathDelimiter(str) + SCMSubFolder;
    if not DirectoryExists(str) then
    begin
      if not CreateDir(str) then
        exit;
    end;
  end;
  result := str;
end;

function ExistsSCMConnectionDefs(): boolean;
begin
  // DEPRECIATED ....
  (*
    UnicodeString str;
    TCHAR szPath[MAX_PATH];
    // Get path for each computer, non-user specific and non-roaming data.
    if (SUCCEEDED(SHGetFolderPath(nullptr, CSIDL_COMMON_APPDATA, nullptr, 0, szPath)))
    {
    str = String(szPath);
    // Append product-specific path
    str = IncludeTrailingPathDelimiter(str) + SCMSubFolder +
    SCMConnectionDefsFileName;
    // Make sure the 'User\AppData\Roaming\%FILENAME%' is created!
    if (FileExists(str)) {
    return true;
    }
    }
    return false;
  *)
  result := true;
end;

function GetSCMPreferenceFileName(AName: String): string;
var
  str: string;
  success: boolean;
begin
  result := '';
  str := GetSCMAppDataDir;
  if str.IsEmpty then
    exit;
  str := str + AName;
  if not FileExists(str) then
  begin
    success := CreateSCMPrefFileName(str);
    if not success then
      exit;
  end;
  result := str;
end;

function GetSCMPreferenceFileName(): string;
begin
  result := GetSCMPreferenceFileName(PrefFileName);
end;

function GetSCMTempDir(): string;
var
  str: string;
begin
  result := '';
  str := GetEnvironmentVariable('TMP');
  str := IncludeTrailingPathDelimiter(str);
  if not DirectoryExists(str) then
  begin
    if not CreateDir(str) then
      exit;
  end;
  result := str;
end;

function GetSCMHelpPrefFileName(): string;
begin
  result := GetSCMPreferenceFileName(HelpPrefFileName);
end;

function GetSCMDocumentDir(): string;
begin
  result := GetEnvironmentVariable('HOMEPATH');
  result := IncludeTrailingPathDelimiter(result);
  result := result + 'SCM\';
end;

function GetRegAppPath(appName: string): string;
var
  reg: TRegistry;
  KeyName: string;
begin
  KeyName := '\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\';
  result := '';
  reg := TRegistry.Create(KEY_READ);
  try
    begin
      reg.RootKey := HKEY_LOCAL_MACHINE;
      if reg.KeyExists(KeyName) then
      begin
        reg.OpenKey(KeyName, false);
        result := reg.ReadString('Path');
      end;
    end;
  finally
    reg.Free;
  end;
end;

function GetRegArtanemusAppPath(appName: string): string;
var
  reg: TRegistry;
  KeyName: string;
begin
  KeyName := '\Software\\Artanemus\';
  result := '';
  KeyName := KeyName + appName + '\';
  result := '';
  reg := TRegistry.Create(KEY_READ);
  try
    begin
      reg.RootKey := HKEY_CURRENT_USER;
      reg.OpenKey(KeyName, false);
      result := reg.ReadString('Path');

    end;
  finally
    reg.Free;
  end;

end;

end.
