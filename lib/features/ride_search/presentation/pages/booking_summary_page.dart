import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/tokens.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/passenger.dart';
import '../provider/booking_provider.dart';
import 'booking_result_page.dart';

class BookingSummaryPage extends StatefulWidget {
  const BookingSummaryPage({super.key});

  @override
  State<BookingSummaryPage> createState() => _BookingSummaryPageState();
}

class _BookingSummaryPageState extends State<BookingSummaryPage> {
  final _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _commentController.text =
        Provider.of<BookingProvider>(context, listen: false).comment;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingProvider>(
      builder: (context, provider, _) {
        final ride = provider.ride;
        if (ride == null) {
          return const Scaffold(
            body: Center(child: Text('No ride selected')),
          );
        }

        final arrivalTime = ride.departureTime.add(const Duration(hours: 4));
        final totalPrice = ride.price * provider.seats;

        return Scaffold(
          backgroundColor: AppTokens.surface,
          appBar: AppBar(
            backgroundColor: AppTokens.surface,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppTokens.text),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppTokens.space6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Book online and secure\nyour seat',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppTokens.text,
                                height: 1.2,
                              ),
                        ),
                        const SizedBox(height: AppTokens.space6),
                        _DateHeader(date: ride.departureTime),
                        const SizedBox(height: AppTokens.space4),
                        _TimelineSection(
                          departureTime: ride.departureTime,
                          arrivalTime: arrivalTime,
                          fromCity: ride.fromCity,
                          toCity: ride.toCity,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: AppTokens.space6),
                          child: Divider(color: AppTokens.outline),
                        ),
                        _PriceSummarySection(
                          seats: provider.seats,
                          pricePerSeat: ride.price,
                          totalPrice: totalPrice,
                          onSeatsChanged: (value) {
                            if (value != null) {
                              provider.updateSeats(value);
                            }
                          },
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: AppTokens.space6),
                          child: Divider(color: AppTokens.outline),
                        ),
                        _MessageSection(
                          driverName: ride.driver.name,
                          commentController: _commentController,
                          onCommentChanged: provider.updateComment,
                        ),
                        const SizedBox(height: AppTokens.space6),
                      ],
                    ),
                  ),
                ),
                _StickyFooter(
                  onPressed: provider.isSubmitting
                      ? null
                      : () async {
                          final auth = context.read<AuthProvider>();
                          if (!auth.isLoggedIn) {
                            context.go('/login?from=/booking-summary');
                            return;
                          }

                          final user = auth.user!;
                          provider.setPassenger(
                            Passenger(
                              id: user.id,
                              name: user.name,
                              isRegistered: true,
                            ),
                          );

                          await provider.submitBooking();
                          if (context.mounted) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const BookingResultPage(),
                              ),
                            );
                          }
                        },
                  isLoading: provider.isSubmitting,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DateHeader extends StatelessWidget {
  final DateTime date;

  const _DateHeader({required this.date});

  @override
  Widget build(BuildContext context) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    final d = date.toLocal();
    final dateStr =
        '${weekDays[d.weekday % 7]} ${d.day} ${months[d.month - 1]}';

    return Text(
      dateStr,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTokens.text,
          ),
    );
  }
}

class _TimelineSection extends StatelessWidget {
  final DateTime departureTime;
  final DateTime arrivalTime;
  final String fromCity;
  final String toCity;

  const _TimelineSection({
    required this.departureTime,
    required this.arrivalTime,
    required this.fromCity,
    required this.toCity,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatTime(departureTime),
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const Spacer(),
              Text(
                _formatTime(arrivalTime),
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(width: AppTokens.space4),
          Column(
            children: [
              const SizedBox(height: 4),
              _HollowDot(),
              Expanded(
                child: Container(
                  width: 1,
                  color: AppTokens.text,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                ),
              ),
              _HollowDot(),
              const SizedBox(height: 4),
            ],
          ),
          const SizedBox(width: AppTokens.space4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fromCity,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTokens.text,
                  ),
                ),
                Text(
                  fromCity.split(' - ').last,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 32),
                Text(
                  toCity,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTokens.text,
                  ),
                ),
                Text(
                  toCity.split(' - ').last,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

class _HollowDot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: AppTokens.surface,
        border: Border.all(color: AppTokens.text, width: 2),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _PriceSummarySection extends StatelessWidget {
  final int seats;
  final double pricePerSeat;
  final double totalPrice;
  final ValueChanged<int?> onSeatsChanged;

  const _PriceSummarySection({
    required this.seats,
    required this.pricePerSeat,
    required this.totalPrice,
    required this.onSeatsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price summary',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTokens.text,
              ),
        ),
        const SizedBox(height: AppTokens.space4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${seats} seat${seats > 1 ? "s" : ""}: PKR ${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(color: AppTokens.text, fontSize: 16),
                ),
                const Text(
                  'Pay in the car',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
            DropdownButton<int>(
              value: seats,
              items: List.generate(
                6,
                (index) => DropdownMenuItem(
                  value: index + 1,
                  child: Text('${index + 1}'),
                ),
              ),
              onChanged: onSeatsChanged,
            ),
          ],
        ),
      ],
    );
  }
}

class _MessageSection extends StatelessWidget {
  final String driverName;
  final TextEditingController commentController;
  final ValueChanged<String> onCommentChanged;

  const _MessageSection({
    required this.driverName,
    required this.commentController,
    required this.onCommentChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Send a message to $driverName to introduce yourself',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTokens.text,
              ),
        ),
        const SizedBox(height: AppTokens.space4),
        TextField(
          controller: commentController,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Comment (optional)',
            border: OutlineInputBorder(),
          ),
          onChanged: onCommentChanged,
        ),
      ],
    );
  }
}

class _StickyFooter extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const _StickyFooter({required this.onPressed, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTokens.space4),
      decoration: BoxDecoration(
        color: AppTokens.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTokens.brand,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: AppTokens.space4),
            shape: const StadiumBorder(),
            elevation: 4,
          ),
          onPressed: onPressed,
          child: isLoading
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bolt, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Book',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
