import '../../../../core/error/failure_mapper.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/auth_credential.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

class VerifyOtpUseCase {
  final AuthRepository _repository;
  VerifyOtpUseCase(this._repository);

  Future<Result<AuthUser>> call({
    required String email,
    required String otp,
  }) async {
    try {
      final user = await _repository.verifyOtp(OtpVerifyCredential(email, otp));
      return Success(user);
    } catch (e, st) {
      return FailureResult(FailureMapper.from(e, st));
    }
  }
}

