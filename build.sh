#!/bin/bash
# ╔══════════════════════════════════════════════════════╗
# ║        函数绘图器 APK 打包脚本                        ║
# ║  需要: Node.js 18+, JDK 17+, Android SDK             ║
# ╚══════════════════════════════════════════════════════╝

set -e
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'

echo -e "${GREEN}[1/5] 安装依赖...${NC}"
npm install

echo -e "${GREEN}[2/5] 添加 Android 平台...${NC}"
npx cap add android || echo "Android 平台已存在，跳过"

echo -e "${GREEN}[3/5] 同步 Web 资源到 Android...${NC}"
npx cap sync android

echo -e "${GREEN}[4/5] 构建 Debug APK...${NC}"
cd android
chmod +x gradlew
./gradlew assembleDebug

cd ..
APK_PATH="android/app/build/outputs/apk/debug/app-debug.apk"
echo -e "${GREEN}[5/5] 完成！${NC}"
echo -e "${YELLOW}APK 路径: ${APK_PATH}${NC}"
echo ""
echo "📦 安装到手机: adb install ${APK_PATH}"
echo "📦 或直接复制 APK 到手机安装"
