import 'package:freezed_annotation/freezed_annotation.dart';

part 'signup_state.freezed.dart';

@freezed
class SignupStateData with _$SignupStateData {
  const factory SignupStateData({
    required String gstNumber,
    required String gstUsername,
    required String email,
    required String phoneNumber,
    required String gstOTP,
    required String udyamOTP,
    required String emailOTP,
    required String emailOTPId,
    required String phoneOTP,
    required String udyamNumber,
    required String companyLegalName,
    required String businessLocation,
    required String gstRegistrationDate,
    required String accountPassword,
  }) = _SignupStateData;

  static const SignupStateData initial = SignupStateData(
    gstNumber: '',
    gstUsername: '',
    email: '',
    phoneNumber: '',
    gstOTP: '',
    udyamOTP: '',
    emailOTP: '',
    emailOTPId: '',
    phoneOTP: '',
    udyamNumber: '',
    companyLegalName: '',
    businessLocation: '',
    gstRegistrationDate: '',
    accountPassword: '',
  );
}
