import '../entities/my_ride.dart';

abstract class MyRidesRepository {
  Future<List<MyRide>> getMyRides(); // non-archived
  Future<List<MyRide>> getArchivedRides();
  Future<MyRide> getRideDetails(String rideId);
}
