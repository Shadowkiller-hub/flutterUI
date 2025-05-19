class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? profileImageUrl;
  final String membershipLevel;
  final int points;
  final int tripCount;
  final int ticketCount;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profileImageUrl,
    required this.membershipLevel,
    required this.points,
    required this.tripCount,
    required this.ticketCount,
  });

  // Create a copy of the user with updated fields
  User copyWith({
    String? name,
    String? email,
    String? phone,
    String? profileImageUrl,
    String? membershipLevel,
    int? points,
    int? tripCount,
    int? ticketCount,
  }) {
    return User(
      id: this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      membershipLevel: membershipLevel ?? this.membershipLevel,
      points: points ?? this.points,
      tripCount: tripCount ?? this.tripCount,
      ticketCount: ticketCount ?? this.ticketCount,
    );
  }

  // Create a user from JSON data
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      profileImageUrl: json['profileImageUrl'],
      membershipLevel: json['membershipLevel'] ?? 'Bronze',
      points: json['points'] ?? 0,
      tripCount: json['tripCount'] ?? 0,
      ticketCount: json['ticketCount'] ?? 0,
    );
  }

  // Convert user to JSON data
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profileImageUrl': profileImageUrl,
      'membershipLevel': membershipLevel,
      'points': points,
      'tripCount': tripCount,
      'ticketCount': ticketCount,
    };
  }
}
