class Bus {
  final String id;
  final String number;
  final String route;
  final String destination;
  final double latitude;
  final double longitude;
  final bool isLive;

  Bus({
    required this.id,
    required this.number,
    required this.route,
    required this.destination,
    required this.latitude,
    required this.longitude,
    this.isLive = true,
  });

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      id: json['id'] ?? '',
      number: json['number'] ?? '',
      route: json['route'] ?? '',
      destination: json['destination'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      isLive: json['isLive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
      'route': route,
      'destination': destination,
      'latitude': latitude,
      'longitude': longitude,
      'isLive': isLive,
    };
  }
}
