import 'package:blocsol_loan_application/invoice_loan/screens/protected/dashboard/dashboard.dart';
import 'package:go_router/go_router.dart';

class InvoiceLoanIndexRouter {
  static const dashboard = "/invoice-loan/dashboard";
  static const liabilities = "/invoice-loan/liabilities";
  static const profile = "/invoice-loan/profile";
}

List<GoRoute> invoiceLoanIndexRoutes = [
  GoRoute(
    path: InvoiceLoanIndexRouter.dashboard,
    builder: (context, state) => const InvoiceLoanDashboard(),
  ),
];
