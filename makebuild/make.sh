cd ../AnalysysSDK/


cp ../makebuild/config.ini config.ini
source config.ini


#修改版本号

#进行AnalysysAgent.h中版本号修改
sed '11d' ../AnalysysSDK_SourceCode/Classes/AnalysysAgent/AnalysysAgent.h > ../AnalysysSDK_SourceCode/Classes/AnalysysAgent/AnalysysAgent_tmp.h

awk 'NR==11{print "// ***** 当前 SDK 版本号：'${version}' **************"}1' ../AnalysysSDK_SourceCode/Classes/AnalysysAgent/AnalysysAgent_tmp.h > ../AnalysysSDK_SourceCode/Classes/AnalysysAgent/AnalysysAgent_tmp1.h

mv ../AnalysysSDK_SourceCode/Classes/AnalysysAgent/AnalysysAgent_tmp1.h ../AnalysysSDK_SourceCode/Classes/AnalysysAgent/AnalysysAgent.h
rm -rf ../AnalysysSDK_SourceCode/Classes/AnalysysAgent/AnalysysAgent_tmp.h ../AnalysysSDK_SourceCode/Classes/AnalysysAgent/AnalysysAgent_tmp1.h


#进行ANSConst.m中版本号修改
sed '13d' ../AnalysysSDK_SourceCode/Classes/AnalysysAgent/ANSConst.m > ../AnalysysSDK_SourceCode/Classes/AnalysysAgent/ANSConst_tmp.m

awk 'NR==13{print "NSString *const ANSSDKVersion = @\"'${version}'\";"}1' ../AnalysysSDK_SourceCode/Classes/AnalysysAgent/ANSConst_tmp.m > ../AnalysysSDK_SourceCode/Classes/AnalysysAgent/ANSConst_tmp1.m

mv ../AnalysysSDK_SourceCode/Classes/AnalysysAgent/ANSConst_tmp1.m ../AnalysysSDK_SourceCode/Classes/AnalysysAgent/ANSConst.m
rm -rf ../AnalysysSDK_SourceCode/Classes/AnalysysAgent/ANSConst_tmp.m ../AnalysysSDK_SourceCode/Classes/AnalysysAgent/ANSConst_tmp1.m


#进行AnalysysAgent.podspec中版本号修改
sed '11d'  ../AnalysysAgent.podspec > ../AnalysysAgent_tmp.podspec


awk 'NR==11{print "      s.version          = '\'${version}\''"}1' ../AnalysysAgent_tmp.podspec  > ../AnalysysAgent_tmp1.podspec

mv ../AnalysysAgent_tmp1.podspec ../AnalysysAgent.podspec
rm -rf ../AnalysysAgent_tmp.podspec ../AnalysysAgent_tmp1.podspec




#sourceCode拷贝到AnalysysSDK
cp -rf ../AnalysysSDK_SourceCode/Classes/  .

cp ../makebuild/AnalysysAgent.sh .
cp ../makebuild/AnalysysEncrypt.sh  .
cp ../makebuild/AnalysysPush.sh .
cp ../makebuild/AnalysysVisual.sh .


#开始打包
sh AnalysysAgent.sh
sh AnalysysEncrypt.sh
sh AnalysysPush.sh
sh AnalysysVisual.sh


rm -rf AnalysysAgent.sh
rm -rf AnalysysEncrypt.sh
rm -rf AnalysysPush.sh
rm -rf AnalysysVisual.sh



cp ../makebuild/config.ini config.ini
cp ../makebuild/md5.txt md5.txt
source config.ini

currentTime='analysys_paas_iOS_SDK_'
currentTime+=${version}
currentTime+='_'
currentTime+=$(date '+%Y%m%d')
mkdir -p ${currentTime}


rm -rf ../${currentTime} ../${currentTime}.zip
cp -rf AnalysysAgent.bundle ${currentTime}/
cp -rf iOSAnalysySDK/AnalysysAgent.framework ${currentTime}/
cp -rf iOSAnalysySDK/AnalysysEncrypt.framework ${currentTime}/
cp -rf iOSAnalysySDK/AnalysysPush.framework ${currentTime}/
cp -rf iOSAnalysySDK/AnalysysVisual.framework ${currentTime}/


#md5文件内容修改

AnalysysAgentMd5=$(md5sum ${currentTime}/AnalysysAgent.framework/AnalysysAgent | awk '{print $1}')
AnalysysEncryptMd5=$(md5sum ${currentTime}/AnalysysEncrypt.framework/AnalysysEncrypt | awk '{print $1}')
AnalysysPushMd5=$(md5sum ${currentTime}/AnalysysPush.framework/AnalysysPush | awk '{print $1}')
AnalysysVisualMd5=$(md5sum ${currentTime}/AnalysysVisual.framework/AnalysysVisual | awk '{print $1}')
sed "s/79ec92789b03e35d4b71eed52902c4a1/${AnalysysAgentMd5}/" md5.txt >md5tmp.txt
mv md5tmp.txt md5.txt

sed "s/8d1647538b28f27d4391d4de597a5f19/${AnalysysEncryptMd5}/" md5.txt >md5tmp.txt
mv md5tmp.txt md5.txt

sed "s/6d77b1e1d776efae64da5ed2df510f4f/${AnalysysPushMd5}/" md5.txt >md5tmp.txt
mv md5tmp.txt md5.txt

sed "s/64afaea5c59cc4797a2b89b4fb3eff83/${AnalysysVisualMd5}/" md5.txt >md5tmp.txt
mv md5tmp.txt md5.txt


zip -r ${currentTime}.zip ${currentTime}
zip -r ${currentTime}.zip ${currentTime} md5.txt


rm -rf ${currentTime}
rm -rf md5.txt
cp ${currentTime}.zip ../${currentTime}.zip
rm -rf ${currentTime}.zip





rm -rf config.ini
