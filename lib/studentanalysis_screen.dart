import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'dart:async';
import 'home_screen.dart';


class SimplifiedStudentAnalysisPage extends StatefulWidget {
  @override
  _SimplifiedStudentAnalysisPageState createState() => _SimplifiedStudentAnalysisPageState();
}

class _SimplifiedStudentAnalysisPageState extends State<SimplifiedStudentAnalysisPage> {
  // Color palette from your design
  final Color steelBlue = Color(0xFF5193B3);
  final Color aqua = Color(0xFF62C4C3);
  final Color peach = Color(0xFFF8D49B);
  final Color cream = Color(0xFFF8E6CB);
  
  // Analysis sources
  final List<String> _analysisSources = ['Live Camera', 'Uploaded Video', 'Recorded Lecture'];
  String _selectedSource = 'Live Camera';
  
  // Analysis state
  bool _isAnalyzing = false;
  double _analysisProgress = 0;
  
  // Selected student for detailed view
  String _selectedStudent = "";
  
  // Sample data - student list
  List<Map<String, dynamic>> _studentList = [
    {
      'name': 'Peter Wong',
      'id': 'S10123',
      'avatar': 'PW',
      'status': 'Engaged',
      'statusColor': Colors.green,
      'attendanceRate': 95,
      'participationRate': 82,
      'emotion': 'Engaged',
      'activity': 'Taking notes',
      'attentionSpan': 87,
      'needsHelp': false,
    },
    {
      'name': 'Sarah Johnson',
      'id': 'S10124',
      'avatar': 'SJ',
      'status': 'Distracted',
      'statusColor': Colors.orange,
      'attendanceRate': 88,
      'participationRate': 45,
      'emotion': 'Distracted',
      'activity': 'Looking elsewhere',
      'attentionSpan': 62,
      'needsHelp': true,
    },
    {
      'name': 'Alex Chen',
      'id': 'S10125',
      'avatar': 'AC',
      'status': 'Confused',
      'statusColor': Colors.purple,
      'attendanceRate': 92,
      'participationRate': 79,
      'emotion': 'Confused',
      'activity': 'Watching',
      'attentionSpan': 75,
      'needsHelp': true,
    },
    {
      'name': 'Maria Garcia',
      'id': 'S10126',
      'avatar': 'MG',
      'status': 'Engaged',
      'statusColor': Colors.green,
      'attendanceRate': 97,
      'participationRate': 90,
      'emotion': 'Engaged',
      'activity': 'Raising hand',
      'attentionSpan': 94,
      'needsHelp': false,
    },
    {
      'name': 'Jamal Wilson',
      'id': 'S10127',
      'avatar': 'JW',
      'status': 'Neutral',
      'statusColor': Colors.grey,
      'attendanceRate': 85,
      'participationRate': 68,
      'emotion': 'Neutral',
      'activity': 'Watching',
      'attentionSpan': 80,
      'needsHelp': false,
    },
  ];
  
  // Sample data
  List<Map<String, dynamic>> _emotionData = [
    {'emotion': 'Engaged', 'percentage': 45, 'color': Colors.green},
    {'emotion': 'Neutral', 'percentage': 25, 'color': Colors.grey},
    {'emotion': 'Confused', 'percentage': 15, 'color': Colors.purple},
    {'emotion': 'Bored', 'percentage': 10, 'color': Colors.blue[200]},
    {'emotion': 'Distracted', 'percentage': 5, 'color': Colors.orange},
  ];
  
  List<Map<String, dynamic>> _actionData = [
    {'action': 'Taking notes', 'percentage': 40, 'color': Colors.teal},
    {'action': 'Watching', 'percentage': 30, 'color': Colors.indigo},
    {'action': 'Raising hand', 'percentage': 15, 'color': Colors.amber},
    {'action': 'Speaking', 'percentage': 10, 'color': Colors.red},
    {'action': 'Off-task', 'percentage': 5, 'color': Colors.grey},
  ];
  
