import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/new_loan_process.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/search/account_aggregator/account_aggregator_webview.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/search/account_aggregator/submitting_invoices_for_offers.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/search/gst_invoices/download_gst_invoices.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/search/gst_invoices/fetching_gst_invoices.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/search/gst_invoices/gst_invoices.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/search/gst_invoices/gst_otp.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/search/gst_invoices/single_invoice_details.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_details.dart';
import 'package:go_router/go_router.dart';

class InvoiceNewLoanRequestRouter {
  static const dashboard = "/invoice-loan/new-loan-request/dashboard";

  // Search
  static const fetching_gst_invoices =
      "/invoice-loan/new-loan-request/fetching-gst-invoices";
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
  static const monitoring_consent_webview =
      "/invoice-loan/new-loan-request/monitoring-consent-webview";
  static const final_details = "/invoice-loan/new-loan-request/final-details";

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
  GoRoute(
    path: InvoiceNewLoanRequestRouter.fetching_gst_invoices,
    builder: (context, state) => const InvoicesFetchingScreen(),
  ),
  GoRoute(
    path: InvoiceNewLoanRequestRouter.verify_gst_otp,
    builder: (context, state) => const GstOtpValidation(),
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
];
