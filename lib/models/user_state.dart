import 'user.dart';

class UserState {
  final User user;

  const UserState({required this.user});

  // Create a copy of the state with updated user
  UserState copyWith({User? user}) {
    return UserState(user: user ?? this.user);
  }

  // Create default state
  factory UserState.initial() {
    return UserState(
      user: User(
        id: '1',
        name: 'John Doe',
        email: 'johndoe@example.com',
        phone: '+1 234 567 8900',
        membershipLevel: 'Silver',
        points: 250,
        tripCount: 12,
        ticketCount: 5,
      ),
    );
  }

  // Create empty state for logout
  factory UserState.empty() {
    return UserState(
      user: User(
        id: '',
        name: '',
        email: '',
        phone: '',
        membershipLevel: 'Bronze',
        points: 0,
        tripCount: 0,
        ticketCount: 0,
      ),
    );
  }
}
