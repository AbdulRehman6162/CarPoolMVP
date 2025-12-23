import '../../domain/entities/booking_result.dart';
import '../../domain/entities/booking_status.dart';

/// Data Transfer Object for booking result.
/// Keeps data-layer JSON parsing separate from domain entities (LSP-safe).
class BookingResultModel {
  final BookingStatus status;
  final String message;

  const BookingResultModel({
    required this.status,
    required this.message,
  });

  factory BookingResultModel.fromJson(Map<String, dynamic> json) {
    final statusString = json['status'] as String? ?? 'DECLINED';
    final BookingStatus status;
    switch (statusString) {
      case 'CONFIRMED':
        status = BookingStatus.confirmed;
        break;
      case 'PENDING_DRIVER':
        status = BookingStatus.pendingDriver;
        break;
      case 'DECLINED':
      default:
        status = BookingStatus.declined;
        break;
    }

    return BookingResultModel(
      status: status,
      message: json['message'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    String statusString;
    switch (status) {
      case BookingStatus.confirmed:
        statusString = 'CONFIRMED';
        break;
      case BookingStatus.pendingDriver:
        statusString = 'PENDING_DRIVER';
        break;
      case BookingStatus.declined:
        statusString = 'DECLINED';
        break;
    }
    return {
      'status': statusString,
      'message': message,
    };
  }

  BookingResult toEntity() => BookingResult(status: status, message: message);

  static BookingResultModel fromEntity(BookingResult r) => BookingResultModel(
        status: r.status,
        message: r.message,
      );
}
