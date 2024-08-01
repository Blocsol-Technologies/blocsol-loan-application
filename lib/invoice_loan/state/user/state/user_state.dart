import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_state.freezed.dart';

@freezed
class UserStateData with _$UserStateData {
  const factory UserStateData({
    required String gstNumber,
    required String gstUsername,
    required String email,
    required String phone,
    required String udyamNumber,
    required String legalName,
    required String tradeName,
    required String businessLocation,
    required bool fetchingData,
  }) = _UserStateData;

  static const UserStateData initial = UserStateData(
    gstNumber: 'Loading...',
    gstUsername: 'Loading...',
    email: 'Loading...',
    phone: 'Loading...',
    udyamNumber: 'Loading...',
    legalName: 'Loading...',
    tradeName: 'Loading...',
    businessLocation: 'Loading...',
    fetchingData: false,
  );
}
