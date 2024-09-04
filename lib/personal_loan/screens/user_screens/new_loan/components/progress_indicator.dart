import 'package:blocsol_loan_application/personal_loan/constants/theme.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/new_loan/new_loan.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonalNewLoanProgressIndicator extends ConsumerWidget {
  const PersonalNewLoanProgressIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(personalNewLoanRequestProvider);
    return Container(
      height: 25,
      width: 90,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.75),
          width: 1,
        ),
      ),
      child: Stack(
        children: <Widget>[
          Center(
            child: Text(
              ref
                  .read(personalNewLoanRequestProvider.notifier)
                  .getProgressUpdateText(),
              style: TextStyle(
                fontFamily: fontFamily,
                fontSize: AppFontSizes.b1,
                fontWeight: AppFontWeights.extraBold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              width: 90 *
                  ref
                      .read(personalNewLoanRequestProvider.notifier)
                      .getProgressFillRatio(),
              height: 25,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
            ),
          ),
        ],
      ),
    );
  }
}
