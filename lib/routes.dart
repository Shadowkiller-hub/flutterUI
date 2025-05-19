import 'package:flutter/material.dart';
import 'screens/map_screen.dart';
import 'screens/schedule_screen.dart';
import 'screens/tickets_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/rewards_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/search_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String schedule = '/schedule';
  static const String search = '/search';
  static const String tickets = '/tickets';
  static const String profile = '/profile';
  static const String rewards = '/rewards';
  static const String about = '/about';
  static const String support = '/support';
  static const String settings = '/settings';
  static const String payment = '/payment';
  static const String history = '/history';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final String? route = settings.name;

    if (route == AppRoutes.home) {
      return MaterialPageRoute(builder: (_) => const MapScreen());
    } else if (route == AppRoutes.schedule) {
      return MaterialPageRoute(builder: (_) => const ScheduleScreen());
    } else if (route == AppRoutes.search) {
      return MaterialPageRoute(builder: (_) => const SearchScreen());
    } else if (route == AppRoutes.tickets) {
      return MaterialPageRoute(builder: (_) => const TicketsScreen());
    } else if (route == AppRoutes.profile) {
      return MaterialPageRoute(builder: (_) => const ProfileScreen());
    } else if (route == AppRoutes.rewards) {
      return MaterialPageRoute(builder: (_) => const RewardsScreen());
    } else if (route == AppRoutes.history) {
      // For now, just showing the tickets screen for history
      return MaterialPageRoute(builder: (_) => const TicketsScreen());
    } else if (route == AppRoutes.about) {
      return MaterialPageRoute(
        builder: (_) => _buildPlaceholderScreen('About'),
      );
    } else if (route == AppRoutes.support) {
      return MaterialPageRoute(
        builder: (_) => _buildPlaceholderScreen('Support'),
      );
    } else if (route == AppRoutes.settings) {
      return MaterialPageRoute(builder: (_) => const SettingsScreen());
    } else if (route == AppRoutes.payment) {
      return MaterialPageRoute(
        builder: (_) => _buildPlaceholderScreen('Payment Methods'),
      );
    } else {
      return MaterialPageRoute(
        builder:
            (_) => Scaffold(
              appBar: AppBar(
                title: const Text('Error'),
                backgroundColor: Colors.amber,
              ),
              body: const Center(child: Text('Route not found!')),
            ),
      );
    }
  }

  static Widget _buildPlaceholderScreen(String title) {
    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: Colors.amber),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.construction, size: 80, color: Colors.amber),
            const SizedBox(height: 16),
            Text(
              '$title page',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'This section is under construction',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Builder(
              builder:
                  (context) => ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Go Back'),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
