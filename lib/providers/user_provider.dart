import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/user_state.dart';

class UserProvider with ChangeNotifier {
  // User state with initial data
  UserState _state = UserState.initial();

  // Getter for user state
  UserState get state => _state;

  // Getter for user
  User get user => _state.user;

  // Update user profile
  void updateProfile({
    String? name,
    String? email,
    String? phone,
    String? profileImageUrl,
  }) {
    final updatedUser = _state.user.copyWith(
      name: name,
      email: email,
      phone: phone,
      profileImageUrl: profileImageUrl,
    );

    _state = _state.copyWith(user: updatedUser);
    notifyListeners();
  }

  // Update user membership level
  void updateMembershipLevel(String level) {
    final updatedUser = _state.user.copyWith(membershipLevel: level);
    _state = _state.copyWith(user: updatedUser);
    notifyListeners();
  }

  // Add points to user
  void addPoints(int points) {
    final updatedUser = _state.user.copyWith(
      points: _state.user.points + points,
    );
    _state = _state.copyWith(user: updatedUser);
    notifyListeners();
  }

  // Add trip to user history
  void addTrip() {
    final updatedUser = _state.user.copyWith(
      tripCount: _state.user.tripCount + 1,
    );
    _state = _state.copyWith(user: updatedUser);
    notifyListeners();
  }

  // Add ticket to user
  void addTicket() {
    final updatedUser = _state.user.copyWith(
      ticketCount: _state.user.ticketCount + 1,
    );
    _state = _state.copyWith(user: updatedUser);
    notifyListeners();
  }

  // Use ticket
  void useTicket() {
    if (_state.user.ticketCount > 0) {
      final updatedUser = _state.user.copyWith(
        ticketCount: _state.user.ticketCount - 1,
      );
      _state = _state.copyWith(user: updatedUser);
      notifyListeners();
    }
  }

  // Logout user (reset to default)
  void logout() {
    _state = UserState.empty();
    notifyListeners();
  }
}
