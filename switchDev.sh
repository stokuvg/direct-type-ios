#!/bin/bash
echo 'Develop向けビルドに切り替えます'
\cp -f ./_BuildMode/awsconfiguration_Dev.json ./direct-type/awsconfiguration.json
\cp -f ./_BuildMode/BuildMode_Dev.swift ./direct-type/BuildMode.swift
##【api.json】はモデル定義が変わるとDevとRelで異なる可能性あり、切り替えるとビルドエラーの可能性あることに留意
\cp -f ./_BuildMode/api_Dev.json ./api/api.json

sh rebuildAll.sh
echo ''
echo '********************************************************************************'
echo '* 【BuildMode.swift】が「Develop」に設定されているか確認してビルドしてください *'
echo '********************************************************************************'
echo ''
