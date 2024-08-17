import 'package:blocsol_loan_application/personal_loan/screens/auth/signup/app_permissions.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/liabilitiies/liabilities_home.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/profile/profile_home.dart';
import 'package:go_router/go_router.dart';

class PersonalLoanIndexRouter {
  static const permissions = "/personal-credit/permissions";

  static const dashboard = "/personal-credit/dashboard";
  static const String liabilities_screen = "/personal-credit/liabilities";
  static const String support_home = "/personal-credit/support/home";

  static const String profile_screen = "/personal-credit/profile";

  /* New Loan Screen */
  static const String new_loan_process = "/personal-credit/new-loan";
  static const String new_loan_error = "/personal-credit/new-loan/error";

  /* search */
  static const String new_loan_data_consent =
      "/personal-credit/new-loan/data-consent";
  static const String new_loan_personal_details_form =
      "/personal-credit/new-loan/personal-details-form";

  /* select */
  static const String new_loan_account_aggregator_info =
      "/personal-credit/new-loan/account-aggregator-info";
  static const String new_loan_account_aggregator_bank_select =
      "/personal-credit/new-loan/account-aggregator-bank-select";
  static const String new_loan_account_aggregator_select =
      "/personal-credit/new-loan/account-aggregator-select";
  static const String new_loan_generate_offers_and_aa_consent =
      "/personal-credit/new-loan/generate-offers-and-aa-consent";
  static const String new_loan_aa_webview =
      "/personal-credit/new-loan/aa-webview";

  static const String new_loan_offers_home =
      "/personal-credit/new-loan/offers-home";

  static const String new_loan_offer_details =
      "/personal-credit/new-loan/offer-details";

  static const String new_loan_update_offer_screen =
      "/personal-credit/new-loan/update-offer-screen";

  static const String new_loan_aadhar_kyc_webview =
      "/personal-credit/new-loan/aadhar-kyc-webview";

  /* init */
  static const String new_loan_share_bank_details =
      "/personal-credit/new-loan/share-bank-details";

  static const String new_loan_repayment_setup =
      "/personal-credit/new-loan/repayment-setup";

  static const String new_loan_agreement =
      "/personal-credit/new-loan/agreement";
  static const String new_loan_agreement_webview =
      "/personal-credit/new-loan/agreement-webview";

  /* confirm */
  static const String new_loan_final_processing_screen =
      "/personal-credit/new-loan/final-processing-screen";

  static const String new_loan_loan_monitoring_webview =
      "/personal-credit/new-loan/loan-monitoring-webview";

  static const String new_loan_final_disbursed_screen =
      "/personal-credit/new-loan/final-disbursed-screen";
}

List<GoRoute> personalLoanIndexRoutes = [
  GoRoute(
    path: PersonalLoanIndexRouter.permissions,
    builder: (context, state) => const PCMobilePermissions(),
  ),
  GoRoute(
    path: PersonalLoanIndexRouter.profile_screen,
    builder: (context, state) => const PCProfileHome(),
  ),
  GoRoute(
    path: PersonalLoanIndexRouter.liabilities_screen,
    builder: (context, state) => const PCLiabilityHome(),
  ),
];
