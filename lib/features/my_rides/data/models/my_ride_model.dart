import '../../domain/entities/my_ride.dart';
import '../../domain/entities/my_ride_role.dart';
import '../../domain/entities/my_ride_status.dart';
import 'ride_passenger_model.dart';
import 'ride_user_model.dart';

class MyRideModel {
  final String id;
  final String fromCity;
  final String fromAddress;
  final String toCity;
  final String toAddress;
  final DateTime departureTime;
  final int estimatedMinutes;
  final double pricePerSeat;
  final int seatsTotal;
  final int seatsAvailable;
  final String role; // 'DRIVER' or 'PASSENGER'
  final String status; // 'WAITING', 'CONFIRMED', 'CANCELLED', 'COMPLETED', 'PENDING_DRIVER'
  final bool isArchived;
  final RideUserModel driver;
  final List<RidePassengerModel> passengers;
  final String? vehicleName;

  const MyRideModel({
    required this.id,
    required this.fromCity,
    required this.fromAddress,
    required this.toCity,
    required this.toAddress,
    required this.departureTime,
    required this.estimatedMinutes,
    required this.pricePerSeat,
    required this.seatsTotal,
    required this.seatsAvailable,
    required this.role,
    required this.status,
    required this.isArchived,
    required this.driver,
    required this.passengers,
    this.vehicleName,
  });

  factory MyRideModel.fromJson(Map<String, dynamic> json) => MyRideModel(
        id: json['id'] as String,
        fromCity: json['fromCity'] as String,
        fromAddress: json['fromAddress'] as String,
        toCity: json['toCity'] as String,
        toAddress: json['toAddress'] as String,
        departureTime: DateTime.parse(json['departureTime'] as String),
        estimatedMinutes: json['estimatedMinutes'] as int? ?? 120,
        pricePerSeat: (json['pricePerSeat'] as num).toDouble(),
        seatsTotal: json['seatsTotal'] as int? ?? 3,
        seatsAvailable: json['seatsAvailable'] as int? ?? 0,
        role: json['role'] as String? ?? 'PASSENGER',
        status: json['status'] as String? ?? 'WAITING',
        isArchived: json['isArchived'] as bool? ?? false,
        driver: RideUserModel.fromJson(json['driver'] as Map<String, dynamic>),
        passengers: ((json['passengers'] as List?) ?? const [])
            .map((e) => RidePassengerModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        vehicleName: json['vehicleName'] as String?,
      );

  MyRide toEntity() {
    final MyRideRole r = role == 'DRIVER' ? MyRideRole.driver : MyRideRole.passenger;

    final MyRideStatus s;
    switch (status) {
      case 'CONFIRMED':
        s = MyRideStatus.confirmed;
        break;
      case 'CANCELLED':
        s = MyRideStatus.cancelled;
        break;
      case 'COMPLETED':
        s = MyRideStatus.completed;
        break;
      case 'PENDING_DRIVER':
        s = MyRideStatus.pendingDriver;
        break;
      case 'WAITING':
      default:
        s = MyRideStatus.waitingForApproval;
        break;
    }

    return MyRide(
      id: id,
      fromCity: fromCity,
      fromAddress: fromAddress,
      toCity: toCity,
      toAddress: toAddress,
      departureTime: departureTime,
      estimatedDuration: Duration(minutes: estimatedMinutes),
      pricePerSeat: pricePerSeat,
      seatsTotal: seatsTotal,
      seatsAvailable: seatsAvailable,
      role: r,
      status: s,
      isArchived: isArchived,
      driver: driver.toEntity(),
      passengers: passengers.map((p) => p.toEntity()).toList(),
      vehicleName: vehicleName,
    );
  }
}
