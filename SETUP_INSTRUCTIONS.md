# 🎵 HƯỚNG DẪN SETUP DỰ ÁN APPMUSIC

## 📦 Bạn đã có gì?

✅ Dự án Flutter hoàn chỉnh
✅ Tất cả source code
✅ Config files cho iOS & Android
✅ GitHub Actions workflow
✅ Documentation đầy đủ

## 🚀 CÁCH 1: Import vào GitHub (KHUYẾN NGHỊ)

### Bước 1: Giải nén folder AppMusic

Giải nén folder `AppMusic` ra desktop hoặc nơi bạn muốn.

### Bước 2: Mở CMD/Terminal tại folder AppMusic

```cmd
cd Desktop\AppMusic
```

### Bước 3: Init Git và push lên GitHub

```cmd
# Init git repository
git init

# Add remote (thay bằng URL repo của bạn)
git remote add origin https://github.com/tuanchan/AppMusic.git

# Add tất cả files
git add .

# Commit
git commit -m "Initial commit - Music Player App"

# Push lên GitHub
git branch -M main
git push -u origin main
```

### Bước 4: Install dependencies

```cmd
# Get Flutter dependencies
flutter pub get

# Check for issues
flutter doctor
```

### Bước 5: Chạy app

```cmd
# Xem devices
flutter devices

# Run app
flutter run
```

### Bước 6: Build IPA qua GitHub Actions

- Sau khi push, vào: https://github.com/tuanchan/AppMusic/actions
- GitHub Actions sẽ tự động build IPA
- Download từ Artifacts

---

## 🔧 CÁCH 2: Chạy local không cần GitHub

### Bước 1: Vào folder AppMusic

```cmd
cd AppMusic
```

### Bước 2: Install dependencies

```cmd
flutter pub get
```

### Bước 3: Chạy app

```cmd
# Android/iOS Simulator
flutter run

# Build APK
flutter build apk --release
```

---

## 📱 Cấu trúc dự án

```
AppMusic/
├── lib/                        # Source code
│   ├── main.dart              # Entry point
│   ├── models/                # Data models
│   ├── screens/               # UI screens
│   ├── services/              # Business logic
│   └── utils/                 # Utilities
├── ios/                       # iOS config
├── android/                   # Android config
├── .github/workflows/         # CI/CD
├── assets/                    # Resources
├── pubspec.yaml              # Dependencies
└── README.md                 # Documentation
```

---

## ⚙️ Các lệnh hữu ích

```cmd
# Install dependencies
flutter pub get

# Run app
flutter run

# Build Android APK
flutter build apk --release

# Build iOS (macOS only)
flutter build ios --release

# Clean project
flutter clean

# Check issues
flutter doctor

# Analyze code
flutter analyze
```

---

## 🐛 Troubleshooting

### Lỗi "flutter not found"
- Cài Flutter SDK: https://flutter.dev/
- Add Flutter vào PATH

### Lỗi dependencies
```cmd
flutter clean
flutter pub get
```

### Lỗi iOS build
```cmd
cd ios
pod install
cd ..
flutter build ios
```

---

## 📚 Tài liệu

- `README.md` - Hướng dẫn tổng quan
- `QUICK_START.md` - Quick reference
- `BUILD_IPA_GUIDE.md` - Build iOS chi tiết
- `ALL_COMMANDS.txt` - Tất cả commands

---

## 🎯 Next Steps

1. ✅ Extract folder AppMusic
2. ✅ Open CMD tại folder
3. ✅ Run: `flutter pub get`
4. ✅ Run: `flutter run`
5. ✅ Push lên GitHub (optional)
6. ✅ Build IPA qua GitHub Actions

**Chúc bạn thành công! 🎵**
