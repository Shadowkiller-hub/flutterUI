import 'package:flutter/material.dart';
import '../widgets/bottom_navigation.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  final List<Map<String, dynamic>> _rewards = [
    {
      'title': 'Free Ride',
      'description': 'Get one free ride on any BMTC bus',
      'points': 200,
      'image': 'assets/images/free_ride.png',
      'isAvailable': true,
    },
    {
      'title': '50% Discount',
      'description': 'Get 50% discount on your next ride',
      'points': 100,
      'image': 'assets/images/discount.png',
      'isAvailable': true,
    },
    {
      'title': 'Monthly Pass',
      'description': 'Get ₹100 off on your next monthly pass',
      'points': 500,
      'image': 'assets/images/monthly_pass.png',
      'isAvailable': false,
    },
    {
      'title': 'Airport Transfer',
      'description': 'Free airport transfer on Vayu Vajra service',
      'points': 800,
      'image': 'assets/images/airport.png',
      'isAvailable': false,
    },
  ];

  final int _userPoints = 250;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rewards',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.amber,
      ),
      body: Column(
        children: [
          // Points summary
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.2),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                const Text('Your Points', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Text(
                  '$_userPoints',
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                // Progress bar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Silver'),
                        const Text('Gold'),
                        const Text('Platinum'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value:
                            _userPoints /
                            1000, // Assuming Platinum is at 1000 points
                        backgroundColor: Colors.grey[300],
                        color: Colors.amber,
                        minHeight: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Rewards list
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Available Rewards',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _rewards.length,
                      itemBuilder: (context, index) {
                        final reward = _rewards[index];
                        final bool canRedeem =
                            _userPoints >= reward['points'] &&
                            reward['isAvailable'];

                        return _buildRewardCard(
                          title: reward['title'],
                          description: reward['description'],
                          points: reward['points'],
                          canRedeem: canRedeem,
                          isAvailable: reward['isAvailable'],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavigation(currentIndex: 4),
    );
  }

  Widget _buildRewardCard({
    required String title,
    required String description,
    required int points,
    required bool canRedeem,
    required bool isAvailable,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Placeholder for reward image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color:
                    isAvailable
                        ? Colors.amber.withOpacity(0.2)
                        : Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Icon(
                  Icons.card_giftcard,
                  size: 40,
                  color: isAvailable ? Colors.amber : Colors.grey,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Reward details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(description, style: TextStyle(color: Colors.grey[600])),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '$points points',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed:
                            canRedeem
                                ? () {
                                  // Redeem reward functionality
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Redeemed $title!'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                                : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black,
                          disabledBackgroundColor: Colors.grey[300],
                          disabledForegroundColor: Colors.grey[600],
                        ),
                        child: const Text('Redeem'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
