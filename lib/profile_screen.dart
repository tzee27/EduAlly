import 'package:flutter/material.dart';
import 'role_selection_page.dart';
import 'home_screen.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Color palette from the design
  final Color steelBlue = Color(0xFF5193B3);
  final Color aqua = Color(0xFF62C4C3);
  final Color peach = Color(0xFFF8D49B);
  final Color cream = Color(0xFFF8E6CB);
  
  // Toggle states
  bool _isFaceIdEnabled = false;
  bool _isTwoFactorEnabled = false;
  bool _isNotificationsEnabled = true;
  bool _isDarkModeEnabled = false;
  
  // Simulated user data
  final Map<String, dynamic> _userData = {
    'name': 'Makabaka',
    'username': '@makabaka',
    'email': 'makabaka@edually.com',
    'phone': '+60 12 345 6789',
    'school': 'International School of Kuala Lumpur',
    'role': 'English Teacher',
    'subjects': ['English Literature', 'Creative Writing'],
    'classes': ['Class 3A', 'Class 4B', 'Class 5C'],
    'joinDate': 'January 2024',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Navigate to the Home Page directly
            if (HomePage.homeKey.currentState != null) {
              HomePage.homeKey.currentState!.onItemTapped(0);
            }
          },
        ),
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: steelBlue),
            onPressed: () => _showEditProfileSheet(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            SizedBox(height: 16),
            _buildAccountSection(),
            SizedBox(height: 16),
            _buildSecuritySection(),
            SizedBox(height: 16),
            _buildPreferencesSection(),
            SizedBox(height: 16),
            _buildSupportSection(),
            SizedBox(height: 16),
            _buildLogoutButton(),
            SizedBox(height: 24),
            Text(
              'EduAlly v1.0.1',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: steelBlue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                  ),
                  image: DecorationImage(
                    image: AssetImage('assets/profile_placeholder.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.camera_alt, color: steelBlue, size: 20),
                  onPressed: () {
                    // Handle profile picture change
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            _userData['name'],
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            _userData['username'],
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _userData['role'],
              style: TextStyle(
                color: steelBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection() {
    return _buildSection(
      title: 'Account Information',
      icon: Icons.person_outline,
      children: [
        _buildInfoRow('Email', _userData['email']),
        _buildInfoRow('Phone', _userData['phone']),
        _buildInfoRow('School', _userData['school']),
        _buildInfoRow('Subjects', _userData['subjects'].join(', ')),
        _buildInfoRow('Classes', _userData['classes'].join(', ')),
        _buildInfoRow('Member Since', _userData['joinDate']),
      ],
    );
  }

  Widget _buildSecuritySection() {
    return _buildSection(
      title: 'Security',
      icon: Icons.shield_outlined,
      children: [
        _buildToggleRow(
          'Face ID / Touch ID',
          'Use biometrics to secure your account',
          _isFaceIdEnabled,
          (value) {
            setState(() {
              _isFaceIdEnabled = value;
            });
          },
        ),
        Divider(),
        _buildToggleRow(
          'Two-Factor Authentication',
          'Add an extra layer of security',
          _isTwoFactorEnabled,
          (value) {
            setState(() {
              _isTwoFactorEnabled = value;
            });
            if (value) {
              _showTwoFactorSetupDialog(context);
            }
          },
        ),
        Divider(),
        _buildActionRow(
          'Change Password',
          'Last changed 30 days ago',
          Icons.chevron_right,
          () {
            // Handle password change
          },
        ),
      ],
    );
  }

  Widget _buildPreferencesSection() {
    return _buildSection(
      title: 'Preferences',
      icon: Icons.settings_outlined,
      children: [
        _buildToggleRow(
          'Notifications',
          'Enable push notifications',
          _isNotificationsEnabled,
          (value) {
            setState(() {
              _isNotificationsEnabled = value;
            });
          },
        ),
        Divider(),
        _buildToggleRow(
          'Dark Mode',
          'Switch to dark theme',
          _isDarkModeEnabled,
          (value) {
            setState(() {
              _isDarkModeEnabled = value;
            });
            // Implement theme change logic
          },
        ),
        Divider(),
        _buildActionRow(
          'Language',
          'English',
          Icons.chevron_right,
          () {
            // Show language selection dialog
          },
        ),
      ],
    );
  }

  Widget _buildSupportSection() {
    return _buildSection(
      title: 'Help & Support',
      icon: Icons.help_outline,
      children: [
        _buildActionRow(
          'Help Center',
          'FAQs and user guides',
          Icons.chevron_right,
          () {
            // Navigate to help center
          },
        ),
        Divider(),
        _buildActionRow(
          'Contact Support',
          'Get help from our team',
          Icons.chevron_right,
          () {
            // Contact support
          },
        ),
        Divider(),
        _buildActionRow(
          'Privacy Policy',
          'How we handle your data',
          Icons.chevron_right,
          () {
            // Show privacy policy
          },
        ),
        Divider(),
        _buildActionRow(
          'Terms of Service',
          'User agreement details',
          Icons.chevron_right,
          () {
            // Show terms of service
          },
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: steelBlue),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleRow(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: steelBlue,
        ),
      ],
    );
  }

  Widget _buildActionRow(
    String title,
    String subtitle,
    IconData iconData,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            iconData,
            color: Colors.grey[400],
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[50],
          foregroundColor: Colors.red,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        onPressed: () {
          _showLogoutConfirmation(context);
        },
        child: Text(
          'Log Out',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  void _showEditProfileSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle indicator
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Divider(),
            // Form fields
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Center(
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: steelBlue,
                                width: 3,
                              ),
                              image: DecorationImage(
                                image: AssetImage('assets/profile_placeholder.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: steelBlue,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                              onPressed: () {
                                // Handle profile picture change
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    _buildTextField('Name', _userData['name']),
                    SizedBox(height: 16),
                    _buildTextField('Username', _userData['username']),
                    SizedBox(height: 16),
                    _buildTextField('Email', _userData['email']),
                    SizedBox(height: 16),
                    _buildTextField('Phone', _userData['phone']),
                    SizedBox(height: 16),
                    _buildTextField('School', _userData['school']),
                    SizedBox(height: 16),
                    _buildTextField('Role', _userData['role']),
                  ],
                ),
              ),
            ),
            // Save button
            Container(
              padding: EdgeInsets.all(20),
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: steelBlue,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _showSuccessSnackbar(context, 'Profile updated successfully');
                },
                child: Text(
                  'Save Changes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String initialValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: TextEditingController(text: initialValue),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: steelBlue),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }

  void _showTwoFactorSetupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Set Up Two-Factor Authentication'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'We will send a verification code to your registered phone number each time you sign in to add an extra layer of security.',
            ),
            SizedBox(height: 16),
            Text(
              '+60 12 345 **** ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _isTwoFactorEnabled = false;
              });
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: steelBlue,
            ),
            onPressed: () {
              Navigator.pop(context);
              _showSuccessSnackbar(context, '2FA has been enabled successfully');
            },
            child: Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Log Out'),
        content: Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              _resetAppState();

                // Navigate to TeacherLoginPage
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => RoleSelectionPage()),
                (route) => false, // Remove all previous routes
              );
            },
            child: Text('Log Out'),
          ),
        ],
      ),
    );
  }

  void _resetAppState() {
  // Reset any app-specific state here
  setState(() {
    _isFaceIdEnabled = false;
    _isTwoFactorEnabled = false;
    _isNotificationsEnabled = true;
    _isDarkModeEnabled = false;
  });
}

  void _showSuccessSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text(message),
          ],
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }
}