import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/common/kyc_verified.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/common/loan_service_error/index.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/common/loan_service_unavailable.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/confirm/loan_flow_completion.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/confirm/monitoring_consent/generating_monitoring_consent.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/confirm/monitoring_consent/monitoring_consent_webview.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/confirm/new_loan_processing.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/init/bank_account_details/new_loan_bank_account_details.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/init/entity_kyc/entity_kyc.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/init/loan_agreement/new_loan_agreement.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/init/loan_agreement/new_loan_agreement_webview.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/init/repayment_setup/new_loan_repayment_setup.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/new_loan_process.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/search/account_aggregator/account_aggregator_webview.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/search/account_aggregator/submitting_invoices_for_offers.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/search/gst_invoices/download_gst_invoices.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/search/gst_invoices/enable_gst_api.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/search/gst_invoices/fetching_gst_invoices.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/search/gst_invoices/gst_invoices.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/search/gst_invoices/gst_otp.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/search/gst_invoices/single_invoice_details.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/select/aadhar_kyc/aadhar_kyc.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/select/offers/independent_key_fact_sheet.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/select/offers/key_fact_sheet.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/select/offers/loan_offers_home.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/select/offers/select_offer_screen.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/select/offers/update_loan_offer_details.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_details.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/state/error_codes.dart';
import 'package:go_router/go_router.dart';

class InvoiceNewLoanRequestRouter {
  static const dashboard = "/invoice-loan/new-loan-request/dashboard";

  // Search
  static const fetching_gst_invoices =
      "/invoice-loan/new-loan-request/fetching-gst-invoices";
  static const enable_gst_api_access = "/invoice-loan/new-loan-request/enable-gst-api-access";
  static const verify_gst_otp = "/invoice-loan/new-loan-request/verify-gst-otp";
  static const downloading_gst_invoices =
      "/invoice-loan/new-loan-request/downloading-gst-invoices";
  static const gst_invoices_showcase =
      "/invoice-loan/new-loan-request/gst-invoices-showcase";
  static const single_gst_invoice_details =
      "/invoice-loan/new-loan-request/single-gst-invoice-details";
  static const submitting_customer_information =
      "/invoice-loan/new-loan-request/submitting-customer-information";
  static const account_aggregator_webview =
      "/invoice-loan/new-loan-request/account-aggregator-webview";

  // Select
  static const loan_offer_select = "/invoice-loan/new-loan-request/loan-offer";
  static const single_bank_offer_select =
      "/invoice-loan/new-loan-request/single-bank-offer";

  static const loan_independent_key_fact_sheet =
      "/invoice-loan/new-loan-request/loan-independent-key-fact-sheet";
  static const loan_key_fact_sheet =
      "/invoice-loan/new-loan-request/loan-key-fact-sheet";
  static const update_loan_amount =
      "/invoice-loan/new-loan-request/update-loan-amount";
  static const aadhar_kyc = "/invoice-loan/new-loan-request/aadhar-kyc";

  // Init
  static const entity_kyc = "/invoice-loan/new-loan-request/entity-kyc";
  static const bank_account_details =
      "/invoice-loan/new-loan-request/bank-account-details";
  static const repayment_setup =
      "/invoice-loan/new-loan-request/repayment-setup";
  static const loan_agreement = "/invoice-loan/new-loan-request/loan-agreement";
  static const loan_agreement_webview =
      "/invoice-loan/new-loan-request/loan-agreement-webview";

  // Confirm
  static const final_processing =
      "/invoice-loan/new-loan-request/final-processing";
  static const generate_monitoring_consent =
      "/invoice-loan/new-loan-request/generate-monitoring-consent";
  static const monitoring_consent_webview =
      "/invoice-loan/new-loan-request/monitoring-consent-webview";
  static const final_details = "/invoice-loan/new-loan-request/final-details";

  // Common
  static const kyc_verified = "/invoice-loan/new-loan-request/kyc-verified";
  // Error
  static const loan_service_error =
      "/invoice-loan/new-loan-request/loan-service-error";
  static const loan_service_unavailable =
      "/invoice-loan/new-loan-request/loan-service-unavailable";
}

