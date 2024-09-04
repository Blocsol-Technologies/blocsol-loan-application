import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/loan_request_router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/theme.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/loan_events/loan_events.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/server_sent_events/sse.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/loan_request.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/state/loan_request_state.dart';
import 'package:blocsol_loan_application/utils/logger.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/snackbar_notifications/util.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class InvoiceLoanRequestSubmittingSearchForm extends ConsumerStatefulWidget {
  const InvoiceLoanRequestSubmittingSearchForm({super.key});

  @override
  ConsumerState<InvoiceLoanRequestSubmittingSearchForm> createState() =>
      _NewLoanSubmittingInvoicesForOffersScreenState();
}

class _NewLoanSubmittingInvoicesForOffersScreenState
    extends ConsumerState<InvoiceLoanRequestSubmittingSearchForm> {
  late CountdownTimerController controller;
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 600;
  final submitInvoiceCancelToken = CancelToken();
  final fetchOfferCancelToken = CancelToken();

  void onCountdownEnd() {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: getSnackbarNotificationWidget(
          message:
              "Unable to fetch offers on invoices. Please contact support.",
          notifType: SnackbarNotificationType.error),
      duration: const Duration(seconds: 10),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  void performActions() async {
    if (ref.read(invoiceNewLoanRequestProvider).submittingInvoicesForOffers) {
      return;
    }

    // Submit the forms
    var response = await ref
        .read(invoiceNewLoanRequestProvider.notifier)
        .submitForms(submitInvoiceCancelToken);

    if (!mounted) return;

    if (!response.success) {
      controller.disposeTimer();

      context.go(InvoiceNewLoanRequestRouter.loan_service_unavailable,
          extra:
              "Unable to submit customer information for loan offers. Please contact support.");

      return;
    }

    var generateAccountAggregatorResponse = await ref
        .read(invoiceNewLoanRequestProvider.notifier)
        .generateAAURL(fetchOfferCancelToken);

    if (!mounted) return;

    if (generateAccountAggregatorResponse.success) {
      bool redirectionRequired =
          generateAccountAggregatorResponse.data['redirect'] ??
              false; // redirect to the select loan offer screen
      if (redirectionRequired) {
        ref
            .read(invoiceNewLoanRequestProvider.notifier)
            .updateState(LoanRequestProgress.customerDetailsProvided);

        ref
            .read(routerProvider)
            .pushReplacement(InvoiceNewLoanRequestRouter.loan_offer_select);

        return;
      } else {
        ref.read(routerProvider).pushReplacement(
            InvoiceNewLoanRequestRouter.account_aggregator_webview,
            extra: generateAccountAggregatorResponse.data['url']);
        return;
      }
    } else {
      logger.d(
          "response.success is after generating aa response ${generateAccountAggregatorResponse.success}");

      context.go(InvoiceNewLoanRequestRouter.loan_service_unavailable,
          extra:
              "Could not generate account aggregator url. Please contact support.");

      return;
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      performActions();
    });
    controller =
        CountdownTimerController(endTime: endTime, onEnd: onCountdownEnd);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    ref.watch(invoiceLoanServerSentEventsProvider);
    ref.watch(invoiceLoanEventsProvider);
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SpacerWidget(
                  height: 50,
                ),
                Lottie.asset("assets/animations/rocket.json",
                    height: RelativeSize.width(300, width),
                    width: RelativeSize.width(300, width)),
                const SpacerWidget(height: 35),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.3),
                    ),
                  ),
                  child: CountdownTimer(
                    controller: controller,
                    onEnd: onCountdownEnd,
                    endTime: endTime,
                    widgetBuilder: (_, CurrentRemainingTime? time) {
                      String text = "${time?.min ?? 0}:${time?.sec}";

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
                const SpacerWidget(
                  height: 100,
                ),
                SizedBox(
                  width: width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Initiating Loan Process with Lender...',
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
                        'Do not press back or close the app.',
                        style: TextStyle(
                          fontFamily: fontFamily,
                          color: const Color.fromRGBO(130, 130, 130, 1),
                          fontSize: AppFontSizes.h3,
                          fontWeight: AppFontWeights.medium,
                          letterSpacing: 0.14,
                        ),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                    ],
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
