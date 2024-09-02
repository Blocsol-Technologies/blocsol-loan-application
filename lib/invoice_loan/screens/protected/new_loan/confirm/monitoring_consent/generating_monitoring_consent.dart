import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/loan_request_router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/theme.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/components/top_nav.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/loan_events/loan_events.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/server_sent_events/sse.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/loan_request.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/state/error_codes.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

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
    var generateConsentResponse = await ref
        .read(invoiceNewLoanRequestProvider.notifier)
        .generateLoanMonitoringConsentRequest(_cancelToken);

    if (!mounted) return;

    if (!generateConsentResponse.success) {
      ref.read(routerProvider).push(
          InvoiceNewLoanRequestRouter.loan_service_error,
          extra: InvoiceLoanServiceErrorCodes.generate_monitoring_consent_failed);
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
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    ref.watch(invoiceNewLoanRequestProvider);
    ref.watch(invoiceLoanServerSentEventsProvider);
    ref.watch(invoiceLoanEventsProvider);
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(
                20, RelativeSize.height(30, height), 20, 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                InvoiceNewLoanRequestTopNav(onBackClick: () {
                  ref.read(routerProvider).pop();
                }),
                const SpacerWidget(
                  height: 80,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Lottie.asset(
                      'assets/animations/abstract_save.json',
                      width: (width - 40),
                    ),
                  ],
                ),
                const SpacerWidget(
                  height: 60,
                ),
                SizedBox(
                  width: width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Generating Consent Details",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: AppFontSizes.heading,
                          fontWeight: AppFontWeights.bold,
                          letterSpacing: 0.14,
                        ),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                      const SpacerWidget(
                        height: 5,
                      ),
                      Text(
                        "Lender requires account monitoring consent for loan processing",
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
