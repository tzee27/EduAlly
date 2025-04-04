
import 'package:flutter/material.dart';

class Course {
  final String name;
  final String code;
  final String status; // E.g., "Registered", "Passed"
  final String? grade; // Grade for passed courses
  final IconData icon;
  final Color color;

  Course({
    required this.name,
    required this.code,
    required this.status,
    this.grade,
    required this.icon,
    required this.color,
  });
}

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({Key? key}) : super(key: key);

  @override
  _CoursesScreenState createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  // List of courses (you can replace this with data from an API or a database)
  List<Course> courses = [
    Course(name: "Introduction to Programming", code: "CS101", status: "Registered", icon: Icons.code, color: Colors.blue),
    Course(name: "Data Structures", code: "CS102", status: "Passed", grade: "A", icon: Icons.storage, color: Colors.green),
    Course(name: "Web Development", code: "CS201", status: "Registered", icon: Icons.web, color: Colors.orange),
    Course(name: "Database Management", code: "CS202", status: "Passed", grade: "B+", icon: Icons.storage_rounded, color: Colors.green),
    Course(name: "Software Engineering", code: "CS301", status: "Registered", icon: Icons.computer, color: Colors.blue),
    Course(name: "Artificial Intelligence", code: "CS302", status: "Passed", grade: "A-", icon: Icons.smart_toy, color: Colors.green),
    Course(name: "Mobile App Development", code: "CS303", status: "Registered", icon: Icons.phone_android, color: Colors.orange),
    Course(name: "Cloud Computing", code: "CS304", status: "Passed", grade: "B", icon: Icons.cloud, color: Colors.green),
    Course(name: "Cybersecurity", code: "CS305", status: "Registered", icon: Icons.security, color: Colors.blue),
    Course(name: "Machine Learning", code: "CS306", status: "Passed", grade: "A", icon: Icons.memory, color: Colors.green),
    Course(name: "Operating Systems", code: "CS307", status: "Registered", icon: Icons.settings, color: Colors.orange),
    Course(name: "Computer Networks", code: "CS308", status: "Passed", grade: "B+", icon: Icons.wifi, color: Colors.green),
  ];

  // List to store the filtered courses based on search input
  List<Course> filteredCourses = [];

  // Text controller for the search bar
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredCourses = courses; // Initially show all courses
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Function to filter courses based on search text
  void _filterCourses(String query) {
    final filtered = courses.where((course) {
      final courseName = course.name.toLowerCase();
      final searchQuery = query.toLowerCase();
      return courseName.contains(searchQuery);
    }).toList();

    setState(() {
      filteredCourses = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'My Courses',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: ListView(
              children: [
                _buildCoursesSection("Registered Courses", "Registered"),
                _buildCoursesSection("Passed Courses", "Passed"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Build search bar
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: "Search Courses...",
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
        onChanged: _filterCourses, // Call the filter function when the search text changes
      ),
    );
  }

  // Build courses section (Registered or Passed)
  Widget _buildCoursesSection(String title, String status) {
    // Filter courses based on the status
    final sectionCourses = filteredCourses.where((course) => course.status == status).toList();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (sectionCourses.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: sectionCourses.length,
              itemBuilder: (context, index) {
                final course = sectionCourses[index];
                return Card(
                  // ignore: deprecated_member_use
                  color: course.color.withOpacity(0.1),
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading: Icon(course.icon, color: course.color),
                    title: Text(course.name),
                    subtitle: Text(course.code + (course.grade != null ? " | Grade: ${course.grade}" : "")),
                  ),
                );
              },
            )
          else
            Text("No $title available."),
        ],
      ),
    );
  }
}
