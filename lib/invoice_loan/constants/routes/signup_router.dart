import 'package:go_router/go_router.dart';

class InvoiceLoanSignupRouter {
  static const request_permissions = '/signup/request-permissions';
  static const mobile_validation = '/signup/mobile-validation';
  static const mobile_otp_verification = '/signup/mobile-otp-verification';
  static const email_validation = '/signup/email-validation';
  static const email_otp_verification = '/signup/email-otp-verification';
  static const profile_creation = '/signup/profile-creation';
  static const gst_validation = '/signup/gst-validation';
  static const udyam_validation = '/signup/udyam-validation';
  static const gst_username_validation = '/signup/gst-username-validation';
  static const gst_otp_verification = '/signup/gst-otp-verification';
  static const fetching_gst_details = '/signup/fetching-gst-details';
  static const password_creation = '/signup/password-creation';
  static const confirm_account = '/signup/confirm-account';
}

List<GoRoute> invoiceLoanSignupRoutes = [
  // GoRoute(
  //   path: InvoiceLoanSignupRouter.mobile_validation,
  //   builder: (context, state) => const SignupIntro(),
  // ),

];
