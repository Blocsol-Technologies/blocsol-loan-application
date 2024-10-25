import 'dart:math';

import 'package:blocsol_loan_application/personal_loan/constants/theme.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/new_loan/new_loan.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonalNewLoanRequestCountdownTimer extends ConsumerStatefulWidget {
  const PersonalNewLoanRequestCountdownTimer({super.key});

  @override
  ConsumerState<PersonalNewLoanRequestCountdownTimer> createState() =>
      _PersonalNewLoanRequestCountdownTimerState();
}

class _PersonalNewLoanRequestCountdownTimerState
    extends ConsumerState<PersonalNewLoanRequestCountdownTimer> {
  int endTime = DateTime.now().millisecondsSinceEpoch ~/ 1000 + 1800;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      int properEndTime = max(
          1800 -
              (DateTime.now().millisecondsSinceEpoch ~/ 1000 -
                  ref
                      .read(personalNewLoanRequestProvider)
                      .offersFetchTime),
          0);

      setState(() {
        endTime =
            DateTime.now().millisecondsSinceEpoch + (properEndTime) * 1000;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: RelativeSize.width(170, width),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: const Color.fromRGBO(233, 248, 238, 1),
        border: Border.all(
          color: Theme.of(context).colorScheme.surface,
          width: 1,
        ),
      ),
      child: Center(
        child: CountdownTimer(
          endTime: endTime,
          onEnd: () {
            // ref.read(invoiceNewLoanRequestProvider.notifier).reset();
            // context.go(InvoiceNewLoanRequestRouter.loan_service_error, extra: InvoiceLoanServiceErrorCodes.request_timeout);
          },
          widgetBuilder: (_, CurrentRemainingTime? time) {
            String text = "${time?.min ?? "00"}min : ${time?.sec ?? "00"}sec";
    
            if (time == null) {
              text = "Time's up!";
            }
    
            return Text(
              "Valid for: $text",
              style: TextStyle(
                fontFamily: fontFamily,
                fontSize: AppFontSizes.b1,
                fontWeight: AppFontWeights.medium,
                color: const Color.fromRGBO(39, 188, 92, 1),
              ),
            );
          },
        ),
      ),
    );
  }
}
