import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// ==========================================
// 1. CẤU HÌNH APP & THEME
// ==========================================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Modern Flutter UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        // Tự động tạo bảng màu hài hòa (Deep Purple)
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.light,
        ),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: Colors.transparent,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF6750A4), width: 2),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/home': (context) => const HomeScreen(),
        '/text': (context) => const TextDetailScreen(),
        '/image': (context) => const ImageDetailScreen(),
        '/input': (context) => const InputDetailScreen(),
        '/column': (context) => const ColumnDetailScreen(),
        '/row': (context) => const RowDetailScreen(),
        '/lazy': (context) => const LazyLoadingScreen(), // Route mới
      },
    );
  }
}

// ==========================================
// 2. MÀN HÌNH CHÀO MỪNG (WELCOME)
// ==========================================
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colorScheme.primary, colorScheme.tertiary],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.flutter_dash,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Mastering\nFlutter UI',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'Thực hành các thành phần UI cơ bản, Layout và Lazy Loading.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                    height: 1.5,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/home'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: colorScheme.primary,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      "Bắt đầu ngay",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 3. HOME SCREEN (DASHBOARD GRID)
// ==========================================
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Menu',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Danh sách bài tập",
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.05,
                children: const [
                  _DashboardItem(
                    title: 'Typography',
                    subtitle: 'Rich Text',
                    icon: Icons.text_fields_rounded,
                    color: Colors.orange,
                    route: '/text',
                  ),
                  _DashboardItem(
                    title: 'Media',
                    subtitle: 'Images',
                    icon: Icons.image_rounded,
                    color: Colors.blue,
                    route: '/image',
                  ),
                  _DashboardItem(
                    title: 'Inputs',
                    subtitle: 'Forms',
                    icon: Icons.edit_note_rounded,
                    color: Colors.green,
                    route: '/input',
                  ),
                  _DashboardItem(
                    title: 'Column',
                    subtitle: 'Vertical Layout',
                    icon: Icons.view_column_rounded,
                    color: Colors.purple,
                    route: '/column',
                  ),
                  _DashboardItem(
                    title: 'Row',
                    subtitle: 'Horizontal Layout',
                    icon: Icons.table_rows_rounded,
                    color: Colors.pink,
                    route: '/row',
                  ),
                  // MỤC MỚI: LAZY LOADING
                  _DashboardItem(
                    title: 'Lazy Lists',
                    subtitle: 'Hiệu năng cao',
                    icon: Icons.view_stream_rounded,
                    color: Colors.teal,
                    route: '/lazy',
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

class _DashboardItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String route;

  const _DashboardItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.pushNamed(context, route),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Hero(
                tag: 'icon_$route',
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 4. TEXT DETAIL
// ==========================================
class TextDetailScreen extends StatelessWidget {
  const TextDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Typography')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Hero(
                    tag: 'icon_/text',
                    child: Icon(
                      Icons.text_fields_rounded,
                      size: 50,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 20),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 28,
                        color: Colors.black87,
                        height: 1.4,
                        fontFamily: 'serif',
                      ),
                      children: [
                        const TextSpan(text: 'The '),
                        TextSpan(
                          text: 'Quick Brown',
                          style: TextStyle(
                            color: Colors.orange.shade800,
                            fontWeight: FontWeight.bold,
                            backgroundColor: Colors.orange.shade100,
                          ),
                        ),
                        const TextSpan(text: '\nFox '),
                        TextSpan(
                          text: 'jumps',
                          style: TextStyle(
                            fontSize: 24,
                            letterSpacing: 4,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const TextSpan(text: ' over\nthe '),
                        const TextSpan(
                          text: 'lazy dog.',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationStyle: TextDecorationStyle.wavy,
                            decorationColor: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 5. IMAGE DETAIL
// ==========================================
class ImageDetailScreen extends StatelessWidget {
  const ImageDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gallery')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildImageCard(context, 'img/1.jpg', 'Khuôn viên trường', 'UTH'),
          const SizedBox(height: 20),
          _buildImageCard(
            context,
            'img/invalid.jpg',
            'Ảnh Demo Lỗi',
            'Test Error Handling',
          ),
        ],
      ),
    );
  }

  Widget _buildImageCard(
    BuildContext context,
    String path,
    String title,
    String subtitle,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.asset(
              path,
              width: double.infinity,
              height: 220,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 220,
                  color: Colors.red.shade50,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.broken_image_rounded,
                        size: 50,
                        color: Colors.red.shade300,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Không tìm thấy ảnh: $path',
                        style: TextStyle(color: Colors.red.shade400),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[500], fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 6. INPUT DETAIL
// ==========================================
class InputDetailScreen extends StatefulWidget {
  const InputDetailScreen({super.key});

  @override
  State<InputDetailScreen> createState() => _InputDetailScreenState();
}

class _InputDetailScreenState extends State<InputDetailScreen> {
  final TextEditingController _controller = TextEditingController();
  String _displayText = "";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Interactive Input')),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Hero(
                tag: 'icon_/input',
                child: Icon(
                  Icons.edit_note_rounded,
                  size: 60,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Nhập thông tin',
                  hintText: 'Ví dụ: Hello Flutter',
                  prefixIcon: Icon(Icons.person_outline_rounded),
                ),
                onChanged: (value) => setState(() => _displayText = value),
              ),
              const SizedBox(height: 30),
              AnimatedOpacity(
                opacity: _displayText.isNotEmpty ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    "Output: $_displayText",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
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

// ==========================================
// 7. LAYOUT DEMOS (STRESS TEST VERSION)
// ==========================================

// --- COLUMN STRESS TEST ---
class ColumnDetailScreen extends StatefulWidget {
  const ColumnDetailScreen({super.key});

  @override
  State<ColumnDetailScreen> createState() => _ColumnDetailScreenState();
}

class _ColumnDetailScreenState extends State<ColumnDetailScreen> {
  // Controller mặc định là 3 phần tử để demo
  final TextEditingController _controller = TextEditingController(text: "3");
  int _itemCount = 3;
  bool _useScrollView =
      true; // Bật scroll để test độ giật (Lag), tắt để test lỗi vỡ giao diện (Overflow)

  void _renderUI() {
    // Ẩn bàn phím
    FocusScope.of(context).unfocus();
    setState(() {
      _itemCount = int.tryParse(_controller.text) ?? 0;
    });

    // Cảnh báo người dùng nếu nhập quá nhiều
    if (_itemCount > 5000) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            '⚠️ Cảnh báo: Số lượng > 5000 có thể gây treo ứng dụng!',
          ),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tạo danh sách Widget (HÀNH VI NẶNG: Tạo tất cả cùng lúc)
    List<Widget> children = List.generate(_itemCount, (index) {
      return Container(
        height: 50,
        margin: const EdgeInsets.only(bottom: 10),
        // Đổi màu xen kẽ để dễ nhìn
        color: index % 2 == 0 ? Colors.red.shade100 : Colors.red.shade200,
        alignment: Alignment.center,
        child: Text(
          "Item $index (Standard Column)",
          style: TextStyle(
            color: Colors.red.shade900,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    });

    // Widget chứa Column
    Widget content = Column(
      mainAxisSize: MainAxisSize.min, // Chỉ chiếm không gian vừa đủ
      children: children,
    );

    // Logic bọc ScrollView
    if (_useScrollView) {
      content = SingleChildScrollView(child: content);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Column Stress Test')),
      body: Column(
        children: [
          // --- BẢNG ĐIỀU KHIỂN (CONTROL PANEL) ---
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  "Thử nghiệm giới hạn của Column",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Số lượng items',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _renderUI,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("RENDER"),
                    ),
                  ],
                ),
                SwitchListTile(
                  title: const Text("Bật SingleScrollView"),
                  subtitle: Text(
                    _useScrollView
                        ? "Đang bật: Test độ giật (Lag) khi list dài"
                        : "Đang tắt: Test lỗi tràn màn hình (Overflow)",
                    style: const TextStyle(fontSize: 12),
                  ),
                  value: _useScrollView,
                  activeColor: Colors.red,
                  onChanged: (val) => setState(() => _useScrollView = val),
                ),
              ],
            ),
          ),

          // --- KHU VỰC HIỂN THỊ ---
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.grey[100],
              padding: const EdgeInsets.all(16),
              // Nếu không bật scroll, Column sẽ bị cắt bớt hoặc lỗi khi item nhiều
              child: _useScrollView
                  ? content
                  : SingleChildScrollView(
                      // Hack nhẹ để vẫn xem được lỗi overflow
                      scrollDirection: Axis
                          .horizontal, // Cho phép cuộn ngang để xem hết lỗi dọc
                      child: content,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- ROW STRESS TEST ---
class RowDetailScreen extends StatefulWidget {
  const RowDetailScreen({super.key});

  @override
  State<RowDetailScreen> createState() => _RowDetailScreenState();
}

class _RowDetailScreenState extends State<RowDetailScreen> {
  final TextEditingController _controller = TextEditingController(text: "3");
  int _itemCount = 3;
  bool _useScrollView = false; // Mặc định tắt để thấy lỗi Row ngay lập tức

  void _renderUI() {
    FocusScope.of(context).unfocus();
    setState(() {
      _itemCount = int.tryParse(_controller.text) ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Tạo danh sách Widget
    List<Widget> children = List.generate(_itemCount, (index) {
      return Container(
        width: 60, // Chiều rộng cố định
        margin: const EdgeInsets.only(right: 10),
        color: index % 2 == 0 ? Colors.blue.shade100 : Colors.blue.shade200,
        alignment: Alignment.center,
        child: Text(
          "$index",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade900,
          ),
        ),
      );
    });

    Widget content = Row(mainAxisSize: MainAxisSize.min, children: children);

    if (_useScrollView) {
      content = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: content,
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Row Stress Test')),
      body: Column(
        children: [
          // --- BẢNG ĐIỀU KHIỂN ---
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  "Row thường rất dễ bị lỗi tràn màn hình ngang",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Số lượng items',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _renderUI,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("RENDER"),
                    ),
                  ],
                ),
                SwitchListTile(
                  title: const Text("Bật SingleScrollView (Ngang)"),
                  subtitle: Text(
                    _useScrollView
                        ? "Đang bật: Cuộn được nhưng tốn RAM"
                        : "Đang tắt: Sẽ bị lỗi 'RenderFlex overflowed'",
                    style: const TextStyle(fontSize: 12),
                  ),
                  value: _useScrollView,
                  activeColor: Colors.blue,
                  onChanged: (val) => setState(() => _useScrollView = val),
                ),
              ],
            ),
          ),

          // --- KHU VỰC HIỂN THỊ ---
          Expanded(
            child: Center(
              child: Container(
                height: 100, // Khung chứa Row
                width: double.infinity,
                color: Colors.grey[200],
                alignment:
                    Alignment.centerLeft, // Căn trái để thấy nó mọc ra từ trái
                padding: const EdgeInsets.symmetric(horizontal: 10),
                // Hiển thị nội dung
                child: content,
              ),
            ),
          ),

          // Giải thích thêm
          if (!_useScrollView && _itemCount > 5)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "⚠️ Lưu ý: Nếu bạn thấy sọc vàng đen bên phải, đó là lỗi Overflow do Row không có khả năng cuộn.",
                style: TextStyle(
                  color: Colors.orange.shade800,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}

// ==========================================
// 8. LAZY LOADING SCREEN (DYNAMIC)
// ==========================================
class LazyLoadingScreen extends StatefulWidget {
  const LazyLoadingScreen({super.key});

  @override
  State<LazyLoadingScreen> createState() => _LazyLoadingScreenState();
}

class _LazyLoadingScreenState extends State<LazyLoadingScreen> {
  // Giá trị mặc định
  int _rowCount = 20;
  int _colCount = 50;

  // Controller để lấy dữ liệu từ ô nhập
  final TextEditingController _rowInputController = TextEditingController(
    text: "20",
  );
  final TextEditingController _colInputController = TextEditingController(
    text: "50",
  );

  @override
  void dispose() {
    _rowInputController.dispose();
    _colInputController.dispose();
    super.dispose();
  }

  // Hàm xử lý khi bấm nút Cập nhật
  void _updateLists() {
    // Ẩn bàn phím
    FocusScope.of(context).unfocus();

    setState(() {
      // Chuyển text thành số, nếu lỗi thì về 0
      _rowCount = int.tryParse(_rowInputController.text) ?? 0;
      _colCount = int.tryParse(_colInputController.text) ?? 0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã tạo $_rowCount Stories và $_colCount bài viết!'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Dynamic Lazy Lists'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Reset về mặc định
              setState(() {
                _rowCount = 20;
                _colCount = 50;
                _rowInputController.text = "20";
                _colInputController.text = "50";
              });
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // --- KHU VỰC CẤU HÌNH (Control Panel) ---
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    "Cấu hình số lượng phần tử",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      // Input cho Row
                      Expanded(
                        child: TextField(
                          controller: _rowInputController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Số lượng Row',
                            prefixIcon: Icon(Icons.view_column),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      // Input cho Column
                      Expanded(
                        child: TextField(
                          controller: _colInputController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Số lượng Column',
                            prefixIcon: Icon(Icons.view_agenda),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton.icon(
                      onPressed: _updateLists,
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text("Cập nhật danh sách"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- 1. LAZY ROW SECTION ---
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Stories (Lazy Row)",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Total: $_rowCount",
                      style: TextStyle(
                        color: Colors.orange.shade800,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(
              height: 100,
              // Nếu rowCount = 0 thì hiển thị thông báo trống
              child: _rowCount == 0
                  ? const Center(child: Text("Không có dữ liệu row"))
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _rowCount, // <--- Dùng biến dynamic
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemBuilder: (context, index) => _buildStoryItem(index),
                    ),
            ),
          ),

          // --- 2. LAZY COLUMN SECTION ---
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "News Feed (Lazy Col)",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Total: $_colCount",
                      style: TextStyle(
                        color: Colors.blue.shade800,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Nếu colCount = 0 thì hiển thị thông báo trống
          _colCount == 0
              ? const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Center(child: Text("Không có bài viết nào")),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildPostItem(context, index),
                    childCount: _colCount, // <--- Dùng biến dynamic
                  ),
                ),

          // Khoảng trắng dưới cùng để không bị che bởi navigation bar (nếu có)
          const SliverPadding(padding: EdgeInsets.only(bottom: 30)),
        ],
      ),
    );
  }

  // Widget con: Story Item
  Widget _buildStoryItem(int index) {
    // Dùng modulo để lặp lại màu sắc nếu index lớn
    final Color color = Colors.primaries[index % Colors.primaries.length];

    return Container(
      width: 75,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.purple.shade300, width: 2),
            ),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.2),
              ),
              child: Center(
                child: Text(
                  "${index + 1}",
                  style: TextStyle(color: color, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "User ${index + 1}",
            style: const TextStyle(fontSize: 11),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Widget con: Post Item
  Widget _buildPostItem(BuildContext context, int index) {
    final Color color = Colors.primaries[index % Colors.primaries.length];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  "#${index + 1}",
                  style: TextStyle(fontWeight: FontWeight.bold, color: color),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Post Item ${index + 1}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Đây là phần tử thứ ${index + 1} trong danh sách Lazy Column.",
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
