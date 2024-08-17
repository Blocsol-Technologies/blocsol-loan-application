import 'package:blocsol_loan_application/personal_loan/screens/user_screens/liabilitiies/liability_details_home.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/liabilitiies/liability_details_payment_history.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/liabilitiies/liability_foreclose_webview.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/liabilitiies/liability_general_webview.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/liabilitiies/liability_missed_emi_payment_webview.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/liabilitiies/liability_prepay.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/liabilitiies/liability_prepay_webview.dart';
import 'package:go_router/go_router.dart';

class PersonalLoanLiabilitiesRouter {
  static const String liability_details_home =
      "/personal-credit/old-loans/details-home";
  static const String liability_final_details =
      "/personal-credit/old-loans/final-details";
  static const String liability_prepayment_webview =
      "/personal-credit/old-loans/prepayment-webview";
  static const String liability_foreclose_webview =
      "/personal-credit/old-loans/foreclose-webview";
  static const String liability_missed_emi_payment_webview =
      "/personal-credit/old-loans/missed-emi-payment-webview";
  static const String liability_payment_history =
      "/personal-credit/old-loans/payment-history";
  static const String liability_prepayment =
      "/personal-credit/old-loans/prepayment";
  static const String liability_general_webview =
      "/personal-credit/old-loans/general-webview";
}

List<GoRoute> personalLoanLiabilitiesRoutes = [
  GoRoute(
    path: PersonalLoanLiabilitiesRouter.liability_details_home,
    builder: (context, state) => const PCLiabilityDetailsHome(),
  ),
  GoRoute(
    path: PersonalLoanLiabilitiesRouter.liability_payment_history,
    builder: (context, state) => const PCLiabilityPaymentDetails(),
  ),
  GoRoute(
    path: PersonalLoanLiabilitiesRouter.liability_prepayment,
    builder: (context, state) => const PCLiabilityPrepay(),
  ),
  GoRoute(
    path: PersonalLoanLiabilitiesRouter.liability_prepayment_webview,
    builder: (context, state) {
      final url = state.extra as String;

      return PCLiabilityPrepaymentWebview(url: url);
    },
  ),
  GoRoute(
    path: PersonalLoanLiabilitiesRouter.liability_foreclose_webview,
    builder: (context, state) {
      final url = state.extra as String;

      return PCLiabilityForeclosureWebview(url: url);
    },
  ),
  GoRoute(
    path: PersonalLoanLiabilitiesRouter.liability_missed_emi_payment_webview,
    builder: (context, state) {
      final url = state.extra as String;

      return PCLiabilityMissedEMIPaymentWebview(url: url);
    },
  ),
  GoRoute(
    path: PersonalLoanLiabilitiesRouter.liability_general_webview,
    builder: (context, state) {
      final url = state.extra as String;

      return PCLiabilityGeneralWebview(url: url);
    },
  ),
];
