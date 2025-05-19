import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bmtc_provider.dart';
import '../widgets/bottom_navigation.dart';
import '../models/bus.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bmtcProvider = Provider.of<BmtcProvider>(context);
    final searchQuery = bmtcProvider.searchQuery;
    final selectedFilter = bmtcProvider.selectedFilter;
    final filteredBuses = bmtcProvider.getFilteredBuses();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search Results',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.amber,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search bus, routes, stops, etc.',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.tune),
                  onPressed: () => _showFilterDialog(context, bmtcProvider),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onChanged: (value) {
                bmtcProvider.setSearchQuery(value);
              },
              controller: TextEditingController(text: searchQuery),
            ),
          ),

          // Filter chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Text(
                  'Filter: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  context,
                  'Bus Number',
                  selectedFilter,
                  bmtcProvider,
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  context,
                  'Bus Route',
                  selectedFilter,
                  bmtcProvider,
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  context,
                  'Destination',
                  selectedFilter,
                  bmtcProvider,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Results count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${filteredBuses.length} results found',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Results list
          Expanded(
            child:
                searchQuery.isEmpty
                    ? _buildEmptySearchState()
                    : filteredBuses.isEmpty
                    ? _buildNoResultsState()
                    : ListView.builder(
                      itemCount: filteredBuses.length,
                      itemBuilder: (context, index) {
                        return _buildBusResultItem(
                          context,
                          filteredBuses[index],
                        );
                      },
                    ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavigation(currentIndex: 2),
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    String label,
    String selectedFilter,
    BmtcProvider provider,
  ) {
    final isSelected = selectedFilter == label;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          provider.setFilter(label);
        }
      },
      selectedColor: Colors.amber,
      checkmarkColor: Colors.black,
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildEmptySearchState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Search for buses, routes, or destinations',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No results found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different search term or filter',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildBusResultItem(BuildContext context, Bus bus) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            bus.number,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        title: Text(
          bus.route,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('To: ${bus.destination}'),
        trailing:
            bus.isLive
                ? const Chip(
                  label: Text('LIVE'),
                  backgroundColor: Colors.green,
                  labelStyle: TextStyle(color: Colors.white, fontSize: 12),
                )
                : null,
        onTap: () {
          // Show bus details
          _showBusDetails(context, bus);
        },
      ),
    );
  }

  void _showFilterDialog(BuildContext context, BmtcProvider provider) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Filter Search'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<String>(
                  title: const Text('Bus Number'),
                  value: 'Bus Number',
                  groupValue: provider.selectedFilter,
                  onChanged: (value) {
                    provider.setFilter(value!);
                    Navigator.pop(context);
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Bus Route'),
                  value: 'Bus Route',
                  groupValue: provider.selectedFilter,
                  onChanged: (value) {
                    provider.setFilter(value!);
                    Navigator.pop(context);
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Destination'),
                  value: 'Destination',
                  groupValue: provider.selectedFilter,
                  onChanged: (value) {
                    provider.setFilter(value!);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('CLOSE'),
              ),
            ],
          ),
    );
  }

  void _showBusDetails(BuildContext context, Bus bus) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height * 0.4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        bus.number,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    if (bus.isLive)
                      Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'LIVE',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Route: ${bus.route}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  'Destination: ${bus.destination}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Current Location',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text('Latitude: ${bus.latitude.toStringAsFixed(4)}'),
                Text('Longitude: ${bus.longitude.toStringAsFixed(4)}'),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Here you would typically navigate to a detailed bus tracking screen
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Track bus functionality'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('TRACK THIS BUS'),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
