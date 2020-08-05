#!/bin/bash
read -p 'Develop向けビルドに切り替えます'
cd direct-type
\cp -f awsconfiguration_Dev.json awsconfiguration.json

cd ..
sh rebuildAll.sh

echo ''
echo '********************************************************************************'
echo '* 【AppDefine.swift】が「Develop」に設定されているか確認してビルドしてください *'
echo '********************************************************************************'
echo ''
