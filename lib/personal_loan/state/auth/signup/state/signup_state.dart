import 'package:freezed_annotation/freezed_annotation.dart';

part 'signup_state.freezed.dart';

@freezed
class SignupStateData with _$SignupStateData {
  const factory SignupStateData({
    required String email,
    required String imageURL,
    required String phoneNumber,

    // personal details
    required String firstName,
    required String lastName,
    required String dob,
    required String gender,
    required String pan,
    required String address,
    required String city,
    required String state,
    required String pincode,
    required String udyam,
    required String companyName,
    required bool udyamValidationRequired,
    required bool udyamValidated,
    required bool personalDetailsValidated,
  }) = _SignupStateData;

  static SignupStateData initial = const SignupStateData(
      email: "",
      imageURL: "",
      phoneNumber: "",
      firstName: "",
      lastName: "",
      dob: "",
      gender: "",
      pan: "",
      address: "",
      city: "",
      state: "",
      pincode: "",
      udyam: "",
      companyName: "",
      udyamValidationRequired: false,
      udyamValidated: false,
      personalDetailsValidated: false);
}
