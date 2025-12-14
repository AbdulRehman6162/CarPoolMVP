import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Core Imports
import '../../../../core/design_system/tokens.dart';

// Feature Imports
import '../providers/search_providers.dart';
import '../../domain/entities/location.dart';

class LocationPickerPage extends ConsumerStatefulWidget {
  final String title; // "Leaving from" or "Going to"

  const LocationPickerPage({super.key, required this.title});

  @override
  ConsumerState<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends ConsumerState<LocationPickerPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider);
    final searchResultsAsync = ref.watch(locationResultsProvider(query));
    final searchResults = ref.watch(locationResultsProvider as ProviderListenable);

    return Scaffold(
      backgroundColor: AppTokens.surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: searchResults.when(
                data: (locations) => _buildLocationList(locations),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppTokens.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back Button
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTokens.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 20),
            ),
          ),
          const SizedBox(height: AppTokens.space6),

          // Title
          Text(widget.title, style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 28)),
          const SizedBox(height: AppTokens.space4),

          // Search Input
          TextField(
            controller: _controller,
            autofocus: true,
            onChanged: (value) {
              // Update the provider state -> triggers logic -> updates UI
              ref.read(searchQueryProvider.notifier).state = value;
            },
            decoration: InputDecoration(
              hintText: "Enter city or address",
              prefixIcon: const Icon(Icons.search, color: AppTokens.outline),
              filled: true,
              fillColor: AppTokens.surfaceVariant,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTokens.radiusLg),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationList(List<Location> locations) {
    return ListView.separated(
      padding: const EdgeInsets.only(top: AppTokens.space4),
      itemCount: locations.length,
      separatorBuilder: (_, __) => const Divider(height: 1, indent: 60),
      itemBuilder: (context, index) {
        final loc = locations[index];
        return ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTokens.surfaceVariant,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.location_on, color: AppTokens.text, size: 20),
          ),
          title: Text(loc.name, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(loc.address, style: const TextStyle(color: Colors.grey)),
          onTap: () {
            // Return the result to the previous screen
            context.pop(loc);
          },
        );
      },
    );
  }
}