# 📍 Hướng dẫn đặt Firebase Configuration Keys

## Vị trí đặt các file cấu hình Firebase

### 🔵 Android

**File cần đặt:** `google-services.json`

**Vị trí:**
```
android/app/google-services.json
```

**Cách lấy file:**
1. Vào [Firebase Console](https://console.firebase.google.com)
2. Chọn project của bạn
3. Vào **Project Settings** (⚙️ icon)
4. Scroll xuống phần **Your apps**
5. Chọn app Android (hoặc tạo mới nếu chưa có)
6. Tải file `google-services.json`
7. Copy file vào thư mục `android/app/`

**Cấu trúc thư mục:**
```
app-clinic-appointment-booking/
├── android/
│   ├── app/
│   │   ├── google-services.json  ← ĐẶT FILE Ở ĐÂY
│   │   ├── build.gradle
│   │   └── src/
│   └── build.gradle
```

### 🍎 iOS

**File cần đặt:** `GoogleService-Info.plist`

**Vị trí:**
```
ios/Runner/GoogleService-Info.plist
```

**Cách lấy file:**
1. Vào [Firebase Console](https://console.firebase.google.com)
2. Chọn project của bạn
3. Vào **Project Settings** (⚙️ icon)
4. Scroll xuống phần **Your apps**
5. Chọn app iOS (hoặc tạo mới nếu chưa có)
6. Tải file `GoogleService-Info.plist`
7. Copy file vào thư mục `ios/Runner/`

**Cấu trúc thư mục:**
```
app-clinic-appointment-booking/
├── ios/
│   ├── Runner/
│   │   ├── GoogleService-Info.plist  ← ĐẶT FILE Ở ĐÂY
│   │   ├── Info.plist
│   │   └── AppDelegate.swift
│   └── Podfile
```

### 🌐 Web (nếu cần)

**File cần cấu hình:** `index.html` trong `web/`

**Vị trí:**
```
web/index.html
```

**Cách cấu hình:**
Thêm script vào `<head>` của `index.html`:

```html
<script src="https://www.gstatic.com/firebasejs/10.x.x/firebase-app.js"></script>
<script src="https://www.gstatic.com/firebasejs/10.x.x/firebase-firestore.js"></script>
<script>
  const firebaseConfig = {
    apiKey: "YOUR_API_KEY",
    authDomain: "YOUR_PROJECT_ID.firebaseapp.com",
    projectId: "YOUR_PROJECT_ID",
    storageBucket: "YOUR_PROJECT_ID.appspot.com",
    messagingSenderId: "YOUR_SENDER_ID",
    appId: "YOUR_APP_ID"
  };
  firebase.initializeApp(firebaseConfig);
</script>
```

## 🚀 Cách tự động setup (Khuyến nghị)

Sử dụng `flutterfire configure` để tự động setup tất cả:

### Bước 1: Cài đặt FlutterFire CLI

```bash
dart pub global activate flutterfire_cli
```

### Bước 2: Đăng nhập Firebase

```bash
firebase login
```

### Bước 3: Chạy cấu hình tự động

```bash
flutterfire configure
```

Lệnh này sẽ:
- ✅ Tự động phát hiện các platform (Android, iOS, Web)
- ✅ Tải và đặt các file cấu hình vào đúng vị trí
- ✅ Tạo file `firebase_options.dart` trong root project
- ✅ Cập nhật các file build.gradle và Podfile nếu cần

### Bước 4: Cập nhật main.dart

Sau khi chạy `flutterfire configure`, file `firebase_options.dart` sẽ được tạo. Cập nhật `main.dart`:

```dart
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // ...
}
```

## 📋 Checklist

Sau khi setup, kiểm tra:

### Android
- [ ] File `android/app/google-services.json` đã có
- [ ] File `android/build.gradle` có dòng:
  ```gradle
  classpath 'com.google.gms:google-services:4.4.0'
  ```
- [ ] File `android/app/build.gradle` có dòng ở cuối:
  ```gradle
  apply plugin: 'com.google.gms.google-services'
  ```

### iOS
- [ ] File `ios/Runner/GoogleService-Info.plist` đã có
- [ ] Đã chạy `pod install` trong thư mục `ios/`:
  ```bash
  cd ios
  pod install
  cd ..
  ```

### Flutter
- [ ] File `firebase_options.dart` đã được tạo (nếu dùng flutterfire configure)
- [ ] Đã chạy `flutter pub get`
- [ ] `main.dart` đã import và sử dụng Firebase options

## ⚠️ Lưu ý quan trọng

1. **Không commit các file cấu hình vào Git** (nếu repo là public)
   - File `google-services.json` và `GoogleService-Info.plist` chứa thông tin nhạy cảm
   - Đảm bảo chúng đã có trong `.gitignore`

2. **Mỗi platform cần file riêng:**
   - Android: `google-services.json`
   - iOS: `GoogleService-Info.plist`
   - Web: Config trong `index.html`

3. **Kiểm tra package name/bundle ID:**
   - Android: Package name trong `android/app/build.gradle` phải khớp với Firebase Console
   - iOS: Bundle ID trong `ios/Runner.xcodeproj` phải khớp với Firebase Console

## 🔍 Kiểm tra cấu hình đã đúng chưa

Chạy app và kiểm tra console:

```bash
flutter run
```

Nếu thấy lỗi:
- `MissingPluginException`: Chạy `flutter clean` và `flutter pub get`
- `FirebaseApp not initialized`: Kiểm tra `main.dart` đã gọi `Firebase.initializeApp()`
- `Permission denied`: Kiểm tra Firestore Rules trong Firebase Console

## 📞 Cần giúp đỡ?

Xem thêm trong file `FIREBASE_SETUP.md` để biết cách:
- Tạo Firebase project
- Cấu hình Firestore Rules
- Troubleshooting các lỗi thường gặp

