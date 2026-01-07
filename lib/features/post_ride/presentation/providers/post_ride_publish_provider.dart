import 'package:flutter/foundation.dart';

import '../../application/usecases/publish_return_ride_usecase.dart';
import '../../application/usecases/publish_ride_usecase.dart';
import '../../domain/entities/ride_draft.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/error/failure_mapper.dart';

class PostRidePublishProvider extends ChangeNotifier {
  final PublishRideUseCase _publishRide;
  final PublishReturnRideUseCase _publishReturnRide;

  PostRidePublishProvider(this._publishRide, this._publishReturnRide);

  bool _loading = false;
  String? _lastPublishedRideId;
  Failure? _failure;
bool get loading => _loading;
  String? get lastPublishedRideId => _lastPublishedRideId;
  String? get errorMessage => _failure?.userMessage;
  Failure? get failure => _failure;

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void _setError(Failure? failure) {
    _failure = failure;
    notifyListeners();
  }

  /// Returns the published ride id, or null if publishing failed.
  Future<String?> publish(RideDraft draft) async {
    _setError(null);
    _setLoading(true);

    try {
      final id = await _publishRide(draft);
      _lastPublishedRideId = id;
      return id;
    } catch (e) {
      _setError(FailureMapper.from(e));
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Returns the published return ride id, or null if publishing failed.
  Future<String?> publishReturn(RideDraft returnDraft) async {
    _setError(null);
    _setLoading(true);

    try {
      final id = await _publishReturnRide(returnDraft);
      return id;
    } catch (e) {
      _setError(FailureMapper.from(e));
      return null;
    } finally {
      _setLoading(false);
    }
  }
}
