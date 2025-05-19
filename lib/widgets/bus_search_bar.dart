import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bmtc_provider.dart';
import '../routes.dart';

class BusSearchBar extends StatelessWidget {
  final VoidCallback onFilterTap;
  final VoidCallback? onSearchTap;

  const BusSearchBar({super.key, required this.onFilterTap, this.onSearchTap});

  @override
  Widget build(BuildContext context) {
    final bmtcProvider = Provider.of<BmtcProvider>(context, listen: false);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search bus, routes, stops, etc.',
                prefixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    // Navigate to search screen
                    Navigator.pushNamed(context, AppRoutes.search);
                  },
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onSubmitted: (_) {
                // Navigate to search screen
                Navigator.pushNamed(context, AppRoutes.search);
              },
              onChanged: (value) {
                // Update search query in provider
                bmtcProvider.setSearchQuery(value);
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.tune, color: Colors.amber),
            onPressed: onFilterTap,
          ),
        ],
      ),
    );
  }
}
