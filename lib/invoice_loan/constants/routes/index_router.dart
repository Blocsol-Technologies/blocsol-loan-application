import 'package:blocsol_loan_application/invoice_loan/screens/auth/permissions.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/dashboard/dashboard.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/liabilities/liabilities_home.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/profile/notifications/notifications_home.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/profile/profile_dashboard/dashboard.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/support/all_tickets.dart';
import 'package:go_router/go_router.dart';

class InvoiceLoanIndexRouter {
  static const dashboard = "/invoice-loan/dashboard";
  static const liabilities = "/invoice-loan/liabilities";
  static const profile = "/invoice-loan/profile";
  static const notifications = "/invoice-loan/notifications";
  static const support = "/invoice-loan/support";
  static const permissions = "/invoice-loan/login/permissions";
  static const invoices = "/invoice-loan/invoices";
}

List<GoRoute> invoiceLoanIndexRoutes = [
  GoRoute(
    path: InvoiceLoanIndexRouter.dashboard,
    builder: (context, state) => const InvoiceLoanDashboard(),
  ),
  GoRoute(
    path: InvoiceLoanIndexRouter.liabilities,
    builder: (context, state) => const InvoiceLoanLiabilitiesHome(),
  ),
  GoRoute(
    path: InvoiceLoanIndexRouter.profile,
    builder: (context, state) => const InvoiceLoanProfileDashboard(),
  ),
  GoRoute(
    path: InvoiceLoanIndexRouter.notifications,
    builder: (context, state) => const InvoiceLoanNotifications(),
  ),
  GoRoute(
    path: InvoiceLoanIndexRouter.support,
    builder: (context, state) => const InvoiceLoanAllSupportTickets(),
  ),
  GoRoute(
    path: InvoiceLoanIndexRouter.permissions,
    builder: (context, state) => const InvoiceLoanAppPermissions(),
  ),
];
