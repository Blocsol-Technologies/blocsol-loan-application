import 'package:blocsol_loan_application/personal_loan/constants/theme.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/profile/account_info/text_boxes.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/profile/components/curved_background.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/profile/components/top_nav_bar.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/account_details/account_details.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlProfileAccountInfo extends ConsumerWidget {
  const PlProfileAccountInfo({super.key});

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
                "Account Information",
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
                child: Column(
                  children: [
                    PlProfileInfoTextBox(
                      label: "Name",
                      textVal: profileRef.name,
                    ),
                    const SpacerWidget(
                      height: 15,
                    ),
                    PlProfileInfoTextBox(
                      label: "Udyam Number",
                      textVal: profileRef.udyam,
                    ),
                    const SpacerWidget(
                      height: 15,
                    ),
                    PlProfileInfoTextBox(
                      label: "Pan Number",
                      textVal: profileRef.pan,
                    ),
                    const SpacerWidget(
                      height: 15,
                    ),
                    PlProfileInfoTextBox(
                      label: "Contact",
                      textVal: profileRef.phone,
                    ),
                    const SpacerWidget(
                      height: 15,
                    ),
                    PlProfileInfoTextBox(
                        label: "Email", textVal: profileRef.email),
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
