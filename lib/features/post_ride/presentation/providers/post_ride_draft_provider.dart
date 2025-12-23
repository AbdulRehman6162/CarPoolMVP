import 'package:flutter/foundation.dart';
import '../../application/usecases/create_new_draft_usecase.dart';
import '../../application/usecases/get_route_options_usecase.dart';
import '../../application/usecases/save_draft_usecase.dart';
import '../../domain/entities/location_selection.dart';
import '../../domain/entities/ride_draft.dart';
import '../../domain/entities/route_option.dart';

class PostRideDraftProvider extends ChangeNotifier {
  final CreateNewDraftUseCase _createNewDraft;
  final SaveDraftUseCase _saveDraft;
  final GetRouteOptionsUseCase _getRouteOptions;

  PostRideDraftProvider(
      this._createNewDraft,
      this._saveDraft,
      this._getRouteOptions,
      );

  RideDraft? _draft;
  bool _loadingRoutes = false;
  List<RouteOption> _routeOptions = const [];

  RideDraft? get draft => _draft;
  bool get hasDraft => _draft != null;

  bool get loadingRoutes => _loadingRoutes;
  List<RouteOption> get routeOptions => _routeOptions;

  Future<void> ensureDraft() async {
    if (_draft != null) return;
    _draft = await _createNewDraft();
    notifyListeners();
  }

  Future<void> _persist() async {
    final d = _draft;
    if (d == null) return;
    await _saveDraft(d);
  }

  Future<void> setPickupAddress(String addressLabel) async {
    await ensureDraft();
    _draft = _draft!.copyWith(pickup: LocationSelection(addressLabel: addressLabel));
    notifyListeners();
    await _persist();
  }

  Future<void> setPickupPin(double lat, double lng) async {
    await ensureDraft();
    final p = _draft!.pickup ?? const LocationSelection(addressLabel: '');
    _draft = _draft!.copyWith(pickup: p.copyWith(lat: lat, lng: lng));
    notifyListeners();
    await _persist();
  }

  Future<void> setDropoffAddress(String addressLabel) async {
    await ensureDraft();
    _draft = _draft!.copyWith(dropoff: LocationSelection(addressLabel: addressLabel));
    notifyListeners();
    await _persist();
  }

  Future<void> setDropoffPin(double lat, double lng) async {
    await ensureDraft();
    final d = _draft!.dropoff ?? const LocationSelection(addressLabel: '');
    _draft = _draft!.copyWith(dropoff: d.copyWith(lat: lat, lng: lng));
    notifyListeners();
    await _persist();
  }

  bool get pickupNeedsPin => _draft?.pickup != null && !(_draft!.pickup!.hasPin);
  bool get dropoffNeedsPin => _draft?.dropoff != null && !(_draft!.dropoff!.hasPin);

  Future<void> loadRouteOptions() async {
    final d = _draft;
    if (d == null || d.pickup == null || d.dropoff == null) return;

    _loadingRoutes = true;
    notifyListeners();
    try {
      _routeOptions = await _getRouteOptions(pickup: d.pickup!, dropoff: d.dropoff!, max: 3);
    } finally {
      _loadingRoutes = false;
      notifyListeners();
    }
  }

  Future<void> selectRoute(RouteOption option) async {
    await ensureDraft();
    _draft = _draft!.copyWith(selectedRoute: option);
    notifyListeners();
    await _persist();
  }

  Future<void> setDepartureDate(DateTime date) async {
    await ensureDraft();
    final normalized = DateTime(date.year, date.month, date.day);
    _draft = _draft!.copyWith(departureDate: normalized);
    notifyListeners();
    await _persist();
  }

  Future<void> setDepartureTime({required int hour, required int minute}) async {
    await ensureDraft();
    _draft = _draft!.copyWith(departureTime: TimeOfDayValue(hour: hour, minute: minute));
    notifyListeners();
    await _persist();
  }

  Future<void> setSeatsOffered(int seats) async {
    await ensureDraft();
    _draft = _draft!.copyWith(seatsOffered: seats);
    notifyListeners();
    await _persist();
  }

  Future<void> setInstantBooking(bool enabled) async {
    await ensureDraft();
    _draft = _draft!.copyWith(instantBooking: enabled);
    notifyListeners();
    await _persist();
  }

  Future<void> setPricePerSeatPkr(int value) async {
    await ensureDraft();
    _draft = _draft!.copyWith(pricePerSeatPkr: value);
    notifyListeners();
    await _persist();
  }

  Future<void> setComments(String value) async {
    await ensureDraft();
    _draft = _draft!.copyWith(comments: value);
    notifyListeners();
    await _persist();
  }

  Future<void> setVehicleId(String vehicleId) async {
    await ensureDraft();
    _draft = _draft!.copyWith(vehicleId: vehicleId);
    notifyListeners();
    await _persist();
  }

  /// Creates a return-ride draft based on the outbound ride:
  /// swap pickup/dropoff + keep settings.
  Future<RideDraft> createReturnDraft() async {
    final d = _draft;
    if (d == null) throw StateError('Draft not initialized');
    final ret = RideDraft(
      id: 'draft_return_${DateTime.now().millisecondsSinceEpoch}',
      pickup: d.dropoff,
      dropoff: d.pickup,
      seatsOffered: d.seatsOffered,
      instantBooking: d.instantBooking,
      pricePerSeatPkr: d.pricePerSeatPkr,
      vehicleId: d.vehicleId,
    );
    return ret;
  }
}
