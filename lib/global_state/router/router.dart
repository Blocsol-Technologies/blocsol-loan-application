import 'package:blocsol_loan_application/global_state/auth/auth.dart';
import 'package:blocsol_loan_application/global_state/theme/theme.dart';
import 'package:blocsol_loan_application/home.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/index_router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/login_router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/router.dart';
import 'package:blocsol_loan_application/main.dart';
import 'package:blocsol_loan_application/personal_loan/routes/index_router.dart';
import 'package:blocsol_loan_application/personal_loan/routes/login_router.dart';
import 'package:blocsol_loan_application/personal_loan/routes/router.dart';
import 'package:blocsol_loan_application/utils/logger.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

class AppRoutes {
  static const entry = "/";
}

final List<String> publicRoutes = [];

@riverpod
class Router extends _$Router {
  @override
  GoRouter build() {
    return GoRouter(
      navigatorKey: navigatorKey,
      debugLogDiagnostics: true,
      initialLocation: AppRoutes.entry,
      routes: [
        GoRoute(
          path: AppRoutes.entry,
          builder: (context, state) => const Home(),
        ),
        ...invoiceLoanRoutes,
      ],
      redirect: (context, state) async {
        var (personalLoanToken, invoiceLoanToken) =
            ref.read(authProvider.notifier).getAuthTokens();

        if (invoiceLoanRoutes.any((route) => route.path == state.uri.path)) {
          await ref
              .read(appThemeProvider.notifier)
              .setTheme(ThemeState.invoiceLoanTheme);
        }

        if (personalLoanRoutes.any((route) => route.path == state.uri.path)) {
          await ref
              .read(appThemeProvider.notifier)
              .setTheme(ThemeState.personalLoanTheme);
        }

        logger.d("navigating to path: ${state.uri.path}");

        if (invoiceLoanToken.isNotEmpty &&
            invoiceLoanPublicRoutes
                .any((route) => route.path == state.uri.path)) {
          return InvoiceLoanIndexRouter.dashboard;
        }

        if (invoiceLoanToken.isEmpty &&
            invoiceLoanProtectedRoutes
                .any((route) => route.path == state.uri.path)) {
          return InvoiceLoanLoginRouter.mobile_auth;
        }

        if (personalLoanToken.isNotEmpty &&
            personalLoanPublicRoutes
                .any((route) => route.path == state.uri.path)) {
          return PersonalLoanIndexRouter.dashboard;
        }

        if (personalLoanToken.isEmpty &&
            personalLoanProtectedRoutes
                .any((route) => route.path == state.uri.path)) {
          return PersonalLoanLoginRouter.index;
        }

        return null;
      },
    );
  }
}
