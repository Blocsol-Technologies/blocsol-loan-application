import 'package:blocsol_loan_application/global_state/auth/auth.dart';
import 'package:blocsol_loan_application/personal_loan/state/auth/signup/http_controller.dart';
import 'package:blocsol_loan_application/personal_loan/state/auth/signup/state/signup_state.dart';
import 'package:blocsol_loan_application/utils/http_service.dart';
import 'package:blocsol_loan_application/utils/regex.dart';
import 'package:blocsol_loan_application/utils/riverpod.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'signup.g.dart';

@riverpod
class PersonalLoanSignup extends _$PersonalLoanSignup {
  @override
  SignupStateData build() {
   ref.cacheFor(const Duration(seconds: 10), (){});
    return  SignupStateData.initial;
  }


  void updateEmailDetails(String email, String imageURL) {
    state = state.copyWith(email: email, imageURL: imageURL);
  }

  void updatePhoneNumber(String phoneNumber) {
    state = state.copyWith(phoneNumber: phoneNumber);
  }

  void setUdyamValidationRequired(bool value) {
    state = state.copyWith(udyamValidationRequired: value);
  }

  void reset() {
    ref.invalidateSelf();
  }

  // Backend Functionality ================================================

  // 2. Send Mobile OTP
  Future<ServerResponse> sendMobileOTP(
      String phoneNumber, String signature, CancelToken cancelToken) async {
    if (!RegexProvider.phoneRegex.hasMatch(phoneNumber)) {
      return ServerResponse(
          success: false, message: "Invalid Phone Number", data: null);
    }

    var response = await PersonalLoanSignupHttpController()
        .sendMobileOtp(phoneNumber, signature, cancelToken);

    if (response.success) {
      state = state.copyWith(phoneNumber: phoneNumber);
    }

    return response;
  }

  // 3. Verify Mobile OTP
  Future<ServerResponse> verifyMobileOTP(
      String phoneNumber, String otp, CancelToken cancelToken) async {
    if (!RegexProvider.phoneRegex.hasMatch(phoneNumber)) {
      return ServerResponse(
          success: false, message: "Invalid Phone Number", data: null);
    }

    if (!RegexProvider.otpRegex.hasMatch(otp)) {
      return ServerResponse(success: false, message: "Invalid OTP", data: null);
    }

    return await PersonalLoanSignupHttpController().verifyMobileOTP(
        phoneNumber, otp, state.email, state.imageURL, cancelToken);
  }

  // 4. Send Personal Details
  Future<ServerResponse> setPersonalDetails(String firstName, String lastName,
      String dob, String gender, String pan, CancelToken cancelToken) async {
    if (state.udyamValidationRequired && !state.udyamValidated) {
      return ServerResponse(
          success: false, message: "Please validate Udyam", data: null);
    }

    if (!RegexProvider.panRegex.hasMatch(pan)) {
      return ServerResponse(success: false, message: "Invalid Pan", data: null);
    }

    if (firstName.isEmpty ||
        lastName.isEmpty ||
        dob.isEmpty ||
        gender.isEmpty) {
      return ServerResponse(
          success: false,
          message:
              "First Name, Last Name. DOB and Gender fields cannot be empty",
          data: null);
    }

    var response = await PersonalLoanSignupHttpController()
        .setPersonalDetails(firstName, lastName, dob, gender, pan, cancelToken);

    if (response.success) {
      state = state.copyWith(
        firstName: firstName,
        lastName: lastName,
        dob: dob,
        gender: gender,
        pan: pan,
        personalDetailsValidated: true,
      );
    }

    return response;
  }

  // 4 b. Verify Udyam details
  Future<ServerResponse> verifyUdyamNumber(
      String udyam, CancelToken cancelToken) async {
    if (!RegexProvider.udyamRegex.hasMatch(udyam)) {
      return ServerResponse(
          success: false, message: "Invalid MSME Number", data: null);
    }

    var response = await PersonalLoanSignupHttpController()
        .verifyUdyamNumber(state.phoneNumber, udyam, cancelToken);

    if (response.success) {
      state = state.copyWith(
        udyamValidated: true,
        udyam: udyam,
        companyName: response.data ?? "",
      );
    }

    return response;
  }

  // 5. Add Address Details
  Future<ServerResponse> addAddressDetails(String address, String city,
      String stateVal, String pincode, CancelToken cancelToken) async {
    if (address.isEmpty ||
        city.isEmpty ||
        stateVal.isEmpty ||
        pincode.isEmpty) {
      return ServerResponse(
          success: false,
          message: "Please fill all the address fields",
          data: null);
    }

    var response = await PersonalLoanSignupHttpController().addAddressDetails(
        state.phoneNumber, address, city, stateVal, pincode, cancelToken);

    if (response.success) {
      state = state.copyWith(
        address: address,
        city: city,
        state: stateVal,
        pincode: pincode,
      );
    }

    return response;
  }

  // 6. Set password
  Future<ServerResponse> setPassword(
      String password, CancelToken cancelToken) async {
    if (!RegexProvider.passwordRegex.hasMatch(password)) {
      return ServerResponse(
          success: false,
          message:
              "Invalid password. It must have 8 characters, 1 uppercase, 1 lowercase, 1 number and 1 special character",
          data: null);
    }

    var response = await PersonalLoanSignupHttpController()
        .setPassword(state.phoneNumber, password, cancelToken);

    if (response.success) {
      await ref
          .read(authProvider.notifier)
          .setPersonalLoanAuthToken(response.data);
    }

    return response;
  }
}
