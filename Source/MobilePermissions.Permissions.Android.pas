unit MobilePermissions.Permissions.Android;

interface

uses
  {$IF CompilerVersion >= 33.0}
  System.Permissions,
  {$ENDIF}
  {$IFDEF ANDROID}
  Androidapi.Helpers,
  Androidapi.JNI.Os,
  Androidapi.JNI.JavaTypes,
  {$ENDIF}
  System.SysUtils,
  System.StrUtils,
  MobilePermissions.Permissions.Interfaces;

type TMobilePermissionsAndroid = class(TInterfacedObject, IMobilePermissions)
  private
    FAndroidVersion: Integer;
    procedure SetAndroidVersion;

  public
    function Request(Permissions: System.TArray<System.string>): IMobilePermissions;

    constructor create;
    destructor  Destroy; override;
    class function New: IMobilePermissions;
end;

implementation

{ TMobilePermissionsAndroid }

constructor TMobilePermissionsAndroid.create;
begin
  FAndroidVersion := 0;
end;

destructor TMobilePermissionsAndroid.Destroy;
begin
  inherited;
end;

procedure TMobilePermissionsAndroid.SetAndroidVersion;
{$IFDEF ANDROID}
var
  VVersionOSStr: String;
{$ENDIF}
begin
  if FAndroidVersion = 0 then
  begin
    {$IFDEF ANDROID}
    VVersionOSStr := JStringToString(TJBuild_VERSION.JavaClass.RELEASE);
    if Pos('.', VVersionOSStr) > 0 then
      VVersionOSStr := Copy(VVersionOSStr, Pos('.', VVersionOSStr)-1);

    FAndroidVersion := StrToInt(VVersionOSStr);
    {$ENDIF}
  end;
end;

class function TMobilePermissionsAndroid.New: IMobilePermissions;
begin
  result := Self.Create;
end;

function TMobilePermissionsAndroid.Request(Permissions: System.TArray<System.string>): IMobilePermissions;
begin
  result := Self;
  SetAndroidVersion;
  {$IF CompilerVersion >= 33.0}
  if (FAndroidVersion > 6) then
    PermissionsService.RequestPermissions(Permissions, nil, nil);
  {$ENDIF}
end;

end.
