import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    required String invoiceLoanToken,
    required String personalLoanToken,
  }) = _AuthState;

  factory AuthState.initialize() => const AuthState(
        invoiceLoanToken: "",
        personalLoanToken: "",
      );
}
