import '../../../../core/error/failure_mapper.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/auth_credential.dart';
import '../../domain/repositories/auth_repository.dart';

/// Starts OAuth sign-in for a provider (Google / Apple / etc).
///
/// In this codebase, [AuthRepository.signIn] returns an [AuthUser] and may throw.
/// OAuth completion typically happens via deep-link callback + auth state updates,
/// but initiating the flow can still fail (bad redirect URL, provider disabled, etc).
///
/// This usecase wraps that into [Result<void>] for consistent UI handling.
class StartOAuthSignInUseCase {
  final AuthRepository _repository;

  StartOAuthSignInUseCase(this._repository);

  Future<Result<void>> call(OAuthProvider provider) async {
    try {
      // OAuthSignInCredential uses a positional constructor in your project.
      await _repository.signIn(OAuthSignInCredential(provider));
      return const Success(null);
    } catch (e, st) {
      return FailureResult<void>(FailureMapper.from(e, st));
    }
  }
}
