source ~/.bash_profile

#v3で死ぬ場合
#brew uninstall swagger-codegen
#brew install swagger-codegen@2
#export PATH="/usr/local/opt/swagger-codegen@2/bin:$PATH"

#生成される .podspec に homepage と summary が存在しなくてエラーになるのでconfigで指定している


#sg3 generate -l swift5 -i api.json  -o ../generated/promise/  --additional-properties podHomepage='http://example.com/SwaggerClient',podSummary='.',unwrapRequired=false
#swagger-codegen generate -l swift5 -i api.json -t ./swift5PromiseKit6 -o ../generated/promise/ -c codegen-config.json


swagger-codegen generate -l swift5 -i appapi.yaml -t ./swift5PromiseKit6 -o ../generated/promise/ -c codegen-config.json
