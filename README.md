# direct-type-ios
direct type のiOSアプリ

## ！！注意！！
- 「Application supports iTunes file sharing」をリリース時には削除すること



## 補足
- 仮の認証画面は、下部タブ「マイページ」を選択肢、内容スクロールさせて最下部にある「設定」→「ログアウト」で、仮の認証関連画面が表示されるようになっています
- 仮のユーザとして「+819001234567」は作成済みのため、そのまま〔Login〕ボタン押下で利用可能なはず
- 〔Status〕ボタン押下で「SignIn]と表示されていれば、プロフィールのフェッチなども可能
- 別のユーザを作成も可能だが、AWS Consoleで「CONFIRMED」にする処理と、6桁コードをログで確認するなどの処理が必要

### 制限事項
- Darkモード非対応
- 郵便番号は7桁入力になっています



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
$ sh rebuildAll.sh
```


【rebuildAll.sh】

```
#!/bin/bash
read -p 'まるっとリビルドします'

\rm -fr ./generated/
\rm -fr ./generatedSvr/
\rm -fr ./direct-type/Pods/
\rm -fr ./direct-type/direct-type.xcworkspace
cd api
sh gen.sh
cd ../
cd direct-type
pod install
```
