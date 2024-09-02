import 'package:blocsol_loan_application/personal_loan/constants/theme.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/profile/components/top_nav_bar.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/account_details/account_details.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PLProfileDashboardHero extends ConsumerWidget {
  const PLProfileDashboardHero({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;
    final profileDetailsRef = ref.watch(personalLoanAccountDetailsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const PlProfileTopNav(),
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
            child: Image.network(
              profileDetailsRef.imageURL.isEmpty
                  ? "https://placehold.co/30x30/000000/FFFFFF.png"
                  : profileDetailsRef.imageURL,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SpacerWidget(
          height: 25,
        ),
        Text(
          profileDetailsRef.name,
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
          'PAN: ${profileDetailsRef.pan}',
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
