import 'package:flutter/material.dart';

class Message {
  final String sender;
  final String content;
  final String time;
  final IconData icon;
  final bool isDetectedStudent;
  final String details;
  bool isRead; // NEW: Track if message is read

  Message({
    required this.sender,
    required this.content,
    required this.time,
    required this.icon,
    required this.details,
    this.isDetectedStudent = false,
    this.isRead = false, // Default: unread
  });
}

class InboxPage extends StatefulWidget {
  const InboxPage({Key? key}) : super(key: key);

  @override
  _InboxPageState createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  List<Message> detectedStudents = [
    Message(
      sender: "CCTV Alert",
      content: "John Doe appears to be sleeping in CS101.",
      time: "10:45 AM",
      icon: Icons.visibility,
      details: "Detected at 10:45 AM in Lecture Hall 3. Repeated in last 2 classes.",
      isDetectedStudent: true,
    ),
    Message(
      sender: "CCTV Alert",
      content: "Jane Smith is talking in class.",
      time: "9:50 AM",
      icon: Icons.mic_off,
      details: "Detected at 9:50 AM in CS101 class. Talking with peers during lecture.",
      isDetectedStudent: true,
    ),
  ];

  List<Message> notifications = [
    Message(
      sender: "Prof. Lee",
      content: "Your quiz marks are available: 85/100",
      time: "Yesterday",
      icon: Icons.check_circle,
      details: "Quiz 1: 85/100 (Multiple Choice: 40/50, Coding: 45/50). Great job!",
    ),
    Message(
      sender: "System Notification",
      content: "Classroom change for CS101 - Room 305",
      time: "9:15 AM",
      icon: Icons.notifications,
      details: "CS101 lecture moved to Room 305 due to maintenance in Room 204.",
    ),
    Message(
      sender: "Mr. Chin",
      content: "Your assignment has been graded: A+",
      time: "10:30 AM",
      icon: Icons.grade,
      details: "Assignment 2: A+ (Report: 48/50, Code: 50/50). Excellent work!",
    ),
    Message(
      sender: "System Notification",
      content: "Upcoming Assignment Due: AI Project",
      time: "2 days left",
      icon: Icons.warning_amber,
      details: "Your AI project is due in 2 days (April 5, 11:59 PM). Ensure submission on time.",
    ),
  ];

  // Function to mark a message as read
  void markAsRead(Message message) {
    setState(() {
      message.isRead = true;
    });
  }

  Widget buildMessageList(String title, List<Message> messages) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurpleAccent,
            ),
          ),
        ),
        ...messages.map((message) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: Icon(
                message.icon,
                color: message.isDetectedStudent ? Colors.redAccent : Colors.deepPurpleAccent,
              ),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      message.sender,
                      style: TextStyle(
                        fontWeight: message.isRead ? FontWeight.normal : FontWeight.bold,
                      ),
                    ),
                  ),
                  if (!message.isRead) // Show blue dot for unread messages
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(left: 4),
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
              subtitle: Text(message.content),
              trailing: Text(message.time),
              onTap: () {
                markAsRead(message);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(message.sender),
                    content: Text(message.details),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Close"),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }).toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inbox"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: ListView(
        children: [
          buildMessageList("Detected Students", detectedStudents),
          buildMessageList("Notifications", notifications),
        ],
      ),
    );
  }
}
