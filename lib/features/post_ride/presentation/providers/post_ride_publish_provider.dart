import 'package:flutter/foundation.dart';
import '../../application/usecases/publish_return_ride_usecase.dart';
import '../../application/usecases/publish_ride_usecase.dart';
import '../../domain/entities/ride_draft.dart';

class PostRidePublishProvider extends ChangeNotifier {
  final PublishRideUseCase _publishRide;
  final PublishReturnRideUseCase _publishReturnRide;

  PostRidePublishProvider(this._publishRide, this._publishReturnRide);

  bool _loading = false;
  String? _lastPublishedRideId;

  bool get loading => _loading;
  String? get lastPublishedRideId => _lastPublishedRideId;

  Future<String> publish(RideDraft draft) async {
    _loading = true;
    notifyListeners();
    try {
      final id = await _publishRide(draft);
      _lastPublishedRideId = id;
      return id;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<String> publishReturn(RideDraft returnDraft) async {
    _loading = true;
    notifyListeners();
    try {
      final id = await _publishReturnRide(returnDraft);
      return id;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
