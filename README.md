# direct-type-ios
direct type のiOSアプリ

## 制限事項

- 仮の認証画面は、下部タブ「マイページ」を選択肢、内容スクロールさせて最下部にある「設定」→「ログアウト」で、仮の認証関連画面が表示されるようになっています


## 環境構築

基本的に、以下の環境を対象とする

- Xcode 11.4.x
    - 対象iOSバージョン: 「iOS 12」以上
    - Swift Language Version: 「Swift 5」
    - UserInterface:「Storyboard」
- Cocoapod 1.8.4
    - AWSMobileClient 2.12.6
    - PromiseKit 6.13.1
- Swagger Codegen 3.0.16

~~~
$ brew install swagger-codegen@3
~~~




## プロジェクト組み込み

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
