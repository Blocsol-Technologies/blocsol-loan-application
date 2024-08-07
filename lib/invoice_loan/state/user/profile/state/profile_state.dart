import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_state.freezed.dart';

@freezed
class InvoiceLoanUserProfileData with _$InvoiceLoanUserProfileData {
  const factory InvoiceLoanUserProfileData({
    required bool dataConsentProvided,
    required String gstNumber,
    required String gstUsername,
    required String email,
    required String phone,
    required String udyamNumber,
    required String legalName,
    required String tradeName,
    required String businessLocation,
    required bool accountAggregatorSetup,
    required bool fetchingData,
  }) = _InvoiceLoanUserProfileData;

  static const InvoiceLoanUserProfileData initial = InvoiceLoanUserProfileData(
    dataConsentProvided: false,
    gstNumber: 'Loading...',
    gstUsername: 'Loading...',
    email: 'Loading...',
    phone: 'Loading...',
    udyamNumber: 'Loading...',
    legalName: 'Loading...',
    tradeName: 'Loading...',
    businessLocation: 'Loading...',
    accountAggregatorSetup: false,
    fetchingData: false,
  );
}
