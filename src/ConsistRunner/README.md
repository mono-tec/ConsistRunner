# ConsistRunner

メインの Windows コンソールアプリケーション。  
社内向けの補助ツールを配布・自動実行するためのサンプル実装です。

## 主な機能

- Serilog によるログ出力
  - Debug ビルド: `bin\Debug\logs\`
  - Release ビルド: `App.Release.config` による環境依存設定
- RunnerService による処理実装
  - `--ping` オプションで現在時刻をログ出力
  - 実運用では DB アクセスや API 呼び出しなどを拡張可能

## 実行例

```powershell
ConsistRunner.exe --ping
```

ログ出力例:

```
[Information] RunnerService started with 1 args.
[Information] Ping: 2025-08-24T12:34:56Z
[Information] RunnerService completed.
```

## 注意事項

- 本リポジトリ内で使用している会社名 **SampleWorks** は、公開用のダミー名称です。  
  実在の企業とは一切関係ありません。  

- アプリケーションアイコンには [Google Material Icons](https://fonts.google.com/icons) を利用しています。  
  Material Icons は [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0) の下で配布されています。

- 本ソフトウェアは学習およびサンプル提供を目的として公開しています。  
  **利用は自己責任でお願いします。**  
  利用により生じたいかなる損害についても、作者は責任を負いません。