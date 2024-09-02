import 'package:blocsol_loan_application/invoice_loan/screens/protected/profile/components/top_nav_bar.dart';
import 'package:blocsol_loan_application/invoice_loan/state/user/profile/profile_details.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/theme.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileDashboardHero extends ConsumerWidget {
  const ProfileDashboardHero({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;
    final profileDetailsRef = ref.watch(invoiceLoanUserProfileDetailsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const InvoiceLoanProfileTopNav(),
        const SpacerWidget(
          height: 25,
        ),
        Container(
          height: RelativeSize.height(100, height),
          width: RelativeSize.height(100, height),
          padding: const EdgeInsets.all(15),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color.fromRGBO(228, 247, 255, 1),
          ),
          child: Center(
            child: Image.asset(
              "assets/images/invoice_loan/profile/office.png",
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SpacerWidget(
          height: 25,
        ),
        Text(
          profileDetailsRef.tradeName,
          style: TextStyle(
            fontFamily: fontFamily,
            fontSize: AppFontSizes.h2,
            fontWeight: AppFontWeights.medium,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SpacerWidget(
          height: 6,
        ),
        Text(
          'GST: ${profileDetailsRef.gstNumber}',
          style: TextStyle(
            fontFamily: fontFamily,
            fontSize: AppFontSizes.b1,
            fontWeight: AppFontWeights.medium,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        )
      ],
    );
  }
}
