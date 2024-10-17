import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/personal_loan/constants/routes/profile_router.dart';
import 'package:blocsol_loan_application/personal_loan/constants/theme.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/profile/bank_account/bank_card.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/profile/components/curved_background.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/profile/components/top_nav_bar.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/account_details/account_details.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/account_details/state/bank_account_details.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlProfileBankAccount extends ConsumerWidget {
  const PlProfileBankAccount({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final profileRef = ref.watch(personalLoanAccountDetailsProvider);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            vertical: RelativeSize.height(25, height),
            horizontal: RelativeSize.width(25, width),
          ),
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const PlProfileTopNav(),
              const SpacerWidget(
                height: 35,
              ),
              Text(
                "Bank Account",
                style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: AppFontSizes.h2,
                  fontWeight: AppFontWeights.medium,
                  color: Theme.of(context).colorScheme.onTertiary,
                ),
              ),
              const SpacerWidget(
                height: 25,
              ),
              PlCurvedBackground(
                horizontalPadding: 11,
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: profileRef.bankAccounts.length,
                      itemBuilder: (ctx, idx) {
                        PlBankAccountDetails bankAccount =
                            profileRef.bankAccounts[idx];
                        bool isPrimary =
                            profileRef.primaryBankAccount.accountNumber ==
                                bankAccount.accountNumber;
                        return GestureDetector(
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            ref.read(routerProvider).push(
                                PersonalLoanProfileRouter.addBankAccount,
                                extra: AddBankAccountRouterDetails(
                                    accountNumber: bankAccount.accountNumber, ifscCode: bankAccount.ifscCode));
                          },
                          child: PlBankDetailsCard(
                            bankName: bankAccount.bankName,
                            accountNumber: bankAccount.accountNumber,
                            ifscCode: bankAccount.ifscCode,
                            accountHolderName: bankAccount.accountHolderName,
                            isPrimary: isPrimary,
                          ),
                        );
                      },
                    ),
                    const SpacerWidget(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        ref.read(routerProvider).push(
                            PersonalLoanProfileRouter.addBankAccount,
                            extra: AddBankAccountRouterDetails(
                                accountNumber: "", ifscCode: ""));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            color: Theme.of(context).colorScheme.primary,
                            size: 25,
                          ),
                          const SpacerWidget(
                            width: 10,
                          ),
                          Text(
                            "Add another account",
                            style: TextStyle(
                                fontFamily: fontFamily,
                                fontSize: AppFontSizes.b1,
                                fontWeight: AppFontWeights.medium,
                                color: Theme.of(context).colorScheme.primary),
                          )
                        ],
                      ),
                    ),
                    profileRef.accountAggregatorId.isEmpty &&
                            profileRef
                                .primaryBankAccount.accountNumber.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              ref.read(routerProvider).push(
                                  PersonalLoanProfileRouter
                                      .accountAggregatorSelect,
                                  extra: ref
                                      .read(
                                          personalLoanAccountDetailsProvider)
                                      .primaryBankAccount
                                      .bankName);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.data_exploration_sharp,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 25,
                                ),
                                const SpacerWidget(
                                  width: 10,
                                ),
                                Text(
                                  "Setup Account Aggregator?",
                                  style: TextStyle(
                                      fontFamily: fontFamily,
                                      fontSize: AppFontSizes.b1,
                                      fontWeight: AppFontWeights.medium,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                )
                              ],
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
