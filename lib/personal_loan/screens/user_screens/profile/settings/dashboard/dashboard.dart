import 'package:blocsol_loan_application/global_state/theme/theme_state.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/profile/components/curved_background.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/profile/components/top_nav_bar.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/profile/settings/dashboard/account_settings.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/profile/settings/dashboard/privacy_settings.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/account_details/account_details.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlProfileSettingsDashboard extends ConsumerWidget {
  const PlProfileSettingsDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final _ = ref.watch(personalLoanAccountDetailsProvider);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            vertical: RelativeSize.height(25, height),
            horizontal: RelativeSize.width(25, width),
          ),
          physics: const BouncingScrollPhysics(),
          child: Stack(
            children: [
              Positioned(
                  child: SizedBox(
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: RelativeSize.width(250, width),
                      width: RelativeSize.width(250, width),
                      child: Center(
                        child: Image.asset(
                          "assets/images/invoice_loan/profile/settings.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
              Column(
                children: [
                  const PlProfileTopNav(),
                  const SpacerWidget(
                    height: 35,
                  ),
                  Text(
                    "Settingss",
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
                  const PlCurvedBackground(
                    child: Column(
                      children: [
                        PlAccountSettings(),
                        SpacerWidget(
                          height: 40,
                        ),
                        PlPrivacySettings(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
