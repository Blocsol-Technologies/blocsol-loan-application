import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/loan_request_router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/theme.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/loan_events/loan_events.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/server_sent_events/sse.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/loan_request.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/state/error_codes.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:lottie/lottie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InvoiceNewLoanGenerateMonitroingConsent extends ConsumerStatefulWidget {
  const InvoiceNewLoanGenerateMonitroingConsent({super.key});

  @override
  ConsumerState<InvoiceNewLoanGenerateMonitroingConsent> createState() =>
      _InvoiceNewLoanGenerateMonitroingConsentState();
}

class _InvoiceNewLoanGenerateMonitroingConsentState
    extends ConsumerState<InvoiceNewLoanGenerateMonitroingConsent> {
  final _cancelToken = CancelToken();

  void fetchMonitoringConsentHandler() async {
    if (ref.read(invoiceNewLoanRequestProvider).generatingMonitoringConsent) {
      return;
    }

    var generateConsentResponse = await ref
        .read(invoiceNewLoanRequestProvider.notifier)
        .generateLoanMonitoringConsentRequest(_cancelToken);

    if (!mounted) return;

    if (!generateConsentResponse.success) {
      ref.read(routerProvider).push(
          InvoiceNewLoanRequestRouter.loan_service_error,
          extra: LoanServiceErrorCodes.generate_monitoring_consent_failed);
      return;
    }

    ref.read(routerProvider).pushReplacement(
        InvoiceNewLoanRequestRouter.monitoring_consent_webview,
        extra: generateConsentResponse.data['url']);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchMonitoringConsentHandler();
    });
    super.initState();
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final newLoanStateRef = ref.watch(invoiceNewLoanRequestProvider);
    ref.watch(invoiceLoanServerSentEventsProvider);
    ref.watch(invoiceLoanEventsProvider);
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(30),
            child: newLoanStateRef.generateMonitoringConsentErr
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Lottie.asset(
                        "assets/animations/error.json",
                        height: 300,
                        width: 300,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Error when generating monitoring consent. Contact Support...",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.h1,
                          fontWeight: AppFontWeights.bold,
                          letterSpacing: 0.4,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        softWrap: true,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              ref.read(routerProvider).pop();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 20),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                child: Text(
                                  "Go Back",
                                  style: TextStyle(
                                    fontFamily: fontFamily,
                                    fontSize: AppFontSizes.h3,
                                    fontWeight: AppFontWeights.medium,
                                    letterSpacing: 0.4,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              fetchMonitoringConsentHandler();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 20),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                child: Text(
                                  "Try Again",
                                  style: TextStyle(
                                    fontFamily: fontFamily,
                                    fontSize: AppFontSizes.h3,
                                    fontWeight: AppFontWeights.medium,
                                    letterSpacing: 0.4,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Lottie.asset(
                        "assets/animations/submitting_details.json",
                        height: 300,
                        width: 300,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Generating Consent Details...",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.h1,
                          fontWeight: AppFontWeights.bold,
                          letterSpacing: 0.4,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        softWrap: true,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      Text(
                        "Please do not press back or exit",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.h3,
                          fontWeight: AppFontWeights.medium,
                          letterSpacing: 0.4,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6),
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
