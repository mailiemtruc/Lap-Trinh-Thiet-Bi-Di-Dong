import 'package:flutter/material.dart';
import 'dart:math';

abstract class Person {
  String _id;
  String _name;
  Person(this._id, this._name);
  String get name => _name;
  String get id => _id;
}

class Member extends Person {
  Member(String id, String name) : super(id, name);
}

class Book {
  String _id;
  String _title;
  String _author;
  bool _isBorrowed;
  String? _borrowedBy;

  final int _colorValue;

  Book(this._id, this._title, this._author)
    : _isBorrowed = false,
      _colorValue =
          Colors.primaries[Random().nextInt(Colors.primaries.length)].value;

  String get id => _id;
  String get title => _title;
  String get author => _author;
  bool get isBorrowed => _isBorrowed;
  String? get borrowedBy => _borrowedBy;
  Color get coverColor => Color(_colorValue);

  void borrow(String memberName) {
    _isBorrowed = true;
    _borrowedBy = memberName;
  }

  void returnBook() {
    _isBorrowed = false;
    _borrowedBy = null;
  }
}

class LibraryManager {
  final List<Book> _books = [];
  final List<Member> _members = [];

  static final LibraryManager _instance = LibraryManager._internal();
  factory LibraryManager() => _instance;
  LibraryManager._internal();

  List<Book> get books => _books;
  List<Member> get members => _members;

  void addBook(Book book) => _books.add(book);
  void addMember(Member member) => _members.add(member);

  bool toggleLoan(String bookId, Member? member) {
    var book = _books.firstWhere((b) => b.id == bookId);
    if (book.isBorrowed) {
      book.returnBook();
      return true;
    } else {
      if (member == null) return false;
      book.borrow(member.name);
      return true;
    }
  }
}

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;
  final bool isLoanScreen;

  const BookCard({
    super.key,
    required this.book,
    required this.onTap,
    this.isLoanScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 90,
                  decoration: BoxDecoration(
                    color: book.coverColor.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: book.coverColor.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.book, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        book.author,
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                      const SizedBox(height: 8),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: book.isBorrowed
                              ? Colors.red[50]
                              : Colors.green[50],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: book.isBorrowed
                                ? Colors.red.withOpacity(0.5)
                                : Colors.green.withOpacity(0.5),
                          ),
                        ),
                        child: Text(
                          book.isBorrowed
                              ? (isLoanScreen
                                    ? "Đang mượn bởi: ${book.borrowedBy}"
                                    : "Đã hết")
                              : "Có sẵn",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: book.isBorrowed
                                ? Colors.red[700]
                                : Colors.green[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                if (isLoanScreen)
                  Icon(
                    book.isBorrowed
                        ? Icons.remove_circle_outline
                        : Icons.add_circle_outline,
                    color: book.isBorrowed ? Colors.red : Colors.indigo,
                    size: 28,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MemberTile extends StatelessWidget {
  final Member member;
  final bool isSelected;
  final VoidCallback? onTap;

  const MemberTile({
    super.key,
    required this.member,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? Colors.indigo.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isSelected ? Border.all(color: Colors.indigo, width: 2) : null,
        boxShadow: isSelected
            ? []
            : [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 5)],
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: Colors.indigoAccent,
          foregroundColor: Colors.white,
          child: Text(member.name.substring(0, 1).toUpperCase()),
        ),
        title: Text(
          member.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.indigo : Colors.black87,
          ),
        ),
        subtitle: Text("ID: ${member.id}"),
        trailing: isSelected
            ? const Icon(Icons.check_circle, color: Colors.indigo)
            : null,
      ),
    );
  }
}

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ModernLibraryApp(),
    ),
  );
}

class ModernLibraryApp extends StatefulWidget {
  const ModernLibraryApp({super.key});

  @override
  State<ModernLibraryApp> createState() => _ModernLibraryAppState();
}

