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
cd direct-type
\cp -f awsconfiguration_Dev.json awsconfiguration.json
bundle exec pod install


