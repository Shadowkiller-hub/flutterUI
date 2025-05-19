import 'package:flutter/material.dart';
import '../screens/map_screen.dart';
import '../screens/schedule_screen.dart';
import '../screens/tickets_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/search_screen.dart';
import '../routes.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;

  const BottomNavigation({super.key, this.currentIndex = 0});

  void _onItemTapped(BuildContext context, int index) {
    if (currentIndex == index) return;

    // Navigate to the appropriate screen
    switch (index) {
      case 0:
        _navigateToScreen(context, const MapScreen());
        break;
      case 1:
        _navigateToScreen(context, const ScheduleScreen());
        break;
      case 2:
        // Search button (central), navigate to search screen
        _navigateToScreen(context, const SearchScreen());
        break;
      case 3:
        _navigateToScreen(context, const TicketsScreen());
        break;
      case 4:
        _navigateToScreen(context, const ProfileScreen());
        break;
    }
  }

  void _navigateToScreen(BuildContext context, Widget screen) {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (context) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(context, 0, Icons.map, 'Map'),
          _buildNavItem(context, 1, Icons.calendar_today, 'Schedule'),
          _buildCircularButton(context),
          _buildNavItem(context, 3, Icons.receipt_long, 'Tickets'),
          _buildNavItem(context, 4, Icons.person, 'Profile'),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    int index,
    IconData icon,
    String label,
  ) {
    final isSelected = currentIndex == index;

    return InkWell(
      onTap: () => _onItemTapped(context, index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSelected ? Colors.amber : Colors.grey, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.amber : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularButton(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: currentIndex == 2 ? Colors.amber : Colors.grey[200],
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(
          Icons.search,
          color: currentIndex == 2 ? Colors.black : Colors.grey,
          size: 28,
        ),
        onPressed: () => _onItemTapped(context, 2),
      ),
    );
  }
}
