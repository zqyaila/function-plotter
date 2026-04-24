# 函数绘图器 APK 打包指南

## 环境要求

| 工具 | 版本 | 说明 |
|------|------|------|
| Node.js | 18+ | https://nodejs.org |
| JDK | 17+ | https://adoptium.net |
| Android Studio | 最新版 | https://developer.android.com/studio |
| Android SDK | API 33+ | 通过 Android Studio 安装 |

---

## 快速开始

### 1. 安装 Android Studio 并配置 SDK

安装 Android Studio 后，打开 SDK Manager 安装：
- Android SDK Platform 33 (或更新)
- Android SDK Build-Tools
- Android Emulator (可选)

### 2. 配置环境变量

**Windows (PowerShell)**
```powershell
$env:ANDROID_HOME = "$env:LOCALAPPDATA\Android\Sdk"
$env:PATH += ";$env:ANDROID_HOME\tools;$env:ANDROID_HOME\platform-tools"
```

**macOS/Linux (添加到 ~/.bashrc 或 ~/.zshrc)**
```bash
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
```

### 3. 打包

```bash
# 进入项目目录
cd function-plotter-apk

# 一键打包 (Linux/macOS)
chmod +x build.sh && ./build.sh

# 手动步骤 (Windows)
npm install
npx cap add android
npx cap sync android
cd android
gradlew.bat assembleDebug
```

### 4. 获取 APK

Debug APK 路径：
```
android/app/build/outputs/apk/debug/app-debug.apk
```

---

## 安装到手机

**方式 A - USB (adb)**
```bash
adb install android/app/build/outputs/apk/debug/app-debug.apk
```

**方式 B - 直接传输**
将 `app-debug.apk` 复制到手机，打开文件管理器安装即可
（需要在设置中开启「允许安装未知来源应用」）

---

## 发布版 APK (去除调试信息)

### 生成签名密钥
```bash
keytool -genkey -v -keystore my-release-key.jks \
  -alias function-plotter \
  -keyalg RSA -keysize 2048 \
  -validity 10000
```

### 配置签名

编辑 `android/app/build.gradle`，在 `android {}` 块内添加：

```gradle
signingConfigs {
    release {
        storeFile file('../../my-release-key.jks')
        storePassword '你的密码'
        keyAlias 'function-plotter'
        keyPassword '你的密码'
    }
}
buildTypes {
    release {
        signingConfig signingConfigs.release
        minifyEnabled false
    }
}
```

### 构建发布版
```bash
cd android && ./gradlew assembleRelease
```

发布 APK 路径：`android/app/build/outputs/apk/release/app-release.apk`

---

## 自定义图标

替换以下目录中的图标文件：
```
android/app/src/main/res/
  mipmap-hdpi/ic_launcher.png      (72x72)
  mipmap-xhdpi/ic_launcher.png     (96x96)
  mipmap-xxhdpi/ic_launcher.png    (144x144)
  mipmap-xxxhdpi/ic_launcher.png   (192x192)
```

推荐使用 Android Studio 的 Image Asset Studio 自动生成所有尺寸。

---

## 常见问题

**Q: `ANDROID_HOME` 找不到**
A: 确认 Android Studio 已安装并打开过一次，SDK 路径通常在：
- Windows: `%LOCALAPPDATA%\Android\Sdk`
- macOS: `~/Library/Android/sdk`
- Linux: `~/Android/Sdk`

**Q: Gradle 构建失败**
A: 检查 JDK 版本：`java -version`，需要 17+

**Q: 手机无法安装**
A: 前往 设置 → 安全 → 开启「未知来源」或「安装未知应用」
