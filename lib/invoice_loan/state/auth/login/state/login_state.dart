import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState({
    required String phoneNumber,
    required String deviceId,
  }) = _LoginState;

  factory LoginState.initialize() => const LoginState(
        phoneNumber: "",
        deviceId: "",
      );
}