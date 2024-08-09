import 'package:blocsol_loan_application/invoice_loan/screens/protected/dashboard/dashboard.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/profile/profile_dashboard/dashboard.dart';
import 'package:go_router/go_router.dart';

class InvoiceLoanIndexRouter {
  static const dashboard = "/invoice-loan/dashboard";
  static const liabilities = "/invoice-loan/liabilities";
  static const profile = "/invoice-loan/profile";
  static const notifications = "/invoice-loan/notifications";
  static const support = "/invoice-loan/support";
}

List<GoRoute> invoiceLoanIndexRoutes = [
  GoRoute(
    path: InvoiceLoanIndexRouter.dashboard,
    builder: (context, state) => const InvoiceLoanDashboard(),
  ),
  GoRoute(
    path: InvoiceLoanIndexRouter.profile,
    builder: (context, state) => const InvoiceLoanProfileDashboard(),
  ),
  GoRoute(
    path: InvoiceLoanIndexRouter.notifications,
    builder: (context, state) => const InvoiceLoanDashboard(),
  ),
  GoRoute(
    path: InvoiceLoanIndexRouter.support,
    builder: (context, state) => const InvoiceLoanDashboard(),
  ),
];
