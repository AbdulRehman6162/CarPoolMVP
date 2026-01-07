import '../../../../core/error/failure_mapper.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/auth_credential.dart';
import '../../domain/repositories/auth_repository.dart';

class SignupUseCase {
  final AuthRepository _repository;
  SignupUseCase(this._repository);

  Future<Result<void>> call({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      await _repository.signUp(
        EmailPasswordSignupCredential(name: name, email: email, password: password),
      );
      return const Success(null);
    } catch (e, st) {
      return FailureResult(FailureMapper.from(e, st));
    }
  }
}

