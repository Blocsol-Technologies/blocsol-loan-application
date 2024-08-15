import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state_data.freezed.dart';

@freezed
class LoginStateData with _$LoginStateData {
  const factory LoginStateData({
    required String pan,
    required String phoneNumber,
  }) = _LoginStateData;
}
