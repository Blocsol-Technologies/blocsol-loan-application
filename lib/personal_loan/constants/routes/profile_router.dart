import 'package:blocsol_loan_application/personal_loan/screens/user_screens/profile/account_aggregator/account_aggregator_select.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/profile/account_info/index.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/profile/bank_account/add_bank_account.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/profile/bank_account/index.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/profile/settings/change_password.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/profile/settings/dashboard/account_settings.dart';
import 'package:blocsol_loan_application/utils/lender_utils.dart';
import 'package:go_router/go_router.dart';

class PersonalLoanProfileRouter {
  static const accountInfo = '/personal-loan/profile/account-info';
  static const bankAccountSettings =
      '/personal-loan/profile/bank-account-settings';
  static const addBankAccount = '/personal-loan/profile/add-bank-account';

  static const accountAggregatorSelect =
      '/personal-loan/profile/account-aggregator-setup';

  static const settings = '/personal-loan/profile/settings';
  static const changePassword =
      '/personal-loan/profile/settings/change-password';
}

List<GoRoute> personalLoanProfileRoutes = [
  GoRoute(
    path: PersonalLoanProfileRouter.accountInfo,
    builder: (context, state) => const PlProfileAccountInfo(),
  ),
  GoRoute(
    path: PersonalLoanProfileRouter.addBankAccount,
    builder: (context, state) {
      var addBankDetailsRouterInfo = state.extra as AddBankAccountRouterDetails;
      final accountNumber = addBankDetailsRouterInfo.accountNumber;
      final ifscCode = addBankDetailsRouterInfo.ifscCode;
      return PlProfileAddBankAccount(
        accountNumber: accountNumber,
        ifscCode: ifscCode,
      );
    },
  ),
  GoRoute(
    path: PersonalLoanProfileRouter.bankAccountSettings,
    builder: (context, state) => const PlProfileBankAccount(),
  ),
  GoRoute(
    path: PersonalLoanProfileRouter.accountAggregatorSelect,
    builder: (context, state) {
      var bankName = state.extra != null ? state.extra as String : "";

      if (bankName.isEmpty) {
        return const PlProfileBankAccount();
      }

      List<AccountAggregatorInfo> aaList = getLenderConnectedAA(bankName);

      return PlProfileAASelect(
        aaList: aaList,
      );
    },
  ),
  GoRoute(
    path: PersonalLoanProfileRouter.settings,
    builder: (context, state) => const PlAccountSettings(),
  ),
  GoRoute(
    path: PersonalLoanProfileRouter.changePassword,
    builder: (context, state) => const PlProfileChangePassword(),
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
