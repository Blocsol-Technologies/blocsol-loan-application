
import 'package:blocsol_loan_application/personal_loan/contants/routes/index_router.dart';
import 'package:blocsol_loan_application/personal_loan/contants/routes/liabilities_router.dart';
import 'package:blocsol_loan_application/personal_loan/contants/routes/loan_request_router.dart';
import 'package:blocsol_loan_application/personal_loan/contants/routes/login_router.dart';
import 'package:blocsol_loan_application/personal_loan/contants/routes/profile_router.dart';
import 'package:blocsol_loan_application/personal_loan/contants/routes/signup_router.dart';
import 'package:blocsol_loan_application/personal_loan/contants/routes/support_router.dart';
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
  ...personalLoanProfileRoutes,
  ...personalLoanRequestRoutes,
  ...personalLoanLiabilitiesRoutes,
  ...personalLoanSupportRoutes
];
