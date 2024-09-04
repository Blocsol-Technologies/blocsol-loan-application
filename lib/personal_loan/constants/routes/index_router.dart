import 'package:blocsol_loan_application/personal_loan/screens/auth/signup/app_permissions.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/home_screen.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/liabilitiies/liabilities_home.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/profile/notifications/notifications_home.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/profile/profile_dashboard/dashboard.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/support/all_tickets.dart';
import 'package:go_router/go_router.dart';

class PersonalLoanIndexRouter {
  static const permissions = "/personal-credit/permissions";

  static const dashboard = "/personal-credit/dashboard";
  static const String liabilities_screen = "/personal-credit/liabilities";
  static const String support_home = "/personal-credit/support/home";

  static const String profile_screen = "/personal-credit/profile";
    static const notifications = "/personal-credit/notifications";
}

List<GoRoute> personalLoanIndexRoutes = [
  GoRoute(
    path: PersonalLoanIndexRouter.dashboard,
    builder: (context, state) => const PCHomeScreen(),
  ),
  GoRoute(
    path: PersonalLoanIndexRouter.permissions,
    builder: (context, state) => const PCMobilePermissions(),
  ),
  GoRoute(
    path: PersonalLoanIndexRouter.support_home,
    builder: (context, state) => const PersonalLoanAllSupportTickets(),
  ),
  GoRoute(
    path: PersonalLoanIndexRouter.profile_screen,
    builder: (context, state) => const PLProfileDashboard(),
  ),
  GoRoute(
    path: PersonalLoanIndexRouter.liabilities_screen,
    builder: (context, state) => const PCLiabilityHome(),
  ),

    GoRoute(
    path: PersonalLoanIndexRouter.notifications,
    builder: (context, state) => const PlNotifications(),
  ),
];
