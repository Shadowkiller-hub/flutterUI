import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../routes.dart';

class MenuScreen extends StatelessWidget {
  final Function() onClose;

  const MenuScreen({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text(
          'Menu',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(icon: const Icon(Icons.close), onPressed: onClose),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User info section
            _buildUserProfileSection(context),

            const Divider(height: 40),

            // Main menu items
            const Text(
              'My Account',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            _buildMenuItem(
              context,
              icon: Icons.person_outline,
              title: 'My Profile',
              route: AppRoutes.profile,
              badge: 'EDIT',
              badgeColor: Colors.blue,
              onTap: () => _showProfileOptions(context),
            ),
            _buildMenuItem(
              context,
              icon: Icons.receipt_long,
              title: 'My Tickets',
              route: AppRoutes.tickets,
              badge: '3',
              badgeColor: Colors.green,
              onTap: () => _showTicketsOptions(context),
            ),
            _buildMenuItem(
              context,
              icon: Icons.history,
              title: 'Trip History',
              route: AppRoutes.history,
              onTap: () => _showTripHistoryOptions(context),
            ),
            _buildMenuItem(
              context,
              icon: Icons.card_giftcard,
              title: 'Rewards',
              route: AppRoutes.rewards,
              badge: 'NEW',
              badgeColor: Colors.orange,
              onTap: () => _showRewardsOptions(context),
            ),
            _buildMenuItem(
              context,
              icon: Icons.credit_card,
              title: 'Payment Methods',
              route: AppRoutes.payment,
              onTap: () => _showPaymentOptions(context),
            ),

            const Divider(height: 40),

            const Text(
              'Information',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            _buildMenuItem(
              context,
              icon: Icons.map_outlined,
              title: 'Routes Map',
              route: AppRoutes.home,
              onTap: () => _showRoutesMapOptions(context),
            ),
            _buildMenuItem(
              context,
              icon: Icons.calendar_today,
              title: 'Bus Schedule',
              route: AppRoutes.schedule,
              onTap: () => _showBusScheduleOptions(context),
            ),
            _buildMenuItem(
              context,
              icon: Icons.info_outline,
              title: 'About BMTC',
              route: AppRoutes.about,
              onTap: () => _showAboutBMTCDialog(context),
            ),
            _buildMenuItem(
              context,
              icon: Icons.support_agent,
              title: 'Help & Support',
              route: AppRoutes.support,
              onTap: () => _showSupportOptions(context),
            ),

            const Divider(height: 40),

            // Settings & Logout
            const Text(
              'Settings',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            _buildSettingsMenuItem(context),
            _buildLogoutButton(context),

            const SizedBox(height: 40),
            // App version
            Center(
              child: Text(
                'App Version 1.0.0',
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfileSection(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return InkWell(
      onTap: () {
        // Navigate to profile screen
        Navigator.pop(context);
        Navigator.pushNamed(context, AppRoutes.profile);
      },
      child: Row(
        children: [
          Stack(
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.amber,
                child: Icon(Icons.person, size: 30, color: Colors.white),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, size: 12, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star, size: 16, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(
                    '${user.membershipLevel} Member',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
    String? badge,
    Color? badgeColor,
    Function()? onTap,
  }) {
    return InkWell(
      onTap:
          onTap ??
          () {
            // Navigate to the specified route
            Navigator.pop(context);
            Navigator.pushNamed(context, route);
          },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: Colors.black87),
            const SizedBox(width: 16),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
            const Spacer(),
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: badgeColor ?? Colors.amber,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsMenuItem(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber, width: 1),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to settings screen
          Navigator.pop(context);
          Navigator.pushNamed(context, AppRoutes.settings);
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.settings_outlined, color: Colors.black),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'App Settings',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'NEW',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Customize your bus tracking experience',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.amber,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return InkWell(
      onTap: () {
        // Logout functionality
        _showLogoutConfirmationDialog(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(Icons.logout, color: Colors.red[400]),
            const SizedBox(width: 16),
            Text(
              'Logout',
              style: TextStyle(
                color: Colors.red[400],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('CANCEL'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Perform logout operation
                  userProvider.logout();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Logged out successfully')),
                  );

                  // Navigate to home screen
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.home,
                    (route) => false,
                  );
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('LOGOUT'),
              ),
            ],
          ),
    );
  }

  void _showProfileOptions(BuildContext context) {
    // Navigate directly to the profile screen
    Navigator.pop(context);
    Navigator.pushNamed(context, AppRoutes.profile);
  }

  void _showTicketsOptions(BuildContext context) {
    // Navigate directly to the tickets screen
    Navigator.pop(context);
    Navigator.pushNamed(context, AppRoutes.tickets);
  }

  void _showTripHistoryOptions(BuildContext context) {
    // Navigate directly to the history screen
    Navigator.pop(context);
    Navigator.pushNamed(context, AppRoutes.history);
  }

  void _showRewardsOptions(BuildContext context) {
    // Navigate directly to the rewards screen
    Navigator.pop(context);
    Navigator.pushNamed(context, AppRoutes.rewards);
  }

  void _showPaymentOptions(BuildContext context) {
    // Navigate directly to the payment screen
    Navigator.pop(context);
    Navigator.pushNamed(context, AppRoutes.payment);
  }

  void _showRoutesMapOptions(BuildContext context) {
    // Navigate directly to the map screen
    Navigator.pop(context);
    Navigator.pushNamed(context, AppRoutes.home);
  }

  void _showBusScheduleOptions(BuildContext context) {
    // Navigate directly to the schedule screen
    Navigator.pop(context);
    Navigator.pushNamed(context, AppRoutes.schedule);
  }

  void _showAboutBMTCDialog(BuildContext context) {
    // Navigate directly to the about screen
    Navigator.pop(context);
    Navigator.pushNamed(context, AppRoutes.about);
  }

  void _showSupportOptions(BuildContext context) {
    // Navigate directly to the support screen
    Navigator.pop(context);
    Navigator.pushNamed(context, AppRoutes.support);
  }
}
