import 'package:flutter/material.dart';

class InboxScreen extends StatefulWidget {
  @override
  _InboxScreenState createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> with TickerProviderStateMixin {
  // Color palette from the design
  final Color steelBlue = Color(0xFF5193B3);
  final Color aqua = Color(0xFF62C4C3);
  final Color peach = Color(0xFFF8D49B);
  final Color cream = Color(0xFFF8E6CB);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Color(0xFFF5F7FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Inbox',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search, color: Colors.black),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.more_vert, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            // Improved Tab Bar Design
            Container(
              color: Colors.white,
              child: TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: steelBlue,
                indicator: BoxDecoration(
                  color: steelBlue,
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                tabs: [
                  Tab(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Focus', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Tab(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Normal', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
            
            // Content area
            Expanded(
              child: TabBarView(
                children: [
                  // Focus Tab (with Emergency/Non-Emergency subtabs)
                  _buildFocusTab(),
                  
                  // Normal Tab (all messages)
                  _buildNormalTab()
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: steelBlue,
          child: Icon(Icons.add),
          onPressed: () {},
        ),
      ),
    );
  }

  // Focus tab content with subtabs
  Widget _buildFocusTab() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          // Sub tabs (Emergency/Non-Emergency)
          Container(
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            child: TabBar(
              indicator: BoxDecoration(
                color: steelBlue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(30),
              ),
              labelColor: steelBlue,
              unselectedLabelColor: Colors.grey[600],
              padding: EdgeInsets.all(4),
              tabs: [
                Tab(
                  icon: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.warning_amber_rounded, size: 16),
                      SizedBox(width: 6),
                      Text('Emergency', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Tab(
                  icon: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox_outlined, size: 16),
                      SizedBox(width: 6),
                      Text('Non-Emergency', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Sub tab content
          Expanded(
            child: TabBarView(
              children: [
                // Emergency messages
                _buildEmergencyMessages(),
                
                // Non-emergency messages
                _buildNonEmergencyMessages(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Emergency messages list
  Widget _buildEmergencyMessages() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16),
      children: [
        _buildSectionHeader("Urgent Messages"),
        _buildEmergencyMessageItem(
          sender: "Security Alert",
          title: "Unauthorized Access",
          preview: "Unusual login attempt detected from IP 192.168.1.45...",
          timeAgo: "30 min ago",
          isUrgent: true,
        ),
        _buildEmergencyMessageItem(
          sender: "System Monitor",
          title: "Student in Distress",
          preview: "AI has detected concerning language in Student ID #2354's messaging...",
          timeAgo: "1 hr ago",
          isUrgent: true,
        ),
        _buildEmergencyMessageItem(
          sender: "Health Services",
          title: "Medical Situation",
          preview: "Student Emma Johnson (Class 4A) reported to the nurse with high fever...",
          timeAgo: "2 hrs ago",
          isUrgent: true,
        ),
      ],
    );
  }

  // Non-emergency messages list
  Widget _buildNonEmergencyMessages() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16),
      children: [
        _buildSectionHeader("Important Notifications"),
        _buildMessageItem(
          title: "Weekly Report Ready",
          sender: "Student Analysis",
          preview: "Your classroom behavior analysis report for this week is now available...",
          timeAgo: "1 hr ago",
          isUnread: true,
          avatar: "SA",
          color: steelBlue,
        ),
        _buildMessageItem(
          title: "Absent Students",
          sender: "Attendance System",
          preview: "Three students have been absent for more than 3 consecutive days...",
          timeAgo: "3 hrs ago",
          isUnread: true,
          avatar: "AS",
          color: aqua,
        ),
        _buildMessageItem(
          title: "Grade Patterns",
          sender: "Performance Alert",
          preview: "Several students are showing declining performance in mathematics...",
          timeAgo: "5 hrs ago",
          isUnread: false,
          avatar: "PA",
          color: peach,
        ),
      ],
    );
  }

  // Normal tab content
  Widget _buildNormalTab() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16),
      children: [
        _buildSectionHeader("Recent Messages"),
        _buildMessageItem(
          title: "Welcome to EduAlly",
          sender: "System Admin",
          preview: "Thank you for joining our platform. Here are some tips...",
          timeAgo: "2 hrs ago",
          isUnread: true,
          avatar: "A",
          color: steelBlue,
        ),
        _buildMessageItem(
          title: "Weekly Progress Report",
          sender: "Class 3B",
          preview: "The average test score has increased by 15% compared...",
          timeAgo: "3 hrs ago",
          isUnread: true,
          avatar: "3B",
          color: aqua,
        ),
        _buildMessageItem(
          title: "Staff Meeting",
          sender: "Principal",
          preview: "Reminder: There will be a staff meeting tomorrow at 9 AM...",
          timeAgo: "5 hrs ago",
          isUnread: false,
          avatar: "P",
          color: peach,
        ),
        _buildSectionHeader("Earlier Today"),
        _buildMessageItem(
          title: "Student Behavior",
          sender: "John Smith",
          preview: "I'd like to discuss some concerns about Alex's behavior in class...",
          timeAgo: "7 hrs ago",
          isUnread: false,
          avatar: "JS",
          color: cream,
        ),
        _buildMessageItem(
          title: "System Update",
          sender: "IT Support",
          preview: "We'll be updating the system this weekend. Please save your work...",
          timeAgo: "9 hrs ago",
          isUnread: false,
          avatar: "IT",
          color: steelBlue,
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0, top: 16, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  // Fixed normal message item
  Widget _buildMessageItem({
    required String title,
    required String sender,
    required String preview,
    required String timeAgo,
    required bool isUnread,
    required String avatar,
    required Color color,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            _showMessagePreview(context, title, sender, preview);
          },
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar or icon
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          avatar,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                timeAgo,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text(
                            "From: $sender",
                            style: TextStyle(
                              color: steelBlue,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            preview,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 16,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (isUnread) ...[
                  SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "Unread",
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Emergency message item design
  Widget _buildEmergencyMessageItem({
    required String sender,
    required String title,
    required String preview,
    required String timeAgo,
    required bool isUrgent,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isUrgent ? Colors.red.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUrgent ? Colors.red : Colors.transparent,
          width: 1,
        ),
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
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            _showMessagePreview(context, title, sender, preview);
          },
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Alert icon
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                SizedBox(width: 12),
                // Message details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.red[800] ?? Colors.red,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            timeAgo,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        "From: $sender",
                        style: TextStyle(
                          color: Colors.red[800] ?? Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        preview,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 16,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "Action Required",
                              style: TextStyle(
                                color: Colors.red[800] ?? Colors.red,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.access_time,
                            color: Colors.red[800] ?? Colors.red,
                            size: 14,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "Respond ASAP",
                            style: TextStyle(
                              color: Colors.red[800] ?? Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Message preview dialog
  void _showMessagePreview(BuildContext context, String title, String sender, String content) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    "From: $sender",
                    style: TextStyle(
                      color: steelBlue,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "Received: Today at 9:45 AM",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            // Message content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      content,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 24),
                    // Full message content
                    Text(
                      "Dear Teacher,\n\n$content\n\nIf there is an issue, please contact the administrative office for further assistance. (officeadmin@edu.com) \n\nBest regards,\n$sender",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Action buttons
            Container(
              padding: EdgeInsets.all(16),
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
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: steelBlue,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        'Reply',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.delete_outline),
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.forward),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}