class _ModernLibraryAppState extends State<ModernLibraryApp> {
  final LibraryManager _manager = LibraryManager();
  int _currentIndex = 0;
  Member? _currentUser;

  @override
  void initState() {
    super.initState();

    _manager.addBook(Book("B01", "Nhà Giả Kim", "Paulo Coelho"));
    _manager.addBook(Book("B02", "Clean Code", "Robert C. Martin"));
    _manager.addBook(Book("B03", "Design Patterns", "Gang of Four"));
    _manager.addMember(Member("M01", "Mai Liêm Trực"));
    _manager.addMember(Member("M02", "Nguyễn Văn A"));
    _currentUser = _manager.members.first;
  }

  void _showAddDialog({required bool isBook}) {
    final c1 = TextEditingController();
    final c2 = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isBook ? "Thêm Sách Mới" : "Thêm Độc Giả",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: c1,
              decoration: InputDecoration(
                labelText: isBook ? "Tên sách" : "Tên độc giả",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            const SizedBox(height: 10),
            if (isBook)
              TextField(
                controller: c2,
                decoration: InputDecoration(
                  labelText: "Tác giả",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  if (c1.text.isNotEmpty) {
                    setState(() {
                      if (isBook) {
                        _manager.addBook(
                          Book(
                            "B${DateTime.now().millisecondsSinceEpoch}",
                            c1.text,
                            c2.text,
                          ),
                        );
                      } else {
                        _manager.addMember(
                          Member(
                            "M${DateTime.now().millisecondsSinceEpoch}",
                            c1.text,
                          ),
                        );
                      }
                    });
                    Navigator.pop(ctx);
                  }
                },
                child: const Text(
                  "Xác Nhận",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHome() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF3F51B5), Color(0xFF5C6BC0)],
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
          ),
          child: Column(
            children: [
              const Text(
                "Xin chào,",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: () => setState(() => _currentIndex = 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _currentUser?.name ?? "Chọn người dùng",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.edit, color: Colors.white70, size: 18),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Kệ Sách Hiện Có",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: _manager.books.length,
            itemBuilder: (ctx, i) {
              final book = _manager.books[i];
              return BookCard(
                book: book,
                isLoanScreen: true,
                onTap: () {
                  if (_currentUser == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Chưa chọn người dùng!")),
                    );
                    return;
                  }
                  setState(() {
                    bool success = _manager.toggleLoan(book.id, _currentUser);
                    if (!success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Sách đang được người khác mượn!"),
                        ),
                      );
                    }
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBookList() {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Kho Sách", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,

        child: const Icon(Icons.library_add),
        onPressed: () => _showAddDialog(isBook: true),
      ),
      body: ListView.builder(
        itemCount: _manager.books.length,
        itemBuilder: (ctx, i) =>
            BookCard(book: _manager.books[i], onTap: () {}),
      ),
    );
  }

  Widget _buildUserList() {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Thành Viên", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: const Icon(Icons.person_add),
        onPressed: () => _showAddDialog(isBook: false),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.blue[50],
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue),
                SizedBox(width: 10),
                Expanded(
                  child: Text("Chạm vào tên để chọn người mượn sách hiện tại."),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _manager.members.length,
              itemBuilder: (ctx, i) {
                final m = _manager.members[i];
                return MemberTile(
                  member: m,
                  isSelected: _currentUser?.id == m.id,
                  onTap: () {
                    setState(() {
                      _currentUser = m;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Đã chọn: ${m.name}")),
                      );
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: IndexedStack(
        index: _currentIndex,
        children: [_buildHome(), _buildBookList(), _buildUserList()],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: Colors.indigo,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          onTap: (idx) => setState(() => _currentIndex = idx),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: "Mượn Trả",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_outlined),
              activeIcon: Icon(Icons.menu_book),
              label: "Sách",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              activeIcon: Icon(Icons.people),
              label: "Độc giả",
            ),
          ],
        ),
      ),
    );
  }
}
