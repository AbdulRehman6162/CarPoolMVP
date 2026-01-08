import '../../../../core/error/failure_mapper.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/auth_credential.dart';
import '../../domain/repositories/auth_repository.dart';

class RequestPhoneOtpUseCase {
  final AuthRepository _repository;
  RequestPhoneOtpUseCase(this._repository);

  Future<Result<void>> call({
    required String phoneE164,
    required AuthOtpChannel preferredChannel,
  }) async {
    try {
      await _repository.requestPhoneOtp(
        PhoneOtpStartCredential(phoneE164, preferredChannel: preferredChannel),
      );
      return const Success(null);
    } catch (e, st) {
      return FailureResult(FailureMapper.from(e, st));
    }
  }
}
