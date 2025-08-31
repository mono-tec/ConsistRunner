@echo off
@setlocal
:: =============================================================================
:: SBOM作成用バッチファイル
:: 対象：.NET Framework 4.7.2 アプリケーション
::
:: 必要な事前準備：
::   - sbom-tool がインストールされていること
::     ⇒ winget または dotnet tool 経由で導入可能
::        winget: winget install Microsoft.SbomTool
::        dotnet: dotnet tool install --global Microsoft.Sbom.DotNetTool
::
:: 実行内容：
::   1. bin\Release フォルダを対象にSBOMを生成
::
:: 出力先：
::   - ./_sbom/manifest.spdx.json
::
:: 備考：
::   - このファイルは Installer フォルダ内に配置し、納品前に実行する
::   - Inno Setup にSBOMを含める場合は、{app}\_sbom に配置する
:: =============================================================================

:: アプリ名と公開フォルダのパスを設定
@set BUILD_DROP_PATH=..\src\ConsistRunner\bin\Release
@set OUTPUT_PATH=.
@set PACKAGE_NAME=ConsistRunner
@set PACKAGE_SUPPLIER=SampleWorks

@rem カレントフォルダに移動
cd /d %~dp0

@echo SBOMファイル作成
@echo.

:: バージョン番号をユーザーから入力
@set /p PACKAGE_VERSION="入力してください（例: 1.0.0）→ バージョン番号: "

:: 入力チェック（空文字のときは終了）
@if "%PACKAGE_VERSION%"=="" (
    @echo バージョンが入力されていません。処理を中止します。
    @exit /b 1
)

@echo 納品しないファイルを削除します...
@echo.

:: 不要ファイルを削除
del /f /q "%BUILD_DROP_PATH%\*.pdb"
del /f /q "%BUILD_DROP_PATH%\*.xml"

@echo バージョン: %PACKAGE_VERSION% を使用してSBOMを生成します...
@echo.

:: SBOMツール実行（出力は _sbom フォルダに格納）
sbom-tool generate ^
  -b "%BUILD_DROP_PATH%" ^
  -m "%OUTPUT_PATH%" ^
  -pn "%PACKAGE_NAME%" ^
  -pv "%PACKAGE_VERSION%" ^
  -ps "%PACKAGE_SUPPLIER%"

@endlocal
@pause