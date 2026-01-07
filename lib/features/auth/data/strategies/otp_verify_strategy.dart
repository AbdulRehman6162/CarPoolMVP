import '../../domain/entities/auth_credential.dart';
import '../../domain/entities/auth_user.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/auth_user_model.dart';
import 'auth_strategy.dart';

class OtpVerifyStrategy extends AuthStrategy {
  final AuthRemoteDataSource _remote;
  OtpVerifyStrategy(this._remote);

  @override
  bool canHandle(AuthCredential credential) => credential is OtpVerifyCredential;

  @override
  Future<AuthUser?> signIn(AuthCredential credential) async {
    final c = credential as OtpVerifyCredential;
    final AuthUserModel model = await _remote.verifyOtp(c.email, c.otp);
    return model.toEntity();
  }
}
