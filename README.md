# direct-type-ios
direct type のiOSアプリ

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
