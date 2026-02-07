# 🎵 Music Player App

Ứng dụng nghe nhạc Flutter với giao diện đỏ đen neon hiện đại, hỗ trợ iOS và Android.

## ✨ Tính năng

- 🎧 Phát nhạc từ file audio trên thiết bị
- 📁 Quét và import thư mục tự động (đệ quy)
- 📂 Import trực tiếp file hoặc thư mục
- ✏️ Đổi tên, thêm, sửa, xóa file nhạc
- 🎵 Player đầy đủ tính năng:
  - Play/Pause/Next/Previous
  - Shuffle & Repeat modes
  - Progress bar với seek
  - Mini player
- 🎨 Giao diện tối ưu với theme đỏ đen neon
- 💾 Lưu danh sách phát tự động

## 🚀 Cài đặt

### Prerequisites

- Flutter SDK 3.0+
- Xcode (cho iOS build)
- Git

### Các lệnh CMD để setup và import project

```bash
# 1. Clone repository
git clone https://github.com/tuanchan/AppMusic.git
cd AppMusic

# 2. Cài đặt dependencies
flutter pub get

# 3. Chạy app trên simulator/device
flutter run

# 4. Build APK cho Android
flutter build apk --release

# 5. Build App Bundle cho Android
flutter build appbundle --release
```

## 📱 Build iOS IPA

### Cách 1: Build local (cần macOS)

```bash
# Build iOS
flutter build ios --release

# Tạo IPA thủ công
cd build/ios/iphoneos
mkdir Payload
cp -r Runner.app Payload/
zip -r AppMusic.ipa Payload
```

### Cách 2: Build tự động qua GitHub Actions

1. Push code lên GitHub:
```bash
git add .
git commit -m "Initial commit"
git push origin main
```

2. GitHub Actions sẽ tự động build và tạo IPA
3. Download artifact từ tab "Actions" trên GitHub

**Lưu ý**: IPA không được codesign sẽ cần:
- Sideload qua AltStore, Sideloadly
- Hoặc codesign với Apple Developer Account

## 🔧 Cấu trúc Project

```
lib/
├── main.dart                 # Entry point
├── models/
│   └── song.dart            # Song model
├── screens/
│   ├── home_screen.dart     # Danh sách nhạc
│   └── player_screen.dart   # Màn hình phát nhạc
├── services/
│   ├── music_service.dart   # Audio player service
│   └── file_service.dart    # File management
└── utils/
    └── app_theme.dart       # Theme configuration
```

## 🎨 Màu sắc Theme

- **Neon Red**: `#FF0040`
- **Dark Red**: `#8B0000`
- **Black**: `#000000`
- **Dark Gray**: `#1A1A1A`
- **Light Gray**: `#2A2A2A`

## 📝 Supported Audio Formats

- MP3
- M4A
- WAV
- FLAC
- AAC
- OGG
- WMA
- OPUS

## 🔐 Permissions

### iOS (Info.plist)
- `NSAppleMusicUsageDescription` - Truy cập thư viện nhạc
- `NSPhotoLibraryUsageDescription` - Chọn file audio
- `UIBackgroundModes` - Phát nhạc nền

### Android (sẽ tự động thêm)
- `READ_EXTERNAL_STORAGE`
- `MANAGE_EXTERNAL_STORAGE`
- `WAKE_LOCK`
- `FOREGROUND_SERVICE`

## 🛠️ Troubleshooting

### Lỗi permission trên iOS
- Đảm bảo Info.plist có đầy đủ permissions
- Restart app sau khi cấp quyền

### Lỗi build iOS
```bash
# Clean và rebuild
flutter clean
flutter pub get
cd ios
pod install
cd ..
flutter build ios
```

### Không thấy file audio
- Kiểm tra quyền truy cập storage
- Đảm bảo file có định dạng được hỗ trợ

## 📄 License

MIT License

## 👨‍💻 Developer

Created by tuanchan

---

**Happy Listening! 🎵**
