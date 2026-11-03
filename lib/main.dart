import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF53389E),
          primary: const Color(0xFF53389E),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class Task {
  String title;
  String subject;
  String desc;
  String priority;
  DateTime tanggal;
  bool isDone;

  Task({
    required this.title,
    required this.subject,
    required this.desc,
    required this.priority,
    required this.tanggal,
    this.isDone = false,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Task> _tasks = [];

  void _showDeleteDialog(Task task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Delete this task?',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: Text(
            '"${task.title}" will be removed from your list. This can\'t be undone.',
            style: const TextStyle(color: Colors.black54, fontSize: 14),
          ),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Cancel', style: TextStyle(color: Colors.black87)),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _tasks.remove(task);
                });
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB42318),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToEditForm(Task? task) async {
    final updatedTask = await Navigator.push<Task>(
      context,
      MaterialPageRoute(
        builder: (context) => TaskFormScreen(task: task),
      ),
    );

    if (updatedTask != null) {
      setState(() {
        if (task != null) {
          final index = _tasks.indexOf(task);
          if (index != -1) {
            _tasks[index] = updatedTask;
          }
        } else {
          _tasks.add(updatedTask);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeCount = _tasks.where((t) => !t.isDone).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          // Custom Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 24),
            decoration: const BoxDecoration(
              color: Color(0xFF53389E),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'MyTask',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$activeCount tasks to finish',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Task List View
          Expanded(
            child: _tasks.isEmpty
                ? const Center(
              child: Text(
                'No tasks yet!',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
                : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                final formattedDate = '${months[task.tanggal.month - 1]} ${task.tanggal.day}';

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Checkbox(
                      value: task.isDone,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      onChanged: (bool? value) {
                        setState(() {
                          task.isDone = value ?? false;
                        });
                      },
                    ),
                    title: Text(
                      task.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        decoration: task.isDone ? TextDecoration.lineThrough : TextDecoration.none,
                        color: task.isDone ? Colors.grey : Colors.black87,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEEF2F6),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              task.subject,
                              style: const TextStyle(
                                color: Color(0xFF3538CD),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Text(
                            formattedDate,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, color: Color(0xFF3538CD), size: 20),
                          onPressed: () => _navigateToEditForm(task),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Color(0xFFD92D20), size: 20),
                          onPressed: () => _showDeleteDialog(task),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: FloatingActionButton.extended(
          backgroundColor: const Color(0xFF53389E),
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          onPressed: () => _navigateToEditForm(null),
          icon: const Icon(Icons.add),
          label: const Text('Add Task', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class TaskFormScreen extends StatefulWidget {
  final Task? task;

  const TaskFormScreen({super.key, this.task});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _subjectController;
  late final TextEditingController _descriptionController;
  late DateTime _selectedDate;
  late String _selectedPriority;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.task?.tanggal ?? DateTime.now();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _subjectController = TextEditingController(text: widget.task?.subject ?? '');
    _descriptionController = TextEditingController(text: widget.task?.desc ?? '');
    _selectedPriority = widget.task?.priority ?? 'Medium';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final formattedDate = '${months[_selectedDate.month - 1]} ${_selectedDate.day}, ${_selectedDate.year}';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Task' : 'Add Task', style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF53389E),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Task Title', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'e.g. Algebra Worksheet 5',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a task title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text('Subject', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _subjectController,
                decoration: InputDecoration(
                  hintText: 'e.g. Math',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a subject';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text('Due Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 6),
              OutlinedButton.icon(
                onPressed: () => _selectDate(context),
                icon: const Icon(Icons.calendar_today_outlined, color: Colors.grey),
                label: Text(formattedDate, style: const TextStyle(color: Colors.black87)),
                style: OutlinedButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Description (optional)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Add notes about this task',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final savedTask = Task(
                      title: _titleController.text.trim(),
                      subject: _subjectController.text.trim(),
                      desc: _descriptionController.text.trim(),
                      priority: _selectedPriority,
                      tanggal: _selectedDate,
                      isDone: widget.task?.isDone ?? false,
                    );

                    Navigator.pop(context, savedTask);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF53389E),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(isEditing ? 'Save Changes' : 'Save Task', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Cancel', style: TextStyle(fontSize: 16, color: Colors.black87)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}