  List<Map<String, dynamic>> _redFlagStudents = [
    {
      'name': 'Sarah Johnson',
      'issue': 'Distracted for the past 10 minutes',
      'avatar': 'SJ',
      'priority': 'high',
    },
    {
      'name': 'Alex Chen',
      'issue': 'Confused during key concept explanations',
      'avatar': 'AC',
      'priority': 'medium',
    },
    {
      'name': 'Emma Wilson',
      'id': 'S10128',
      'issue': 'Absent for 3 consecutive days',
      'avatar': 'EW',
      'priority': 'high',
    },
  ];

  Timer? _analysisTimer;

  @override
  void dispose() {
    _analysisTimer?.cancel();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Student Analysis',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline, color: Colors.black),
            onPressed: () => _showHelpDialog(),
          ),
        ],
      ),
      body: _isAnalyzing 
          ? _buildAnalyzingView() 
          : (_selectedStudent.isNotEmpty 
              ? _buildStudentDetailView() 
              : _buildAnalysisView()),
      bottomNavigationBar: _buildBottomBar(),
    );
  }
  
  Widget _buildSourceSelector() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Analysis Source',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedSource,
                isExpanded: true,
                icon: Icon(Icons.arrow_drop_down),
                style: TextStyle(color: Colors.black, fontSize: 16),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedSource = newValue;
                    });
                  }
                },
                items: _analysisSources.map<DropdownMenuItem<String>>((String value) {
                  IconData icon;
                  if (value == 'Live Camera') {
                    icon = Icons.videocam;
                  } else if (value == 'Uploaded Video') {
                    icon = Icons.upload_file;
                  } else {
                    icon = Icons.video_library;
                  }
                  
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Row(
                      children: [
                        Icon(icon, size: 20, color: steelBlue),
                        SizedBox(width: 12),
                        Text(value),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          SizedBox(height: 16),
          _selectedSource != 'Live Camera'
              ? ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: steelBlue,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    _selectVideoForAnalysis();
                  },
                  icon: Icon(Icons.add),
                  label: Text(
                    _selectedSource == 'Uploaded Video' 
                        ? 'Upload Video for Analysis' 
                        : 'Select Recorded Lecture',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              : Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: steelBlue,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _isAnalyzing = true;
                            _startAnalysis();
                          });
                        },
                        icon: Icon(Icons.play_arrow),
                        label: Text(
                          'Start Live Analysis',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: steelBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.settings, color: steelBlue),
                        onPressed: () {
                          _showCameraSettings();
                        },
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
  
  Widget _buildCameraPreview() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 200,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // This would be a camera preview in a real app
            Image.network(
              'https://via.placeholder.com/800x400/333333/666666?text=Camera+Preview',
              fit: BoxFit.cover,
            ),
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'LIVE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 12,
              bottom: 12,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${_studentList.length} students detected',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStudentToggleSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Select Student',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                'Total: ${_studentList.length} students',
                style: TextStyle(
                  color: steelBlue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.8,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: _studentList.length,
            itemBuilder: (context, index) {
              final student = _studentList[index];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedStudent = student['name'] as String;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: (student['statusColor'] as Color).withOpacity(0.3),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 3,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: steelBlue.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                student['avatar'] as String,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: steelBlue,
                                ),
                              ),
                            ),
                          ),
                          if (student['needsHelp'] as bool)
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.priority_high,
                                    color: Colors.white,
                                    size: 10,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 6),
                      Text(
                        (student['name'] as String).split(' ')[0],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 2),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: (student['statusColor'] as Color).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          student['status'] as String,
                          style: TextStyle(
                            fontSize: 10,
                            color: student['statusColor'] as Color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildEmotionSummary() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Student Emotions',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: steelBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.people, size: 14, color: steelBlue),
                    SizedBox(width: 4),
                    Text(
                      'Student Count',
                      style: TextStyle(
                        fontSize: 12,
                        color: steelBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          // Student emotion breakdown
          _buildStudentEmotionBreakdown(),
        ],
      ),
    );
  }
  
  Widget _buildActionSummary() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Student Actions',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: aqua.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.people, size: 14, color: aqua),
                    SizedBox(width: 4),
                    Text(
                      'Student Count',
                      style: TextStyle(
                        fontSize: 12,
                        color: aqua,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          // Student action breakdown
          _buildStudentActionBreakdown(),
        ],
      ),
    );
  }
  
  Widget _buildPercentageBar(String label, dynamic value, Color color, {bool isCount = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label),
              Text(
                isCount ? '$value students' : '$value%',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          LinearPercentIndicator(
            lineHeight: 10,
            percent: isCount ? (value / _studentList.length) : (value / 100),
            progressColor: color,
            backgroundColor: Colors.grey.shade200,
            padding: EdgeInsets.zero,
            animation: true,
            animationDuration: 1000,
            barRadius: Radius.circular(8),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStudentEmotionBreakdown() {
    // Count students by emotion
    Map<String, int> emotionCounts = {};
    Map<String, Color> emotionColors = {
      'Engaged': Colors.green,
      'Neutral': Colors.grey,
      'Confused': Colors.purple,
      'Distracted': Colors.orange,
      'Bored': Colors.blue[200]!,
    };
    
    for (var student in _studentList) {
      String emotion = student['emotion'] as String;
      emotionCounts[emotion] = (emotionCounts[emotion] ?? 0) + 1;
    }
    
    return Column(
      children: emotionCounts.entries.map((entry) {
        return _buildPercentageBar(
          entry.key, 
          entry.value,
          emotionColors[entry.key] ?? Colors.grey,
          isCount: true,
        );
      }).toList(),
    );
  }
  
  Widget _buildStudentActionBreakdown() {
    // Count students by activity
    Map<String, int> activityCounts = {};
    Map<String, Color> activityColors = {
      'Taking notes': Colors.teal,
      'Watching': Colors.indigo,
      'Raising hand': Colors.amber,
      'Speaking': Colors.red,
      'Looking elsewhere': Colors.orange,
      'Off-task': Colors.grey,
    };
    
    for (var student in _studentList) {
      String activity = student['activity'] as String;
      activityCounts[activity] = (activityCounts[activity] ?? 0) + 1;
    }
    
    return Column(
      children: activityCounts.entries.map((entry) {
        return _buildPercentageBar(
          entry.key, 
          entry.value,
          activityColors[entry.key] ?? Colors.grey,
          isCount: true,
        );
      }).toList(),
    );
  }
  
  Widget _buildRedFlagSection() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.red),
                  SizedBox(width: 8),
                  Text(
                    'Attention Needed',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Text(
                '${_redFlagStudents.length} students',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _redFlagStudents.isEmpty
              ? Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'No issues detected at this time',
                          style: TextStyle(color: Colors.green[800]),
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: _redFlagStudents
                      .map((student) => _buildStudentIssueCard(student))
                      .toList(),
                ),
        ],
      ),
    );
  }
  
  Widget _buildStudentIssueCard(Map<String, dynamic> student) {
    Color priorityColor;
    if (student['priority'] == 'high') {
      priorityColor = Colors.red;
    } else if (student['priority'] == 'medium') {
      priorityColor = Colors.orange;
    } else {
      priorityColor = Colors.amber;
    }
    
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: priorityColor.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
        color: priorityColor.withOpacity(0.05),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: priorityColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                student['avatar'] as String,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: priorityColor,
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student['name'] as String,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  student['issue'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              _showStudentActionMenu(student);
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildAnalysisView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSourceSelector(),
          _selectedSource == 'Live Camera' ? _buildCameraPreview() : SizedBox(),
          _buildStudentToggleSection(),
          _buildEmotionSummary(),
          _buildActionSummary(),
          _buildRedFlagSection(),
          SizedBox(height: 20),
        ],
      ),
    );
  }
  
  Widget _buildStudentDetailView() {
    // Find the selected student
    final student = _studentList.firstWhere(
      (s) => s['name'] == _selectedStudent,
      orElse: () => _studentList[0],
    );
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: steelBlue,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          _selectedStudent = "";
                        });
                      },
                    ),
                    Text(
                      'Student Detail',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          student['avatar'] as String,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: steelBlue,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            student['name'] as String,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'ID: ${student['id']}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: student['statusColor'] as Color,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              student['status'] as String,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Current status
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Status',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatusItem(
                      icon: Icons.sentiment_satisfied_alt,
                      label: 'Emotion',
                      value: student['emotion'] as String,
                      color: student['statusColor'] as Color,
                    ),
                    _buildStatusItem(
                      icon: Icons.accessibility_new,
                      label: 'Activity',
                      value: student['activity'] as String,
                      color: aqua,
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Performance metrics
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Performance Metrics',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          CircularPercentIndicator(
                            radius: 60,
                            lineWidth: 10,
                            percent: (student['attendanceRate'] as int) / 100,
                            center: Text(
                              '${student['attendanceRate']}%',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            progressColor: steelBlue,
                            backgroundColor: Colors.grey.shade200,
                            circularStrokeCap: CircularStrokeCap.round,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Attendance',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          CircularPercentIndicator(
                            radius: 60,
                            lineWidth: 10,
                            percent: (student['participationRate'] as int) / 100,
                            center: Text(
                              '${student['participationRate']}%',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            progressColor: aqua,
                            backgroundColor: Colors.grey.shade200,
                            circularStrokeCap: CircularStrokeCap.round,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Participation',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          CircularPercentIndicator(
                            radius: 60,
                            lineWidth: 10,
                            percent: (student['attentionSpan'] as int) / 100,
                            center: Text(
                              '${student['attentionSpan']}%',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            progressColor: peach,
                            backgroundColor: Colors.grey.shade200,
                            circularStrokeCap: CircularStrokeCap.round,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Attention Span',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Suggestions
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Suggestions',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 16),
                _buildSuggestionItem(
                  icon: Icons.lightbulb_outline,
                  title: 'Engagement Tips',
                  description: (student['needsHelp'] as bool)
                      ? 'Try interactive activities to increase engagement'
                      : 'Continue current approach - good engagement level',
                  actionText: 'View Tips',
                ),
                Divider(height: 24),
                _buildSuggestionItem(
                  icon: Icons.groups_outlined,
                  title: 'Group Placement',
                  description: 'Recommended group assignments for projects',
                  actionText: 'View Groups',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionItem({
    required IconData icon,
    required String title,
    required String description,
    required String actionText,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: steelBlue.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: steelBlue),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            actionText,
            style: TextStyle(
              color: steelBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildStatusItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
  
  Widget _buildAnalyzingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(steelBlue),
            value: _analysisProgress > 0 ? _analysisProgress : null,
          ),
          SizedBox(height: 20),
          Text(
            'Analyzing classroom...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Detecting student behavior patterns',
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
          if (_analysisProgress > 0)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '${(_analysisProgress * 100).toInt()}% complete',
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
  
  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
          IconButton(
            icon: Icon(Icons.dashboard, color: Colors.grey[600]),
            onPressed: () {
              // Navigate back to dashboard
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                HomePage.homeKey.currentState?.onItemTapped(0);
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.save, color: Colors.grey[600]),
            onPressed: () {
              // Save analysis
              _showSaveAnalysisDialog();
            },
          ),
          IconButton(
            icon: Icon(Icons.share, color: Colors.grey[600]),
            onPressed: () {
              // Share analysis
              _showShareDialog();
            },
          ),
          IconButton(
            icon: Icon(Icons.settings, color: Colors.grey[600]),
            onPressed: () {
              // Open settings
              _showAnalysisSettings();
            },
          ),
        ],
      ),
    );
  }

  // Helper methods
  
  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Student Analysis Help'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHelpSection(
                'Live Analysis', 
                'Use your camera to analyze student behavior in real-time.'
              ),
              SizedBox(height: 16),
              _buildHelpSection(
                'Video Analysis', 
                'Upload a recorded video for post-session analysis.'
              ),
              SizedBox(height: 16),
              _buildHelpSection(
                'Student Details', 
                'Tap on any student avatar to view detailed analytics.'
              ),
              SizedBox(height: 16),
              _buildHelpSection(
                'Red Flags', 
                'Students requiring attention are highlighted automatically.'
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('CLOSE'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildHelpSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 4),
        Text(
          content,
          style: TextStyle(
            fontSize: 14,
          ),
        ),
      ],
    );
  }
  
  void _selectVideoForAnalysis() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Video'),
        content: Text('This would open a file picker to select a video for analysis.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('CANCEL'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: steelBlue,
            ),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _isAnalyzing = true;
                _startAnalysis();
              });
            },
            child: Text('SELECT'),
          ),
        ],
      ),
    );
  }
  
  void _startAnalysis() {
    // Simulate analysis process
    _analysisProgress = 0;
    _analysisTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        _analysisProgress += 0.01;
        if (_analysisProgress >= 1.0) {
          _analysisTimer?.cancel();
          _isAnalyzing = false;
        }
      });
    });
  }
  
  void _showCameraSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Camera Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Camera Source'),
              subtitle: Text('Main Camera'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Divider(),
            ListTile(
              title: Text('Resolution'),
              subtitle: Text('720p'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Divider(),
            ListTile(
              title: Text('Face Detection Sensitivity'),
              subtitle: Text('Medium'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('CLOSE'),
          ),
        ],
      ),
    );
  }
  
  void _showStudentActionMenu(Map<String, dynamic> student) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Actions for ${student['name']}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.message, color: steelBlue),
              title: Text('Message Student'),
              onTap: () {
                Navigator.pop(context);
                // Message the student
              },
            ),
            ListTile(
              leading: Icon(Icons.analytics_outlined, color: steelBlue),
              title: Text('View Detailed Analytics'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedStudent = student['name'] as String;
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.add_alert, color: steelBlue),
              title: Text('Set Alert'),
              onTap: () {
                Navigator.pop(context);
                // Set an alert
              },
            ),
            ListTile(
              leading: Icon(Icons.report_problem_outlined, color: Colors.red),
              title: Text('Mark as Resolved'),
              onTap: () {
                Navigator.pop(context);
                // Mark the issue as resolved
                setState(() {
                  _redFlagStudents.removeWhere(
                    (s) => s['name'] == student['name'] && s['avatar'] == student['avatar']
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSaveAnalysisDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Save Analysis'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Analysis Name',
                border: OutlineInputBorder(),
                hintText: 'Class Session - ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.folder_outlined, color: Colors.grey),
                SizedBox(width: 8),
                Text('Save to: Class Analysis > Term 2'),
                Spacer(),
                Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('CANCEL'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: steelBlue,
            ),
            onPressed: () {
              Navigator.pop(context);
              // Show a snackbar to confirm saving
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Analysis saved successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Text('SAVE'),
          ),
        ],
      ),
    );
  }

  void _showShareDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Share Analysis'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.email_outlined, color: steelBlue),
              title: Text('Email Report'),
              onTap: () {
                Navigator.pop(context);
                // Email functionality
              },
            ),
            ListTile(
              leading: Icon(Icons.description_outlined, color: steelBlue),
              title: Text('Export as PDF'),
              onTap: () {
                Navigator.pop(context);
                // PDF export functionality
              },
            ),
            ListTile(
              leading: Icon(Icons.cloud_upload_outlined, color: steelBlue),
              title: Text('Upload to Cloud'),
              onTap: () {
                Navigator.pop(context);
                // Cloud upload functionality
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('CANCEL'),
          ),
        ],
      ),
    );
  }

  void _showAnalysisSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Analysis Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Analysis Frequency'),
              subtitle: Text('Every 5 seconds'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Divider(),
            ListTile(
              title: Text('Tracked Behaviors'),
              subtitle: Text('Emotions, Activities, Attention'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Divider(),
            ListTile(
              title: Text('Alert Thresholds'),
              subtitle: Text('Customize warning conditions'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('CLOSE'),
          ),
        ],
      ),
    );
  }
}