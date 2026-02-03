import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login/Welcom_page.dart';
import 'Settings_page.dart';

import 'models/task.dart';
import 'Widgets/circel.dart';
import 'widgets/task_input.dart';
import 'widgets/task_list.dart';
import 'serves/task_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();

  final dailyService = TaskService('dailyTasks');
  final monthlyService = TaskService('monthlyTasks');
  final yearlyService = TaskService('yearlyTasks');

  double calculateProgress(List<Task> tasks) {
    if (tasks.isEmpty) return 0;
    return tasks.where((t) => t.isDone).length / tasks.length;
  }

  Widget taskPage({
    required TaskService service,
    required String title,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: StreamBuilder<List<Task>>(
        stream: service.getTasks(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final tasks = snapshot.data!;

          return Column(
            children: [
              ProgressCircle(
                percent: calculateProgress(tasks),
                title: title,
                color: color,
              ),
              const SizedBox(height: 20),

              TaskInput(
                controller: _controller,
                onAddTask: (text) {
                  service.addTask(text);
                },
              ),

              const SizedBox(height: 12),

              TaskList(
                tasks: tasks,
                onToggle: (task) {
                  service.updateTask(task.id, !task.isDone);
                },
                onDelete: (task) {
                  service.deleteTask(task.id);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  // ================= DRAWER =================
  Drawer _buildDrawer(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                user?.displayName != null && user!.displayName!.isNotEmpty
                    ? user.displayName![0].toUpperCase()
                    : "U",
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            accountName: Text(user?.displayName ?? "مستخدم"),
            accountEmail: Text(user?.email ?? ""),
          ),

          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("الملف الشخصي"),
            onTap: () {
              Navigator.pop(context);
            },
          ),

          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("الإعدادات"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              "تسجيل الخروج",
              style: TextStyle(color: Colors.red),
            ),
            onTap: () async {
              Navigator.pop(context); // يقفل الـ Drawer

              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("تسجيل الخروج"),
                  content: const Text("هل أنت متأكد أنك تريد تسجيل الخروج؟"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("إلغاء",style: TextStyle(color: Colors.black),),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text("خروج",style: TextStyle(color: Colors.black),),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Welcomepage()),
                  (route) => false,
                );
              }
            },
          ),

          const Spacer(),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              "تسجيل الخروج",
              style: TextStyle(color: Colors.red),
            ),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(
                context,
                "Login",
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: _buildDrawer(context), // ☰ التلات شرط

        appBar: AppBar(
          title: const Text(
            "المهام",
            style: TextStyle(fontSize: 40, color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60), // 👈 ارتفاع التابس
            child: TabBar(
              labelStyle: const TextStyle(
                fontSize: 18, // 👈 حجم النص
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: const TextStyle(fontSize: 16),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              indicatorColor: Colors.white,
              tabs: const [
                Tab(text: "اليومية"),
                Tab(text: "الشهرية"),
                Tab(text: "السنوية"),
              ],
            ),
          ),
        ),

        body: TabBarView(
          children: [
            taskPage(
              service: dailyService,
              title: "إنجاز اليوم",
              color: Colors.green,
            ),
            taskPage(
              service: monthlyService,
              title: "إنجاز الشهر",
              color: Colors.orange,
            ),
            taskPage(
              service: yearlyService,
              title: "إنجاز السنة",
              color: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }
}
