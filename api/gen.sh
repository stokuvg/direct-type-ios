#生成される .podspec に homepage と summary が存在しなくてエラーになるのでconfigで指定している
swagger-codegen generate -l swift5 -i appapi.yaml -t ./swift5PromiseKit6 -o ../generated/promise/ -c codegen-config.json
swagger-codegen generate -l swift5 -i api.json -t ./swift5PromiseKit6 -o ../generatedSvr/promise/ -c codegen-config-svr.json
swagger-codegen generate -l swift5 -i apiRecommend.yaml -t ./swift5PromiseKit6 -o ../generatedRecommend/promise/ -c codegen-config-recommend.json
