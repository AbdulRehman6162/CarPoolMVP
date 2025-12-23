import 'dart:collection';
import '../../domain/entities/ride_draft.dart';
import '../../domain/repositories/ride_draft_repository.dart';

class RideDraftRepositoryMemory implements RideDraftRepository {
  final Map<String, RideDraft> _store = HashMap();

  @override
  Future<RideDraft> createNewDraft() async {
    final id = 'draft_${DateTime.now().millisecondsSinceEpoch}';
    final draft = RideDraft(id: id);
    _store[id] = draft;
    return draft;
  }

  @override
  Future<void> deleteDraft(String id) async {
    _store.remove(id);
  }

  @override
  Future<RideDraft?> getDraftById(String id) async {
    return _store[id];
  }

  @override
  Future<void> saveDraft(RideDraft draft) async {
    _store[draft.id] = draft;
  }
}
