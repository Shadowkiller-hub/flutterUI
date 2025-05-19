import 'package:flutter/material.dart';
import 'dart:async';

class RouteDetailsScreen extends StatefulWidget {
  final String routeId;
  final String routeName;

  const RouteDetailsScreen({
    super.key,
    required this.routeId,
    required this.routeName,
  });

  @override
  State<RouteDetailsScreen> createState() => _RouteDetailsScreenState();
}

class _RouteDetailsScreenState extends State<RouteDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isFavorite = false;
  bool _isLiveTracking = false;
  Timer? _liveUpdateTimer;
  int _currentBusPosition = 0;

  final List<BusStop> _stops = [
    BusStop(
      name: 'Majestic Bus Station',
      time: '06:00 AM',
      distance: '0.0 km',
      isTerminal: true,
    ),
    BusStop(
      name: 'K.R. Market',
      time: '06:15 AM',
      distance: '2.5 km',
      isTerminal: false,
    ),
    BusStop(
      name: 'Town Hall',
      time: '06:25 AM',
      distance: '4.2 km',
      isTerminal: false,
    ),
    BusStop(
      name: 'Richmond Circle',
      time: '06:35 AM',
      distance: '6.8 km',
      isTerminal: false,
    ),
    BusStop(
      name: 'Hosur Road',
      time: '06:45 AM',
      distance: '8.5 km',
      isTerminal: false,
    ),
    BusStop(
      name: 'Forum Mall',
      time: '06:55 AM',
      distance: '10.2 km',
      isTerminal: false,
    ),
    BusStop(
      name: 'HSR Layout',
      time: '07:10 AM',
      distance: '12.7 km',
      isTerminal: true,
    ),
  ];

  final List<BusSchedule> _schedules = [
    BusSchedule(
      startTime: '06:00 AM',
      endTime: '07:10 AM',
      frequency: 'Every 15 min',
      type: 'Regular',
    ),
    BusSchedule(
      startTime: '07:00 AM',
      endTime: '10:00 AM',
      frequency: 'Every 10 min',
      type: 'Peak Hours',
    ),
    BusSchedule(
      startTime: '10:00 AM',
      endTime: '04:00 PM',
      frequency: 'Every 15 min',
      type: 'Regular',
    ),
    BusSchedule(
      startTime: '04:00 PM',
      endTime: '08:00 PM',
      frequency: 'Every 10 min',
      type: 'Peak Hours',
    ),
    BusSchedule(
      startTime: '08:00 PM',
      endTime: '10:00 PM',
      frequency: 'Every 20 min',
      type: 'Night',
    ),
  ];

  final List<BusFare> _fares = [
    BusFare(type: 'Regular', fare: '₹25', description: 'Standard fare'),
    BusFare(type: 'Student', fare: '₹15', description: 'With valid student ID'),
    BusFare(type: 'Senior Citizen', fare: '₹15', description: 'Age 60+'),
    BusFare(
      type: 'Monthly Pass',
      fare: '₹1100',
      description: 'Unlimited rides for 30 days',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _stopLiveTracking();
    _tabController.dispose();
    super.dispose();
  }

  void _toggleLiveTracking() {
    setState(() {
      _isLiveTracking = !_isLiveTracking;
    });

    if (_isLiveTracking) {
      _startLiveTracking();
    } else {
      _stopLiveTracking();
    }
  }

  void _startLiveTracking() {
    // Update bus position every 3 seconds
    _liveUpdateTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          // Move to next stop (simulating bus movement)
          if (_currentBusPosition < _stops.length - 1) {
            _currentBusPosition++;
          } else {
            _currentBusPosition = 0; // Loop back to start
          }
        });

        // Show notification when bus reaches a new stop
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bus arrived at ${_stops[_currentBusPosition].name}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });
  }

  void _stopLiveTracking() {
    _liveUpdateTimer?.cancel();
    _liveUpdateTimer = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(
          'Route ${widget.routeName}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              setState(() {
                _isFavorite = !_isFavorite;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _isFavorite
                        ? 'Added to favorites'
                        : 'Removed from favorites',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'share') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sharing route info...')),
                );
              } else if (value == 'download') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Downloading route for offline use...'),
                  ),
                );
              }
            },
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: 'share',
                    child: Row(
                      children: [
                        Icon(Icons.share, size: 20),
                        SizedBox(width: 8),
                        Text('Share Route'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'download',
                    child: Row(
                      children: [
                        Icon(Icons.download, size: 20),
                        SizedBox(width: 8),
                        Text('Download Offline'),
                      ],
                    ),
                  ),
                ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          indicatorColor: Colors.black,
          tabs: const [
            Tab(text: 'STOPS'),
            Tab(text: 'SCHEDULE'),
            Tab(text: 'FARES'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildStopsTab(), _buildScheduleTab(), _buildFaresTab()],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _toggleLiveTracking,
        backgroundColor: _isLiveTracking ? Colors.green : Colors.amber,
        icon: Icon(
          _isLiveTracking ? Icons.gps_fixed : Icons.directions_bus,
          color: Colors.black,
        ),
        label: Text(
          _isLiveTracking ? 'Live Tracking' : 'Track Live',
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildStopsTab() {
    return ListView.builder(
      itemCount: _stops.length,
      itemBuilder: (context, index) {
        final stop = _stops[index];
        final isLastStop = index == _stops.length - 1;
        final isBusAtThisStop = _isLiveTracking && index == _currentBusPosition;

        return Column(
          children: [
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color:
                      isBusAtThisStop
                          ? Colors.green
                          : (stop.isTerminal ? Colors.amber : Colors.grey[300]),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isBusAtThisStop ? Icons.directions_bus : Icons.location_on,
                  color: Colors.black,
                ),
              ),
              title: Text(
                stop.name,
                style: TextStyle(
                  fontWeight:
                      isBusAtThisStop || stop.isTerminal
                          ? FontWeight.bold
                          : FontWeight.normal,
                ),
              ),
              subtitle: Text('${stop.time} • ${stop.distance}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isBusAtThisStop)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'BUS HERE',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.map),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Showing ${stop.name} on map')),
                      );
                    },
                  ),
                ],
              ),
            ),
            if (!isLastStop)
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Container(height: 30, width: 2, color: Colors.grey[300]),
              ),
          ],
        );
      },
    );
  }

  Widget _buildScheduleTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Route Schedule',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Operating Days',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text('Monday to Saturday: Regular Service'),
                const Text('Sunday & Holidays: Reduced Service'),
                const SizedBox(height: 16),
                const Text(
                  'First & Last Bus',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text('First Bus: 06:00 AM from Majestic'),
                const Text('Last Bus: 10:00 PM from Majestic'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Frequency Details',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _schedules.length,
          itemBuilder: (context, index) {
            final schedule = _schedules[index];
            return Card(
              child: ListTile(
                title: Text('${schedule.startTime} - ${schedule.endTime}'),
                subtitle: Text(schedule.frequency),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color:
                        schedule.type == 'Peak Hours'
                            ? Colors.amber
                            : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    schedule.type,
                    style: TextStyle(
                      color:
                          schedule.type == 'Peak Hours'
                              ? Colors.black
                              : Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFaresTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Fare Information',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Route Details',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text('Route Length: 12.7 km'),
                const Text('Estimated Travel Time: 70 minutes'),
                const SizedBox(height: 16),
                const Text(
                  'Payment Methods',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text('• Cash'),
                const Text('• BMTC Smart Card'),
                const Text('• Mobile App Payment'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Fare Categories',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _fares.length,
          itemBuilder: (context, index) {
            final fare = _fares[index];
            return Card(
              child: ListTile(
                title: Text(fare.type),
                subtitle: Text(fare.description),
                trailing: Text(
                  fare.fare,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Purchasing ticket...')),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: const Text(
            'Purchase Ticket',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class BusStop {
  final String name;
  final String time;
  final String distance;
  final bool isTerminal;

  BusStop({
    required this.name,
    required this.time,
    required this.distance,
    required this.isTerminal,
  });
}

class BusSchedule {
  final String startTime;
  final String endTime;
  final String frequency;
  final String type;

  BusSchedule({
    required this.startTime,
    required this.endTime,
    required this.frequency,
    required this.type,
  });
}

class BusFare {
  final String type;
  final String fare;
  final String description;

  BusFare({required this.type, required this.fare, required this.description});
}
