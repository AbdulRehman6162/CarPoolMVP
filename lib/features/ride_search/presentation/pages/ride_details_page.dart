import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/design_system/tokens.dart';
import '../../../../core/widgets/app_button.dart';
import '../../domain/entities/ride.dart';

class RideDetailsPage extends StatelessWidget {
  final Ride ride;

  const RideDetailsPage({super.key, required this.ride});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(elevation: 0, backgroundColor: Colors.white, leading: BackButton(color: Colors.black)),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppTokens.space4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Sunday, 23 November", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTokens.brand)),
                  SizedBox(height: AppTokens.space6),

                  // Route Visualization
                  _buildRouteStep(ride.departureTime, ride.from),
                  Container(
                    height: 30,
                    margin: EdgeInsets.only(left: 7),
                    decoration: const BoxDecoration(
                      border: Border(left: BorderSide(color: AppTokens.brand, width: 2)),
                    ),
                  ),
                  _buildRouteStep(ride.arrivalTime, ride.to),

                  Divider(height: 40),

                  // Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total price for 1 passenger"),
                      Text("PKR ${ride.price}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTokens.brand)),
                    ],
                  ),

                  Divider(height: 40),

                  // Driver Info
                  Text("Driver", style: TextStyle(fontWeight: FontWeight.bold)),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(backgroundImage: NetworkImage(ride.driverImage)),
                    title: Text(ride.driverName),
                    subtitle: Text("Verified Profile • Rarely cancels"),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ),
          ),

          // Book Button
          Padding(
            padding: EdgeInsets.all(AppTokens.space4),
            child: SizedBox(
              width: double.infinity,
              child: AppButton.primary("Book", onPressed: () {
                // Navigate to Booking Logic
              }),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRouteStep(DateTime time, String location) {
    return Row(
      children: [
        Column(
          children: [
            Container(width: 16, height: 16, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppTokens.brand, width: 3))),
          ],
        ),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(DateFormat('HH:mm').format(time), style: TextStyle(fontWeight: FontWeight.bold)),
            Text(location, style: TextStyle(color: Colors.grey[700])),
          ],
        )
      ],
    );
  }
}