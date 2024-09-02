
import 'package:blocsol_loan_application/personal_loan/constants/routes/index_router.dart';
import 'package:blocsol_loan_application/personal_loan/constants/routes/liabilities_router.dart';
import 'package:blocsol_loan_application/personal_loan/constants/routes/loan_request_router.dart';
import 'package:blocsol_loan_application/personal_loan/constants/routes/login_router.dart';
import 'package:blocsol_loan_application/personal_loan/constants/routes/profile_router.dart';
import 'package:blocsol_loan_application/personal_loan/constants/routes/signup_router.dart';
import 'package:blocsol_loan_application/personal_loan/constants/routes/support_router.dart';
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
  ...personalNewLoanRequestRoutes,
  ...personalLoanLiabilitiesRoutes,
  ...personalLoanSupportRoutes
];
