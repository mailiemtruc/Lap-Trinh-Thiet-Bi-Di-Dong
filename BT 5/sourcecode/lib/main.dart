import 'package:flutter/material.dart';

// 1. Model dữ liệu (Mô phỏng)
class Student {
  final String id; // Bắt buộc (Non-nullable)
  final String name; // Bắt buộc
  final String? email; // Có thể null (Nullable)
  final String? avatarUrl; // Có thể null

  Student({required this.id, required this.name, this.email, this.avatarUrl});
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: NullSafetyExampleScreen());
  }
}

class NullSafetyExampleScreen extends StatelessWidget {
  NullSafetyExampleScreen({super.key});

  // Giả lập dữ liệu: Email bị null
  final Student student = Student(
    id: "SV001",
    name: "Mai Liêm Trực",
    email: null, // Test trường hợp null
    avatarUrl: null,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Demo Null Safety")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // --- Ví dụ dùng ?? (If-null) ---
            // Nếu avatarUrl null, dùng icon mặc định
            student.avatarUrl != null
                ? Image.network(
                    student.avatarUrl!,
                  ) // Dùng ! nếu đã check if (hoặc để an toàn thì ko cần !)
                : const Icon(Icons.person, size: 100),

            const SizedBox(height: 20),

            // --- Ví dụ dùng biến Non-nullable ---
            Text(
              student.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            // --- Ví dụ dùng ?? để hiển thị text mặc định ---
            Text(
              "Email: ${student.email ?? "Chưa cập nhật"}",
              style: TextStyle(
                color: student.email == null ? Colors.grey : Colors.black,
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                // --- Ví dụ dùng ! (Assertion) ---
                // Cẩn thận: Dòng này sẽ gây Crash nếu email là null
                try {
                  print("Độ dài email: ${student.email!.length}");
                } catch (e) {
                  print("Lỗi: Email đang bị null mà cố tình dùng dấu !");

                  // Hiển thị thông báo lỗi lên màn hình (Thay thế cho logic crash)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Lỗi: Dữ liệu Email bị thiếu!"),
                    ),
                  );
                }
              },
              child: const Text("Kiểm tra độ dài Email (Dùng !)"),
            ),
          ],
        ),
      ),
    );
  }
}
