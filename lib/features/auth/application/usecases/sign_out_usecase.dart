import '../../../../core/error/failure_mapper.dart';
import '../../../../core/result/result.dart';
import '../../domain/repositories/auth_repository.dart';

class SignOutUseCase {
  final AuthRepository _repository;
  SignOutUseCase(this._repository);

  Future<Result<void>> call() async {
    try {
      await _repository.signOut();
      return const Success(null);
    } catch (e, st) {
      return FailureResult(FailureMapper.from(e, st));
    }
  }
}

