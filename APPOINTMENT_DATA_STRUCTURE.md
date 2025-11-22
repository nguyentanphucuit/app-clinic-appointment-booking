# Cấu trúc dữ liệu Appointment trong Firestore

## Khi user book lịch, dữ liệu được lưu vào collection `appointments`:

### Document Structure:
```json
{
  "id": "1735123456789",  // Document ID (timestamp milliseconds)
  "userId": "1735123456789",  // ID của user đặt lịch
  "doctorId": "1",  // ID của bác sĩ
  "dateTime": Timestamp,  // Ngày và giờ hẹn (Firestore Timestamp)
  "duration": "30 min",  // Thời lượng khám
  "reason": "Tư vấn chung",  // Lý do khám
  "status": "upcoming",  // Trạng thái: "upcoming", "completed", "cancelled"
  "notes": null,  // Ghi chú (có thể null)
  "prescription": null  // Đơn thuốc (có thể null)
}
```

## Chi tiết các field:

### 1. **id** (Document ID)
- **Type**: String
- **Value**: Timestamp milliseconds (ví dụ: `"1735123456789"`)
- **Mô tả**: ID duy nhất của appointment, được tạo từ `DateTime.now().millisecondsSinceEpoch.toString()`

### 2. **userId**
- **Type**: String
- **Value**: ID của user đặt lịch
- **Mô tả**: Dùng để filter appointments theo user khi đăng nhập

### 3. **doctorId**
- **Type**: String
- **Value**: ID của bác sĩ
- **Mô tả**: Reference đến bác sĩ trong collection `doctors`

### 4. **dateTime**
- **Type**: Firestore Timestamp
- **Value**: Ngày và giờ hẹn khám
- **Mô tả**: Được convert từ `DateTime` sang `Timestamp.fromDate()`

### 5. **duration**
- **Type**: String
- **Value**: Thời lượng khám (ví dụ: `"30 min"`, `"45 min"`)
- **Mô tả**: Mặc định là `"30 min"` khi book

### 6. **reason**
- **Type**: String
- **Value**: Lý do khám (user nhập hoặc mặc định `"Tư vấn chung"`)
- **Mô tả**: Mô tả lý do đặt lịch

### 7. **status**
- **Type**: String
- **Value**: `"upcoming"`, `"completed"`, hoặc `"cancelled"`
- **Mô tả**: Trạng thái của appointment
  - `upcoming`: Sắp tới
  - `completed`: Đã hoàn thành
  - `cancelled`: Đã hủy

### 8. **notes** (Optional)
- **Type**: String hoặc null
- **Value**: Ghi chú từ bác sĩ sau khi khám
- **Mô tả**: Được thêm sau khi appointment completed

### 9. **prescription** (Optional)
- **Type**: String hoặc null
- **Value**: Đơn thuốc từ bác sĩ
- **Mô tả**: Được thêm sau khi appointment completed

## Ví dụ dữ liệu thực tế:

```json
{
  "id": "1735123456789",
  "userId": "1735123456789",
  "doctorId": "1",
  "dateTime": {
    "_seconds": 1735123456,
    "_nanoseconds": 789000000
  },
  "duration": "30 min",
  "reason": "Tư vấn chung",
  "status": "upcoming",
  "notes": null,
  "prescription": null
}
```

## Collection trong Firestore:

- **Collection name**: `appointments`
- **Document ID**: Appointment ID (timestamp)
- **Index cần thiết**: 
  - Composite index: `userId` + `dateTime` (descending)
  - Để query nhanh appointments của user theo thời gian

## Query appointments:

### Lấy tất cả appointments của user:
```dart
_appointmentsCollection
  .where('userId', isEqualTo: userId)
  .orderBy('dateTime', descending: true)
  .get()
```

### Lấy appointment theo ID:
```dart
_appointmentsCollection.doc(appointmentId).get()
```

## Lưu ý:

1. **userId** được tự động lấy từ `UserProvider.currentUser.id` khi book
2. **doctorId** được lấy từ doctor object khi book
3. **dateTime** được validate trước khi lưu (phải trong tương lai, trong giờ làm việc, và trong ngày bác sĩ làm việc)
4. Khi update appointment, **userId** được giữ nguyên
5. Khi load appointments, cần load thêm thông tin doctor từ collection `doctors` dựa vào `doctorId`

