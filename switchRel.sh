#!/bin/bash
echo 'Release向けビルドに切り替えます'
\cp -f ./_BuildMode/awsconfiguration_Rel.json ./direct-type/awsconfiguration.json
\cp -f ./_BuildMode/BuildMode_Rel.swift ./direct-type/BuildMode.swift

sh rebuildAll.sh
echo ''
echo '********************************************************************************'
echo '* 【BuildMode.swift】が「Release」に設定されているか確認してビルドしてください *'
echo '********************************************************************************'
echo ''
