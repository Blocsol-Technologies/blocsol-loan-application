import 'package:blocsol_loan_application/global_state/auth/auth.dart';
import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/global_state/theme/theme_state.dart';
import 'package:blocsol_loan_application/personal_loan/constants/routes/index_router.dart';
import 'package:blocsol_loan_application/personal_loan/constants/routes/profile_router.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/profile/profile_dashboard/dashboard_hero.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/profile/profile_dashboard/nav_item.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/account_details/account_details.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PLProfileDashboard extends ConsumerWidget {
  const PLProfileDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            vertical: RelativeSize.height(25, height),
            horizontal: RelativeSize.width(25, width),
          ),
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const PLProfileDashboardHero(),
              SpacerWidget(
                height: RelativeSize.height(52, height),
              ),
              const PlProfileNavItem(
                text: "Account Information",
                route: PersonalLoanProfileRouter.accountInfo,
              ),
              const PlProfileNavItem(
                text: "Bank Account",
                route: PersonalLoanProfileRouter.bankAccountSettings,
              ),
              const PlProfileNavItem(
                  text: "Support", route: PersonalLoanIndexRouter.support_home),
              Container(
                width: width,
                height: RelativeSize.height(70, height),
                padding:
                    EdgeInsets.only(bottom: RelativeSize.height(15, height)),
                margin:
                    EdgeInsets.only(bottom: RelativeSize.height(15, height)),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 1,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.2),
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        ref.read(routerProvider).push(
                            PersonalLoanProfileRouter.accountAggregatorSelect,
                            extra: ref
                                .read(personalLoanAccountDetailsProvider)
                                .primaryBankAccount
                                .bankName);
                      },
                      child: Container(
                        height: RelativeSize.height(50, height),
                        width: width,
                        padding: const EdgeInsets.only(
                            top: 17, bottom: 17, left: 17, right: 9),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(228, 247, 255, 1),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Account Aggregator",
                              style: TextStyle(
                                fontFamily: fontFamily,
                                fontSize: AppFontSizes.h3,
                                fontWeight: AppFontWeights.medium,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: Theme.of(context).colorScheme.onSurface,
                              size: 17,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const PlProfileNavItem(
                text: "Settings",
                route: PersonalLoanProfileRouter.settings,
              ),
              GestureDetector(
                onTap: () async {
                  HapticFeedback.heavyImpact();
                  await ref.read(authProvider.notifier).logoutInvoiceLoanUser();

                  if (!context.mounted) return;

                  context.go(AppRoutes.entry);
                },
                child: Container(
                  height: RelativeSize.height(50, height),
                  width: width,
                  padding: const EdgeInsets.only(
                      top: 17, bottom: 17, left: 17, right: 9),
                  decoration: BoxDecoration(
                    color: Colors.red.shade400,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Logout",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.h3,
                          fontWeight: AppFontWeights.medium,
                          color: Colors.white,
                        ),
                      ),
                      const Icon(
                        Icons.login_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
