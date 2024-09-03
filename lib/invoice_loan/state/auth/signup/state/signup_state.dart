import 'package:freezed_annotation/freezed_annotation.dart';

part 'signup_state.freezed.dart';

@freezed
class InvoiceLoanSignupStateData with _$InvoiceLoanSignupStateData {
  const factory InvoiceLoanSignupStateData({
    required String gstNumber,
    required String gstUsername,
    required String email,
    required String emailOtpId,
    required String phoneNumber,
    required String udyamNumber,
    required String companyLegalName,
    required String businessLocation,
    required String gstRegistrationDate,
  }) = _InvoiceLoanSignupStateData;

  static const InvoiceLoanSignupStateData initial = InvoiceLoanSignupStateData(
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
