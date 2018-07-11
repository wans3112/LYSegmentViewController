#!/bin/bash

set -e

deleteTag=0
commit_msg=""

while  getopts  " d:m: "  arg #选项后面的冒号表示该选项需要参数
do
case  $arg  in
d)
deleteTag=$OPTARG #是否删除原来tag
;;
m)
commit_msg=$OPTARG
# echo "d-msg:$commit_msg"
;;
? )  #当有不认识的选项的时候arg为 ?
echo  " unkonw argument "
exit  1
;;
esac
done

podspecName=$(basename $(find . -name *.podspec) | sed 's/.podspec//g' )

version=$(awk '/\.version/' $podspecName.podspec | awk '/[0-9]\.[0-9]\.[0-9]/' | sed 's/.version//g'  | sed 's/[^0-9/.]//g')
describe=$(awk '/\.summary/' $podspecName.podspec | sed "s/\'//g" | sed "s/[a-zA-Z]*.summary//g" | sed "s/=//g")

#echo $podspecName
#echo $describe
#echo $version

# 检查是否已经提交
check_results=`git status`
echo "result: $check_results"
if [[ $check_results =~ 'nothing to commit' ]];
then
  echo "---------Don't Need Commit, Script To Be Continue---------"
else
  git add .

  if [ -n "$commit_msg" ];
  then
    # commit_msg 不为空
    git commit -m "$commit_msg"
  else
    git commit -m "update version $version"
  fi


fi

git pull
git push


if [ $deleteTag = '1' ] ; then
    git tag --delete $version
    git push origin --delete tag $version
fi

# 最近一次提交信息
nearest_commit_info=`git log --pretty=format:"%s" -1`

git tag -a ${version} -m "$nearest_commit_info"
git push origin ${version}

publicSpecs="https://github.com/CocoaPods/Specs.git"
privateSpecs="http://192.168.10.81/IOS/commline/iOSPod.git"

#pod repo remove iOSPod LYCache.podspec
#,http://iOS:123456@192.168.10.224:3000/iOS/iOSPod.git

pod lib lint  --allow-warnings  --use-libraries --verbose --sources=$privateSpecs,$publicSpecs

pod repo push --allow-warnings --use-libraries --verbose iOSPod $podspecName.podspec --sources=$privateSpecs,$publicSpecs
