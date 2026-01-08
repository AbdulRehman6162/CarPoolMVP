import '../../../../core/error/failure_mapper.dart';
import '../../../../core/result/result.dart';
import '../../domain/repositories/auth_repository.dart';

class ChangePasswordUseCase {
  final AuthRepository _repository;
  ChangePasswordUseCase(this._repository);

  Future<Result<void>> call({required String newPassword}) async {
    try {
      await _repository.changePassword(newPassword);
      return const Success(null);
    } catch (e, st) {
      return FailureResult(FailureMapper.from(e, st));
    }
  }
}
