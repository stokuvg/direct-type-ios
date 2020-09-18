# direct-type-ios
Direct type のiOSアプリ

## ！！注意！！
- 「Application supports iTunes file sharing」をリリース時には削除すること

## 環境構築

基本的に、以下の環境を対象とする

- Xcode 11.4.x
    - 対象iOSバージョン: 「iOS 12」以上
    - Swift Language Version: 「Swift 5」
    - UserInterface:「Storyboard」
- Cocoapod 1.8.4
    - AWSMobileClient 2.12.6
    - PromiseKit 6.13.1
- Swagger Codegen 3.0.20

~~~
$ sudo gem install bundler -v 1.17.2 -n /usr/local/bin
## $ sudo gem install cocoapods -v 1.8.4 ＊こちらGem管理にしたため手作業管理は不要
$ brew install swagger-codegen@3
~~~




## プロジェクト組み込み

### ビルド定義の切り替え方法
- 【switchDev.sh】で開発用のモードに切り替える。それ以後は【rebuildAll.sh】を実行
- 【switchRel.sh】でリリース用のモードに切り替える。それ以後は【rebuildAll.sh】を実行

### ▼補足：
- これらのスクリプトを実行すると、「_BuildMode」フォルダにあるファイルをモードに応じてコピーする
- 【awsconfiguration.json】は、AWSMobileClientが利用するCognito認証用の定義ファイル
- 【BuildMode.swift】は、下記で定義している「AppDefine」でのモード指定。
- 　⇒これに応じて値が切り替わるため、適宜Stagingなども増やして対応させていく

```
$ sh switchDev.sh
```

### api.jsonなどの変更時
- Develop/Release用それぞれを、「_buidlMode」フォルダに用意しておく必要あり
- Swagger Client生成が必要となるため、下記を実施

```
$ sh rebuildAll.sh
```


## 強制アップデート対応

### 定義ファイルの配置
- アプリは起動時にJSONファイルを取得し、その記述に従ってアップデート誘導ダイアログを表示する
- JSONファイルの配置先は、【AppDefine.swift】「tudUpdateInfoServerPath」「tudUpdateInfoJsonName」で定義
- JSONファイルの定義は、「api」フォルダ内の【apiVerCheck.yaml】としてSwagger形式で定義
    - 「required_version」：必要となるバージョンを記載。これ未満のアプリが起動された場合に、アップデート誘導ダイアログが表示される
    - 「force_update」：強制アップデートを実施させるか。trueを指定した場合には〔OK〕ボタンのみとなる。falseならば〔OK〕〔Cancel〕ボタンあり
    - 「dialog_title」：表示するダイアログのタイトル部分。なければ省略される
    - 「dialog_message」：表示するダイアログのメッセージ部分
    - 「update_url」：〔OK〕ボタン押下時に遷移させるURL

```
{
  "required_version": "1.0.3",
  "force_update": true,
  "dialog_title": "強制アップデート",
  "dialog_message": "このアプリを利用するには、最新バージョンへのアップデートが必要です。\nAppStoreへ移動します。",
  "update_url": "https://itunes.apple.com/jp/app/id1525688066?mt="
}
```




