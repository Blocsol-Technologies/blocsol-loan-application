import 'package:go_router/go_router.dart';

class PersonalLoanSignupRouter {
  static const String intro = "/personal-credit/auth/signup/home";
  static const String mobile_auth =
      "/personal-credit/auth/signup/mobile-auth";
  static const String mobile_otp_auth =
      "/personal-credit/auth/signup/mobile-otp-auth";
  static const String mobile_persmissions =
      "/personal-credit/auth/signup/mobile-permissions";
  static const String personal_details =
      "/personal-credit/auth/signup/personal-details";
  static const String password = "/personal-credit/auth/signup/password";
}

List<GoRoute> personalLoanSignupRoutes = [];
