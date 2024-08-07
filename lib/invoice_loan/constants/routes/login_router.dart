import 'package:blocsol_loan_application/invoice_loan/screens/auth/login/mobile_auth.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/auth/login/otp_auth.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/auth/login/password_auth.dart';
import 'package:go_router/go_router.dart';

class InvoiceLoanLoginRouter {
  static const mobile_auth = "/invoice-loan/login/mobile-auth";
  static const password = "/invoice-loan/login/password";
  static const otp_validation = "/invoice-loan/login/otp-validation";
}

List<GoRoute> invoiceLoanLoginRoutes = [
  GoRoute(
    path: InvoiceLoanLoginRouter.mobile_auth,
    builder: (context, state) => const LoginMobileValidation(),
  ),

    GoRoute(
    path: InvoiceLoanLoginRouter.password,
    builder: (context, state) => const LoginPasswordValidation(),
  ),

    GoRoute(
    path: InvoiceLoanLoginRouter.otp_validation,
    builder: (context, state) => const LoginMobileOtpValidation(),
  ),
];
