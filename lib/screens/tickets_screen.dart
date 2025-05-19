import 'package:flutter/material.dart';
import '../widgets/bottom_navigation.dart';

class TicketsScreen extends StatelessWidget {
  const TicketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'My Tickets',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.amber,
          bottom: const TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black54,
            indicatorColor: Colors.black,
            tabs: [Tab(text: 'ACTIVE'), Tab(text: 'HISTORY')],
          ),
        ),
        body: TabBarView(
          children: [
            // Active tickets tab
            _buildActiveTickets(),
            // History tickets tab
            _buildTicketHistory(),
          ],
        ),
        bottomNavigationBar: const BottomNavigation(currentIndex: 3),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showBuyTicketModal(context);
          },
          backgroundColor: Colors.amber,
          child: const Icon(Icons.add, color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildActiveTickets() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 2,
      itemBuilder: (context, index) {
        return _buildTicketCard(
          context,
          isActive: true,
          routeNumber: index == 0 ? '500A' : '401K',
          from: index == 0 ? 'Koramangala' : 'Ejipura',
          to: index == 0 ? 'Domulur' : 'Viveknagar',
          date:
              'Valid until: ${DateTime.now().add(const Duration(days: 1)).day}/${DateTime.now().month}/${DateTime.now().year}',
          price: index == 0 ? '₹25' : '₹20',
        );
      },
    );
  }

  Widget _buildTicketHistory() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      itemBuilder: (context, index) {
        return _buildTicketCard(
          context,
          isActive: false,
          routeNumber:
              index % 3 == 0 ? '500A' : (index % 3 == 1 ? '401K' : '500D'),
          from:
              index % 3 == 0
                  ? 'Koramangala'
                  : (index % 3 == 1 ? 'Ejipura' : 'St Bed'),
          to:
              index % 3 == 0
                  ? 'Domulur'
                  : (index % 3 == 1 ? 'Viveknagar' : 'Koramangala'),
          date:
              'Used on: ${DateTime.now().subtract(Duration(days: index + 1)).day}/${DateTime.now().subtract(Duration(days: index + 1)).month}/${DateTime.now().year}',
          price: index % 3 == 0 ? '₹25' : (index % 3 == 1 ? '₹20' : '₹30'),
        );
      },
    );
  }

  Widget _buildTicketCard(
    BuildContext context, {
    required bool isActive,
    required String routeNumber,
    required String from,
    required String to,
    required String date,
    required String price,
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
      child: Column(
        children: [
          // Top colored section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isActive ? Colors.amber : Colors.grey[300],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Bus $routeNumber',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  price,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          // Ticket details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Route information
                Row(
                  children: [
                    const Icon(
                      Icons.circle_outlined,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(from, style: const TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(left: 7),
                  height: 20,
                  width: 2,
                  color: Colors.grey[300],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 16,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(to, style: const TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Date and status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      date,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isActive ? Colors.green[50] : Colors.grey[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        isActive ? 'ACTIVE' : 'USED',
                        style: TextStyle(
                          color:
                              isActive ? Colors.green[800] : Colors.grey[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showBuyTicketModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Buy New Ticket',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Route selection
                  const Text(
                    'Select Route',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    value: '500A',
                    items: const [
                      DropdownMenuItem(
                        value: '500A',
                        child: Text('500A - Koramangala to Domulur'),
                      ),
                      DropdownMenuItem(
                        value: '401K',
                        child: Text('401K - Ejipura to Viveknagar'),
                      ),
                      DropdownMenuItem(
                        value: '500D',
                        child: Text('500D - St Bed to Koramangala'),
                      ),
                    ],
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 20),
                  // Ticket type selection
                  const Text(
                    'Ticket Type',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTicketTypeCard(
                          title: 'Single',
                          price: '₹25',
                          isSelected: true,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildTicketTypeCard(
                          title: 'Return',
                          price: '₹45',
                          isSelected: false,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildTicketTypeCard(
                          title: 'Day Pass',
                          price: '₹70',
                          isSelected: false,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  // Payment method
                  const Text(
                    'Payment Method',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildPaymentMethod(
                    icon: Icons.account_balance_wallet,
                    title: 'BMTC Wallet',
                    subtitle: 'Balance: ₹120',
                    isSelected: true,
                  ),
                  _buildPaymentMethod(
                    icon: Icons.credit_card,
                    title: 'Credit/Debit Card',
                    subtitle: '**** 1234',
                    isSelected: false,
                  ),
                  const Spacer(),
                  // Buy button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Ticket purchased successfully!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Buy Ticket - ₹25',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildTicketTypeCard({
    required String title,
    required String price,
    required bool isSelected,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSelected ? Colors.amber.withOpacity(0.2) : Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected ? Colors.amber : Colors.transparent,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            price,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.black : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isSelected ? Colors.amber.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected ? Colors.amber : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: RadioListTile(
        value: isSelected,
        groupValue: true,
        onChanged: (value) {},
        title: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.amber : Colors.grey),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        controlAffinity: ListTileControlAffinity.trailing,
        activeColor: Colors.amber,
      ),
    );
  }
}
