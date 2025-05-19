import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../models/bus.dart';
import '../models/place.dart';

class BmtcProvider with ChangeNotifier {
  // Mock data for buses
  final List<Bus> _buses = [
    Bus(
      id: '1',
      number: '500A',
      route: 'Koramangala - Ejipura - Domulur',
      destination: 'Koramangala',
      latitude: 12.9352,
      longitude: 77.6245,
    ),
    Bus(
      id: '2',
      number: '401K',
      route: 'Koramangala - St Bed - Viveknagar',
      destination: 'Viveknagar',
      latitude: 12.9515,
      longitude: 77.6280,
    ),
    Bus(
      id: '3',
      number: '500D',
      route: 'Koramangala - Ejipura - Domulur',
      destination: 'Domulur',
      latitude: 12.9399,
      longitude: 77.6192,
    ),
  ];

  // Mock data for places
  final List<Place> _places = [
    Place(
      id: '1',
      name: 'XYZ Bank',
      type: 'bank',
      latitude: 12.9452,
      longitude: 77.6130,
    ),
    Place(
      id: '2',
      name: 'XYZ Bank',
      type: 'bank',
      latitude: 12.9585,
      longitude: 77.6260,
    ),
    Place(
      id: '3',
      name: 'PQR Hospital',
      type: 'hospital',
      latitude: 12.9500,
      longitude: 77.6140,
    ),
    Place(
      id: '4',
      name: 'Food Court',
      type: 'food_court',
      latitude: 12.9452,
      longitude: 77.6300,
    ),
    Place(
      id: '5',
      name: 'Food Court',
      type: 'food_court',
      latitude: 12.9542,
      longitude: 77.6160,
    ),
    Place(
      id: '6',
      name: 'ABC Hotel',
      type: 'hotel',
      latitude: 12.9320,
      longitude: 77.6220,
    ),
  ];

  // User's current location
  LocationData? _currentLocation;
  LatLng _center = const LatLng(
    12.9350,
    77.6240,
  ); // Default center (Koramangala)

  // Filter states
  String _selectedFilter = 'Destination';
  String _searchQuery = '';

  // Getters
  List<Bus> get buses => [..._buses];
  List<Place> get places => [..._places];
  LocationData? get currentLocation => _currentLocation;
  LatLng get center => _center;
  String get selectedFilter => _selectedFilter;
  String get searchQuery => _searchQuery;

  // Methods to update filters
  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Get filtered buses based on current filter
  List<Bus> getFilteredBuses() {
    if (_searchQuery.isEmpty) {
      return _buses;
    }

    switch (_selectedFilter) {
      case 'Bus Number':
        return _buses
            .where(
              (bus) =>
                  bus.number.toLowerCase().contains(_searchQuery.toLowerCase()),
            )
            .toList();
      case 'Bus Route':
        return _buses
            .where(
              (bus) =>
                  bus.route.toLowerCase().contains(_searchQuery.toLowerCase()),
            )
            .toList();
      case 'Destination':
        return _buses
            .where(
              (bus) => bus.destination.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ),
            )
            .toList();
      default:
        return _buses;
    }
  }

  // Initialize and get user's current location
  Future<void> getCurrentLocation() async {
    final location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Check if location service is enabled
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    // Check if permission is granted
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // Get current location
    _currentLocation = await location.getLocation();
    if (_currentLocation != null) {
      _center = LatLng(
        _currentLocation!.latitude!,
        _currentLocation!.longitude!,
      );
    }

    // Listen for location changes
    location.onLocationChanged.listen((LocationData newLocation) {
      _currentLocation = newLocation;
      notifyListeners();
    });

    notifyListeners();
  }
}
