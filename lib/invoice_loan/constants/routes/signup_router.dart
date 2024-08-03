import 'package:blocsol_loan_application/invoice_loan/screens/auth/signup/account/account_created.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/auth/signup/account/signup_password_creation.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/auth/signup/business_details/gst_otp_validation.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/auth/signup/business_details/gst_username_validation.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/auth/signup/business_details/gst_validation.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/auth/signup/business_details/udyam_validation.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/auth/signup/profile/email_otp_verification.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/auth/signup/profile/email_validation.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/auth/signup/profile/mobile_otp_verification.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/auth/signup/profile/mobile_validation.dart';
import 'package:go_router/go_router.dart';

class InvoiceLoanSignupRouter {
  static const request_permissions = '/signup/request-permissions';
  static const mobile_validation = '/signup/mobile-validation';
  static const mobile_otp_verification = '/signup/mobile-otp-verification';
  static const email_validation = '/signup/email-validation';
  static const email_otp_verification = '/signup/email-otp-verification';
  static const gst_validation = '/signup/gst-validation';
  static const udyam_validation = '/signup/udyam-validation';
  static const gst_username_validation = '/signup/gst-username-validation';
  static const gst_otp_verification = '/signup/gst-otp-verification';
  static const fetching_gst_details = '/signup/fetching-gst-details';
  static const password_creation = '/signup/password-creation';
  static const account_created = '/signup/account-created';
}

List<GoRoute> invoiceLoanSignupRoutes = [
  GoRoute(
    path: InvoiceLoanSignupRouter.mobile_validation,
    builder: (context, state) => const SignupMobileValidation(),
  ),
  GoRoute(
    path: InvoiceLoanSignupRouter.mobile_otp_verification,
    builder: (context, state) => const SignupMobileOtpValidation(),
  ),
  GoRoute(
    path: InvoiceLoanSignupRouter.email_validation,
    builder: (context, state) => const SignupEmailValidation(),
  ),
  GoRoute(
    path: InvoiceLoanSignupRouter.email_otp_verification,
    builder: (context, state) => const SignupEmailOtpValidation(),
  ),
  GoRoute(
    path: InvoiceLoanSignupRouter.gst_validation,
    builder: (context, state) => const SignupGstValidation(),
  ),
  GoRoute(
    path: InvoiceLoanSignupRouter.gst_username_validation,
    builder: (context, state) => const SignupGstUsernameValidation(),
  ),
  GoRoute(
    path: InvoiceLoanSignupRouter.gst_otp_verification,
    builder: (context, state) => const SignupGstOtpValidation(),
  ),
  GoRoute(
    path: InvoiceLoanSignupRouter.udyam_validation,
    builder: (context, state) => const SignupUdyamValidation(),
  ),
  GoRoute(
    path: InvoiceLoanSignupRouter.password_creation,
    builder: (context, state) => const SignupPasswordCreation(),
  ),
    GoRoute(
    path: InvoiceLoanSignupRouter.account_created,
    builder: (context, state) => const SignupAccountCreated(),
  ),
];
