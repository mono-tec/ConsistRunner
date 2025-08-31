# InnoReplacer

Inno Setup から呼び出される文字列置換ツールです。  
UTF-8 / UTF-16 / UTF-32 (LE/BE) の BOM を保持しつつ文字列を置換できます。

## 使い方

```powershell
InnoReplacer.exe <filePath> <searchText> <replaceText>
```

または複数ペアを指定する場合:

```csharp
var svc = new FileTextReplaceService();
svc.ReplaceInPlace("TaskTemplate.xml", new [] {
    new KeyValuePair<string,string>("__EXE_PATH__", @"C:\Program Files\SampleWorks\ConsistRunner\ConsistRunner.exe"),
    new KeyValuePair<string,string>("__ARGS__", "--ping")
});
```

## 典型的な利用シーン

- タスクスケジューラ XML の `Program` パス差し替え
- App.Release.config 内の `#LOG_ROOT#` をインストール先に置換

## 注意事項

- 本リポジトリ内で使用している会社名 **SampleWorks** は、公開用のダミー名称です。  
  実在の企業とは一切関係ありません。  

- アプリケーションアイコンには [Google Material Icons](https://fonts.google.com/icons) を利用しています。  
  Material Icons は [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0) の下で配布されています。

- 本ソフトウェアは学習およびサンプル提供を目的として公開しています。  
  **利用は自己責任でお願いします。**  
  利用により生じたいかなる損害についても、作者は責任を負いません。
