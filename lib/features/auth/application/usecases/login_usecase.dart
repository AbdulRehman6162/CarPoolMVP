import '../../../../core/error/failure_mapper.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/auth_credential.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;
  LoginUseCase(this._repository);

  Future<Result<AuthUser>> call({
    required String email,
    required String password,
  }) async {
    try {
      final user =
          await _repository.signIn(EmailPasswordLoginCredential(email, password));
      return Success(user);
    } catch (e, st) {
      return FailureResult(FailureMapper.from(e, st));
    }
  }
}

