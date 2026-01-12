import 'dart:async';
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
      title: 'UTH SmartTasks',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const SplashScreen(),
    );
  }
}

// ==================== 1. SPLASH SCREEN ====================
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Nền trắng sạch
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // --- PHẦN 1: LOGO CHÍNH ---
            // Bạn nên chọn 1 trong 2 cách dưới đây (đừng dùng cả 2):

            // CÁCH A: Nếu bạn có ảnh Logo đẹp, tách nền (Transparent)
            Image.asset('assets/images/image.png', width: 200),

            // CÁCH B: Nếu chưa có ảnh đẹp, hãy dùng Icon + Text (Tự thiết kế)
            // Container(
            //   padding: const EdgeInsets.all(20),
            //   decoration: BoxDecoration(
            //     color: Colors.blue.shade50, // Nền tròn nhạt
            //     shape: BoxShape.circle,
            //   ),
            //   child: Icon(
            //     Icons.school_rounded,
            //     size: 80,
            //     color: Colors.blue.shade900, // Màu xanh đậm sang trọng
            //   ),
            // ),
            const SizedBox(height: 30),

            // --- PHẦN 2: TÊN APP ---
            Text(
              "UTH SmartTasks",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade900, // Đồng bộ màu với Icon
                letterSpacing: 1.2, // Giãn chữ ra cho thoáng
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "University of Transport Ho Chi Minh City",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey, // Màu phụ nên dùng màu xám
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 50),

            // --- PHẦN 3: LOADING (Tạo cảm giác app đang chạy) ---
            const CircularProgressIndicator(
              color: Colors.blue, // Loading xoay màu xanh
              strokeWidth: 3,
            ),
          ],
        ),
      ),

      // (Tuỳ chọn) Footer dưới cùng
      bottomNavigationBar: const SizedBox(
        height: 50,
        child: Center(
          child: Text(
            "Version 1.0.0",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ),
      ),
    );
  }
}

// ==================== 2. OOP MODEL (ĐÃ SỬA) ====================
class OnboardingContent {
  final String title;
  final String description;
  final String image; // Đổi từ IconData sang String để chứa đường dẫn ảnh

  OnboardingContent({
    required this.title,
    required this.description,
    required this.image,
  });
}

// ==================== 3. ONBOARDING SCREEN ====================
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentIndex = 0;
  final PageController _controller = PageController();

  // Dữ liệu mẫu (ĐÃ SỬA: Điền đường dẫn ảnh)
  final List<OnboardingContent> _contents = [
    OnboardingContent(
      title: "Easy Time Management",
      description:
          "With management based on priority and daily tasks, it will give you convenience in managing and determining the tasks that must be done first.",
      image: "assets/images/image2.png", // Ảnh 1
    ),
    OnboardingContent(
      title: "Increase Work Effectiveness",
      description:
          "Time management and the determination of more important tasks will give your job statistics better and always improve.",
      image: "assets/images/image3.png", // Ảnh 2
    ),
    OnboardingContent(
      title: "Reminder Notification",
      description:
          "The advantage of this application is that it also provides reminders for you so you don't forget to keep doing your assignments.",
      image: "assets/images/image4.png", // Ảnh 3
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Thêm nền trắng cho đẹp
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _contents.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // --- SỬA Ở ĐÂY: Hiển thị ảnh thay vì Icon ---
                        Image.asset(
                          _contents[index].image,
                          height: 250, // Chiều cao ảnh
                          fit: BoxFit.contain, // Giữ tỉ lệ ảnh
                        ),

                        const SizedBox(height: 40),

                        Text(
                          _contents[index].title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 20),

                        Text(
                          _contents[index].description,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Phần điều hướng bên dưới (Giữ nguyên)
            Padding(
              padding: const EdgeInsets.only(bottom: 50, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _currentIndex > 0
                      ? IconButton(
                          onPressed: () {
                            _controller.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.blue,
                          ),
                        )
                      : const SizedBox(width: 48),

                  Row(
                    children: List.generate(
                      _contents.length,
                      (index) => Container(
                        margin: const EdgeInsets.only(right: 5),
                        height: 10,
                        width: _currentIndex == index ? 20 : 10,
                        decoration: BoxDecoration(
                          color: _currentIndex == index
                              ? Colors.blue
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      if (_currentIndex == _contents.length - 1) {
                        print("Navigate to Home Screen");
                      } else {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      _currentIndex == _contents.length - 1
                          ? "Get Started"
                          : "Next",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
