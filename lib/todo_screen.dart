import 'package:flutter/material.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({Key? key}) : super(key: key);

  @override
  _ToDoScreenState createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  List<Map<String, dynamic>> tasks = [];
  final TextEditingController _taskController = TextEditingController();

  void _addTask() {
    final taskText = _taskController.text;
    if (taskText.isNotEmpty) {
      setState(() {
        tasks.add({'task': taskText, 'isDone': false});
        _taskController.clear();
      });
    }
  }

  void _toggleTaskDone(int index) {
    setState(() {
      tasks[index]['isDone'] = !tasks[index]['isDone'];
    });
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _taskController,
              decoration: const InputDecoration(
                hintText: 'Enter task...',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.add),
              ),
              onSubmitted: (_) => _addTask(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return ListTile(
                    title: Text(
                      task['task'],
                      style: TextStyle(
                        decoration: task['isDone']
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        task['isDone'] ? Icons.check_box : Icons.check_box_outline_blank,
                        color: Colors.deepPurpleAccent,
                      ),
                      onPressed: () => _toggleTaskDone(index),
                    ),
                    onLongPress: () => _deleteTask(index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
