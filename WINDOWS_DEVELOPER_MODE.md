# 🔧 Hướng dẫn bật Developer Mode trên Windows

## Vấn đề
Flutter cần symlink support để build app với plugins. Trên Windows, điều này yêu cầu Developer Mode được bật.

## Cách bật Developer Mode

### Phương pháp 1: Qua Settings (Khuyến nghị)

1. **Mở Settings:**
   - Nhấn `Windows + I` hoặc
   - Chạy lệnh: `start ms-settings:developers`

2. **Vào phần For developers:**
   - Trong Settings, tìm và click vào **"For developers"** hoặc **"Privacy & security" > "For developers"**

3. **Bật Developer Mode:**
   - Tìm toggle **"Developer Mode"**
   - Bật nó lên (ON)
   - Windows sẽ yêu cầu restart hoặc xác nhận

4. **Restart máy (nếu cần):**
   - Sau khi bật, có thể cần restart máy tính

### Phương pháp 2: Qua Registry (Nâng cao)

Nếu không tìm thấy Developer Mode trong Settings:

1. Nhấn `Windows + R`
2. Gõ `regedit` và Enter
3. Điều hướng đến:
   ```
   HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock
   ```
4. Tạo hoặc sửa DWORD:
   - Name: `AllowDevelopmentWithoutDevLicense`
   - Value: `1`
5. Restart máy

### Phương pháp 3: Chạy PowerShell với quyền Admin

```powershell
# Mở PowerShell với quyền Administrator
# Chạy lệnh sau:
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" -Name "AllowDevelopmentWithoutDevLicense" -Value 1
```

## Sau khi bật Developer Mode

1. **Restart máy tính** (nếu cần)
2. **Chạy lại Flutter:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

## Kiểm tra Developer Mode đã bật chưa

Chạy lệnh sau trong PowerShell:
```powershell
Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" -Name "AllowDevelopmentWithoutDevLicense"
```

Nếu trả về `1` thì đã bật thành công.

## Lưu ý

- Developer Mode cho phép các tính năng phát triển như symlink, sideload apps
- Không ảnh hưởng đến bảo mật của máy tính
- Có thể tắt lại sau khi không cần dùng Flutter

## Troubleshooting

### Vẫn không hoạt động sau khi bật Developer Mode

1. **Kiểm tra quyền Admin:**
   - Đảm bảo đang chạy terminal với quyền Administrator

2. **Restart máy:**
   - Một số thay đổi chỉ có hiệu lực sau khi restart

3. **Kiểm tra Windows version:**
   - Developer Mode có sẵn từ Windows 10 version 1607 trở lên

4. **Thử build lại:**
   ```bash
   flutter clean
   cd android
   ./gradlew clean
   cd ..
   flutter pub get
   flutter run
   ```

