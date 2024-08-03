import 'package:freezed_annotation/freezed_annotation.dart';

part 'signup_state.freezed.dart';

@freezed
class SignupStateData with _$SignupStateData {
  const factory SignupStateData({
    required String gstNumber,
    required String gstUsername,
    required String email,
    required String emailOtpId,
    required String phoneNumber,
    required String udyamNumber,
    required String companyLegalName,
    required String businessLocation,
    required String gstRegistrationDate,
  }) = _SignupStateData;

  static const SignupStateData initial = SignupStateData(
    gstNumber: '',
    gstUsername: '',
    email: '',
    emailOtpId: '',
    phoneNumber: '',
    udyamNumber: '',
    companyLegalName: '',
    businessLocation: '',
    gstRegistrationDate: '',
  );
}
