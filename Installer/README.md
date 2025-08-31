# Installer

このフォルダには、**ConsistRunner** アプリケーションを配布するための  
**Inno Setup スクリプト**と関連ファイルが含まれています。

## 内容

- `base.iss`  
  インストーラのベーススクリプト。アプリ本体の配置・タスクスケジューラ登録・アンインストール処理を記述。

- `CreateSBOM.bat`  
  ConsistRunner 用の **SBOM（Software Bill of Materials）** を作成するためのバッチファイル。  
  ビルド済みの成果物を解析して SBOM を生成し、ライブラリ依存関係を明示します。

- `InnoReplacer.exe`  
  インストーラ実行中に設定ファイルやタスクスケジューラ XML 内のプレースホルダを置換する補助ツール。  
  UTF-8/UTF-16/UTF-32 の BOM を保持したまま置換できるのが特徴です。  
  **Tools/InnoReplacer プロジェクトをビルドし、生成された exe をこのフォルダに配置してください。**

- `ConsistRunner_Hourly.xml`  
  **1時間ごとのタスク処理を行うタスクスケジューラ定義のテンプレートファイル**です。  
  インストーラ実行時に `InnoReplacer` によりアプリ実行パスやログパスが差し替えられます。

- `icon.ico`  
  インストーラで使用するアプリケーションアイコン。  
  [Google Material Icons](https://fonts.google.com/icons) をベースに作成しています。  
  Material Icons は [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0) の下で配布されています。

## インストーラの作成方法

1. [Inno Setup](https://jrsoftware.org/isinfo.php) をインストール（バージョン 6.5.0 以上推奨）。  
2. Visual Studio で `ConsistRunner.sln` を Release ビルド。  
3. `Tools/InnoReplacer` を Release ビルドし、生成された `InnoReplacer.exe` を本フォルダへ配置。  
4. コマンドラインまたは Inno Setup IDE で以下を実行。

```powershell
   iscc base.iss
```

5. Output/ フォルダに ConsistRunner_Setup.exe が生成されます。

必要に応じて CreateSBOM.bat を実行し、SBOM を生成してください。

## インストーラの挙動

- 既定のインストール先は
C:\Program Files\SampleWorks\ConsistRunner\

- ログ出力先はインストール先配下の logs フォルダ。

- タスクスケジューラに自動実行タスクを登録（ConsistRunner_Hourly.xml を利用）。

- アンインストール時にはタスク登録も削除。

- SBOM は CreateSBOM.bat により生成可能。

## 注意事項

- 本リポジトリ内で使用している会社名 **SampleWorks** は、公開用のダミー名称です。  
  実在の企業とは一切関係ありません。  

- アプリケーションアイコンには [Google Material Icons](https://fonts.google.com/icons) を利用しています。  
  Material Icons は [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0) の下で配布されています。

- 本ソフトウェアは学習およびサンプル提供を目的として公開しています。  
  **利用は自己責任でお願いします。**  
  利用により生じたいかなる損害についても、作者は責任を負いません。

