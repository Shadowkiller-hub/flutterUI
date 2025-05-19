import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bmtc_provider.dart';

class FilterBottomSheet extends StatelessWidget {
  final VoidCallback onClose;

  const FilterBottomSheet({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final bmtcProvider = Provider.of<BmtcProvider>(context);
    final selectedFilter = bmtcProvider.selectedFilter;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 0),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'FILTERS',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              IconButton(icon: const Icon(Icons.close), onPressed: onClose),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFilterButton(
                context,
                'Bus Number',
                selectedFilter == 'Bus Number',
                bmtcProvider,
              ),
              _buildFilterButton(
                context,
                'Bus Route',
                selectedFilter == 'Bus Route',
                bmtcProvider,
              ),
              _buildFilterButton(
                context,
                'Destination',
                selectedFilter == 'Destination',
                bmtcProvider,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildFilterButton(
            context,
            'Nearby Places',
            false,
            bmtcProvider,
            fullWidth: true,
          ),
          const SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              hintText: 'Search bus, routes, stops, etc.',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onChanged: (value) {
              bmtcProvider.setSearchQuery(value);
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildFilterButton(
    BuildContext context,
    String text,
    bool isSelected,
    BmtcProvider provider, {
    bool fullWidth = false,
  }) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: () {
          provider.setFilter(text);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.amber : Colors.grey[200],
          foregroundColor: isSelected ? Colors.black : Colors.black54,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        child: Text(text),
      ),
    );
  }
}
