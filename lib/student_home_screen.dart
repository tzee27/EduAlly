import 'package:flutter/material.dart';
import 'student_profile_screen.dart';
import 'student_calender_screen.dart';
import 'course_screen.dart';
import 'ai_chatbot.dart';
import 'student_inbox_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> todoList = [];
  List<bool> completed = [];
  int unreadMessages = 5;
  final TextEditingController _todoController = TextEditingController();
  final String studentName = "John Doe"; // Replace with dynamic student name

  final List<Map<String, dynamic>> announcements = [
    {
      "icon": Icons.event,
      "title": "Tech Talk: AI & Future",
      "description": "Join the AI talk this Friday at 2 PM.",
      "color": const Color.fromARGB(255, 99, 210, 91)
    },
    {
      "icon": Icons.school,
      "title": "University Open Day",
      "description": "Visitors from XYZ School touring the campus.",
      "color": Colors.green
    },
    {
      "icon": Icons.speaker,
      "title": "Guest Speaker: Dr. John",
      "description": "Special talk by Dr. John on cybersecurity.",
      "color": Colors.orange
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // This hides the back arrow
        title: const Text('Student Dashboard'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 156, 152, 170),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          children: [
            // Welcome Message
            Text(
              "Welcome, $studentName 👋",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 20),

            // Unread Messages Panel
            Container(
              padding: const EdgeInsets.all(16),
              decoration: _boxDecoration(const Color(0xFFF8D49B)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Unread Messages',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5A5A5A),
                    ),
                  ),
                  Chip(
                    label: Text(
                      unreadMessages.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: const Color(0xFF5AB728),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // To-Do List Centered Box
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 350,
                padding: const EdgeInsets.all(16),
                decoration: _boxDecoration(const Color(0xFFF8E6CB)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'To-Do List',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5A5A5A),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _todoController,
                      decoration: const InputDecoration(
                        labelText: 'Add a task',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (task) {
                        setState(() {
                          if (task.isNotEmpty) {
                            todoList.add(task);
                            completed.add(false);
                            _todoController.clear();
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    if (todoList.isNotEmpty)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: List.generate(todoList.length, (index) {
                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
                              leading: Checkbox(
                                value: completed[index],
                                onChanged: (bool? value) {
                                  setState(() {
                                    completed[index] = value!;
                                  });
                                },
                              ),
                              title: Text(
                                todoList[index],
                                style: TextStyle(
                                  decoration: completed[index] ? TextDecoration.lineThrough : null,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    todoList.removeAt(index);
                                    completed.removeAt(index);
                                  });
                                },
                              ),
                            );
                          }),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Features Grid
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              padding: const EdgeInsets.all(8.0),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildFeatureBox(Icons.chat_bubble_outline, "AI Chatbot", const Color(0xFF5193B3), const AIChatbotPage()),
                _buildFeatureBox(Icons.calendar_today, "Classes", const Color(0xFF62C4C3), CalendarScreen()),
                _buildFeatureBox(Icons.mail_outline, "Inbox", const Color.fromARGB(255, 255, 212, 144), const InboxPage()),
                _buildFeatureBox(Icons.archive_rounded, "Courses", const Color.fromARGB(255, 183, 165, 138), const CoursesScreen()),
              ],
            ),

            const SizedBox(height: 20),

            // Announcements Panel
            _buildAnnouncementPanel(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureBox(IconData icon, String label, Color color, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        height: 140, // Square shape
        decoration: _boxDecoration(color),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnnouncementPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "📢 Announcements",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Column(
            children: List.generate(announcements.length, (index) {
              final announcement = announcements[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: _boxDecoration(announcement["color"]),
                child: Row(
                  children: [
                    Icon(announcement["icon"], size: 40, color: Colors.white),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(announcement["description"], style: const TextStyle(fontSize: 14, color: Colors.white)),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  BoxDecoration _boxDecoration(Color color) {
    return BoxDecoration(color: color, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 2, blurRadius: 5)]);
  }
}
