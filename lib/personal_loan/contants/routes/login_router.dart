import 'package:blocsol_loan_application/personal_loan/screens/auth/login/login_screen.dart';
import 'package:go_router/go_router.dart';

class PersonalLoanLoginRouter {
  static const mobil_auth = '/personal-loan/mobile_auth';
}

List<GoRoute> personalLoanLoginRoutes = [
  GoRoute(
    path: PersonalLoanLoginRouter.mobil_auth,
    builder: (context, state) => const PCLoginScreen(),
  ),
];
