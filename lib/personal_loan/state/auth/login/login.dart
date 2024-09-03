import 'package:blocsol_loan_application/global_state/auth/auth.dart';
import 'package:blocsol_loan_application/personal_loan/state/auth/login/http_controller.dart';
import 'package:blocsol_loan_application/personal_loan/state/auth/login/state/login_state_data.dart';
import 'package:blocsol_loan_application/utils/http_service.dart';
import 'package:blocsol_loan_application/utils/regex.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login.g.dart';

@riverpod
class PersonalLoginState extends _$PersonalLoginState {
  @override
  LoginStateData build() {
    ref.keepAlive();
    return const LoginStateData(pan: "", phoneNumber: "");
  }

  void reset() {
    ref.invalidateSelf();
  }

  // 1. Validate Password
  Future<ServerResponse> verifyPassword(String phoneNumber, String password,
      String signature, CancelToken cancelToken) async {
    if (!RegexProvider.phoneRegex.hasMatch(phoneNumber)) {
      return ServerResponse(
          success: false, message: "Invalid Phone Number", data: null);
    }

    if (!RegexProvider.passwordRegex.hasMatch(password)) {
      return ServerResponse(
          success: false, message: "Invalid Password", data: null);
    }

    var response = await PersonalLoanLoginHttpController()
        .validatePassword(phoneNumber, password, signature, cancelToken);

    if (response.success) {
      state = state.copyWith(pan: response.data, phoneNumber: phoneNumber);
    }

    return response;
  }

  // 2. Verify OTP
  Future<ServerResponse> verifyMobileOTP(
      String otp, CancelToken cancelToken) async {
    if (!RegexProvider.phoneRegex.hasMatch(state.phoneNumber)) {
      return ServerResponse(
          success: false, message: "Invalid Phone Number", data: null);
    }

    if (!RegexProvider.otpRegex.hasMatch(otp)) {
      return ServerResponse(success: false, message: "Invalid OTP", data: null);
    }

    var response = await PersonalLoanLoginHttpController()
        .validateOtp(state.phoneNumber, otp, state.pan, cancelToken);

    if (response.success) {
      ref.read(authProvider.notifier).setPersonalLoanAuthToken(response.data);
    }

    return response;
  }
}
