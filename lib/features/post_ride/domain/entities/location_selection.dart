import 'package:meta/meta.dart';

@immutable
class LocationSelection {
  final String addressLabel;
  final double? lat;
  final double? lng;

  const LocationSelection({
    required this.addressLabel,
    this.lat,
    this.lng,
  });

  bool get hasPin => lat != null && lng != null;

  LocationSelection copyWith({
    String? addressLabel,
    double? lat,
    double? lng,
  }) {
    return LocationSelection(
      addressLabel: addressLabel ?? this.addressLabel,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
    );
  }
}
