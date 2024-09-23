import 'package:blocsol_loan_application/invoice_loan/screens/protected/profile/account_aggregator/account_aggregator_select.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/profile/account_info/index.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/profile/bank_account/add_bank_account.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/profile/bank_account/index.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/profile/privacy_policy_webview.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/profile/settings/change_password.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/profile/settings/dashboard/dashboard.dart';
import 'package:blocsol_loan_application/utils/lender_utils.dart';
import 'package:go_router/go_router.dart';

class InvoiceLoanProfileRouter {
  static const accountInfo = '/invoice-loan/profile/account-info';
  static const bankAccountSettings =
      '/invoice-loan/profile/bank-account-settings';
  static const addBankAccount = '/invoice-loan/profile/add-bank-account';

  static const accountAggregatorSelect =
      '/invoice-loan/profile/account-aggregator-setup';

  static const settings = '/invoice-loan/profile/settings';
  static const changePassword =
      '/invoice-loan/profile/settings/change-password';

  static const privacyPolicy = '/invoice-loan/profile/privacy-policy';
}

List<GoRoute> invoiceLoanProfileRoutes = [
  GoRoute(
    path: InvoiceLoanProfileRouter.accountInfo,
    builder: (context, state) => const InvoiceLoanProfileAccountInfo(),
  ),
  GoRoute(
    path: InvoiceLoanProfileRouter.addBankAccount,
    builder: (context, state) {
      var addBankDetailsRouterInfo = state.extra as AddBankAccountRouterDetails;
      final accountNumber = addBankDetailsRouterInfo.accountNumber;
      final ifscCode = addBankDetailsRouterInfo.ifscCode;
      return InvoiceLoanProfileAddBankAccount(
        accountNumber: accountNumber,
        ifscCode: ifscCode,
      );
    },
  ),
  GoRoute(
    path: InvoiceLoanProfileRouter.bankAccountSettings,
    builder: (context, state) => const InvoiceLoanProfileBankAccount(),
  ),
  GoRoute(
    path: InvoiceLoanProfileRouter.accountAggregatorSelect,
    builder: (context, state) {
      var bankName = state.extra != null ? state.extra as String : "";

      if (bankName.isEmpty) {
        return const InvoiceLoanProfileBankAccount();
      }

      List<AccountAggregatorInfo> aaList = getLenderConnectedAA(bankName);

      return InvoiceLoanProfileAASelect(
        aaList: aaList,
      );
    },
  ),
  GoRoute(
    path: InvoiceLoanProfileRouter.settings,
    builder: (context, state) => const InvoiceLoanProfileSettingsDashboard(),
  ),
  GoRoute(
    path: InvoiceLoanProfileRouter.changePassword,
    builder: (context, state) => const InvoiceLoanProfileChangePassword(),
  ),
  GoRoute(
    path: InvoiceLoanProfileRouter.privacyPolicy,
    builder: (context, state) => const InvoiceLoanPrivacyPolicyWebview(),
  ),
];

class AddBankAccountRouterDetails {
  final String accountNumber;
  final String ifscCode;

  AddBankAccountRouterDetails({
    required this.accountNumber,
    required this.ifscCode,
  });
}