List<GoRoute> invoiceLoanRequestRoutes = [
  GoRoute(
    path: InvoiceNewLoanRequestRouter.dashboard,
    builder: (context, state) => const InvoiceNewLoanRequestDashboard(),
  ),

  // Search
  GoRoute(
    path: InvoiceNewLoanRequestRouter.fetching_gst_invoices,
    builder: (context, state) => const InvoicesFetchingScreen(),
  ),
  GoRoute(
    path: InvoiceNewLoanRequestRouter.verify_gst_otp,
    builder: (context, state) => const GstOtpValidation(),
  ),
    GoRoute(
    path: InvoiceNewLoanRequestRouter.enable_gst_api_access,
    builder: (context, state) => const EnableGSTAPI(),
  ),
  GoRoute(
    path: InvoiceNewLoanRequestRouter.downloading_gst_invoices,
    builder: (context, state) => const GstDataDownloadScreen(),
  ),
  GoRoute(
    path: InvoiceNewLoanRequestRouter.gst_invoices_showcase,
    builder: (context, state) => const NewLoanGstInvoices(),
  ),
  GoRoute(
    path: InvoiceNewLoanRequestRouter.single_gst_invoice_details,
    builder: (context, state) {
      Invoice invoice = state.extra as Invoice;

      return SingleInvoiceDetailsScreen(invoice: invoice);
    },
  ),
  GoRoute(
    path: InvoiceNewLoanRequestRouter.submitting_customer_information,
    builder: (context, state) => const InvoiceLoanRequestSubmittingSearchForm(),
  ),
  GoRoute(
    path: InvoiceNewLoanRequestRouter.account_aggregator_webview,
    builder: (context, state) {
      String url = state.extra as String;

      return AccountAggregatorWebview(url: url);
    },
  ),

  // Select
  GoRoute(
    path: InvoiceNewLoanRequestRouter.loan_offer_select,
    builder: (context, state) => const InvoiceNewLoanOffersSelect(),
  ),

  GoRoute(
    path: InvoiceNewLoanRequestRouter.single_bank_offer_select,
    builder: (context, state) => const InvoiceNewLoanOfferDetails(),
  ),

  GoRoute(
    path: InvoiceNewLoanRequestRouter.loan_independent_key_fact_sheet,
    builder: (context, state) => const InvoiceNewLoanIndependedtKeyFactSheet(),
  ),

  GoRoute(
    path: InvoiceNewLoanRequestRouter.loan_key_fact_sheet,
    builder: (context, state) => const InvoiceLoanKeyFactSheet(),
  ),

  GoRoute(
    path: InvoiceNewLoanRequestRouter.update_loan_amount,
    builder: (context, state) => const InvoiceNewLoanUpdateOffer(),
  ),

  GoRoute(
    path: InvoiceNewLoanRequestRouter.aadhar_kyc,
    builder: (context, state) => const InvoiceNewLoanAadharKyc(),
  ),

  // Init
  GoRoute(
    path: InvoiceNewLoanRequestRouter.entity_kyc,
    builder: (context, state) => const InvoiceNewLoanEntityKyc(),
  ),

  GoRoute(
    path: InvoiceNewLoanRequestRouter.bank_account_details,
    builder: (context, state) => const InvoiceNewLoanBankAccountDetails(),
  ),

  GoRoute(
    path: InvoiceNewLoanRequestRouter.repayment_setup,
    builder: (context, state) => const InvoiceNewLoanRepaymentSetup(),
  ),

  GoRoute(
    path: InvoiceNewLoanRequestRouter.loan_agreement,
    builder: (context, state) => const InvoiceNewLoanAgreement(),
  ),

  GoRoute(
    path: InvoiceNewLoanRequestRouter.loan_agreement_webview,
    builder: (context, state) {
      String url = state.extra as String;

      return InvoiceNewLoanAgreementWebview(url: url);
    },
  ),

  // Confirm
  GoRoute(
    path: InvoiceNewLoanRequestRouter.final_processing,
    builder: (context, state) => const InvoiceNewLoanProcessing(),
  ),

  GoRoute(
    path: InvoiceNewLoanRequestRouter.generate_monitoring_consent,
    builder: (context, state) =>
        const InvoiceNewLoanGenerateMonitroingConsent(),
  ),

  GoRoute(
    path: InvoiceNewLoanRequestRouter.monitoring_consent_webview,
    builder: (context, state) {
      String url = state.extra as String;

      return InvoiceNewLoanMonitoringConsentWebview(url: url);
    },
  ),

  GoRoute(
    path: InvoiceNewLoanRequestRouter.final_details,
    builder: (context, state) => const InvoiceNewLoanFlowCompletion(),
  ),

  // Common
  GoRoute(
    path: InvoiceNewLoanRequestRouter.kyc_verified,
    builder: (context, state) {
      IBCKycType kycTypeVal = state.extra as IBCKycType;

      return InvoiceLoanKycVerified(kycType: kycTypeVal);
    },
  ),

  GoRoute(
    path: InvoiceNewLoanRequestRouter.loan_service_error,
    builder: (context, state) {
      InvoiceLoanServiceErrorCodes errorCodeVal =
          state.extra as InvoiceLoanServiceErrorCodes;

      return InvoiceLoanServiceError(errorCode: errorCodeVal);
    },
  ),

  GoRoute(
    path: InvoiceNewLoanRequestRouter.loan_service_unavailable,
    builder: (context, state) {
      String errMessage = (state.extra as String?) ??
          "Service is currently unavailable. Please try again later.";

      return InvoiceLoanServiceUnavailable(message: errMessage);
    },
  ),
];

enum IBCKycType { aadhar, entity }
