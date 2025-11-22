# Hướng dẫn cấu hình Firebase Firestore

## Bước 1: Tạo Firebase Project

1. Truy cập [Firebase Console](https://console.firebase.google.com)
2. Nhấn "Add project" hoặc chọn project có sẵn
3. Điền tên project và làm theo hướng dẫn

## Bước 2: Thêm Flutter App vào Firebase

1. Trong Firebase Console, chọn project của bạn
2. Nhấn vào biểu tượng Flutter (hoặc "Add app" > Flutter)
3. Điền tên app và đăng ký

## Bước 3: Cài đặt Firebase CLI và FlutterFire CLI

```bash
# Cài đặt Firebase CLI
npm install -g firebase-tools

# Cài đặt FlutterFire CLI
dart pub global activate flutterfire_cli
```

## Bước 4: Cấu hình Firebase cho Flutter

```bash
# Đăng nhập Firebase
firebase login

# Cấu hình FlutterFire (tự động tạo firebase_options.dart)
flutterfire configure
```

Lệnh này sẽ:
- Tự động phát hiện các platform (Android, iOS, Web)
- Tạo file `firebase_options.dart`
- Hướng dẫn thêm các file cấu hình cần thiết

## Bước 5: Cấu hình Firestore Rules (Không cần Auth)

Vì app không sử dụng authentication, bạn cần cấu hình Firestore rules để cho phép đọc/ghi công khai:

1. Trong Firebase Console, vào **Firestore Database**
2. Chọn tab **Rules**
3. Cập nhật rules như sau:

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

**⚠️ CẢNH BÁO**: Rules này cho phép ai cũng có thể đọc/ghi dữ liệu. Chỉ nên dùng cho development hoặc testing. 

Để bảo mật hơn trong production, bạn nên:
- Thêm authentication
- Hoặc sử dụng App Check để xác thực app
- Hoặc tạo custom rules dựa trên logic nghiệp vụ

## Bước 6: Tạo Collections trong Firestore

App sẽ tự động tạo các collections khi chạy lần đầu:
- `users` - Thông tin người dùng
- `doctors` - Thông tin bác sĩ
- `appointments` - Lịch hẹn

Hoặc bạn có thể tạo thủ công trong Firebase Console.

## Bước 7: Chạy App

```bash
flutter pub get
flutter run
```

## Lưu ý

- File `firebase_options.dart` sẽ được tạo tự động bởi `flutterfire configure`
- Nếu không có file này, app sẽ báo lỗi khi khởi động
- Đảm bảo đã thêm các file cấu hình:
  - Android: `android/app/google-services.json`
  - iOS: `ios/Runner/GoogleService-Info.plist`

## Troubleshooting

### Lỗi: "FirebaseApp not initialized"
- Đảm bảo đã chạy `flutterfire configure`
- Kiểm tra file `firebase_options.dart` đã được tạo
- Đảm bảo `Firebase.initializeApp()` được gọi trong `main()`

### Lỗi: "MissingPluginException"
- Chạy `flutter clean`
- Chạy `flutter pub get`
- Rebuild app: `flutter run`

### Lỗi: "Permission denied" khi đọc/ghi Firestore
- Kiểm tra Firestore Rules đã được cấu hình đúng
- Đảm bảo Firestore đã được enable trong Firebase Console

