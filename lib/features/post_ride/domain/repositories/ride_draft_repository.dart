import '../entities/ride_draft.dart';

abstract class RideDraftRepository {
  Future<RideDraft> createNewDraft();
  Future<RideDraft?> getDraftById(String id);
  Future<void> saveDraft(RideDraft draft);
  Future<void> deleteDraft(String id);
}
