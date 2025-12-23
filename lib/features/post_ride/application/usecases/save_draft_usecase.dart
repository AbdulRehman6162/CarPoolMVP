import '../../domain/entities/ride_draft.dart';
import '../../domain/repositories/ride_draft_repository.dart';

class SaveDraftUseCase {
  final RideDraftRepository _repo;
  SaveDraftUseCase(this._repo);

  Future<void> call(RideDraft draft) => _repo.saveDraft(draft);
}
