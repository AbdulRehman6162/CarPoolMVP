import '../../../../core/error/failure_mapper.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/auth_credential.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

class VerifyPhoneOtpUseCase {
  final AuthRepository _repository;
  VerifyPhoneOtpUseCase(this._repository);

  Future<Result<AuthUser>> call({
    required String phoneE164,
    required String code,
  }) async {
    try {
      final user = await _repository.verifyPhoneOtp(
        PhoneOtpVerifyCredential(phoneE164, code),
      );
      return Success(user);
    } catch (e, st) {
      return FailureResult(FailureMapper.from(e, st));
    }
  }
}
