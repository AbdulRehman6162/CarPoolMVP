import '../../domain/entities/ride_draft.dart';
import '../../domain/repositories/ride_draft_repository.dart';

class CreateNewDraftUseCase {
  final RideDraftRepository _repo;
  CreateNewDraftUseCase(this._repo);

  Future<RideDraft> call() => _repo.createNewDraft();
}
