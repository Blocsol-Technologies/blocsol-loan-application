import 'package:blocsol_loan_application/invoice_loan/screens/auth/login/login.dart';
import 'package:go_router/go_router.dart';

class InvoiceLoanLoginRouter {
  static const index = "/login";
}

List<GoRoute> invoiceLoanLoginRoutes = [
  GoRoute(
    path: InvoiceLoanLoginRouter.index,
    builder: (context, state) => const InvoiceLoanLogin(),
  ),
];
