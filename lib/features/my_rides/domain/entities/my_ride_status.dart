enum MyRideStatus {
  waitingForApproval,
  pendingDriver,
  confirmed,
  cancelled,
  completed,
}

extension MyRideStatusX on MyRideStatus {
  String get label {
    switch (this) {
      case MyRideStatus.waitingForApproval:
        return 'Waiting for approval';
      case MyRideStatus.pendingDriver:
        return 'Pending driver';
      case MyRideStatus.confirmed:
        return 'Confirmed';
      case MyRideStatus.cancelled:
        return 'Cancelled';
      case MyRideStatus.completed:
        return 'Completed';
    }
  }
}
