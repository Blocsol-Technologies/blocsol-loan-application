import 'package:blocsol_loan_application/invoice_loan/screens/protected/liabilities/foreclosure/liability_foreclose_webview.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/liabilities/missed-emi/liability_missed_emi_payment_webview.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/liabilities/prepayment/liability_prepay.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/liabilities/prepayment/liability_prepay_webview.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/liabilities/single-liability-details/single_liability_details_home.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/liabilities/single-liability-details/single_liability_details_payment_history.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/liabilities/single-liability-details/single_liability_full_details.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/liabilities/single-liability-details/single_liability_general_webview.dart';
import 'package:go_router/go_router.dart';

class InvoiceLoanLiabilitiesRouter {
  static const String singleLiabilityDetails =
      'invoice-loan/liabilities/single-liability-details';

  static const String full_details = 'invoice-loan/liabilities/full-details';
  static const String payment_history =
      'invoice-loan/liabilities/payment-history';
  static const String general_webview =
      'invoice-loan/liabilities/general-webview';  

  static const String payment_error_page = 'invoice-loan/liabilities/error-page';

  // Foreclosure
  static const String liability_foreclosure_webview =
      'invoice-loan/liabilities/liability-foreclosure-webview';

  // Missed Emi
  static const String missed_emi_payment =
      'invoice-loan/liabilities/missed-emi-payment';

  // Prepayment
  static const String prepayment_amount_selection =
      'invoice-loan/liabilities/prepayment-amount-selection';
  static const String prepayment_webview =
      'invoice-loan/liabilities/prepayment-webview';
}

List<GoRoute> invoiceLoanLiabilitiesRoutes = [
  GoRoute(
    path: InvoiceLoanLiabilitiesRouter.singleLiabilityDetails,
    builder: (context, state) => const InvoiceLoanSingleLiabilityDetailsHome(),
  ),
  GoRoute(
    path: InvoiceLoanLiabilitiesRouter.full_details,
    builder: (context, state) => const InvoiceLoanLiabilityFullDetails(),
  ),
  GoRoute(
    path: InvoiceLoanLiabilitiesRouter.payment_history,
    builder: (context, state) => const InvoiceLoanLiabilityPaymentHistory(),
  ),

   GoRoute(
    path: InvoiceLoanLiabilitiesRouter.general_webview,
    builder: (context, state) {
      String url = state.extra as String;

      return InvoiceLoanLiabilityGeneralWebview(url: url);
    },
  ),

  GoRoute(
    path: InvoiceLoanLiabilitiesRouter.liability_foreclosure_webview,
    builder: (context, state) {
      String url = state.extra as String;

      return InvoiceLoanLiabilityForeclosureWebview(url: url);
    },
  ),
  GoRoute(
    path: InvoiceLoanLiabilitiesRouter.missed_emi_payment,
    builder: (context, state) {
      String url = state.extra as String;

      return InvoiceLoanLiabilityMissedEmiPaymentWebview(url: url);
    },
  ),
  GoRoute(
    path: InvoiceLoanLiabilitiesRouter.prepayment_amount_selection,
    builder: (context, state) =>
        const InvoiceLoanLiabilityPrepayAmountSelector(),
  ),
  GoRoute(
    path: InvoiceLoanLiabilitiesRouter.prepayment_webview,
    builder: (context, state) {
      String url = state.extra as String;

      return InvoiceLoanLiabilityPrepaymentWebview(url: url);
    },
  ),
];
