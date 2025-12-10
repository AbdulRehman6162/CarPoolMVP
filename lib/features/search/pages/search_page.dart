
import 'package:flutter/material.dart';
import '../../../core/widgets/ride_card.dart';
import '../../../core/design_system/tokens.dart';
import '../../../core/widgets/app_chip.dart';
import '../../../services/mock_data.dart';
import '../../../services/whatsapp_service.dart';
import 'package:go_router/go_router.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String fromCity = 'Lahore';
  String toCity = 'Islamabad';
  DateTime date = DateTime.now().add(const Duration(days: 1));

  @override
  Widget build(BuildContext context) {
    final filtered = MockData.rides.where((r) => r.from == fromCity && r.to == toCity).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find a Ride'),
        actions: [
          IconButton(onPressed: () => context.push('/booking-requests'), icon: const Icon(Icons.inbox)),
          IconButton(onPressed: () => context.push('/publish'), icon: const Icon(Icons.add_circle_outline)),
          IconButton(onPressed: () => context.push('/chat?name=Ali%20Khan&online=true'), icon: const Icon(Icons.chat_bubble_outline)),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTokens.space3),
          child: Column(
            children: [
              Row(children: [
                Expanded(child: _CityField(label: 'From', value: fromCity, onTap: () => _swap())),
                const SizedBox(width: AppTokens.space2),
                const Icon(Icons.swap_horiz),
                const SizedBox(width: AppTokens.space2),
                Expanded(child: _CityField(label: 'To', value: toCity, onTap: () => _swap())),
              ]),
              const SizedBox(height: AppTokens.space2),
              _DateRow(date: date, onPick: () async {
                final picked = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 60)),
                  initialDate: date,
                );
                if (picked != null) setState(() => date = picked);
              }),
              const SizedBox(height: AppTokens.space3),
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    AppFilterChip(label: 'Cheapest', selected: true),
                    SizedBox(width: 8),
                    AppFilterChip(label: 'Earliest'),
                    SizedBox(width: 8),
                    AppFilterChip(label: 'Most seats'),
                  ],
                ),
              ),
              const SizedBox(height: AppTokens.space3),
              Expanded(
                child: filtered.isEmpty
                    ? const _EmptyState()
                    : ListView.separated(
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (_, i) => RideCard(
                          ride: filtered[i],
                          onRequest: () => WhatsAppService.openChat(
                            phone: filtered[i].phone,
                            message: 'Salam ${filtered[i].driver}, I\'m interested in your ${filtered[i].from}→${filtered[i].to} ride at ${filtered[i].time}. Is a seat available?',
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

  void _swap() => setState(() {
    final tmp = fromCity; fromCity = toCity; toCity = tmp;
  });
}

class _CityField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;
  const _CityField({required this.label, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 44,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: AppTokens.space3),
        decoration: BoxDecoration(
          color: AppTokens.surfaceVariant,
          borderRadius: BorderRadius.circular(AppTokens.radiusMd),
          border: Border.all(color: AppTokens.outline.withOpacity(0.6)),
        ),
        child: Row(children: [
          Icon(label == 'From' ? Icons.radio_button_checked : Icons.flag, size: 18),
          const SizedBox(width: 8),
          Text(value),
        ]),
      ),
    );
  }
}

class _DateRow extends StatelessWidget {
  final DateTime date;
  final VoidCallback onPick;
  const _DateRow({required this.date, required this.onPick});

  @override
  Widget build(BuildContext context) {
    final label = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return Row(
      children: [
        const Icon(Icons.calendar_month),
        const SizedBox(width: 8),
        Text(label),
        const Spacer(),
        TextButton(onPressed: onPick, child: const Text('Change')),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: const [
        Icon(Icons.hourglass_empty, size: 64),
        SizedBox(height: 8),
        Text('No rides found for this route.'),
        Text('Try another time or swap cities.'),
      ]),
    );
  }
}
