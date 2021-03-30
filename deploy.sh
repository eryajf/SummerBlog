#!/usr/bin/env sh

# 确保脚本抛出遇到的错误
set -e

# # 生成静态文件
npm run build

# 进入生成的文件夹
pushd docs/.vuepress/  >/dev/null 2>&1

rm  -rf dist.zip 

# 压缩
zip -q -r dist.zip dist/

# ssh
scp dist.zip  root@IP:/www/wwwroot/update/

# 远程执行
ssh root@ip "/www/wwwroot/update/update.sh"

popd >/dev/null 2>&1
##########################

## 判断生成urls.txt

if [ -f urls.txt ];then
# echo "文件存在"
rm -rf  urls.txt && node utils/baiduPush.js https://www.xswsym.online
else
# echo "文件不存在"
node utils/baiduPush.js https://www.xswsym.online
fi

## 循环
for i in `seq 1 20`
do
  curl -H 'Content-Type:text/plain' --data-binary @urls.txt "http://data.zz.baidu.com/urls?site=www.xswsym.online&token=W180K19QCHkwdjCz"
done 