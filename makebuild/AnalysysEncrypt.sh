
SRCROOT="."
FMK_NAME="AnalysysEncrypt"
INSTALL_DIR=${SRCROOT}/iOSAnalysySDK/${FMK_NAME}.framework

# 清理原有库
if [ -d "${INSTALL_DIR}" ]
then
rm -rf "${INSTALL_DIR}"
fi

WRK_DIR=build
DEVICE_DIR=${WRK_DIR}/Release-iphoneos/${FMK_NAME}.framework
SIMULATOR_DIR=${WRK_DIR}/Release-iphonesimulator/${FMK_NAME}.framework

# 编译库framework
xcodebuild clean
xcodebuild -configuration "Release" -target "${FMK_NAME}" -sdk iphoneos build
xcodebuild -configuration "Release" -target "${FMK_NAME}" -sdk iphonesimulator build

# 适配xcode 12 模拟器与真机framework都包含arm64架构，导致编译失败
lipo "${SIMULATOR_DIR}/${FMK_NAME}" -remove arm64 -output "${SIMULATOR_DIR}/${FMK_NAME}"

## 合并framework
mkdir -p "${INSTALL_DIR}"
cp -R "${DEVICE_DIR}/" "${INSTALL_DIR}/"
lipo -create "${DEVICE_DIR}/${FMK_NAME}" "${SIMULATOR_DIR}/${FMK_NAME}" -output "${INSTALL_DIR}/${FMK_NAME}"

rm -r "${WRK_DIR}"
#open "${SRCROOT}/iOSAnalysySDK"




