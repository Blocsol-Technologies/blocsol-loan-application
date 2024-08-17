import 'package:blocsol_loan_application/personal_loan/screens/auth/signup/app_permissions.dart';
import 'package:go_router/go_router.dart';

class PersonalLoanIndexRouter {
  static const dashboard = "/personal-credit/dashboard";
  static const permissions = "/personal-credit/permissions";

  /* User Screens */
  static const String home_screen = "/personal-credit/home";

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

  /* Old Loans */
  static const String old_loans_screen = "/personal-credit/old-loans";
  static const String old_loan_details_home =
      "/personal-credit/old-loans/details-home";
  static const String old_loan_final_details =
      "/personal-credit/old-loans/final-details";
  static const String old_loan_prepayment_webview =
      "/personal-credit/old-loans/prepayment-webview";
  static const String old_loan_foreclose_webview =
      "/personal-credit/old-loans/foreclose-webview";
  static const String old_loan_missed_emi_payment_webview =
      "/personal-credit/old-loans/missed-emi-payment-webview";
  static const String old_loan_payment_history =
      "/personal-credit/old-loans/payment-history";
  static const String old_loan_prepayment =
      "/personal-credit/old-loans/prepayment";
  static const String old_loan_general_webview =
      "/personal-credit/old-loans/general-webview";

  /* Support */
  static const String raise_new_ticket =
      "/personal-credit/support/raise-new-ticket";
  static const String support_home = "/personal-credit/support/home";
  static const String support_ticket_details =
      "/personal-credit/support/ticket-details";
}

List<GoRoute> personalLoanIndexRoutes = [
  GoRoute(
    path: PersonalLoanIndexRouter.permissions,
    builder: (context, state) => const PCMobilePermissions(),
  ),
];
