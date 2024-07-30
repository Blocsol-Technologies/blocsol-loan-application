import 'package:blocsol_loan_application/global-state/auth/auth.dart';
import 'package:blocsol_loan_application/home.dart';
import 'package:blocsol_loan_application/main.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router_state.g.dart';

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

      
      ],
      redirect: (context, state) {
        // I will get null value here for the token if 1. It doesnt exist or 2. It is expired
        var token =  ref.read(authStateProvider.notifier).getAuthToken();
        // print("naviting path is ${state.uri.path}");

        // If valid token exists and user tries to login, navigate to home screen
        // if (tokenVal.isNotEmpty && state.uri.path == AppRoutes.login) {
        //   return AppRoutes.msme_home_screen;
        // }

        // The order is important because publicRoutes contains the loginScreen
        if (publicRoutes.contains(state.uri.path)) {
          return null;
        }

        if (token.isEmpty) {
          return AppRoutes.entry;
        }

        return null;
      },
    );
  }
}
