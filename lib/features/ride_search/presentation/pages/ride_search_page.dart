import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/tokens.dart';
import '../provider/ride_search_provider.dart';
import 'select_date_page.dart';
import 'select_seats_page.dart';

class RideSearchPage extends StatelessWidget {
  const RideSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Using a Stack to handle the background/header overlap cleanly
    return Scaffold(
      backgroundColor: AppTokens.surfaceVariant,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const _HeaderSection(),
            Transform.translate(
              offset: const Offset(0, -40),
              // Pull the card up to overlap the header
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppTokens.space4),
                child: _SearchFormCard(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Specialized component for the Header UI (SRP)
class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: const BoxDecoration(
        // Using a gradient similar to the reference design
        gradient: LinearGradient(
          colors: [Color(0xFF67E8F9), Color(0xFF38BDF8)], // Cyan-300 to Sky-400
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32), // approx 2rem
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Stack(
        children: [
          // Background pattern or image could go here
          Positioned(
            bottom: 80, // Leave space for the card overlap
            left: AppTokens.space4,
            right: AppTokens.space4,
            child: Text(
              'Your pick of rides at low prices',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Specialized component for the Search Form (SRP)
class _SearchFormCard extends StatelessWidget {
  const _SearchFormCard();

  @override
  Widget build(BuildContext context) {
    return Consumer<RideSearchProvider>(
      builder: (context, provider, _) {
        final filters = provider.filters;

        return Container(
          decoration: BoxDecoration(
            color: AppTokens.surface,
            borderRadius: BorderRadius.circular(AppTokens.radiusLg),
            boxShadow: AppTokens.cardShadow,
          ),
          padding: const EdgeInsets.all(AppTokens.space4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Leaving From
              _SearchInputTile(
                icon: Icons.radio_button_unchecked,
                hint: 'Leaving from',
                value: filters.fromCity.isEmpty ? null : filters.fromCity,
                onTap: () async {
                  final city = await context.push<String>(
                    '/select-city',
                    extra: 'Leaving from',
                  );
                  if (city != null) provider.updateFromCity(city);
                },
              ),
              const Divider(height: 1),

              // Going To
              _SearchInputTile(
                icon: Icons.radio_button_unchecked,
                hint: 'Going to',
                value: filters.toCity.isEmpty ? null : filters.toCity,
                onTap: () async {
                  final city = await context.push<String>('/select-city',
                      extra: 'Going to');

                  if (city != null) provider.updateToCity(city);
                },
              ),
              const Divider(height: 1),

              // Date and Seats Row
              Row(
                children: [
                  Expanded(
                    child: _SearchInputTile(
                      icon: Icons.calendar_today,
                      hint: 'Date',
                      value: filters.date.toLocal().toString().substring(0, 10),
                      onTap: () async {
                        final picked =
                            await Navigator.of(context).push<DateTime>(
                          MaterialPageRoute(
                            builder: (_) =>
                                SelectDatePage(initialDate: filters.date),
                          ),
                        );
                        if (picked != null) provider.updateDate(picked);
                      },
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.grey.withOpacity(0.2),
                  ),
                  Expanded(
                    child: _SearchInputTile(
                      icon: Icons.person_outline,
                      hint: 'Seats',
                      value: filters.seats.toString(),
                      onTap: () async {
                        final seats = await Navigator.of(context).push<int>(
                          MaterialPageRoute(
                            builder: (_) =>
                                SelectSeatsPage(initialSeats: filters.seats),
                          ),
                        );
                        if (seats != null) provider.updateSeats(seats);
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppTokens.space4),

              // Error Message
              if (provider.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppTokens.space2),
                  child: Text(
                    provider.errorMessage!,
                    style: const TextStyle(color: AppTokens.error),
                    textAlign: TextAlign.center,
                  ),
                ),

              // Search Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTokens.brand,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(vertical: AppTokens.space3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTokens.radiusMd),
                    ),
                    elevation: 0,
                  ),
                  onPressed: provider.isLoading
                      ? null
                      : () async {
                          await provider.searchRides();
                          if (context.mounted) {
                            context.goNamed('results');
                          }
                        },
                  child: provider.isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Search',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Reusable Input Tile (Open/Closed Principle)
/// Can be extended or reused for any input type without modifying the core form logic.
class _SearchInputTile extends StatelessWidget {
  final IconData icon;
  final String hint;
  final String? value;
  final VoidCallback onTap;

  const _SearchInputTile({
    required this.icon,
    required this.hint,
    this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null && value!.isNotEmpty;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTokens.radiusSm),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppTokens.space4,
          horizontal: AppTokens.space2,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: hasValue ? AppTokens.brand : Colors.grey,
              size: 24,
            ),
            const SizedBox(width: AppTokens.space3),
            Expanded(
              child: Text(
                hasValue ? value! : hint,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: hasValue ? AppTokens.text : Colors.grey,
                      fontWeight:
                          hasValue ? FontWeight.w500 : FontWeight.normal,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
