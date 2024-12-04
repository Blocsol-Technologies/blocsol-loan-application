import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/global_state/theme/theme_state.dart';
import 'package:blocsol_loan_application/personal_loan/constants/routes/loan_request_router.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/new_loan/components/timer.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/new_loan/components/top_nav.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/events/loan_events/loan_events.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/events/server_sent_events/sse.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/new_loan/new_loan.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/snackbar_notifications/util.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:go_router/go_router.dart';


class PersonalNewLoanAgreementFailed extends ConsumerStatefulWidget {
  const PersonalNewLoanAgreementFailed({super.key});

  @override
  ConsumerState<PersonalNewLoanAgreementFailed> createState() =>
      _PersonalNewLoanAgreementFailedState();
}

class _PersonalNewLoanAgreementFailedState
    extends ConsumerState<PersonalNewLoanAgreementFailed> {
  final _cancelToken = CancelToken();
  bool _refetchingLoanAgreementUrl = false;

  Future<void> _refetchLoanAgreementUrl() async {
    if (!ref.read(personalNewLoanRequestProvider).loanAgreementFailure) {
      return;
    }

    setState(() {
      _refetchingLoanAgreementUrl = true;
    });

    ref
        .read(personalNewLoanRequestProvider.notifier)
        .updateLoanAgreementFailure(false);

    var response = await ref
        .read(personalNewLoanRequestProvider.notifier)
        .refetchLoanAgreementURL(_cancelToken);

    if (!mounted) return;

    setState(() {
      _refetchingLoanAgreementUrl = false;
    });

    if (!response.success) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: getSnackbarNotificationWidget(
            message:
                "Lender does not support refetching loan agreement. Please start again!",
            notifType: SnackbarNotificationType.error),
        duration: const Duration(seconds: 5),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    ref.watch(personalLoanServerSentEventsProvider);
    ref.watch(personalLoanEventsProvider);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
              RelativeSize.width(20, width),
              RelativeSize.height(30, height),
              RelativeSize.width(20, width),
              RelativeSize.height(50, height)),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              PersonalNewLoanRequestTopNav(
                onBackClick: () {
                  ref.read(routerProvider).pushReplacement(
                      PersonalNewLoanRequestRouter.new_loan_offers_home);
                },
              ),
              const SpacerWidget(height: 35),
              const PersonalNewLoanRequestCountdownTimer(),
              const SpacerWidget(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Lottie.asset(
                    'assets/animations/unavailable.json',
                    width: (width - 80),
                  ),
                ],
              ),
              const SpacerWidget(
                height: 40,
              ),
              SizedBox(
                width: width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Lender has rejected your",
                      style: TextStyle(
                        fontFamily: fontFamily,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: AppFontSizes.heading,
                        fontWeight: AppFontWeights.bold,
                        letterSpacing: 0.14,
                      ),
                      textAlign: TextAlign.start,
                      softWrap: true,
                    ),
                    Text(
                      "Loan Agreement Submission!",
                      style: TextStyle(
                        fontFamily: fontFamily,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: AppFontSizes.heading,
                        fontWeight: AppFontWeights.bold,
                        letterSpacing: 0.14,
                      ),
                      textAlign: TextAlign.start,
                      softWrap: true,
                    ),
                    const SpacerWidget(
                      height: 5,
                    ),
                    Text(
                      "Choose your next step",
                      style: TextStyle(
                        fontFamily: fontFamily,
                        color: const Color.fromRGBO(130, 130, 130, 1),
                        fontSize: AppFontSizes.h3,
                        fontWeight: AppFontWeights.medium,
                        letterSpacing: 0.14,
                      ),
                      textAlign: TextAlign.start,
                      softWrap: true,
                    ),
                    const SpacerWidget(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () async {
                        HapticFeedback.heavyImpact();
                        await _refetchLoanAgreementUrl();
                      },
                      child: Container(
                        height: 40,
                        width: RelativeSize.width(252, width),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).colorScheme.tertiary,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: _refetchingLoanAgreementUrl
                              ? Lottie.asset(
                                  "assets/animations/loading_spinner.json",
                                  width: 40)
                              : Text(
                                  "Retry Agreement Signing",
                                  style: TextStyle(
                                    fontFamily: fontFamily,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontSize: AppFontSizes.h3,
                                    fontWeight: AppFontWeights.bold,
                                    letterSpacing: 0.14,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SpacerWidget(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.heavyImpact();
                        context.go(PersonalNewLoanRequestRouter.new_loan_offers_home);
                      },
                      child: Container(
                        height: 40,
                        width: RelativeSize.width(252, width),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).colorScheme.surface,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Select Another Offer",
                            style: TextStyle(
                              fontFamily: fontFamily,
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: AppFontSizes.h3,
                              fontWeight: AppFontWeights.bold,
                              letterSpacing: 0.14,
                            ),
                          ),
                        ),
                      ),
                    ),
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
