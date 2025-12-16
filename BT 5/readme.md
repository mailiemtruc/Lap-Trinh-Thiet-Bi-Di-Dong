# Báo Cáo Bài Tập Tuần 3: Tìm hiểu về Null Safety trong Dart (Flutter)

## 1. Thế nào là Nullable?

Trong Dart (kể từ phiên bản 2.12), tính năng **Sound Null Safety** được áp dụng mặc định. Hệ thống kiểu dữ liệu phân biệt rõ ràng giữa biến có thể chứa giá trị `null` và biến không thể chứa `null`.

- **Non-nullable types (Mặc định):** Biến bắt buộc phải có giá trị, không bao giờ được `null`.
  ```dart
  String ten = "Mai Liêm Trực"; // Không thể gán null
  ```
- **Nullable types:** Biến được phép nhận giá trị `null`, khai báo bằng cách thêm dấu `?` sau kiểu dữ liệu.
  ```dart
  String? email = null; // Hợp lệ
  ```

## 2. Khi nào nên / không nên dùng?

### Khi nào NÊN dùng Nullable (`Type?`):

- **Dữ liệu API/Backend:** Khi lấy dữ liệu từ Server về mà một số trường có thể không có giá trị.
- **Giá trị tùy chọn (Optional):** Trong các Widget Form, trường nào người dùng không bắt buộc nhập thì nên để null.
- **Khởi tạo muộn:** Khi biến chưa có giá trị ngay lúc khởi tạo class (dù trường hợp này nên ưu tiên từ khóa `late` nếu chắc chắn sẽ có dữ liệu sau này).

### Khi nào KHÔNG NÊN dùng (Non-nullable):

- **Dữ liệu cốt lõi:** Các biến quan trọng để App hoạt động (ví dụ: `id` của user, `context` của widget).
- **Tránh "Null check hell":** Nếu biến nào cũng để `?`, bạn sẽ phải dùng `if (x != null)` ở khắp mọi nơi, làm code dài dòng và khó đọc.

## 3. Cách thức xử lý Null phổ biến trong Dart

Tương ứng với các toán tử trong yêu cầu bài tập, Dart có các cú pháp sau:

### 3.1. Toán tử `?` (Nullable Declaration)

Dùng khi khai báo biến.

```dart
int? age; // age có thể là số nguyên hoặc null
```

### 3.2. Toán tử ?. (Aware Access Operator)

Truy cập thuộc tính an toàn. Nếu đối tượng null, nó trả về null thay vì báo lỗi.

```dart
// Nếu user null, length sẽ là null. Không bị crash.
int? length = user?.name?.length;
```

### 3.3. Toán tử ?? (If-null Operator)

Tương đương với ?: (Elvis) trong Kotlin. Dùng để gán giá trị mặc định nếu biểu thức bên trái là null.

```dart
// Nếu name là null, lấy giá trị "Unknown"
String displayName = name ?? "Unknown";
```

### 3.4. Xử lý thay thế let

Dart không có hàm let tích hợp sẵn giống hệt Kotlin. Để thực hiện một khối lệnh chỉ khi biến không null, ta thường dùng:

#### Cách 1: Kiểm tra if truyền thống (Dart có Type Promotion, tự hiểu biến đã an toàn).

```dart
if (user != null) {
  print(user.name); // Dart tự hiểu user ở đây không null
}
```

#### Cách 2: Dùng toán tử cascade ?.. (thực hiện chuỗi hành động nếu không null).

### 3.5. Toán tử ! (Null Assertion Operator)

Tương đương với !! trong Kotlin. Báo cho trình biên dịch: "Tao chắc chắn biến này không null, cứ dùng đi". Rủi ro: Nếu biến là null, App sẽ bị Crash ngay lập tức (TypeError).

```dart
// Chỉ dùng khi chắc chắn 100%
int len = name!.length;
```
