import 'package:blocsol_loan_application/personal_loan/screens/auth/signup/mobile_otp_auth.dart';
import 'package:blocsol_loan_application/personal_loan/screens/auth/signup/mobile_verification.dart';
import 'package:blocsol_loan_application/personal_loan/screens/auth/signup/personal_details.dart';
import 'package:blocsol_loan_application/personal_loan/screens/auth/signup/signup_home.dart';
import 'package:go_router/go_router.dart';

class PersonalLoanSignupRouter {
  static const String intro = "/personal-credit/auth/signup/home";
  static const String mobile_auth = "/personal-credit/auth/signup/mobile-auth";
  static const String mobile_otp_auth =
      "/personal-credit/auth/signup/mobile-otp-auth";
  static const String personal_details =
      "/personal-credit/auth/signup/personal-details";
  static const String password = "/personal-credit/auth/signup/password";
}

List<GoRoute> personalLoanSignupRoutes = [
  GoRoute(
    path: PersonalLoanSignupRouter.intro,
    builder: (context, state) => const PCSignupHome(),
  ),
  GoRoute(
    path: PersonalLoanSignupRouter.mobile_auth,
    builder: (context, state) => const PCSignupMobileAuth(),
  ),
  GoRoute(
    path: PersonalLoanSignupRouter.mobile_otp_auth,
    builder: (context, state) => const PCSignupMobileOTPAuth(),
  ),
  GoRoute(
    path: PersonalLoanSignupRouter.personal_details,
    builder: (context, state) => const PCSignupPersonalDetails(),
  ),

   GoRoute(
    path: PersonalLoanSignupRouter.password,
    builder: (context, state) => const PCSignupPersonalDetails(),
  ),
];
