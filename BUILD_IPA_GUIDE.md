# 📱 Hướng dẫn Build IPA cho iOS

## Phương án 1: Build qua GitHub Actions (KHUYẾN NGHỊ)

### Bước 1: Push code lên GitHub

```bash
# Từ thư mục AppMusic
git init
git add .
git commit -m "Initial commit - Music Player App"
git remote add origin https://github.com/tuanchan/AppMusic.git
git branch -M main
git push -u origin main
```

### Bước 2: Chờ GitHub Actions build

1. Vào repository trên GitHub: https://github.com/tuanchan/AppMusic
2. Click vào tab **Actions**
3. Chờ workflow "Build iOS IPA" chạy xong (khoảng 10-15 phút)
4. Download file **AppMusic-iOS** từ Artifacts

### Bước 3: Install IPA

File IPA không được codesign, bạn cần dùng một trong các công cụ:

#### Option A: AltStore (FREE)
1. Cài AltStore trên máy tính: https://altstore.io/
2. Cài AltServer trên iPhone
3. Kéo thả file IPA vào AltStore
4. App sẽ được cài đặt với free developer certificate

#### Option B: Sideloadly (FREE)
1. Download Sideloadly: https://sideloadly.io/
2. Kết nối iPhone qua USB
3. Kéo thả IPA vào Sideloadly
4. Đăng nhập Apple ID (free account)
5. Click Start

#### Option C: iOS App Signer (macOS)
1. Download iOS App Signer
2. Tạo free provisioning profile từ Xcode
3. Sign IPA với profile
4. Cài bằng Apple Configurator 2

---

## Phương án 2: Build Local (Cần macOS + Xcode)

### Yêu cầu:
- macOS
- Xcode 15+
- CocoaPods
- Apple Developer Account (FREE hoặc PAID)

### Các bước:

#### 1. Setup môi trường

```bash
# Cài CocoaPods
sudo gem install cocoapods

# Vào thư mục iOS
cd ios

# Cài dependencies
pod install

cd ..
```

#### 2. Build với FREE Apple ID

```bash
# Build app
flutter build ios --release

# Tạo IPA
cd build/ios/iphoneos
mkdir Payload
cp -r Runner.app Payload/
zip -r AppMusic.ipa Payload
```

File IPA tạo ra ở: `build/ios/iphoneos/AppMusic.ipa`

#### 3. Build với Developer Account ($99/năm)

##### Tạo Certificates & Profiles:

1. Vào https://developer.apple.com/account
2. Tạo **App ID**: `com.tuanchan.appmusic`
3. Tạo **Distribution Certificate**
4. Tạo **Provisioning Profile** (Ad Hoc hoặc App Store)
5. Download certificate và profile

##### Cấu hình Xcode:

```bash
# Mở project trong Xcode
open ios/Runner.xcworkspace
```

Trong Xcode:
1. Select **Runner** project
2. Select **Runner** target
3. Tab **Signing & Capabilities**:
   - Team: Chọn team của bạn
   - Bundle Identifier: `com.tuanchan.appmusic`
   - Provisioning Profile: Chọn profile vừa tạo

##### Build IPA signed:

```bash
# Build với signing
flutter build ipa --release

# IPA ở:
# build/ios/ipa/appmusic.ipa
```

---

## Phương án 3: TestFlight Distribution

Nếu có Apple Developer Account ($99/năm):

### 1. Cấu hình App Store Connect

1. Vào https://appstoreconnect.apple.com
2. Tạo app mới với Bundle ID: `com.tuanchan.appmusic`
3. Điền thông tin app

### 2. Upload qua Xcode

```bash
# Build archive
flutter build ipa --release

# Hoặc trong Xcode:
open ios/Runner.xcworkspace
# Product > Archive
# Upload to App Store Connect
```

### 3. TestFlight

1. Sau khi upload, vào App Store Connect
2. TestFlight > Builds
3. Chọn build vừa upload
4. Add External Testers
5. Gửi link TestFlight cho người dùng

---

## ⚠️ Lưu ý quan trọng

### Free Apple ID
- App chỉ hoạt động 7 ngày
- Cần re-sign mỗi 7 ngày
- Tối đa 3 apps cùng lúc
- Không thể distribute

### Paid Developer Account ($99/năm)
- App hoạt động 1 năm
- Có thể distribute qua TestFlight
- Có thể publish lên App Store
- Unlimited apps

### IPA từ GitHub Actions
- Không được codesign
- Phải dùng AltStore/Sideloadly
- Cần re-sign mỗi 7 ngày với free account

---

## 🔧 Troubleshooting

### Lỗi "Unable to install"
- Kiểm tra device đã trust certificate chưa
- Settings > General > VPN & Device Management
- Trust certificate

### Lỗi "App not opening"
- Xóa app và cài lại
- Restart device
- Re-sign IPA

### Lỗi khi build
```bash
# Clean và rebuild
flutter clean
cd ios
pod deintegrate
pod install
cd ..
flutter build ios
```

---

## 📚 Tài liệu tham khảo

- Flutter iOS deployment: https://docs.flutter.dev/deployment/ios
- AltStore: https://altstore.io/
- Sideloadly: https://sideloadly.io/
- Apple Developer: https://developer.apple.com/

---

**Chúc bạn build thành công! 🎉**
