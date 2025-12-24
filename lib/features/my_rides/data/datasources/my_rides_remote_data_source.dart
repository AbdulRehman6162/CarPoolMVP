import '../models/my_ride_model.dart';
import '../models/ride_passenger_model.dart';
import '../models/ride_user_model.dart';

/// Mock remote datasource (replace with API later).
class MyRidesRemoteDataSource {
  Future<List<MyRideModel>> fetchMyRides() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    final now = DateTime.now();
    return [
      MyRideModel(
        id: 'r1',
        fromCity: 'Karachi',
        fromAddress: 'Block 13, Gulistan-e-Johar',
        toCity: 'Hyderabad',
        toAddress: 'Main Rd, Autobhan',
        departureTime: now.add(const Duration(days: 2)),
        estimatedMinutes: 140,
        pricePerSeat: 700,
        seatsTotal: 3,
        seatsAvailable: 2,
        role: 'PASSENGER',
        status: 'WAITING',
        isArchived: false,
        driver: const RideUserModel(id: 'd1', name: 'Usman Ali', isVerified: true),
        passengers: const [],
        vehicleName: 'Toyota Aqua',
      ),
      MyRideModel(
        id: 'r2',
        fromCity: 'Islamabad',
        fromAddress: 'F-8 Markaz, Islamabad',
        toCity: 'Lahore',
        toAddress: 'Kalma Chowk, Lahore',
        departureTime: now.add(const Duration(days: 4)),
        estimatedMinutes: 260,
        pricePerSeat: 1200,
        seatsTotal: 3,
        seatsAvailable: 2,
        role: 'DRIVER',
        status: 'CONFIRMED',
        isArchived: false,
        driver: const RideUserModel(id: 'me', name: 'You', isVerified: true),
        passengers: const [
          RidePassengerModel(
            user: RideUserModel(id: 'p1', name: 'Zoya Khan', isVerified: false),
            seatsBooked: 1,
            note: 'I will bring a small bag.',
          ),
        ],
        vehicleName: 'Honda Civic',
      ),
      MyRideModel(
        id: 'r3',
        fromCity: 'Islamabad',
        fromAddress: 'E-11, Main Street 123',
        toCity: 'Lahore',
        toAddress: 'Liberty Market, Gulberg',
        departureTime: now.subtract(const Duration(days: 1)),
        estimatedMinutes: 190,
        pricePerSeat: 1500,
        seatsTotal: 3,
        seatsAvailable: 1,
        role: 'PASSENGER',
        status: 'COMPLETED',
        isArchived: false,
        driver: const RideUserModel(id: 'd2', name: 'Shree', isVerified: true),
        passengers: const [],
        vehicleName: 'Toyota Aqua',
      ),
    ];
  }

  Future<List<MyRideModel>> fetchArchivedRides() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    final now = DateTime.now();
    return [
      MyRideModel(
        id: 'a1',
        fromCity: 'Islamabad',
        fromAddress: 'Main Street, Block F',
        toCity: 'Lahore',
        toAddress: 'City Center, Near Grand Mosque',
        departureTime: now.subtract(const Duration(days: 10)),
        estimatedMinutes: 190,
        pricePerSeat: 450,
        seatsTotal: 2,
        seatsAvailable: 0,
        role: 'DRIVER',
        status: 'CANCELLED',
        isArchived: true,
        driver: const RideUserModel(id: 'me', name: 'You', isVerified: true),
        passengers: const [
          RidePassengerModel(
            user: RideUserModel(id: 'p3', name: 'Zoya Khan', isVerified: false),
            seatsBooked: 1,
            note: null,
          ),
        ],
        vehicleName: 'Suzuki Alto',
      ),
      MyRideModel(
        id: 'a2',
        fromCity: 'Islamabad',
        fromAddress: 'Main Street 123, E-11',
        toCity: 'Lahore',
        toAddress: 'Liberty Market, Gulberg',
        departureTime: now.subtract(const Duration(days: 20)),
        estimatedMinutes: 190,
        pricePerSeat: 1500,
        seatsTotal: 3,
        seatsAvailable: 1,
        role: 'PASSENGER',
        status: 'CANCELLED',
        isArchived: true,
        driver: const RideUserModel(id: 'd2', name: 'Shree', isVerified: true),
        passengers: const [],
        vehicleName: 'Toyota Aqua',
      ),
    ];
  }

  Future<MyRideModel> fetchRideDetails(String rideId) async {
    final all = [...await fetchMyRides(), ...await fetchArchivedRides()];
    return all.firstWhere((e) => e.id == rideId);
  }
}
