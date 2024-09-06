import 'package:blocsol_loan_application/personal_loan/screens/user_screens/new_loan/common/kyc_verified.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/new_loan/common/loan_service_errors/error_codes.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/new_loan/common/loan_service_errors/index.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/new_loan/common/loan_service_unavailable.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/new_loan/confirm/final_disbursed_screen.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/new_loan/confirm/final_processing_screen.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/new_loan/confirm/loan_monitoring_webview.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/new_loan/init/loan_agreement/new_loan_agreement.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/new_loan/init/loan_agreement/new_loan_agreement_webview.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/new_loan/init/repayment_setup.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/new_loan/init/share_bank_account.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/new_loan/new_loan_error.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/new_loan/new_loan_process.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/new_loan/search/data_consent.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/new_loan/search/peronal_details_form.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/new_loan/select/aadhar_kyc.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/new_loan/select/account_aggregator/account_aggregator_webview.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/new_loan/select/account_aggregator/fetch_consent_handler.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/new_loan/select/loan_offers/key_fact_sheet.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/new_loan/select/loan_offers/loan_offer_details.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/new_loan/select/loan_offers/loan_offers_home.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/new_loan/select/loan_offers/update_loan_offer_details.dart';
import 'package:go_router/go_router.dart';

class PersonalNewLoanRequestRouter {
  static const String new_loan_process = "/personal-credit/new-loan";
  static const String new_loan_error = "/personal-credit/new-loan/error";

  /* search */
  static const String new_loan_data_consent =
      "/personal-credit/new-loan/data-consent";
  static const String new_loan_personal_details_form =
      "/personal-credit/new-loan/personal-details-form";

  /* select */
  static const String new_loan_generate_offers_and_aa_consent =
      "/personal-credit/new-loan/generate-offers-and-aa-consent";
  static const String new_loan_aa_webview =
      "/personal-credit/new-loan/aa-webview";

  static const String new_loan_offers_home =
      "/personal-credit/new-loan/offers-home";

  static const String new_loan_offer_details =
      "/personal-credit/new-loan/offer-details";

    static const String new_loan_key_fact_sheet =
      "/personal-credit/new-loan/key-fact-sheet";

  static const String new_loan_update_offer_screen =
      "/personal-credit/new-loan/update-offer-screen";

  static const String new_loan_aadhar_kyc_webview =
      "/personal-credit/new-loan/aadhar-kyc-webview";

  static const kyc_verified = "/personal-loan/new-loan-request-kyc-verified";

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

  // Common

  static const loan_service_error =
      "/personal-credit/new-loan-request/loan-service-error";
  static const loan_service_unavailable =
      "/personal-credit/new-loan-request/loan-service-unavailable";
}

List<GoRoute> personalNewLoanRequestRoutes = [
  GoRoute(
    path: PersonalNewLoanRequestRouter.new_loan_process,
    builder: (context, state) => const PCNewLoanProcessScreen(),
  ),

  GoRoute(
    path: PersonalNewLoanRequestRouter.new_loan_error,
    builder: (context, state) {
      final errorMessage = state.extra as String;
      return PCNewLoanErrorScreen(errorMessage: errorMessage);
    },
  ),

  // Search
  GoRoute(
    path: PersonalNewLoanRequestRouter.new_loan_data_consent,
    builder: (context, state) => const PCNewLoanDataConsent(),
  ),

  GoRoute(
    path: PersonalNewLoanRequestRouter.new_loan_personal_details_form,
    builder: (context, state) => const PCNewLoanPersonalDetailsForm(),
  ),

  GoRoute(
    path: PersonalNewLoanRequestRouter.new_loan_generate_offers_and_aa_consent,
    builder: (context, state) => const PCNewLoanGenerateOfferConsent(),
  ),

  GoRoute(
    path: PersonalNewLoanRequestRouter.new_loan_aa_webview,
    builder: (context, state) {
      final url = state.extra as String;
      return PCNewLoanAAWebview(url: url);
    },
  ),

  // Select
  GoRoute(
    path: PersonalNewLoanRequestRouter.new_loan_offers_home,
    builder: (context, state) => const PCNewLoanOfferHome(),
  ),


  GoRoute(
    path: PersonalNewLoanRequestRouter.new_loan_key_fact_sheet,
    builder: (context, state) => const PCNewLoanKeyFactSheet(),
  ),

  GoRoute(
    path: PersonalNewLoanRequestRouter.new_loan_offer_details,
    builder: (context, state) => const PCNewLoanOfferDetails(),
  ),

  GoRoute(
    path: PersonalNewLoanRequestRouter.new_loan_update_offer_screen,
    builder: (context, state) => const PCNewLoanUpdateLoanOffer(),
  ),

  GoRoute(
    path: PersonalNewLoanRequestRouter.new_loan_aadhar_kyc_webview,
    builder: (context, state) => const PCNewLoanAadharKYCWebview(),
  ),

  GoRoute(
    path: PersonalNewLoanRequestRouter.kyc_verified,
    builder: (context, state) => const PCKycVerified(),
  ),
  // Init

  GoRoute(
    path: PersonalNewLoanRequestRouter.new_loan_share_bank_details,
    builder: (context, state) => const PCNewLoanBankAccountDetails(),
  ),

  GoRoute(
    path: PersonalNewLoanRequestRouter.new_loan_repayment_setup,
    builder: (context, state) => const PCNewLoanRepaymentSetup(),
  ),

  GoRoute(
    path: PersonalNewLoanRequestRouter.new_loan_agreement,
    builder: (context, state) => const PCNewLoanLoanAgreement(),
  ),

  GoRoute(
    path: PersonalNewLoanRequestRouter.new_loan_agreement_webview,
    builder: (context, state) {
      final url = state.extra as String;
      return PCNewLoanAgreementWebview(url: url);
    },
  ),

  // Confirm
  GoRoute(
    path: PersonalNewLoanRequestRouter.new_loan_final_processing_screen,
    builder: (context, state) => const PCNewLoanFinalProcessing(),
  ),

  GoRoute(
    path: PersonalNewLoanRequestRouter.new_loan_loan_monitoring_webview,
    builder: (context, state) {
      final url = state.extra as String;
      return PCNewLoanMonitoringConsentAAWebview(url: url);
    },
  ),

  GoRoute(
    path: PersonalNewLoanRequestRouter.new_loan_final_disbursed_screen,
    builder: (context, state) => const PCNewLoanDisbursedScreen(),
  ),

  // Common

  GoRoute(
    path: PersonalNewLoanRequestRouter.loan_service_error,
    builder: (context, state) {
      PersonalLoanServiceErrorCodes errorCodeVal =
          state.extra as PersonalLoanServiceErrorCodes;

      return PersonalLoanServiceError(errorCode: errorCodeVal);
    },
  ),

  GoRoute(
    path: PersonalNewLoanRequestRouter.loan_service_unavailable,
    builder: (context, state) {
      String errMessage = (state.extra as String?) ??
          "Service is currently unavailable. Please try again later.";

      return PersonalLoanServiceUnavailable(message: errMessage);
    },
  ),
];
