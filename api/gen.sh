source ~/.bash_profile
#生成される .podspec に homepage と summary が存在しなくてエラーになるのでconfigで指定している
swagger-codegen generate -l swift5 -i appapi.yaml -t ./swift5PromiseKit6 -o ../generated/promise/ -c codegen-config.json
