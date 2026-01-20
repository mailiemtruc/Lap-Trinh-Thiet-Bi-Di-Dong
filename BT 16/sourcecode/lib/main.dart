import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

// --- CẤU HÌNH MÀU SẮC & THEME ---
class AppColors {
  static const Color primary = Color(0xFF2563EB); // Xanh dương hiện đại
  static const Color background = Color(0xFFF3F4F6); // Xám nhạt nền nã
  static const Color cardBg = Colors.white;
  static const Color textDark = Color(0xFF1F2937);
  static const Color textLight = Color(0xFF6B7280);

  // Màu Priority
  static const Color highPriority = Color(0xFFEF4444); // Đỏ
  static const Color mediumPriority = Color(0xFFF59E0B); // Vàng cam
  static const Color lowPriority = Color(0xFF10B981); // Xanh lá
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UTH SmartTasks',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true, // Kích hoạt Material 3 mới nhất
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          background: AppColors.background,
        ),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: AppColors.textDark,
            fontSize: 24,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
          iconTheme: IconThemeData(color: AppColors.textDark),
        ),
      ),
      home: const TaskListScreen(),
    );
  }
}

// ================== 1. MODEL SIÊU BỀN (GIỮ NGUYÊN) ==================
class Subtask {
  final String title;
  final bool isCompleted;
  Subtask({required this.title, required this.isCompleted});
  factory Subtask.fromJson(Map<String, dynamic> json) {
    return Subtask(
      title: json['title']?.toString() ?? 'No Title',
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}

class Attachment {
  final String fileName;
  Attachment({required this.fileName});
  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(fileName: json['fileName']?.toString() ?? 'Unknown File');
  }
}

class Task {
  final String id;
  final String title;
  final String description;
  final String status;
  final String priority;
  final String category;
  final String dueDate;
  final List<Subtask> subtasks;
  final List<Attachment> attachments;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.category,
    required this.dueDate,
    required this.subtasks,
    required this.attachments,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    var subtaskList = (json['subtasks'] is List)
        ? json['subtasks'] as List
        : [];
    var attachmentList = (json['attachments'] is List)
        ? json['attachments'] as List
        : [];

    return Task(
      id: json['id']?.toString() ?? '0',
      title: json['title']?.toString() ?? 'No Title',
      description: json['description']?.toString() ?? '',
      status: json['status']?.toString() ?? 'Pending',
      category: json['category']?.toString() ?? 'General',
      priority: json['priority']?.toString() ?? 'Low',
      dueDate: (json['dueDate'] != null && json['dueDate'].toString() != "-1")
          ? json['dueDate'].toString().split('T')[0]
          : 'N/A',
      subtasks: subtaskList.map((i) => Subtask.fromJson(i)).toList(),
      attachments: attachmentList.map((i) => Attachment.fromJson(i)).toList(),
    );
  }
}

// ================== 2. API SERVICE (GIỮ NGUYÊN) ==================
class ApiService {
  static const String baseUrl = 'https://amock.io/api/researchUTH';

  static Future<List<Task>> fetchTasks() async {
    final response = await http.get(Uri.parse('$baseUrl/tasks'));
    if (response.statusCode == 200) {
      final dynamic body = jsonDecode(response.body);
      List<dynamic> dataList = [];
      if (body is List) {
        dataList = body;
      } else if (body is Map<String, dynamic>) {
        if (body['tasks'] is List)
          dataList = body['tasks'];
        else if (body['data'] is List)
          dataList = body['data'];
      }
      return dataList.map((item) => Task.fromJson(item)).toList();
    } else {
      return [];
    }
  }

  static Future<Task> fetchTaskDetail(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/task/$id'));
    if (response.statusCode == 200) {
      final dynamic body = jsonDecode(response.body);
      if (body is Map<String, dynamic>) {
        if (body['isSuccess'] == false || body['data'] == null) {
          throw Exception(body['message'] ?? 'Unable to locate task');
        }
      }
      if (body is Map<String, dynamic> &&
          body['data'] is Map<String, dynamic>) {
        return Task.fromJson(body['data']);
      }
      return Task.fromJson(body);
    } else {
      throw Exception('Lỗi kết nối (Mã ${response.statusCode})');
    }
  }

  static Future<bool> deleteTask(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/task/$id'));
    return response.statusCode == 200 || response.statusCode == 204;
  }
}

