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
      home: const Practice2Screen(),
    );
  }
}

class Practice2Screen extends StatefulWidget {
  const Practice2Screen({super.key});

  @override
  State<Practice2Screen> createState() => _Practice2ScreenState();
}

class _Practice2ScreenState extends State<Practice2Screen> {
  final TextEditingController _emailController = TextEditingController();

  String _message = "";

  Color _messageColor = Colors.red;

  void _checkEmail() {
    String email = _emailController.text;

    setState(() {
      if (email.isEmpty) {
        _message = "Email không hợp lệ";
        _messageColor = Colors.red;
      } else if (!email.contains("@")) {
        _message = "Email không đúng định dạng";
        _messageColor = Colors.red;
      } else {
        _message = "Bạn đã nhập email hợp lệ";
        _messageColor = Colors.green;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bài tập - Thực hành 2"),
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Thực hành 02",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: "Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
            ),

            const SizedBox(height: 10),

            if (_message.isNotEmpty)
              Text(
                _message,
                style: TextStyle(
                  color: _messageColor,
                  fontWeight: FontWeight.w500,
                ),
              ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _checkEmail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2196F3),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Kiểm tra",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
