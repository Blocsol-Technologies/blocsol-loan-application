import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:blocsol_loan_application/personal_loan/constants/routes/loan_request_router.dart';
import 'package:blocsol_loan_application/personal_loan/constants/theme.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/account_details/account_details.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/events/loan_events/loan_events.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/events/server_sent_events/sse.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/new_loan/new_loan.dart';
import 'package:blocsol_loan_application/utils/logger.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/snackbar_notifications/util.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class PCNewLoanGenerateOfferConsent extends ConsumerStatefulWidget {
  const PCNewLoanGenerateOfferConsent({super.key});

  @override
  ConsumerState<PCNewLoanGenerateOfferConsent> createState() =>
      _PCNewLoanGenerateOfferConsentState();
}

class _PCNewLoanGenerateOfferConsentState
    extends ConsumerState<PCNewLoanGenerateOfferConsent> {
  late CountdownTimerController _controller;
  final _generateOffersCancelToken = CancelToken();

  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 600;

  void _onCountdownEnd() {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'On Snap!',
        message: "Unable to fetch offers. Please contact support.",
        contentType: ContentType.failure,
      ),
      duration: const Duration(seconds: 10),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
    return;
  }

  void _performActions() async {
    if (ref.read(personalNewLoanRequestProvider).fetchingOffers) {
      return;
    }

    // Submit the forms
    var response = await ref
        .read(personalNewLoanRequestProvider.notifier)
        .submitFormsAndGenerateAAURL(_generateOffersCancelToken);

    if (!mounted) return;

    logFirebaseEvent("personal_loan_application_process", {
      "step": "submit_form_and_generate_aa_url",
      "phoneNumber": ref.read(personalLoanAccountDetailsProvider).phone,
      "success": response.success,
      "message": response.message,
      "data": response.data ?? {},
    });

    if (!response.success) {
      _controller.disposeTimer();

      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: getSnackbarNotificationWidget(
            message: "Unable to submit personal details to lenders",
            notifType: SnackbarNotificationType.error),
        duration: const Duration(seconds: 5),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);

      await Future.delayed(const Duration(seconds: 5));

      if (mounted) {
        context.go(PersonalNewLoanRequestRouter.new_loan_offers_home);
      }

      return;
    }

    context.go(PersonalNewLoanRequestRouter.new_loan_aa_webview,
        extra: response.data);

    return;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _performActions();
    });
    _controller =
        CountdownTimerController(endTime: endTime, onEnd: _onCountdownEnd);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _generateOffersCancelToken.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(personalNewLoanRequestProvider);
    ref.watch(personalLoanEventsProvider);
    ref.watch(personalLoanServerSentEventsProvider);
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset("assets/animations/submitting_details.json",
                    height: 250, width: 250),
                const SpacerWidget(height: 35),
                Text(
                  'We are submitting your details for offers. This may take a few minutes.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: AppFontSizes.h2,
                      fontWeight: AppFontWeights.medium,
                      color: Theme.of(context).colorScheme.onSurface),
                ),
                const SpacerWidget(height: 20),
                Text(
                  'Do not press back or close the app.',
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: AppFontSizes.h3,
                      fontWeight: AppFontWeights.medium,
                      color: Theme.of(context).colorScheme.onSurface),
                ),
                const SpacerWidget(height: 25),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  child: CountdownTimer(
                    controller: _controller,
                    onEnd: _onCountdownEnd,
                    endTime: endTime,
                    widgetBuilder: (_, CurrentRemainingTime? time) {
                      String text =
                          "min: ${time?.min ?? 0} - sec: ${time?.sec}";

                      if (time == null) {
                        text = "Time's up!";
                      }

                      return Text(
                        text,
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.h2,
                          fontWeight: AppFontWeights.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
