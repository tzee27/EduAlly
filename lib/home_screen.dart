import 'package:flutter/material.dart';
import 'inbox_screen.dart'; 
import 'calendar_screen.dart';
import 'aichatbot_screen.dart';
import 'profile_screen.dart';
import 'studentanalysis_screen.dart';
import 'cctv_screen.dart';

class HomePage extends StatefulWidget {
  // Add a static GlobalKey to access the state from other screens
  static final GlobalKey<_HomePageState> homeKey = GlobalKey<_HomePageState>();
  
  HomePage() : super(key: homeKey);
  
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Color palette from the design
  final Color steelBlue = Color(0xFF5193B3);
  final Color aqua = Color(0xFF62C4C3);
  final Color peach = Color(0xFFF8D49B);
  final Color cream = Color(0xFFF8E6CB);
  
  // Track the selected index
  int _selectedIndex = 0;
  
  // List of pages to display
  late final List<Widget> _pages;
  
  @override
  void initState() {
    super.initState();
    _pages = [
      _buildMainContent(),
      AIChatbotScreen(),
      CalendarSchedulePage(),
      ProfilePage(), 
    ];
  }
  
  // Method to handle bottom navigation tap - accessible to child widgets
  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }
  
  // The main dashboard content moved to its own method
  Widget _buildMainContent() {
    return Column(
      children: [
        // Header
        _buildHeader(),
        
        // Main content - scrollable
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  _buildSearchBar(),
                  SizedBox(height: 24),
                  _buildQuickStats(),
                  SizedBox(height: 24),
                  _buildMainNavigation(context),
                  SizedBox(height: 24),
                  _buildToolsAndResources(context), // Pass context here
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(13, 0, 0, 0),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side - Logo and teacher badge
          Row(
            children: [
              Text(
                'EduAlly',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue[500],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Teacher',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          // Right side - Notifications and profile picture
          Row(
            children: [
              Icon(Icons.notifications_outlined, color: Colors.grey[600]),
              SizedBox(width: 16),
              // Profile picture with tap area - using GestureDetector for reliable tapping
              GestureDetector(
                onTap: () { 
                  setState(() {
                    _selectedIndex = 3; // Navigate to profile page
                  });
                },
                behavior: HitTestBehavior.opaque, // Important to ensure taps are registered
                child: Padding(
                  padding: EdgeInsets.all(4), // Bigger tap target
                  child: Stack(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: steelBlue, width: 2),
                          image: DecorationImage(
                            image: NetworkImage('https://via.placeholder.com/40'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          height: 12,
                          width: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search for students, classes, or resources...',
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('24', 'Students', steelBlue),
          _buildStatItem('4', 'Classes', aqua),
          _buildStatItem('8', 'Tasks', steelBlue),
          _buildStatItem('3', 'Alerts', peach),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  Widget _buildMainNavigation(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        _buildNavigationCard(
          'Student Analysis',
          'Monitor classroom behaviors',
          Icons.bar_chart,
          steelBlue,
          Colors.white,
          onTap: () {
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => SimplifiedStudentAnalysisPage())
            );
          },
        ),
        _buildNavigationCard(
          'AI Chatbot',
          'Student support assistance',
          Icons.chat_bubble_outline,
          aqua,
          Colors.white,
          onTap: () {
            // Instead of using Navigator, we can directly switch to the tab
            setState(() {
              _selectedIndex = 1; // Index of AI Chatbot in _pages
            });
          },
        ),
        _buildNavigationCard(
          'Inbox',
          'View your messages',
          Icons.mail_outline,
          cream,
          Colors.grey[700]!,
          onTap: () {
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => InboxScreen())
            );
          },
        ),
        _buildNavigationCard(
          'Calendar',
          'Schedule and events',
          Icons.calendar_today,
          peach,
          Colors.grey[700]!,
          onTap: () {
            // Instead of using Navigator, we can directly switch to the tab
            setState(() {
              _selectedIndex = 2; // Index of Calendar in _pages
            });
          },
        ),
      ],
    );
  }

  Widget _buildNavigationCard(
      String title, 
      String subtitle, 
      IconData icon, 
      Color bgColor, 
      Color textColor, 
      {VoidCallback? onTap}
  ) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap ?? () {},
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: textColor, size: 40),
                SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: textColor.withOpacity(0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToolsAndResources(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Tools & Resources',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.grey[700],
        ),
      ),
      SizedBox(height: 12),
      Row(
        children: [
          // CCTV Connect Button
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue[500],
                elevation: 2,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                try {
                  Navigator.push(
                    context, 
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => UltraSimpleCCTVScreen(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return child;
                      },
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error opening CCTV: $e"))
                  );
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.videocam_outlined, size: 24),
                  SizedBox(height: 8),
                  Text(
                    'CCTV Connect',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          SizedBox(width: 12),
          
          // Profile Button - using same style as CCTV button
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue[500],
                elevation: 2,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                setState(() {
                  _selectedIndex = 3; // Navigate to profile page
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_outline, size: 24),
                  SizedBox(height: 8),
                  Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

  Widget _buildBottomNavigation() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem('Dashboard', Icons.dashboard, _selectedIndex == 0, 0),
          _buildNavItem('Chat', Icons.chat_bubble_outline, _selectedIndex == 1, 1),
          _buildNavItem('Calendar', Icons.calendar_today, _selectedIndex == 2, 2),
          _buildNavItem('Profile', Icons.person_outline, _selectedIndex == 3, 3),
        ],
      ),
    );
  }

  Widget _buildNavItem(String label, IconData icon, bool isActive, int index) {
    return InkWell(
      onTap: () => onItemTapped(index), // Using the public method
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? Colors.blue[500] : Colors.grey[400],
            size: 24,
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? Colors.blue[500] : Colors.grey[400],
              fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}