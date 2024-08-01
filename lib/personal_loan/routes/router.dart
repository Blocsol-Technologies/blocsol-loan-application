
import 'package:blocsol_loan_application/personal_loan/routes/index_router.dart';
import 'package:blocsol_loan_application/personal_loan/routes/liabilities_router.dart';
import 'package:blocsol_loan_application/personal_loan/routes/loan_request_router.dart';
import 'package:blocsol_loan_application/personal_loan/routes/login_router.dart';
import 'package:blocsol_loan_application/personal_loan/routes/signup_router.dart';
import 'package:blocsol_loan_application/personal_loan/routes/support_router.dart';
import 'package:go_router/go_router.dart';

List<GoRoute> personalLoanRoutes = [
  ...personalLoanPublicRoutes,
  ...personalLoanProtectedRoutes,
];

List<GoRoute> personalLoanPublicRoutes = [
  ...personalLoanLoginRoutes,
  ...personalLoanSignupRoutes,
];

List<GoRoute> personalLoanProtectedRoutes = [
  ...personalLoanIndexRoutes,
  ...personalLoanProtectedRoutes,
  ...personalLoanRequestRoutes,
  ...personalLoanLiabilitiesRoutes,
  ...personalLoanSupportRoutes
];
