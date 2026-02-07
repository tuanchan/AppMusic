# 🚀 QUICK START - Các lệnh CMD từ đầu đến cuối

## 📋 Prerequisites
- Git đã cài đặt
- Flutter SDK đã cài đặt
- Xcode (cho iOS) hoặc Android Studio (cho Android)

---

## 🔥 OPTION 1: Clone và Setup Tự Động (KHUYẾN NGHỊ)

```cmd
REM Bước 1: Clone repository
git clone https://github.com/tuanchan/AppMusic.git
cd AppMusic

REM Bước 2: Chạy script setup tự động
COMPLETE_SETUP.bat

REM Script sẽ tự động:
REM - Tạo Flutter project structure
REM - Cài đặt tất cả dependencies
REM - Tạo folders cần thiết
REM - Hướng dẫn copy files
REM - Build và push lên GitHub
```

---

## 💻 OPTION 2: Setup Thủ Công - Các Lệnh CMD Chi Tiết

### A. Clone và Khởi Tạo

```cmd
REM Clone repository
git clone https://github.com/tuanchan/AppMusic.git
cd AppMusic

REM Tạo Flutter project
flutter create --org com.tuanchan --platforms ios,android .
```

### B. Cài Dependencies

```cmd
REM Cài các package chính
flutter pub add just_audio
flutter pub add audio_service
flutter pub add file_picker
flutter pub add path_provider
flutter pub add permission_handler
flutter pub add audio_video_progress_bar
flutter pub add rxdart
flutter pub add shared_preferences
flutter pub add audio_session

REM Cài dev dependencies
flutter pub add flutter_launcher_icons --dev

REM Get tất cả dependencies
flutter pub get
```

### C. Tạo Cấu Trúc Thư Mục

```cmd
REM Tạo folders
mkdir lib\models
mkdir lib\screens
mkdir lib\services
mkdir lib\utils
mkdir assets\icons
mkdir .github\workflows
```

### D. Copy Files (Thủ Công)

Copy các file sau vào đúng vị trí:
- `lib\main.dart`
- `lib\models\song.dart`
- `lib\screens\home_screen.dart`
- `lib\screens\player_screen.dart`
- `lib\services\music_service.dart`
- `lib\services\file_service.dart`
- `lib\utils\app_theme.dart`
- `pubspec.yaml` (QUAN TRỌNG!)
- `ios\Runner\Info.plist`
- `.github\workflows\ios-build.yml`
- `.gitignore`
- `README.md`

### E. Test và Build

```cmd
REM Kiểm tra lỗi
flutter analyze

REM Chạy app trên device
flutter run

REM Build Android APK
flutter build apk --release

REM Build Android App Bundle
flutter build appbundle --release
```

### F. Push lên GitHub

```cmd
REM Add tất cả files
git add .

REM Commit
git commit -m "Initial commit - Music Player App"

REM Push lên GitHub
git push origin main
```

---

## 📱 BUILD IPA (iOS)

### Cách 1: Qua GitHub Actions (Tự động)

```cmd
REM Sau khi push code lên GitHub
REM 1. Vào: https://github.com/tuanchan/AppMusic/actions
REM 2. Chờ workflow "Build iOS IPA" hoàn thành
REM 3. Download file từ Artifacts
REM 4. Cài đặt bằng AltStore hoặc Sideloadly
```

### Cách 2: Build Local (macOS)

```cmd
REM Build iOS
flutter build ios --release

REM Tạo IPA
cd build\ios\iphoneos
mkdir Payload
xcopy /E /I Runner.app Payload\Runner.app
powershell Compress-Archive -Path Payload -DestinationPath AppMusic.zip
ren AppMusic.zip AppMusic.ipa
```

---

## 🎯 Các Lệnh Hữu Ích

```cmd
REM Xem devices kết nối
flutter devices

REM Clean project
flutter clean

REM Xóa và cài lại dependencies
flutter pub get

REM Update Flutter
flutter upgrade

REM Check Flutter doctor
flutter doctor

REM Run với hot reload
flutter run

REM Build release APK
flutter build apk --release

REM Build iOS (macOS only)
flutter build ios --release

REM Check dependencies
flutter pub outdated

REM Fix dependencies
flutter pub upgrade

REM Generate app icon
flutter pub run flutter_launcher_icons
```

---

## 🔧 Troubleshooting Commands

```cmd
REM Lỗi dependencies
flutter clean
flutter pub get

REM Lỗi build iOS
cd ios
pod deintegrate
pod install
cd ..
flutter clean
flutter build ios

REM Lỗi build Android
flutter clean
cd android
gradlew clean
cd ..
flutter build apk

REM Reset Git
git fetch origin
git reset --hard origin/main
```

---

## 📍 Các Path Quan Trọng

```
Project Root: AppMusic\

Source Code:
  AppMusic\lib\
  AppMusic\lib\main.dart
  AppMusic\lib\models\
  AppMusic\lib\screens\
  AppMusic\lib\services\
  AppMusic\lib\utils\

iOS Config:
  AppMusic\ios\Runner\Info.plist

Android Config:
  AppMusic\android\app\src\main\AndroidManifest.xml

GitHub Actions:
  AppMusic\.github\workflows\ios-build.yml

Build Outputs:
  Android APK: AppMusic\build\app\outputs\flutter-apk\app-release.apk
  iOS Runner: AppMusic\build\ios\iphoneos\Runner.app
```

---

## ⚡ One-Line Commands (Copy-Paste Nhanh)

```cmd
REM Setup nhanh (tất cả trong 1 dòng)
git clone https://github.com/tuanchan/AppMusic.git && cd AppMusic && flutter create --org com.tuanchan --platforms ios,android . && flutter pub add just_audio audio_service file_picker path_provider permission_handler audio_video_progress_bar rxdart shared_preferences audio_session && flutter pub add flutter_launcher_icons --dev && flutter pub get

REM Build và push nhanh
flutter clean && flutter pub get && flutter build apk --release && git add . && git commit -m "Build update" && git push origin main
```

---

## 📚 Tài Liệu Đầy Đủ

Xem chi tiết hơn tại:
- `README.md` - Hướng dẫn tổng quan
- `BUILD_IPA_GUIDE.md` - Chi tiết build iOS
- `IMPORT_GUIDE.md` - Import vào project có sẵn
- `COMPLETE_SETUP.bat` - Script setup tự động

---

**Happy Coding! 🎵🎧**
