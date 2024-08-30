import 'package:blocsol_loan_application/global_state/auth/auth.dart';
import 'package:blocsol_loan_application/global_state/theme/theme.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/index_router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/login_router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/router.dart';
import 'package:blocsol_loan_application/choice_screens/login_choice.dart';
import 'package:blocsol_loan_application/main.dart';
import 'package:blocsol_loan_application/not_found.dart';
import 'package:blocsol_loan_application/personal_loan/contants/routes/index_router.dart';
import 'package:blocsol_loan_application/personal_loan/contants/routes/login_router.dart';
import 'package:blocsol_loan_application/personal_loan/contants/routes/router.dart';
import 'package:blocsol_loan_application/choice_screens/signup_choice.dart';
import 'package:blocsol_loan_application/utils/logger.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

class AppRoutes {
  static const entry = "/";
  static const signupChoice = "/signup_choice";
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
      errorBuilder: (context, state) {
        bool isInvoiceLoanRoute =
            invoiceLoanRoutes.any((route) => route.path == state.uri.path);

        return NotFoundPage(
          invoiceLoanPage: isInvoiceLoanRoute,
        );
      },
      routes: [
        GoRoute(
          path: AppRoutes.entry,
          builder: (context, state) => const LoginChoice(),
        ),
        GoRoute(
          path: AppRoutes.signupChoice,
          builder: (context, state) => const SignupChoice(),
        ),
        ...invoiceLoanRoutes,
        ...personalLoanRoutes,
      ],
      redirect: (context, state) async {
        var (personalLoanToken, invoiceLoanToken) =
            ref.read(authProvider.notifier).getAuthTokens();

        if (invoiceLoanRoutes.any((route) => route.path == state.uri.path)) {
          await ref
              .read(appThemeProvider.notifier)
              .setTheme(ThemeState.invoiceLoanTheme);
        } else if (personalLoanRoutes.any((route) => route.path == state.uri.path)) {
          await ref
              .read(appThemeProvider.notifier)
              .setTheme(ThemeState.personalLoanTheme);
        } else {
          await ref.read(appThemeProvider.notifier).setTheme(ThemeState.defaultTheme);
        }

        logger.d(
            "navigating to path: ${state.uri.path} \n extra: ${state.extra}");

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
          return PersonalLoanLoginRouter.mobil_auth;
        }

        return null;
      },
    );
  }
}
