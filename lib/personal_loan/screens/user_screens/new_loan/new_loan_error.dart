import 'package:blocsol_loan_application/personal_loan/constants/routes/index_router.dart';
import 'package:blocsol_loan_application/personal_loan/constants/theme.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/events/loan_events/loan_events.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/events/server_sent_events/sse.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class PCNewLoanErrorScreen extends ConsumerStatefulWidget {
  final String errorMessage;
  const PCNewLoanErrorScreen({super.key, required this.errorMessage});

  @override
  ConsumerState<PCNewLoanErrorScreen> createState() => _PCNewLoanErrorScreenState();
}

class _PCNewLoanErrorScreenState extends ConsumerState<PCNewLoanErrorScreen> {
  @override
  Widget build(BuildContext context) {
    ref.watch(personalLoanServerSentEventsProvider);
    ref.watch(personalLoanEventsProvider);
    return SafeArea(
        child: Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Container(
        padding: EdgeInsets.all(
            RelativeSize.height(30, MediaQuery.of(context).size.height)),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SpacerWidget(height: 120),
            Lottie.asset("assets/animations/error.json",
                height: 200, width: 200),
            const SpacerWidget(height: 35),
            Text(
              widget.errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: fontFamily,
                fontSize: AppFontSizes.h2,
                fontWeight: AppFontWeights.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SpacerWidget(
              height: 80,
            ),
           
            GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                context.go(PersonalLoanIndexRouter.dashboard);
              },
              child: Container(
                height: 30,
                width: 150,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    "Restart",
                    style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: AppFontSizes.h3,
                      fontWeight: AppFontWeights.medium,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
