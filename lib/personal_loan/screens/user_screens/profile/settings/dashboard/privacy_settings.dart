import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/global_state/theme/theme_state.dart';
import 'package:blocsol_loan_application/personal_loan/constants/routes/profile_router.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlPrivacySettings extends ConsumerWidget {
  const PlPrivacySettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;

    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Privacy & Security",
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: AppFontSizes.h3,
              fontWeight: AppFontWeights.medium,
              color: const Color.fromRGBO(75, 85, 95, 1),
            ),
          ),
          const SpacerWidget(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              ref
                  .read(routerProvider)
                  .push(PersonalLoanProfileRouter.changePassword);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Change Password",
                  style: TextStyle(
                    fontFamily: fontFamily,
                    fontSize: AppFontSizes.b1,
                    fontWeight: AppFontWeights.medium,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
