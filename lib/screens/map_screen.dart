import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import '../widgets/bottom_navigation.dart';
import '../screens/menu_screen.dart';
import '../screens/profile_screen.dart';
import '../widgets/bus_search_bar.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../routes.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  bool _isFilterSheetOpen = false;
  bool _isLoading = true;
  bool _showMap = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // Map controller
  final MapController _mapController = MapController();
  LatLng _currentPosition = LatLng(
    12.9716,
    77.5946,
  ); // Default Bangalore coordinates

  // Mock bus data for demonstration
  final List<Map<String, dynamic>> _nearbyBuses = [
    {
      'id': 'KA-01-F-1234',
      'route': '500C',
      'distance': '0.5 km',
      'eta': '2 min',
      'position': LatLng(12.9726, 77.5956),
    },
    {
      'id': 'KA-01-F-5678',
      'route': '401K',
      'distance': '1.2 km',
      'eta': '5 min',
      'position': LatLng(12.9736, 77.5936),
    },
    {
      'id': 'KA-01-F-9012',
      'route': '600A',
      'distance': '1.8 km',
      'eta': '8 min',
      'position': LatLng(12.9706, 77.5976),
    },
  ];

  @override
  void initState() {
    super.initState();

    // Create pulse animation for location indicator
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Get current location
    _getCurrentLocation();

    // Simulate loading the map
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever
      return;
    }

    // Get current position
    try {
      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _toggleFilterSheet() {
    setState(() {
      _isFilterSheetOpen = !_isFilterSheetOpen;
    });
  }

  void _toggleMapView() {
    setState(() {
      _showMap = !_showMap;
      if (_showMap) {
        // Refresh location when showing map
        _getCurrentLocation();
      }
    });
  }

  void _navigateToSearch() {
    Navigator.pushNamed(context, AppRoutes.search);
  }

  void _showMenu() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MenuScreen(onClose: () => Navigator.pop(context)),
      ),
    );
  }

  void _showProfile() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const ProfileScreen()));
  }

  void _showBusDetails(Map<String, dynamic> bus) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height * 0.4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Route ${bus['route']}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(
                    Icons.directions_bus,
                    color: Colors.amber,
                  ),
                  title: Text('Bus ID: ${bus['id']}'),
                ),
                ListTile(
                  leading: const Icon(Icons.location_on, color: Colors.amber),
                  title: Text('Distance: ${bus['distance']}'),
                ),
                ListTile(
                  leading: const Icon(Icons.access_time, color: Colors.amber),
                  title: Text('ETA: ${bus['eta']}'),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        _showMap = true;
                      });

                      // Center map on the bus
                      if (bus['position'] != null) {
                        _mapController.move(bus['position'], 15);
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Tracking this bus...')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Track This Bus',
                      style: TextStyle(
                        color: Colors.black,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'BusMap',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.amber,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: _showProfile,
          ),
        ],
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: _showMenu),
      ),
      body: Stack(
        children: [
          // Map placeholder or actual map
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                ),
              )
              : _showMap
              ? _buildOsmMap()
              : _buildMapPlaceholder(),

          // Search Bar
          if (!_isFilterSheetOpen)
            Positioned(
              left: 0,
              right: 0,
              bottom: 80,
              child: BusSearchBar(
                onFilterTap: _toggleFilterSheet,
                onSearchTap: _navigateToSearch,
              ),
            ),

          // Filter Bottom Sheet
          if (_isFilterSheetOpen)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: FilterBottomSheet(onClose: _toggleFilterSheet),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_showMap) {
            // If map is showing, center on current location
            _getCurrentLocation();
            _mapController.move(_currentPosition, 15);
          } else {
            // Otherwise toggle map view
            _toggleMapView();
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Locating your position...')),
          );
        },
        backgroundColor: Colors.amber,
        child: Icon(
          _showMap ? Icons.my_location : Icons.map,
          color: Colors.black,
        ),
      ),
      bottomNavigationBar: const BottomNavigation(currentIndex: 0),
    );
  }

  Widget _buildOsmMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(initialCenter: _currentPosition, initialZoom: 15),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.busmap',
        ),
        // Current location marker
        MarkerLayer(
          markers: [
            Marker(
              point: _currentPosition,
              width: 30,
              height: 30,
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          width: 15,
                          height: 15,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Bus markers
            ..._nearbyBuses.map(
              (bus) => Marker(
                point: bus['position'],
                width: 40,
                height: 40,
                child: GestureDetector(
                  onTap: () => _showBusDetails(bus),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.amber,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.directions_bus,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMapPlaceholder() {
    return Stack(
      children: [
        // Map background
        Container(
          color: Colors.grey[200],
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.map, size: 100, color: Colors.amber),
                const SizedBox(height: 20),
                const Text(
                  'Map View',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _toggleMapView,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                  ),
                  child: const Text('Show Map'),
                ),
              ],
            ),
          ),
        ),

        // Nearby buses panel
        Positioned(
          top: 20,
          left: 20,
          right: 20,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nearby Buses',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...List.generate(
                    _nearbyBuses.length,
                    (index) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            _nearbyBuses[index]['route'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      title: Text('Bus ${_nearbyBuses[index]['id']}'),
                      subtitle: Text('${_nearbyBuses[index]['distance']} away'),
                      trailing: Text(
                        'ETA: ${_nearbyBuses[index]['eta']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      onTap: () => _showBusDetails(_nearbyBuses[index]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
