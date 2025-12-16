import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: PaymentScreen()),
  );
}

abstract class PaymentMethod {
  String get name;
  IconData get iconData;
  Color get brandColor;
  String processPayment();
}

class PayPal extends PaymentMethod {
  @override
  String get name => "PayPal";
  @override
  IconData get iconData => Icons.paypal;
  @override
  Color get brandColor => const Color(0xFF003087);
  @override
  String processPayment() => "Đang kết nối API PayPal...\nVui lòng đăng nhập.";
}

class GooglePay extends PaymentMethod {
  @override
  String get name => "GooglePay";
  @override
  IconData get iconData => Icons.g_mobiledata;
  @override
  Color get brandColor => Colors.red;
  @override
  String processPayment() => "Đang xác thực vân tay qua Google Services...";
}

class ApplePay extends PaymentMethod {
  @override
  String get name => "ApplePay";
  @override
  IconData get iconData => Icons.apple;
  @override
  Color get brandColor => Colors.black;
  @override
  String processPayment() => "Đang quét FaceID...";
}

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final List<PaymentMethod> _methods = [PayPal(), GooglePay(), ApplePay()];

  int _selectedIndex = -1;

  void _selectMethod(int index) {
    setState(() {
      _selectedIndex = index;
    });

    print("--- DEMO OOP ---");
    print("Chọn: ${_methods[index].name}");
    print(
      "Class thực tế: ${_methods[index].runtimeType}",
    ); // Chứng minh Đa hình
  }

  @override
  Widget build(BuildContext context) {
    final selectedMethod = _selectedIndex != -1
        ? _methods[_selectedIndex]
        : null;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          "Thanh toán (Demo OOP)",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Container(
                height: 100,
                alignment: Alignment.center,
                child: selectedMethod == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.touch_app, size: 50, color: Colors.grey),
                          Text(
                            "Hãy chọn phương thức (Encapsulation Demo)",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            selectedMethod.iconData,
                            size: 50,
                            color: selectedMethod.brandColor,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            selectedMethod.name,
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: selectedMethod.brandColor,
                            ),
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: 40),

              // List Options
              Expanded(
                child: ListView.builder(
                  itemCount: _methods.length,
                  itemBuilder: (context, index) {
                    final method = _methods[index];
                    final isSelected = _selectedIndex == index;

                    return InkWell(
                      onTap: () => _selectMethod(index),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: isSelected
                                ? Colors.blue
                                : Colors.transparent,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 10),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isSelected
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_unchecked,
                              color: isSelected ? Colors.blue : Colors.grey,
                            ),
                            const SizedBox(width: 15),
                            Text(
                              method.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Icon(method.iconData, color: method.brandColor),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    disabledBackgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  onPressed: selectedMethod != null
                      ? () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: Column(
                                children: [
                                  Icon(
                                    selectedMethod.iconData,
                                    size: 50,
                                    color: selectedMethod.brandColor,
                                  ),
                                  const SizedBox(height: 10),
                                  Text("Xử lý ${selectedMethod.name}"),
                                ],
                              ),
                              content: Text(
                                selectedMethod.processPayment(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 16),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Đóng"),
                                ),
                              ],
                            ),
                          );
                        }
                      : null,
                  child: const Text(
                    "Continue",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
