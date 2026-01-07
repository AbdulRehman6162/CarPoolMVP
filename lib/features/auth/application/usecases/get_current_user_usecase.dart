import '../../../../core/error/failure_mapper.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

class GetCurrentUserUseCase {
  final AuthRepository _repository;
  GetCurrentUserUseCase(this._repository);

  Future<Result<AuthUser?>> call() async {
    try {
      final user = await _repository.getCurrentUser();
      return Success(user);
    } catch (e, st) {
      return FailureResult(FailureMapper.from(e, st));
    }
  }
}

