import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Imports from your existing project structure
import '../../../core/design_system/tokens.dart';
import '../../../core/widgets/app_button.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // State for the search inputs
  String? _from;
  String? _to;
  DateTime _date = DateTime.now();
  int _passengers = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTokens.surfaceVariant, // Matches your tokens
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Hero Section
            _buildHeroSection(context),

            // 2. Floating Search Card
            Transform.translate(
              offset: const Offset(0, -40),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppTokens.space4),
                child: _buildSearchCard(context),
              ),
            ),

            // 3. Recent Searches / Promotions could go here
            Padding(
              padding: const EdgeInsets.all(AppTokens.space4),
              child: Text(
                  "Recent Rides",
                  style: Theme.of(context).textTheme.titleLarge
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      height: 260,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppTokens.brand, // Your Blue Color
        image: DecorationImage(
          // Placeholder image (replace with asset later)
          image: NetworkImage('https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?q=80&w=1000&auto=format&fit=crop'),
          fit: BoxFit.cover,
          opacity: 0.4, // Dim the image so text pops
        ),
      ),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(AppTokens.space6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Your pick of rides at low prices",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTokens.space4),
      decoration: BoxDecoration(
        color: AppTokens.surface,
        borderRadius: BorderRadius.circular(AppTokens.radiusLg),
        boxShadow: AppTokens.cardShadow,
      ),
      child: Column(
        children: [
          // FROM Input
          _buildInputTile(
            context,
            icon: Icons.radio_button_unchecked,
            label: _from ?? "Leaving from",
            isPlaceholder: _from == null,
            onTap: () {
              // TODO: Navigate to Location Picker
              print("Pick Origin");
            },
          ),

          const Divider(height: 1, indent: 40),

          // TO Input
          _buildInputTile(
            context,
            icon: Icons.location_on_outlined,
            label: _to ?? "Going to",
            isPlaceholder: _to == null,
            onTap: () {
              // TODO: Navigate to Location Picker
              print("Pick Destination");
            },
          ),

          const Divider(height: 1, indent: 40),

          // Date & Passengers
          Row(
            children: [
              Expanded(
                child: _buildInputTile(
                  context,
                  icon: Icons.calendar_today_outlined,
                  label: "Today",
                  isPlaceholder: false,
                  onTap: () {
                    // TODO: Open Date Picker
                  },
                ),
              ),
              Container(width: 1, height: 40, color: AppTokens.outline),
              Expanded(
                child: _buildInputTile(
                  context,
                  icon: Icons.person_outline,
                  label: "$_passengers",
                  isPlaceholder: false,
                  onTap: () {
                    setState(() => _passengers = _passengers < 4 ? _passengers + 1 : 1);
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: AppTokens.space4),

          // Search Button (Using your AppButton!)
          SizedBox(
            width: double.infinity,
            child: AppButton.primary(
              "Search",
              onPressed: () {
                // Navigate to results
                context.pushNamed('bookingRequests'); // Example navigation
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputTile(
      BuildContext context, {
        required IconData icon,
        required String label,
        required bool isPlaceholder,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTokens.radiusMd),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppTokens.space4),
        child: Row(
          children: [
            Icon(icon, color: AppTokens.outline, size: 24),
            const SizedBox(width: AppTokens.space3),
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: isPlaceholder ? Colors.grey : AppTokens.text,
                fontWeight: isPlaceholder ? FontWeight.w400 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}