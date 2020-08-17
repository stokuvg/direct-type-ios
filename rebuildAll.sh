#!/bin/bash
read -p 'まるっとリビルドします'

\rm -fr ./generated/
\rm -fr ./generatedSvr/
\rm -fr ./generatedRecommend/
\rm -fr ./direct-type/Pods/
\rm -fr ./direct-type/direct-type.xcworkspace
cd api
sh gen.sh
cd ../
## リコメンドで [prod] 先頭保証するため、ファイル生成後にカスタムしたものを上書きしている
\cp -f ./_Patch/RecommendAPI.swift ./generatedRecommend/promise/SERecommend/Classes/Swaggers/APIs/RecommendAPI.swift

## Pod処理
cd direct-type
bundle exec pod install
