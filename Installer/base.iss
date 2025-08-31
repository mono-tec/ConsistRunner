

; 発行フォルダのルートを定義
#define PublishDir        "..\src\ConsistRunner\bin\Release"
#define ToolDir           "..\tools\InnoReplacer\bin\Release"

#define TaskName          "ConsistRunner_Hourly"
#define AppName           "ConsistRunner"
#define ReplaceAppName    "InnoReplacer"
#define MyCompany         "SampleWorks"
#define MyAppVersion      "1.0.0"
#define InstallDir        "{autopf}\" + MyCompany + "\" + AppName
#define DataDir           "{commonappdata}\" + AppName

; タスク開始時刻
#define TaskTempStartTime "00:05:00"

[Setup]
AppName={#AppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyCompany}
DefaultDirName={autopf}\{#MyCompany}\{#AppName}
DefaultGroupName={#MyCompany}
DisableDirPage=no
DisableProgramGroupPage=yes
OutputDir=.
OutputBaseFilename=ConsistRunner-Setup
SetupIconFile=icon.ico
PrivilegesRequired=admin
; 64bitOS設定(32bitosはコメントにする)
ArchitecturesInstallIn64BitMode=x64os

[Languages]
Name: "japanese"; MessagesFile: "compiler:Languages\Japanese.isl"

[Files]
; アプリ本体（Releaseビルド成果物）
Source: "{#PublishDir}\{#AppName}.exe"; DestDir: "{#InstallDir}"; Flags: ignoreversion
Source: "{#PublishDir}\{#AppName}.exe.config"; DestDir: "{app}"; Flags: ignoreversion
; ★ DLL 一括追加
Source: "{#PublishDir}\*.dll"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs

; 置換ツール（実行後に削除します）
Source: "{#ToolDir}\{#ReplaceAppName}.exe";   DestDir: "{app}"; Flags: ignoreversion
Source: "{#TaskName}.xml";   DestDir: "{app}"; Flags: ignoreversion

[Dirs]
Name: "{#DataDir}\logs"; Flags: uninsalwaysuninstall


[Code]
var
  Page1, Page2: TInputQueryWizardPage;

procedure InitializeWizard;
begin 

 // Page 1：タスク情報
  Page1 := CreateInputQueryPage(wpSelectDir,
    'タスク情報設定',
    'タスク情報設定を行います。',
    '以下の各項目を入力してください。');
  Page1.Add('タスク開始時刻:', False);
  Page1.Values[0] := '{#TaskTempStartTime}';

   // Page 2：出力先情報
  Page2 := CreateInputQueryPage(Page1.ID,
    '出力先設定',
    '出力先情報設定を行います。',
    '以下の各項目を入力してください。');
  Page2.Add('ログ出力先:', False);
  
  // 初期表示時は {app} を展開した値をセット
  // ExpandConstant('{app}') は InitializeWizard の時点では既定の DefaultDirName を反映
    Page2.Values[0] := AddBackslash(WizardDirValue) + 'logs';
end;

procedure CurPageChanged(CurPageID: Integer);
begin
  // ユーザーがインストール先を変えてから当ページに入ったとき、最新の選択を反映
  if CurPageID = Page2.ID then
  begin
    // WizardDirValue は現時点の「選択されたインストール先」
    Page2.Values[0] := AddBackslash(WizardDirValue) + 'logs';
  end;
end;

// Getter関数（[Run] セクションで使えるようにする）
function GetExeName(Param: string): string; begin Result := '{#AppName}.exe'; end;
function GetWorkingDir(Param: string): string; begin Result := ExpandConstant('{app}'); end;
function GetTaskStartTime(Param: string): string; begin Result := Page1.Values[0]; end;
function GetLogRoot(Param: string): string; begin Result := Page2.Values[0]; end;

[Run]
; ① 文字列置換ツール実行
Filename: "{app}\{#ReplaceAppName}.exe"; Parameters: """{app}\{#AppName}.exe.config"" ""#LOG_ROOT#"" ""{code:GetLogRoot}"""; Flags: runhidden waituntilterminated
Filename: "{app}\{#ReplaceAppName}.exe"; Parameters: """{app}\{#TaskName}.xml"" ""#EXE_NAME#"" ""{code:GetExeName}"""; Flags: runhidden waituntilterminated
Filename: "{app}\{#ReplaceAppName}.exe"; Parameters: """{app}\{#TaskName}.xml"" ""#WORKING_DIR#"" ""{code:GetWorkingDir}"""; Flags: runhidden waituntilterminated
Filename: "{app}\{#ReplaceAppName}.exe"; Parameters: """{app}\{#TaskName}.xml"" ""#TASK_START_TIME#"" ""{code:GetTaskStartTime}"""; Flags: runhidden waituntilterminated
Filename: "{app}\{#ReplaceAppName}.exe"; Parameters: """{app}\{#TaskName}.xml"" ""#AUTHOR#"" ""{#MyCompany}"""; Flags: runhidden waituntilterminated

; ② 文字列変換ツール削除
Filename: "cmd.exe"; Parameters: "/C del /F /Q ""{app}\{#ReplaceAppName}.exe"""; Flags: runhidden shellexec waituntilterminated

; ③ 出力先フォルダを作成（なければ） ---
Filename: "cmd.exe"; Parameters: "/C if not exist ""{code:GetLogRoot}""    mkdir ""{code:GetLogRoot}""";    Flags: runhidden waituntilterminated

; ④ LocalService(S-1-5-19) に Modify を付与（継承付きで配下にも適用）---
Filename: "cmd.exe"; Parameters: "/C icacls ""{code:GetLogRoot}""    /grant *S-1-5-19:(OI)(CI)M /T /C /Q"; Flags: runhidden waituntilterminated

; ⑤ タスク削除（存在しなくてもOK）
Filename: "schtasks.exe"; Parameters: "/Delete /TN ""{#TaskName}"" /F"; Flags: runhidden waituntilterminated
; ⑥ タスク作成
Filename: "schtasks.exe"; Parameters: "/Create /TN ""{#TaskName}"" /XML ""{app}\{#TaskName}.xml"" /F"; Flags: runhidden waituntilterminated

[UninstallRun]
; タスク削除
Filename: "schtasks.exe"; Parameters: "/Delete /TN ""{#TaskName}"" /F"; Flags: runhidden waituntilterminated; RunOnceId: "Delete_{#TaskName}"

[Icons]
Name: "{group}\{#AppName}"; Filename: "{app}\{#AppName}.exe"