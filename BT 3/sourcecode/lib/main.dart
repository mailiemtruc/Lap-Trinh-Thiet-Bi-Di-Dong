import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Practice3Screen(),
    );
  }
}

class Practice3Screen extends StatefulWidget {
  const Practice3Screen({super.key});

  @override
  State<Practice3Screen> createState() => _Practice3ScreenState();
}

class _Practice3ScreenState extends State<Practice3Screen> {
  // Controller để quản lý 2 ô nhập liệu
  final TextEditingController _controllerA = TextEditingController();
  final TextEditingController _controllerB = TextEditingController();

  // Biến lưu kết quả để hiển thị
  String _result = "";

  // Hàm xử lý tính toán
  void _calculate(String operator) {
    // 1. Lấy dữ liệu từ ô nhập
    String textA = _controllerA.text;
    String textB = _controllerB.text;

    // 2. Kiểm tra xem có phải số hợp lệ không
    double? numA = double.tryParse(textA);
    double? numB = double.tryParse(textB);

    if (numA == null || numB == null) {
      setState(() {
        _result = "Vui lòng nhập số hợp lệ!";
      });
      return;
    }

    // 3. Thực hiện phép tính
    double tempResult = 0;
    switch (operator) {
      case '+':
        tempResult = numA + numB;
        break;
      case '-':
        tempResult = numA - numB;
        break;
      case '*':
        tempResult = numA * numB;
        break;
      case '/':
        if (numB == 0) {
          setState(() {
            _result = "Không thể chia cho 0";
          });
          return;
        }
        tempResult = numA / numB;
        break;
    }

    // 4. Cập nhật kết quả lên màn hình
    setState(() {
      // Nếu kết quả là số nguyên (ví dụ 4.0) thì bỏ số 0 đuôi cho đẹp
      if (tempResult == tempResult.toInt()) {
        _result = tempResult.toInt().toString();
      } else {
        _result = tempResult.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thực hành 03"),
        backgroundColor: Colors.white,
        elevation: 0, // Bỏ bóng mờ cho giống thiết kế phẳng
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Căn lề trái
          children: [
            // --- Ô NHẬP SỐ A ---
            // Dùng Container để tạo viền bo tròn như thiết kế
            TextField(
              controller: _controllerA,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Nhập số A",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // --- HÀNG NÚT PHÉP TÍNH ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildButton("+", Colors.red),
                _buildButton("-", Colors.orange),
                _buildButton("*", Colors.blue), // Trong hình là màu xanh tím
                _buildButton("/", Colors.black),
              ],
            ),

            const SizedBox(height: 20),

            // --- Ô NHẬP SỐ B ---
            TextField(
              controller: _controllerB,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Nhập số B",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // --- HIỂN THỊ KẾT QUẢ ---
            Row(
              children: [
                const Text(
                  "Kết quả: ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  _result,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Hàm phụ để vẽ nút bấm cho gọn code (Tránh lặp lại code 4 lần)
  Widget _buildButton(String label, Color color) {
    return SizedBox(
      width: 70, // Chiều rộng nút
      height: 50, // Chiều cao nút
      child: ElevatedButton(
        onPressed: () => _calculate(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
