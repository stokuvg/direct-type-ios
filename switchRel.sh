#!/bin/bash
read -p 'Release向けビルドに切り替えます'
cd direct-type
\cp -f awsconfiguration_Rel.json awsconfiguration.json

cd ..
sh rebuildAll.sh

echo ''
echo '********************************************************************************'
echo '* 【AppDefine.swift】が「Release」に設定されているか確認してビルドしてください *'
echo '********************************************************************************'
echo ''
