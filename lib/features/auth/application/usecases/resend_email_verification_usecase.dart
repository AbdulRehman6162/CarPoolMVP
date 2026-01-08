import '../../../../core/error/failure_mapper.dart';
import '../../../../core/result/result.dart';
import '../../domain/repositories/auth_repository.dart';

class ResendEmailVerificationUseCase {
  final AuthRepository _repository;
  ResendEmailVerificationUseCase(this._repository);

  Future<Result<void>> call({required String email}) async {
    try {
      await _repository.resendEmailVerification(email);
      return const Success(null);
    } catch (e, st) {
      return FailureResult(FailureMapper.from(e, st));
    }
  }
}
