import 'package:flutter/material.dart';

class UltraSimpleCCTVScreen extends StatefulWidget {
  @override
  _UltraSimpleCCTVScreenState createState() => _UltraSimpleCCTVScreenState();
}

class _UltraSimpleCCTVScreenState extends State<UltraSimpleCCTVScreen> {
  // Color palette
  final Color steelBlue = Color(0xFF5193B3);
  final Color aqua = Color(0xFF62C4C3);
  final Color peach = Color(0xFFF8D49B);
  final Color cream = Color(0xFFF8E6CB);
  
  // Selected camera
  int _selectedCamera = -1;
  
  // Sample CCTV data - ultra simplified
  final List<Map<String, dynamic>> _cameras = [
    {
      'id': 'CCTV 1',
      'name': 'Classroom 101',
      'students': 24,
      'active': true,
    },
    {
      'id': 'CCTV 2',
      'name': 'Classroom 102',
      'students': 18,
      'active': true,
    },
    {
      'id': 'CCTV 3',
      'name': 'Science Lab',
      'students': 12,
      'active': true,
    },
    {
      'id': 'CCTV 4',
      'name': 'Computer Lab',
      'students': 15,
      'active': true,
    },
    {
      'id': 'CCTV 5',
      'name': 'Library',
      'students': 0,
      'active': false,
    },
    {
      'id': 'CCTV 6',
      'name': 'Auditorium',
      'students': 32,
      'active': true,
    },
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: steelBlue,
        title: Text('CCTV Status'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Refreshing status...'))
              );
            },
          ),
        ],
      ),
      body: _selectedCamera == -1 ? _buildSimpleList() : _buildCameraDetails(),
    );
  }
  
  Widget _buildSimpleList() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: _cameras.length,
      itemBuilder: (context, index) {
        final camera = _cameras[index];
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedCamera = index;
            });
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 3,
                  offset: Offset(0, 1),
                ),
              ],
              border: Border.all(
                color: camera['active'] ? steelBlue.withOpacity(0.3) : Colors.red.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // Status indicator
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: camera['active'] ? Colors.green : Colors.red,
                  ),
                ),
                SizedBox(width: 16),
                // Camera info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${camera['id']} - ${camera['name']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        camera['active'] 
                            ? '${camera['students']} students detected' 
                            : 'Offline',
                        style: TextStyle(
                          color: camera['active'] ? Colors.black87 : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                // Arrow
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildCameraDetails() {
    final camera = _cameras[_selectedCamera];
    
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedCamera = -1;
              });
            },
            child: Row(
              children: [
                Icon(Icons.arrow_back, size: 20),
                SizedBox(width: 8),
                Text(
                  'Back to list',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 24),
          
          // Camera detail card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: camera['active'] ? steelBlue.withOpacity(0.5) : Colors.red.withOpacity(0.5),
                width: 2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: camera['active'] ? steelBlue.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        camera['active'] ? Icons.videocam : Icons.videocam_off,
                        color: camera['active'] ? steelBlue : Colors.red,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${camera['id']}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${camera['name']}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: camera['active'] ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: camera['active'] ? Colors.green : Colors.red,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        camera['active'] ? 'Active' : 'Offline',
                        style: TextStyle(
                          color: camera['active'] ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 32),
                
                // Stats
                if (camera['active']) ...[
                  Text(
                    'Current Status',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  
                  SizedBox(height: 16),
                  
                  _buildDetailItem(
                    icon: Icons.people,
                    title: 'Students Detected',
                    value: '${camera['students']}',
                  ),
                  
                  Divider(height: 32),
                  
                  _buildDetailItem(
                    icon: Icons.access_time,
                    title: 'Last Updated',
                    value: '2 minutes ago',
                  ),
                ] else ...[
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.red.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.red,
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Camera Offline',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'This camera is not transmitting data. Please check the connection.',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          SizedBox(height: 24),
          
          // Action buttons
          if (camera['active']) ...[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: steelBlue,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Processing video...'))
                );
              },
              child: Text(
                'Process Video',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ] else ...[
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Attempting to reconnect...'))
                );
              },
              child: Text(
                'Attempt Reconnect',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: steelBlue.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: steelBlue,
            size: 20,
          ),
        ),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ],
    );
  }
}