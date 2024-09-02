import 'package:blocsol_loan_application/invoice_loan/screens/protected/profile/components/curved_background.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/profile/components/top_nav_bar.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/profile/account_info/text_boxes.dart';
import 'package:blocsol_loan_application/invoice_loan/state/user/profile/profile_details.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/theme.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InvoiceLoanProfileAccountInfo extends ConsumerWidget {
  const InvoiceLoanProfileAccountInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final profileRef = ref.watch(invoiceLoanUserProfileDetailsProvider);
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
              const InvoiceLoanProfileTopNav(),
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
              CurvedBackground(
                child: Column(
                  children: [
                    InvoiceLoanProfileInfoTextBox(
                      label: "Name",
                      textVal: profileRef.tradeName,
                    ),
                    const SpacerWidget(
                      height: 15,
                    ),
                    InvoiceLoanProfileInfoTextBox(
                      label: "GST Number",
                      textVal: profileRef.gstNumber,
                    ),
                    const SpacerWidget(
                      height: 15,
                    ),
                    InvoiceLoanProfileInfoTextBox(
                      label: "Pan Number",
                      textVal: profileRef.gstNumber.length == 15
                          ? profileRef.gstNumber.substring(2, 12)
                          : "",
                    ),
                    const SpacerWidget(
                      height: 15,
                    ),
                    InvoiceLoanProfileInfoTextBox(
                      label: "Contact",
                      textVal: profileRef.phone,
                    ),
                    const SpacerWidget(
                      height: 15,
                    ),
                    InvoiceLoanProfileInfoTextBox(
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
