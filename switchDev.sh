#!/bin/bash
echo 'Develop向けビルドに切り替えます'
\cp -f ./_BuildMode/awsconfiguration_Dev.json ./direct-type/awsconfiguration.json
\cp -f ./_BuildMode/BuildMode_Dev.swift ./direct-type/BuildMode.swift

sh rebuildAll.sh
echo ''
echo '********************************************************************************'
echo '* 【BuildMode.swift】が「Develop」に設定されているか確認してビルドしてください *'
echo '********************************************************************************'
echo ''
