; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define AppName "CryptoCurrencies Data Plug-in for AmiBroker"
#define AppVersion "0.9.15"
#define AppPublisher "�2018 Arakcheev V.A."
#define AppSupportURL "http://amicoins.ru"

[Setup]

; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)

AppId={{2BF6B45F-4990-4F46-9DBB-8292CBC23169}

AppName={#AppName}
AppVersion={#AppVersion}
AppPublisher={#AppPublisher}

CreateAppDir=no
InfoBeforeFile=c:\Projects\Installer\License.txt

OutputDir=c:\Projects\Installer\bin
OutputBaseFilename=Setup

Compression=lzma
SolidCompression=yes

; ����������� ������ Windows 7
MinVersion=6.1

ArchitecturesInstallIn64BitMode=x64     

[Languages]

Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"

[Files]
Source: "c:\Projects\Installer\CryptoCurrenciesDemo32.dll"; DestDir: "{tmp}"; Flags: deleteafterinstall ignoreversion
Source: "c:\Projects\Installer\CryptoCurrenciesDemo64.dll"; DestDir: "{tmp}"; Flags: deleteafterinstall ignoreversion
Source: "c:\Projects\Installer\Newtonsoft.Json.dll";        DestDir: "{tmp}"; Flags: deleteafterinstall ignoreversion

; ���� ������������
Source: "c:\Projects\Installer\Manual.pdf";                 DestDir: "{tmp}"; Flags: deleteafterinstall ignoreversion

; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Tasks]
Name: StartAfterInstall; Description: Display the PDF Installation Guide

[Run]

 ; �������� ������ � ������ ����������
 Filename: "{sys}\xcopy.exe"; Parameters: {code:SetComma}{tmp}\Newtonsoft.Json.dll{code:SetComma} {code:SetComma}{code:GetInstallPath}{code:SetComma} /Y; StatusMsg: "Copy JSON serializer..."; 
 Filename: "{sys}\xcopy.exe"; Parameters: {code:SetComma}{tmp}\CryptoCurrenciesDemo64.dll{code:SetComma} {code:SetComma}{code:GetInstallPath}\Plugins{code:SetComma} /Y; StatusMsg: "Copy plugin library..."; Check: Is64BitBroker;
 Filename: "{sys}\xcopy.exe"; Parameters: {code:SetComma}{tmp}\CryptoCurrenciesDemo32.dll{code:SetComma} {code:SetComma}{code:GetInstallPath}\Plugins{code:SetComma} /Y; StatusMsg: "Copy plugin library..."; Check: not Is64BitBroker;
 Filename: "{sys}\xcopy.exe"; Parameters: {code:SetComma}{tmp}\Manual.pdf{code:SetComma} {code:SetComma}{code:GetInstallPath}{code:SetComma} /Y; StatusMsg: "Copy manual..."; 
 Filename: "{code:GetInstallPath}\Manual.pdf"; Tasks: StartAfterInstall; Flags: shellexec runasoriginaluser
 ; ��� ��� ����������� ��������
[Code]  

function SetComma(str:String):String;
  begin
    Result := #34;
  end;

// ���������� ������� ���������� ��� AmiBroker 
// (x86 � x64 ���������� ���� � ���� ���������� � �������) 
function GetInstallPath(appID:String):string;
  var 
    path: string;
    begin
      path:= '';
      RegQueryStringValue(HKCU, 'Software\TJP\Broker\Defaults', 'LastGoodPath', path);
      Result:= path;
    end;

// �������� ����������
function IsDotNetDetected(): boolean;
   var 
      reg_key: string;      // ��������������� ��������� ���������� �������
      success: boolean;     // ���� ������� ������������� ������ .NET
      key_value: cardinal;  // ����������� �� ������� �������� �����
      sub_key: string;

  begin

    success := false;
    reg_key := 'SOFTWARE\Microsoft\NET Framework Setup\NDP\';

    sub_key := 'v4\Full';
    reg_key := reg_key + sub_key;
    success := RegQueryDWordValue(HKLM, reg_key, 'Install', key_value);
    success := success and (key_value = 1);  
        
    result := success;

  end;

// Callback �������, ���������� ��� ������������� 
function InitializeSetup(): boolean;
  var 
    is_installed:boolean;
    ErrCode:integer;
  begin  
    is_installed := true;

    // ���� ��� ��������� ������ .NET ������� ��������� � ���, ��� �����������
    // ���������� ���������� � �� ������ ���������
    if not IsDotNetDetected() then
      begin
        MsgBox('{#AppName} requires Microsoft .NET Framework 4.0 Full Profile. Please, install it first!', mbInformation, MB_OK);
        is_installed := false;
        ShellExec('open', 'http://microsoft.com/en-us/download/details.aspx?id=17718', '', '', SW_SHOW, ewNoWait, ErrCode);                                                              
      end;   

    result := is_installed;

  end;

  // ��������� ������� ������������� ������ AmiBroker
  function Is64BitBroker():boolean;
    var 
      default: boolean;
      path: string;

      begin
        
         default := false;
         path := GetInstallPath('');

         if FileExists(path + '\' + 'dbcapi_64VC8.dll') then 
            begin
              default := true;
            end;             

      result := default;

      end;





