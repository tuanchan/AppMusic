# 🎵 MUSIC PLAYER APP - PROJECT SUMMARY

## 📦 Tổng Quan Dự Án

**Tên ứng dụng**: Music Player App
**Platform**: iOS & Android
**Framework**: Flutter 3.0+
**Repository**: https://github.com/tuanchan/AppMusic.git
**Theme**: Đỏ Đen Neon (#FF0040, #000000)

---

## ✨ Tính Năng Chính

✅ **Quản lý nhạc**
- Import file/thư mục tự động
- Quét đệ quy tất cả sub-folders
- Đổi tên, xóa, thêm file trực tiếp
- Lưu danh sách tự động

✅ **Player đầy đủ**
- Play/Pause/Next/Previous
- Shuffle & Repeat modes
- Progress bar với seek
- Mini player sticky
- Background audio support

✅ **Giao diện**
- Theme đỏ đen neon
- Animation quay album
- Neon glow effects
- Dark mode optimized

✅ **Hỗ trợ formats**
MP3, M4A, WAV, FLAC, AAC, OGG, WMA, OPUS

---

## 📁 Cấu Trúc Project

```
AppMusic/
├── lib/
│   ├── main.dart                    # Entry point
│   ├── models/
│   │   └── song.dart               # Data model
│   ├── screens/
│   │   ├── home_screen.dart        # Danh sách nhạc + Mini player
│   │   └── player_screen.dart      # Full player UI
│   ├── services/
│   │   ├── music_service.dart      # Audio playback logic
│   │   └── file_service.dart       # File management
│   └── utils/
│       └── app_theme.dart          # Theme config
│
├── ios/
│   └── Runner/
│       └── Info.plist              # iOS permissions
│
├── android/
│   └── app/
│       └── src/main/
│           └── AndroidManifest.xml # Android permissions
│
├── .github/
│   └── workflows/
│       └── ios-build.yml           # GitHub Actions workflow
│
├── assets/
│   └── icons/                      # App icons
│
├── COMPLETE_SETUP.bat              # Setup script tự động
├── QUICK_START.md                  # Quick reference
├── BUILD_IPA_GUIDE.md             # iOS build chi tiết
├── IMPORT_GUIDE.md                # Import vào repo có sẵn
└── README.md                       # Documentation chính
```

---

## 🎨 Theme Colors

```dart
Neon Red:   #FF0040  // Primary, buttons, accents
Dark Red:   #8B0000  // Secondary
Black:      #000000  // Background
Dark Gray:  #1A1A1A  // Cards, surfaces
Light Gray: #2A2A2A  // Borders
Text White: #FFFFFF  // Primary text
Text Gray:  #B0B0B0  // Secondary text
```

---

## 📦 Dependencies

### Main Dependencies
```yaml
just_audio: ^0.9.36                    # Audio playback
audio_service: ^0.18.12                # Background audio
audio_session: ^0.1.18                 # Audio session management
audio_video_progress_bar: ^2.0.1       # Progress bar UI
file_picker: ^6.1.1                    # File picking
path_provider: ^2.1.1                  # Path utilities
permission_handler: ^11.1.0            # Permissions
rxdart: ^0.27.7                        # Reactive programming
shared_preferences: ^2.2.2             # Local storage
```

### Dev Dependencies
```yaml
flutter_launcher_icons: ^0.13.1        # Generate app icons
```

---

## 🚀 Cách Sử Dụng

### 1️⃣ Setup Project (Lần Đầu)

**Option A: Tự động (Khuyến nghị)**
```cmd
git clone https://github.com/tuanchan/AppMusic.git
cd AppMusic
COMPLETE_SETUP.bat
```

**Option B: Thủ công**
```cmd
git clone https://github.com/tuanchan/AppMusic.git
cd AppMusic
flutter create --org com.tuanchan --platforms ios,android .
flutter pub add just_audio audio_service file_picker path_provider permission_handler audio_video_progress_bar rxdart shared_preferences audio_session
flutter pub add flutter_launcher_icons --dev
flutter pub get
```

### 2️⃣ Chạy App

```cmd
# Check devices
flutter devices

# Run on device
flutter run

# Run release mode
flutter run --release
```

### 3️⃣ Build

**Android APK**
```cmd
flutter build apk --release
# Output: build\app\outputs\flutter-apk\app-release.apk
```

**Android App Bundle**
```cmd
flutter build appbundle --release
# Output: build\app\outputs\bundle\release\app-release.aab
```

**iOS (macOS only)**
```cmd
flutter build ios --release
# Output: build\ios\iphoneos\Runner.app
```

### 4️⃣ Deploy

**Push to GitHub**
```cmd
git add .
git commit -m "Update"
git push origin main
```

**Build IPA via GitHub Actions**
1. Push code lên GitHub
2. Vào: https://github.com/tuanchan/AppMusic/actions
3. Wait for workflow completion
4. Download IPA from Artifacts
5. Install với AltStore/Sideloadly

---

## 🔑 Key Features Code

### Music Service (Singleton)
```dart
MusicService()
  .setPlaylist(songs)           // Set danh sách
  .playSongAt(index)            // Phát bài tại index
  .togglePlayPause()            // Play/Pause
  .next()                        // Next song
  .previous()                    // Previous song
  .seek(duration)                // Seek to position
  .toggleShuffle()               // Bật/tắt shuffle
  .toggleLoopMode()              // Cycle loop modes
```

### File Service (Singleton)
```dart
FileService()
  .pickAudioFiles()              // Chọn files
  .pickFolder()                  // Chọn folder
  .scanFolder(path)              // Quét folder đệ quy
  .renameFile(song, newName)     // Đổi tên
  .deleteFile(path)              // Xóa file
  .saveSongs(songs)              // Lưu danh sách
  .loadSongs()                   // Load danh sách
```

---

## 📱 Permissions

### iOS (Info.plist)
```xml
<key>NSAppleMusicUsageDescription</key>
<string>Access music library</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Select audio files</string>
<key>UIBackgroundModes</key>
<array><string>audio</string></array>
```

### Android (AndroidManifest.xml)
```xml
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WAKE_LOCK"/>
<uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
```

---

## 🐛 Troubleshooting

### Lỗi Dependencies
```cmd
flutter clean
flutter pub get
```

### Lỗi iOS Build
```cmd
cd ios
pod deintegrate
pod install
cd ..
flutter clean
flutter build ios
```

### Lỗi Android Build
```cmd
flutter clean
cd android
gradlew clean
cd ..
flutter build apk
```

### Lỗi Git
```cmd
git fetch origin
git reset --hard origin/main
```

---

## 📊 GitHub Actions Workflow

File: `.github/workflows/ios-build.yml`

**Trigger**: Push to main/master branch

**Steps**:
1. Checkout code
2. Setup Flutter
3. Install dependencies
4. Run tests (continue on error)
5. Build iOS (no codesign)
6. Create IPA
7. Upload artifacts

**Outputs**:
- `AppMusic-iOS.zip` - IPA file
- `Runner-app.zip` - Runner.app bundle

---

## 🎯 Next Steps

### Improvements
- [ ] Add metadata extraction (ID3 tags)
- [ ] Add playlist management
- [ ] Add equalizer
- [ ] Add lyrics support
- [ ] Add online streaming
- [ ] Add social sharing

### Production
- [ ] Setup Apple Developer Account
- [ ] Create App ID & Certificates
- [ ] Setup TestFlight
- [ ] Submit to App Store
- [ ] Setup Firebase Analytics
- [ ] Add crash reporting

---

## 📞 Support

- **Repository**: https://github.com/tuanchan/AppMusic
- **Issues**: https://github.com/tuanchan/AppMusic/issues
- **Discussions**: https://github.com/tuanchan/AppMusic/discussions

---

## 📄 License

MIT License - Free to use and modify

---

## 🙏 Credits

- **just_audio** - Audio playback
- **audio_service** - Background audio
- **file_picker** - File selection
- **Flutter** - Framework

---

**Created with ❤️ by tuanchan**

**Version**: 1.0.0
**Last Updated**: 2024

---

## 🔗 Quick Links

- [Quick Start Guide](QUICK_START.md)
- [iOS Build Guide](BUILD_IPA_GUIDE.md)
- [Import Guide](IMPORT_GUIDE.md)
- [Setup Script](COMPLETE_SETUP.bat)
- [README](README.md)

---

**🎵 Happy Listening! 🎧**