// ================== 3. UI MÀN HÌNH DANH SÁCH (MODERN UI) ==================

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});
  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late Future<List<Task>> futureTasks;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() {
    setState(() {
      futureTasks = ApiService.fetchTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('My Tasks'),
            Text(
              'Stay productive today',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textLight),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _loadTasks,
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.refresh,
                color: AppColors.primary,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: FutureBuilder<List<Task>>(
        future: futureTasks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (snapshot.hasData) {
            final tasks = snapshot.data!;
            if (tasks.isEmpty) return const EmptyView();

            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              itemCount: tasks.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return TaskCard(
                  task: tasks[index],
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TaskDetailScreen(taskId: tasks[index].id),
                      ),
                    );
                    if (result == 'refresh') _loadTasks();
                  },
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  const TaskCard({super.key, required this.task, required this.onTap});

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return AppColors.highPriority;
      case 'medium':
        return AppColors.mediumPriority;
      default:
        return AppColors.lowPriority;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: IntrinsicHeight(
            child: Row(
              children: [
                // Dải màu Priority bên trái
                Container(width: 6, color: _getPriorityColor(task.priority)),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                task.category,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            Text(
                              task.dueDate == 'N/A' ? '' : task.dueDate,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textLight,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          task.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          task.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.textLight,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmptyView extends StatelessWidget {
  const EmptyView({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)],
            ),
            child: Icon(
              Icons.assignment_add,
              size: 60,
              color: AppColors.primary.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "No Tasks Found",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "You are free for the day!",
            style: TextStyle(color: AppColors.textLight),
          ),
        ],
      ),
    );
  }
}

// ================== 4. UI MÀN HÌNH CHI TIẾT (MODERN UI) ==================

class TaskDetailScreen extends StatefulWidget {
  final String taskId;
  const TaskDetailScreen({super.key, required this.taskId});
  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late Future<Task> futureTaskDetail;

  @override
  void initState() {
    super.initState();
    futureTaskDetail = ApiService.fetchTaskDetail(widget.taskId);
  }

  void _deleteTask() async {
    // Show confirm dialog đẹp hơn
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Task?"),
        content: const Text("This action cannot be undone."),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.highPriority,
              foregroundColor: Colors.white,
            ),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      bool success = await ApiService.deleteTask(widget.taskId);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Deleted successfully"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, 'refresh');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Nền trắng cho trang chi tiết
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delete_outline,
                color: Colors.red,
                size: 22,
              ),
            ),
            onPressed: _deleteTask,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: FutureBuilder<Task>(
        future: futureTaskDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Hiển thị lỗi đẹp hơn
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 60,
                    color: Colors.red.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      snapshot.error.toString().replaceAll("Exception:", ""),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData) {
            final task = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      task.status.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tiêu đề lớn
                  Text(
                    task.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Ngày tháng
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 16,
                        color: AppColors.textLight,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Due: ${task.dueDate}",
                        style: const TextStyle(
                          color: AppColors.textLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // 3 ô thông tin
                  Row(
                    children: [
                      _buildDetailBox(
                        "Category",
                        task.category,
                        Icons.folder_outlined,
                        Colors.blue,
                      ),
                      const SizedBox(width: 16),
                      _buildDetailBox(
                        "Priority",
                        task.priority,
                        Icons.flag_outlined,
                        Colors.orange,
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Description Section
                  const Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    task.description,
                    style: const TextStyle(
                      color: AppColors.textLight,
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Subtasks Section
                  if (task.subtasks.isNotEmpty) ...[
                    const Text(
                      "Subtasks",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...task.subtasks.map(
                      (sub) => Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: CheckboxListTile(
                          title: Text(
                            sub.title,
                            style: TextStyle(
                              decoration: sub.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: sub.isCompleted
                                  ? Colors.grey
                                  : AppColors.textDark,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          value: sub.isCompleted,
                          activeColor: AppColors.primary,
                          checkboxShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          onChanged: (val) {},
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),

                  // Attachments Section
                  if (task.attachments.isNotEmpty) ...[
                    const Text(
                      "Attachments",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...task.attachments.map(
                      (file) => Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.insert_drive_file,
                                color: Colors.blue,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                file.fileName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.download_rounded,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildDetailBox(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: color.withOpacity(0.8)),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
