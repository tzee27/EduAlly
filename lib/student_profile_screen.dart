import 'package:flutter/material.dart';
import 'role_selection_page.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Profile'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 179, 174, 190),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Add logout functionality
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Profile Picture
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage('https://www.example.com/profile.jpg'),
              ),
            ),
            const SizedBox(height: 20),

            // Personal Information Section
            _buildSection(
              title: 'Personal Information',
              color: Colors.blue.shade50,
              children: [
                _buildProfileInfoRow(Icons.person, 'Name', 'John Doe'),
                _buildProfileInfoRow(Icons.perm_identity, 'Student ID', 'CS123456'),
                _buildProfileInfoRow(Icons.cake, 'Age', '22'),
                _buildProfileInfoRow(Icons.accessibility, 'Gender', 'Male'),
                _buildEditButton(context), // Edit button
              ],
            ),

            const SizedBox(height: 20),

            // Academic Information Section
            _buildSection(
              title: 'Academic Information',
              color: Colors.green.shade50,
              children: [
                _buildProfileInfoRow(Icons.school, 'Degree Program', 'BSc Computer Science'),
                _buildProfileInfoRow(Icons.calendar_today, 'Current Semester', 'Semester 4'),
                _buildProfileInfoRow(Icons.grade, 'CGPA', '3.8/4.0'),
                _buildEditButton(context), // Edit button
              ],
            ),

            const SizedBox(height: 20),

            // Courses Taken Section
            _buildSection(
              title: 'Courses Taken This Semester',
              color: Colors.yellow.shade50,
              children: [
                _CourseItem(courseName: 'Data Structures'),
                _CourseItem(courseName: 'Operating Systems'),
                _CourseItem(courseName: 'Database Management'),
                _CourseItem(courseName: 'Software Engineering'),
                _CourseItem(courseName: 'Artificial Intelligence'),
                _buildEditButton(context), // Edit button
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Reusable Section Widget
  Widget _buildSection({
    required String title,
    required Color color,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 2, blurRadius: 5),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurpleAccent,
            ),
          ),
          const SizedBox(height: 10),
          Column(children: children),
        ],
      ),
    );
  }

  // Reusable Profile Information Row
  Widget _buildProfileInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color.fromARGB(255, 157, 150, 174),
            size: 24,
          ),
          const SizedBox(width: 10),
          Text(
            '$label:',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  // Edit Button
  Widget _buildEditButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ElevatedButton(
        onPressed: () {
          // Navigate to the Edit Profile screen (you can implement this)
          _showEditProfileDialog(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 216, 213, 222), // Button color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text('Edit Profile'),
      ),
    );
  }

  // Logout Dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => RoleSelectionPage()),
                  (Route<dynamic> route) => false, // Remove all previous routes
                );
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  // Course Item widget
  Widget _CourseItem({required String courseName}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Icon(Icons.book, color: Colors.deepPurpleAccent),
          const SizedBox(width: 10),
          Text(
            courseName,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.deepPurpleAccent,
            ),
          ),
        ],
      ),
    );
  }

  // Edit Profile Dialog
  void _showEditProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: const Text('You can implement the edit profile functionality here.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Implement your edit functionality here
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
