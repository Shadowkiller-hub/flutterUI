import 'package:flutter/material.dart';
import '../widgets/bottom_navigation.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  String _selectedRoute = '500A';
  DateTime _selectedDate = DateTime.now();

  final List<Map<String, dynamic>> _scheduleData = [
    {
      'routeNumber': '500A',
      'routeName': 'Koramangala - Ejipura - Domulur',
      'stops': [
        {'stopName': 'Koramangala Bus Stand', 'time': '06:00', 'isMajor': true},
        {'stopName': 'Ejipura Signal', 'time': '06:15', 'isMajor': false},
        {'stopName': 'Sony World Junction', 'time': '06:25', 'isMajor': true},
        {'stopName': 'Domulur', 'time': '06:40', 'isMajor': true},
      ],
      'frequency': '15 mins',
      'firstBus': '06:00',
      'lastBus': '22:30',
    },
    {
      'routeNumber': '401K',
      'routeName': 'Koramangala - St Bed - Viveknagar',
      'stops': [
        {'stopName': 'Koramangala Bus Stand', 'time': '06:30', 'isMajor': true},
        {'stopName': 'St. Bed Layout', 'time': '06:45', 'isMajor': true},
        {'stopName': 'Richmond Circle', 'time': '07:00', 'isMajor': false},
        {'stopName': 'Viveknagar', 'time': '07:15', 'isMajor': true},
      ],
      'frequency': '20 mins',
      'firstBus': '06:30',
      'lastBus': '22:00',
    },
    {
      'routeNumber': '500D',
      'routeName': 'St Bed - Koramangala - Domulur',
      'stops': [
        {'stopName': 'St. Bed Layout', 'time': '07:00', 'isMajor': true},
        {'stopName': 'Koramangala Bus Stand', 'time': '07:15', 'isMajor': true},
        {'stopName': 'Ejipura Signal', 'time': '07:25', 'isMajor': false},
        {'stopName': 'Domulur', 'time': '07:40', 'isMajor': true},
      ],
      'frequency': '15 mins',
      'firstBus': '07:00',
      'lastBus': '23:00',
    },
  ];

  Map<String, dynamic> get _currentSchedule {
    return _scheduleData.firstWhere(
      (schedule) => schedule['routeNumber'] == _selectedRoute,
      orElse: () => _scheduleData[0],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bus Schedule',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.amber,
      ),
      body: Column(
        children: [
          // Route selection
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.amber.withOpacity(0.2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Route',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    value: _selectedRoute,
                    items:
                        _scheduleData.map<DropdownMenuItem<String>>((schedule) {
                          return DropdownMenuItem<String>(
                            value: schedule['routeNumber'] as String,
                            child: Text(
                              '${schedule['routeNumber']} - ${schedule['routeName']}',
                            ),
                          );
                        }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedRoute = value;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16),
                // Date selection
                Row(
                  children: [
                    const Text(
                      'Date:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 16),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.calendar_today),
                      label: Text(
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                      ),
                      onPressed: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 30),
                          ),
                        );
                        if (pickedDate != null && pickedDate != _selectedDate) {
                          setState(() {
                            _selectedDate = pickedDate;
                          });
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.amber),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Route info and timings
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Route summary
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  _currentSchedule['routeNumber'] as String,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _currentSchedule['routeName'] as String,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildInfoRow(
                            'Frequency:',
                            _currentSchedule['frequency'] as String,
                          ),
                          _buildInfoRow(
                            'First Bus:',
                            _currentSchedule['firstBus'] as String,
                          ),
                          _buildInfoRow(
                            'Last Bus:',
                            _currentSchedule['lastBus'] as String,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Stops timeline
                    const Text(
                      'Schedule',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._buildStopsTimeline(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavigation(currentIndex: 1),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          const SizedBox(width: 8),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  List<Widget> _buildStopsTimeline() {
    final stops = _currentSchedule['stops'] as List<dynamic>;

    return List.generate(stops.length, (index) {
      final Map<String, dynamic> stop = stops[index] as Map<String, dynamic>;
      final bool isFirst = index == 0;
      final bool isLast = index == stops.length - 1;

      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color:
                      stop['isMajor'] == true ? Colors.amber : Colors.grey[300],
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
              ),
              if (!isLast)
                Container(width: 2, height: 50, color: Colors.grey[300]),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stop['stopName'] as String,
                  style: TextStyle(
                    fontWeight:
                        stop['isMajor'] == true
                            ? FontWeight.bold
                            : FontWeight.normal,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${stop['time']} ${isFirst
                      ? '(Departure)'
                      : isLast
                      ? '(Arrival)'
                      : ''}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                if (!isLast) const SizedBox(height: 36),
              ],
            ),
          ),
        ],
      );
    });
  }
}
