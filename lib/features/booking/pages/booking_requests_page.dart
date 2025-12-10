
import 'package:flutter/material.dart';
import '../../../core/design_system/tokens.dart';
import '../../../core/widgets/app_button.dart';
import 'package:go_router/go_router.dart';

class BookingRequestsPage extends StatelessWidget {
  const BookingRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Booking Requests')),
      body: ListView(
        padding: const EdgeInsets.all(AppTokens.space3),
        children: const [
          _RequestCard(name: 'Ali Khan', dateTime: 'Mon, Dec 18 at 9:30 AM', seats: 2, from: 'Downtown Central', to: 'Airport Terminal 2', avatarUrl: 'https://i.pravatar.cc/150?img=12'),
          SizedBox(height: 12),
          _RequestCard(name: 'Sofia Reyes', dateTime: 'Mon, Dec 18 at 2:00 PM', seats: 1, from: 'Northside Mall', to: 'Greenfield Park', avatarUrl: 'https://i.pravatar.cc/150?img=49'),
          SizedBox(height: 24),
          _EmptyCard(),
        ],
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final String name, dateTime, from, to;
  final int seats;
  final String avatarUrl;
  const _RequestCard({required this.name, required this.dateTime, required this.seats, required this.from, required this.to, required this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTokens.radiusXl),
        border: Border.all(color: AppTokens.outline.withOpacity(0.5)),
        boxShadow: AppTokens.cardShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              CircleAvatar(backgroundImage: NetworkImage(avatarUrl), radius: 22),
              const SizedBox(width: 12),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(name, style: Theme.of(context).textTheme.titleMedium),
                Text('View Profile', style: TextStyle(color: cs.primary)),
              ]),
            ]),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            _Row(icon: Icons.event, text: 'On: $dateTime'),
            _Row(icon: Icons.people, text: 'Seats: $seats'),
            _Row(icon: Icons.radio_button_checked, text: 'From: $from'),
            _Row(icon: Icons.flag, text: 'To: $to'),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: AppButton.secondary('Decline', onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Declined'))))),
              const SizedBox(width: 12),
              Expanded(child: AppButton.primary('Accept', onPressed: () => context.push('/booking-confirmed'))),
            ]),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Row({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(children: [
        Icon(icon, size: 20),
        const SizedBox(width: 8),
        Expanded(child: Text(text)),
      ]),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTokens.outline.withOpacity(0.5), style: BorderStyle.solid),
        boxShadow: AppTokens.cardShadow,
      ),
      child: Column(
        children: [
          Icon(Icons.inventory_2, size: 48, color: cs.primary),
          const SizedBox(height: 12),
          const Text("You're all caught up!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const Text('There are no pending requests right now.', textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
