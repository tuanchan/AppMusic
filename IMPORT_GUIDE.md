# 📥 Hướng dẫn Import Code vào Project Có Sẵn

Nếu bạn đã có repository `https://github.com/tuanchan/AppMusic.git` và muốn import code này vào.

## 🔄 Cách 1: Ghi đè toàn bộ (Khuyến nghị nếu repo mới)

```bash
# 1. Clone repo hiện tại
git clone https://github.com/tuanchan/AppMusic.git
cd AppMusic

# 2. Xóa toàn bộ nội dung cũ (giữ lại .git)
# Windows CMD:
for /d %i in (*) do @if not "%i"==".git" rd /s /q "%i"
del /q *.*

# Hoặc PowerShell:
Get-ChildItem -Exclude .git | Remove-Item -Recurse -Force

# 3. Copy toàn bộ file từ thư mục code mới vào
# (Giả sử code mới ở Desktop\MusicApp)
xcopy /E /I /Y C:\Users\YourName\Desktop\MusicApp\* .

# 4. Commit và push
git add .
git commit -m "Initial Music Player App"
git push origin main -f
```

---

## 🔀 Cách 2: Merge vào branch mới (Giữ lại history)

```bash
# 1. Clone repo
git clone https://github.com/tuanchan/AppMusic.git
cd AppMusic

# 2. Tạo branch mới
git checkout -b music-player-app

# 3. Xóa nội dung cũ
# Windows CMD:
for /d %i in (*) do @if not "%i"==".git" rd /s /q "%i"
del /q *.*

# 4. Copy file mới vào
xcopy /E /I /Y C:\Path\To\NewCode\* .

# 5. Commit
git add .
git commit -m "Add Music Player App"

# 6. Push branch mới
git push origin music-player-app

# 7. Merge vào main (trên GitHub hoặc local)
git checkout main
git merge music-player-app
git push origin main
```

---

## 📋 Cách 3: Setup từ đầu trong repo có sẵn

```bash
# 1. Clone repo
git clone https://github.com/tuanchan/AppMusic.git
cd AppMusic

# 2. Tạo Flutter project
flutter create --org com.tuanchan --platforms ios,android .

# 3. Thay thế file pubspec.yaml
# Copy nội dung từ pubspec.yaml mới

# 4. Get dependencies
flutter pub get

# 5. Tạo cấu trúc thư mục
mkdir lib\models
mkdir lib\screens
mkdir lib\widgets
mkdir lib\services
mkdir lib\utils
mkdir assets\icons

# 6. Copy từng file vào đúng thư mục:
# lib\main.dart
# lib\models\song.dart
# lib\screens\home_screen.dart
# lib\screens\player_screen.dart
# lib\services\music_service.dart
# lib\services\file_service.dart
# lib\utils\app_theme.dart
# ios\Runner\Info.plist
# .github\workflows\ios-build.yml

# 7. Commit
git add .
git commit -m "Setup Music Player App"
git push origin main
```

---

## 🚀 Các lệnh CMD đầy đủ (Copy & Paste)

### Nếu repo hoàn toàn trống:

```cmd
REM Bước 1: Clone repo
git clone https://github.com/tuanchan/AppMusic.git
cd AppMusic

REM Bước 2: Tạo Flutter project
flutter create --org com.tuanchan --platforms ios,android .

REM Bước 3: Cài dependencies
flutter pub add just_audio
flutter pub add audio_service
flutter pub add file_picker
flutter pub add path_provider
flutter pub add permission_handler
flutter pub add audio_video_progress_bar
flutter pub add rxdart
flutter pub add shared_preferences
flutter pub add audio_session
flutter pub add flutter_launcher_icons --dev

REM Bước 4: Tạo cấu trúc
mkdir lib\models
mkdir lib\screens
mkdir lib\services
mkdir lib\utils
mkdir assets\icons
mkdir .github\workflows

REM Bước 5: Copy tất cả file đã tạo vào đúng vị trí
REM (Cần copy thủ công hoặc dùng script)

REM Bước 6: Run app để test
flutter pub get
flutter run

REM Bước 7: Commit và push
git add .
git commit -m "Initial commit - Music Player App"
git push origin main
```

---

## 📝 Checklist sau khi import

- [ ] File `pubspec.yaml` đã được cập nhật
- [ ] Chạy `flutter pub get` thành công
- [ ] Tất cả file trong `lib/` đã được copy
- [ ] File `ios/Runner/Info.plist` đã có permissions
- [ ] File `.github/workflows/ios-build.yml` đã có
- [ ] Chạy `flutter run` không có lỗi
- [ ] Push code lên GitHub thành công
- [ ] GitHub Actions workflow chạy thành công

---

## ⚠️ Lưu ý

1. **Backup trước khi ghi đè**: Nếu repo có code cũ quan trọng, backup trước
2. **Xóa .git cẩn thận**: Không xóa thư mục `.git` nếu muốn giữ history
3. **Kiểm tra .gitignore**: Đảm bảo file `.gitignore` phù hợp với Flutter
4. **Test local trước**: Chạy `flutter run` local trước khi push
5. **GitHub Actions**: Kiểm tra workflow chạy thành công sau khi push

---

## 🆘 Gặp vấn đề?

### Lỗi khi flutter pub get
```bash
flutter clean
flutter pub get
```

### Lỗi git conflict
```bash
git fetch origin
git reset --hard origin/main
```

### Muốn làm lại từ đầu
```bash
# Xóa thư mục AppMusic
cd ..
rmdir /s /q AppMusic

# Clone lại
git clone https://github.com/tuanchan/AppMusic.git
cd AppMusic
```

---

**Hoàn thành! Giờ bạn có thể build IPA qua GitHub Actions** 🎉
