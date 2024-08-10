import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/loan_request_router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/theme.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/loan_events/loan_events.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/server_sent_events/sse.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/loan_request.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/state/loan_request_state.dart';
import 'package:blocsol_loan_application/utils/logger.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

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
      content: AwesomeSnackbarContent(
        title: 'On Snap!',
        message: "Unable to fetch offers on invoices. Please contact support.",
        contentType: ContentType.failure,
      ),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset("assets/animations/filing_invoice_forms.json",
                    height: 250, width: 250),
                const SpacerWidget(height: 35),
                Text(
                  'We are submitting your invoices for offers. This may take a few minutes.',
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
                      fontSize: AppFontSizes.h2,
                      fontWeight: AppFontWeights.medium,
                      color: Theme.of(context).colorScheme.onSurface),
                ),
                const SpacerWidget(height: 20),
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
                    controller: controller,
                    onEnd: onCountdownEnd,
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
