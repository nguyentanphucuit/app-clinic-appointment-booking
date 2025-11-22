# ✅ Firebase Setup Checklist

## Đã hoàn thành ✅

- [x] Firebase dependencies đã được thêm vào `pubspec.yaml`
- [x] Google services plugin đã được thêm vào `android/settings.gradle.kts`
- [x] Firebase dependencies đã được thêm vào `android/app/build.gradle.kts`
- [x] File `google-services.json` đã được đặt vào `android/app/`
- [x] Firebase đã được khởi tạo trong `main.dart`
- [x] `FirestoreService` đã được tạo và tích hợp vào các providers

## Cần làm tiếp 🔲

### 1. Cấu hình Firestore Rules (QUAN TRỌNG!)

Vì app không sử dụng authentication, bạn **PHẢI** cấu hình Firestore Rules để cho phép đọc/ghi:

1. Vào [Firebase Console](https://console.firebase.google.com)
2. Chọn project: **clinic-appointment-booki-f0846**
3. Vào **Firestore Database** > tab **Rules**
4. Cập nhật rules như sau:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Cho phép đọc/ghi công khai (chỉ dùng cho development/testing)
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```

5. Nhấn **Publish** để lưu rules

**⚠️ CẢNH BÁO**: Rules này cho phép ai cũng có thể đọc/ghi dữ liệu. Chỉ nên dùng cho development hoặc testing.

### 2. Enable Firestore Database

1. Trong Firebase Console, vào **Firestore Database**
2. Nếu chưa có database, nhấn **Create database**
3. Chọn **Start in test mode** (hoặc **Production mode** nếu muốn cấu hình rules ngay)
4. Chọn location gần bạn nhất
5. Nhấn **Enable**

### 3. (Tùy chọn) Tạo firebase_options.dart

Nếu muốn sử dụng `firebase_options.dart` để cấu hình tốt hơn:

```bash
# Cài đặt FlutterFire CLI
dart pub global activate flutterfire_cli

# Đăng nhập Firebase
firebase login

# Cấu hình tự động
flutterfire configure
```

Sau đó cập nhật `main.dart`:
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

### 4. Test app

```bash
# Sync dependencies
flutter pub get

# Chạy app
flutter run
```

## Kiểm tra hoạt động

Sau khi chạy app, kiểm tra:

1. **Firebase Console > Firestore Database**
   - Collections sẽ được tạo tự động: `users`, `doctors`, `appointments`
   - Dữ liệu mẫu sẽ được thêm vào khi app chạy lần đầu

2. **App hoạt động bình thường**
   - Đăng nhập vào app
   - Xem danh sách bác sĩ
   - Đặt lịch hẹn
   - Kiểm tra dữ liệu trong Firestore Console

## Troubleshooting

### Lỗi: "Permission denied" khi đọc/ghi Firestore
→ **Giải pháp**: Kiểm tra Firestore Rules đã được cấu hình đúng (bước 1)

### Lỗi: "FirebaseApp not initialized"
→ **Giải pháp**: Đảm bảo `Firebase.initializeApp()` được gọi trong `main()`

### Lỗi: "MissingPluginException"
→ **Giải pháp**: 
```bash
flutter clean
flutter pub get
flutter run
```

### Không thấy dữ liệu trong Firestore
→ **Giải pháp**: 
- Kiểm tra Firestore Rules cho phép đọc/ghi
- Kiểm tra console log xem có lỗi gì không
- Đảm bảo app đã chạy và tạo dữ liệu mẫu

## Thông tin project

- **Project ID**: `clinic-appointment-booki-f0846`
- **Project Number**: `853235858442`
- **Storage Bucket**: `clinic-appointment-booki-f0846.firebasestorage.app`

## Bước tiếp theo sau khi setup xong

1. Test tất cả chức năng: đăng nhập, xem bác sĩ, đặt lịch, chỉnh sửa profile
2. Kiểm tra dữ liệu trong Firestore Console
3. (Tùy chọn) Cấu hình Firestore Rules bảo mật hơn cho production
4. (Tùy chọn) Thêm authentication nếu cần bảo mật

