import 'package:blocsol_loan_application/global_state/auth/auth.dart';
import 'package:blocsol_loan_application/invoice_loan/state/auth/login/http_controller.dart';
import 'package:blocsol_loan_application/invoice_loan/state/auth/login/state/login_state.dart';
import 'package:blocsol_loan_application/utils/http_service.dart';
import 'package:blocsol_loan_application/utils/regex.dart';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login.g.dart';

@riverpod
class Login extends _$Login {
  @override
  LoginState build() {
    return LoginState.initialize();
  }

  void setPhoneNumber(String phoneNumber) {
    state = state.copyWith(phoneNumber: phoneNumber);
  }

  void setDeviceId(String deviceId) {
    state = state.copyWith(deviceId: deviceId);
  }

  // HTTP Requests
  Future<ServerResponse> validatePassword(String phoneNumber, String password, CancelToken cancelToken) async {
    var deviceId = state.deviceId;

    if (!RegexProvider.phoneRegex.hasMatch(phoneNumber)) {
      return ServerResponse(success: false, message: "invalid phone number");
    }

    if (!RegexProvider.passwordRegex.hasMatch(password)) {
      return ServerResponse(success: false, message: "invalid password");
    }

    var response = await LoginHttpController.validatePassword(
        phoneNumber, password, deviceId, cancelToken);

    return response;
  }

  Future<ServerResponse> validateLoginOTP(
      String otp, CancelToken cancelToken) async {
    var phoneNumber = state.phoneNumber;

    if (!RegexProvider.phoneRegex.hasMatch(phoneNumber)) {
      return ServerResponse(success: false, message: "invalid phone number");
    }

    if (!RegexProvider.otpRegex.hasMatch(otp)) {
      return ServerResponse(success: false, message: "invalid otp");
    }

    var response =
        await LoginHttpController.validateOtp(phoneNumber, otp, cancelToken);

    if (response.success) {
      await ref
          .read(authProvider.notifier)
          .setInvoiceLoanAuthToken(response.data ?? "");
    }

    return response;
  }
}
