# ConsistRunner ソリューション

このリポジトリは、Windows 環境で **一貫性のある配布・ログ管理・自動実行** を実現するためのサンプルアプリケーション群です。  
主に Inno Setup とタスクスケジューラを組み合わせ、社内ツールやバッチアプリを確実に配布できる仕組みを提供します。

## プロジェクト構成

- **ConsistRunner**  
  メインのコンソールアプリ。  
  Serilog を用いてログを出力し、タスクスケジューラ経由で自動実行する。

- **ConsistRunnerTests**  
  MSTest による単体テストプロジェクト。  
  RunnerService の挙動やログ出力を検証する。

- **Tools/InnoReplacer**  
  文字列置換ツール。Inno Setup から呼び出し、UTF-8/UTF-16/UTF-32 の BOM を維持しながら安全に置換を行う。

## 開発環境

- .NET Framework 4.7.2
- Visual Studio 2022
- Inno Setup 6.5.0 以上（インストーラ作成用）

## ビルド方法

```powershell
# Visual Studio 開発者コマンドプロンプトにて
msbuild ConsistRunner.sln /p:Configuration=Release
```

## インストーラ作成手順

```powershell
cd ConsistRunner\Installer
ISCC base.iss
```

## 注意事項

- 本リポジトリ内で使用している会社名 **SampleWorks** は、公開用のダミー名称です。  
  実在の企業とは一切関係ありません。  

- アプリケーションアイコンには [Google Material Icons](https://fonts.google.com/icons) を利用しています。  
  Material Icons は [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0) の下で配布されています。

- 本ソフトウェアは学習およびサンプル提供を目的として公開しています。  
  **利用は自己責任でお願いします。**  
  利用により生じたいかなる損害についても、作者は責任を負いません。

- このリポジトリは学習・サンプル公開用であり、**Issues での問い合わせ対応は行っていません**。  
  バグ報告や機能追加要望への対応予定もありませんのでご了承ください。

## ライセンス

- このリポジトリはサンプルとして公開しているものであり、MIT ライセンスに基づき利用可能です。


