import '../../../../core/error/failure_mapper.dart';
import '../../../../core/result/result.dart';
import '../../domain/repositories/auth_repository.dart';

class RequestPasswordResetUseCase {
  final AuthRepository _repository;
  RequestPasswordResetUseCase(this._repository);

  Future<Result<void>> call({required String email}) async {
    try {
      await _repository.requestPasswordReset(email);
      return const Success(null);
    } catch (e, st) {
      return FailureResult(FailureMapper.from(e, st));
    }
  }
}
