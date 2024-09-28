import 'package:blocsol_loan_application/global_state/auth/auth.dart';
import 'package:blocsol_loan_application/invoice_loan/state/auth/signup/http_controller.dart';
import 'package:blocsol_loan_application/invoice_loan/state/auth/signup/state/signup_state.dart';
import 'package:blocsol_loan_application/utils/http_service.dart';
import 'package:blocsol_loan_application/utils/regex.dart';
import 'package:blocsol_loan_application/utils/riverpod.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'signup.g.dart';

@riverpod
class InvoiceLoanSignupState extends _$InvoiceLoanSignupState {
  @override
  InvoiceLoanSignupStateData build() {
    ref.cacheFor(const Duration(seconds: 10), () {});
    return InvoiceLoanSignupStateData.initial;
  }

  void dispose() {
    ref.invalidateSelf();
  }

  void updateGstNumber(String gstNumber) {
    state = state.copyWith(gstNumber: gstNumber);
  }

  void updateGstUsername(String gstUsername) {
    state = state.copyWith(gstUsername: gstUsername);
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void updatePhoneNumber(String phoneNumber) {
    state = state.copyWith(phoneNumber: phoneNumber);
  }

  void updateUdyamNumber(String udyamNumber) {
    state = state.copyWith(udyamNumber: udyamNumber);
  }

  void updateCompanyLegalName(String companyLegalName) {
    state = state.copyWith(companyLegalName: companyLegalName);
  }

  void updateBusinessLocation(String businessLocation) {
    state = state.copyWith(businessLocation: businessLocation);
  }

  void updateGstRegistrationDate(String gstRegistrationDate) {
    state = state.copyWith(gstRegistrationDate: gstRegistrationDate);
  }

  void reset() {
    ref.invalidateSelf();
  }

  // Http Requests ================================================

  /* Send Mobile OTP */
  Future<ServerResponse> sendMobileOTP(
      String phoneNumber, String signature, CancelToken cancelToken) async {
    if (!RegexProvider.phoneRegex.hasMatch(phoneNumber)) {
      return ServerResponse(
        success: false,
        message: "Invalid Phone Number",
      );
    }

    var response = await SignupHttpController().sendMobileOtp(
        phoneNumber, signature, cancelToken);

    if (response.success) {
      state = state.copyWith(phoneNumber: phoneNumber);
    }

    return response;
  }

  /* Verify Mobile OTP */
  Future<ServerResponse> verifyMobileOTP(
      String otp, CancelToken cancelToken) async {
    String phoneNumber = state.phoneNumber;

    if (!RegexProvider.phoneRegex.hasMatch(phoneNumber)) {
      return ServerResponse(
        success: false,
        message: "Invalid Phone Number",
      );
    }

    if (!RegexProvider.otpRegex.hasMatch(otp)) {
      return ServerResponse(
        success: false,
        message: "Invalid OTP",
      );
    }

    return SignupHttpController().verifyMobileOtp(phoneNumber, otp, cancelToken);
  }

  /* Verify Email OTP */
  Future<ServerResponse> sendEmailOTP(
      String email, CancelToken cancelToken) async {
    if (!RegexProvider.emailRegex.hasMatch(email)) {
      return ServerResponse(
        success: false,
        message: "Invalid Email Address",
      );
    }

    var response = await SignupHttpController().sendEmailOtp(email, cancelToken);

    if (response.success) {
      state = state.copyWith(email: email, emailOtpId: response.data);
    }

    return response;
  }

  /* Verify Email OTP */
  Future<ServerResponse> verifyEmailOTP(
      String otp, CancelToken cancelToken) async {
    String email = state.email;
    String otpId = state.emailOtpId;

    if (!RegexProvider.emailRegex.hasMatch(email)) {
      return ServerResponse(
        success: false,
        message: "Invalid Email Address",
      );
    }

    if (!RegexProvider.otpRegex.hasMatch(otp)) {
      return ServerResponse(
        success: false,
        message: "Invalid OTP",
      );
    }

    return SignupHttpController().verifyEmailOtp(email, otp, otpId, cancelToken);
  }

  /* Create Preliminary Profile */
  Future<ServerResponse> createPreliminaryProfile(
      CancelToken cancelToken) async {
    String email = state.email;
    String phoneNumber = state.phoneNumber;

    if (!RegexProvider.emailRegex.hasMatch(email)) {
      return ServerResponse(
        success: false,
        message: "Invalid Email Address",
      );
    }

    if (!RegexProvider.phoneRegex.hasMatch(phoneNumber)) {
      return ServerResponse(
        success: false,
        message: "Invalid Phone Nuber",
      );
    }

    return SignupHttpController().createPreliminaryProfile(
        email, phoneNumber, cancelToken);
  }

  /* Validate GST Number */
  Future<ServerResponse> verifyGstNumber(
      String gst, CancelToken cancelToken) async {
    String phoneNumber = state.phoneNumber;

    if (!RegexProvider.gstRegex.hasMatch(gst)) {
      return ServerResponse(
        success: false,
        message: "Invalid GST Number",
      );
    }

    if (!RegexProvider.phoneRegex.hasMatch(phoneNumber)) {
      return ServerResponse(
        success: false,
        message: "Validate phone number first!!",
      );
    }

    var response = await SignupHttpController().verifyGstNumber(
        gst, phoneNumber, cancelToken);

    if (response.success) {
      state = state.copyWith(
          gstNumber: gst,
          companyLegalName: response.data['companyLegalName'],
          businessLocation: response.data['businessLocation'],
          gstRegistrationDate: response.data['gstRegistrationDate']);
    }

    return response;
  }

  /* Verify Udyam Aadhar Details */
  Future<ServerResponse> verifyUdyamNumber(
      String udyam, CancelToken cancelToken) async {
    String gst = state.gstNumber;

    if (!RegexProvider.gstRegex.hasMatch(gst)) {
      return ServerResponse(
        success: false,
        message: "Invalid GST Number",
      );
    }

    if (!RegexProvider.udyamRegex.hasMatch(udyam)) {
      return ServerResponse(
        success: false,
        message: "Invalid Udyam Aadhar!!",
      );
    }

    var response =
        await SignupHttpController().verifyUdyamNumber(gst, udyam, cancelToken);

    if (response.success) {
      state = state.copyWith(udyamNumber: udyam);
    }

    return response;
  }

  /* Send GST OTP */
  Future<ServerResponse> sendGSTOTP(
      String gstUsername, CancelToken cancelToken) async {
    String gst = state.gstNumber;

    if (!RegexProvider.gstRegex.hasMatch(gst)) {
      return ServerResponse(
        success: false,
        message: "Invalid GST Number",
      );
    }

    if (gstUsername.isEmpty) {
      return ServerResponse(
        success: false,
        message: "Invalid GST Username!!",
      );
    }

    var response =
        await SignupHttpController().sendGstOtp(gst, gstUsername, cancelToken);

    if (response.success) {
      state = state.copyWith(gstUsername: gstUsername);
    }

    return response;
  }

  /* Verify GST OTP */
  Future<ServerResponse> verifyGSTOTP(
      String otp, CancelToken cancelToken) async {
    String gst = state.gstNumber;
    String gstUsername = state.gstUsername;

    if (!RegexProvider.gstRegex.hasMatch(gst)) {
      return ServerResponse(
        success: false,
        message: "Invalid GST Number",
      );
    }

    if (gstUsername.isEmpty) {
      return ServerResponse(
        success: false,
        message: "Invalid GST Username!!",
      );
    }

    if (!RegexProvider.otpRegex.hasMatch(otp)) {
      return ServerResponse(
        success: false,
        message: "Invalid OTP",
      );
    }

    return SignupHttpController().verifyGstOtp(
        gst, gstUsername, otp, cancelToken);
  }

  /* Poll to check if GST data downloaded */
  Future<ServerResponse> pollForGSTVerificationCompletion() async {
    var gst = state.gstNumber;

    if (!RegexProvider.gstRegex.hasMatch(gst)) {
      return ServerResponse(
        success: false,
        message: "Invalid GST Number",
      );
    }

    bool isDone = false;
    num pollCount = 0;

    while (!isDone && pollCount < 10) {
      var response = await SignupHttpController().checkGstDataDownloadCompletion(
          gst, CancelToken());

      if (response.success) {
        isDone = true;
        break;
      } else {
        pollCount++;
      }

      await Future.delayed(const Duration(seconds: 15));
    }

    if (!isDone) {
      return ServerResponse(
        success: false,
        message: "GST verification could not succeed! Contact Support...",
      );
    }

    return ServerResponse(success: true, message: "GST Verified Successfully");
  }

/* Set Account Password */
  Future<ServerResponse> setAccountPassword(String password, CancelToken cancelToken) async {
    String gst = state.gstNumber;

    if (!RegexProvider.gstRegex.hasMatch(gst)) {
      return ServerResponse(
        success: false,
        message: "Invalid GST Number",
      );
    }

    if (!RegexProvider.passwordRegex.hasMatch(password)) {
      return ServerResponse(
        success: false,
        message: "Invalid Password. Password too weak!",
      );
    }

    var response = await SignupHttpController().setAccountPassword(
        gst, password, cancelToken);

    if (response.success) {
      await ref
          .read(authProvider.notifier)
          .setInvoiceLoanAuthToken(response.data['token']);
    }

    return response;
  }
}
