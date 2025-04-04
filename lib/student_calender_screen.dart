import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  late Map<DateTime, List<String>> _events;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    _events = {
      DateTime.utc(2025, 4, 1): ['Statistics Class - 2:00 PM, Room 101'],
      DateTime.utc(2025, 4, 2): ['Basketball Practice - 4:00 PM, Sports Hall'],
      DateTime.utc(2025, 4, 5): ['Mathematics Exam - 10:00 AM, Hall B'],
      DateTime.utc(2025, 4, 6): ['Talk: AI in Healthcare - 6:00 PM, Lecture Hall'],
      DateTime.utc(2025, 4, 8): ['Group Project Meeting - 3:00 PM, Library'],
      DateTime.utc(2025, 4, 10): ['Music Club Workshop - 5:00 PM, Room 302'],
      DateTime.utc(2025, 4, 12): ['Coding Bootcamp - 3:00 PM, Lab 1'],
      DateTime.utc(2025, 4, 14): ['Chemistry Lab Test - 2:00 PM, Lab 4'],
      DateTime.utc(2025, 4, 16): ['Dance Rehearsal - 4:00 PM, Dance Studio'],
      DateTime.utc(2025, 4, 18): ['Student Council Meeting - 1:00 PM, Room 201'],
      DateTime.utc(2025, 4, 19): ['Renewable Energy Talk - 6:30 PM, Hall A'],
      DateTime.utc(2025, 4, 21): ['History Exam Review - 1:00 PM, Room 109'],
      DateTime.utc(2025, 4, 22): ['Robotics Workshop - 2:00 PM, Lab 2'],
      DateTime.utc(2025, 4, 23): ['Blockchain Seminar - 7:00 PM, Auditorium'],
      DateTime.utc(2025, 4, 27): ['Networking Session - 4:00 PM, Conference Hall'],
      DateTime.utc(2025, 4, 29): ['Coding Challenge - 3:00 PM, Lab 3'],
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Class Schedule & Events'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Calendar Box
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TableCalendar(
                  firstDay: DateTime.utc(2025, 1, 1),
                  lastDay: DateTime.utc(2025, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  eventLoader: (day) {
                    return _events[day] ?? [];
                  },
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.blueAccent,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.deepPurpleAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
            Text(
              'Events on ${DateFormat('dd MMM yyyy').format(_selectedDay)}:',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildEventList(),
          ],
        ),
      ),
    );
  }

  Widget _buildEventList() {
    final eventsForSelectedDay = _events[_selectedDay] ?? [];

    if (eventsForSelectedDay.isEmpty) {
      return const Center(
        child: Text('No events for this day.', style: TextStyle(fontSize: 16)),
      );
    }

    return Column(
      children: eventsForSelectedDay.map((event) {
        return _buildEventCard(event);
      }).toList(),
    );
  }

  Widget _buildEventCard(String event) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.blueAccent.shade100,
      child: ListTile(
        leading: const Icon(Icons.event, color: Colors.white),
        title: Text(
          event,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
      ),
    );
  }
}
