import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/global_state/theme/theme_state.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/index_router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/loan_request_router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/support_router.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/loan_events/loan_events.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/server_sent_events/sse.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/loan_request.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/state/error_codes.dart';
import 'package:blocsol_loan_application/utils/lender_utils.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:lottie/lottie.dart';

class InvoiceNewLoanMonitoringConsentWebview extends ConsumerStatefulWidget {
  final String url;
  const InvoiceNewLoanMonitoringConsentWebview({super.key, required this.url});

  @override
  ConsumerState<InvoiceNewLoanMonitoringConsentWebview> createState() =>
      _InvoiceNewLoanMonitoringConsentWebviewState();
}

class _InvoiceNewLoanMonitoringConsentWebviewState
    extends ConsumerState<InvoiceNewLoanMonitoringConsentWebview> {
  final _cancelToken = CancelToken();
  final GlobalKey _montoringConsentAAWebviewScreen = GlobalKey();

  String _currentUrl = "";
  bool _loadingAAURL = true;

  InAppWebViewController? webViewController;

  void _checkMonitoringConsentSuccess(String? ecres, String? resdate) async {
    if (ref
        .read(invoiceNewLoanRequestProvider)
        .validatingMonitoringConsentSuccess) {
      return;
    }

    if (ecres == null || resdate == null) {
      ref.read(routerProvider).push(
          InvoiceNewLoanRequestRouter.loan_service_error,
          extra: LoanServiceErrorCodes.monitoring_consent_verification_failed);
      return;
    }

    var checkSuccessResponse = await ref
        .read(invoiceNewLoanRequestProvider.notifier)
        .checkLoanMonitoringConsentSuccess(_cancelToken, ecres, resdate);

    if (!checkSuccessResponse.success) {
      ref.read(routerProvider).push(
          InvoiceNewLoanRequestRouter.loan_service_error,
          extra: LoanServiceErrorCodes.monitoring_consent_verification_failed);
      return;
    }
  }

  @override
  void initState() {
    setState(() {
      _currentUrl = widget.url;
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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final newLoanStateRef = ref.watch(invoiceNewLoanRequestProvider);
    ref.watch(invoiceLoanServerSentEventsProvider);
    ref.watch(invoiceLoanEventsProvider);
    final selectedOffer = newLoanStateRef.selectedOffer;
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            padding: EdgeInsets.fromLTRB(
                RelativeSize.width(20, width),
                RelativeSize.height(20, height),
                RelativeSize.width(20, width),
                RelativeSize.height(0, height)),
            child: newLoanStateRef.monitoringConsentError
                ? SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Lottie.asset(
                          "assets/animations/error.json",
                          height: 200,
                          width: 200,
                        ),
                        const SpacerWidget(height: 20),
                        Text(
                          "You did not provide account monitoring consent. Could not validate monitoring consent. Contact Support...",
                          style: TextStyle(
                            fontFamily: fontFamily,
                            fontSize: AppFontSizes.h3,
                            fontWeight: AppFontWeights.bold,
                            letterSpacing: 0.4,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          softWrap: true,
                          textAlign: TextAlign.center,
                        ),
                        const SpacerWidget(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                HapticFeedback.mediumImpact();
                                context.go(InvoiceLoanIndexRouter.dashboard);
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
                                    "Restart Journey",
                                    style: TextStyle(
                                      fontFamily: fontFamily,
                                      fontSize: AppFontSizes.h3,
                                      fontWeight: AppFontWeights.medium,
                                      letterSpacing: 0.4,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                : newLoanStateRef.validatingMonitoringConsentSuccess
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const SpacerWidget(height: 150),
                            Lottie.asset(
                                "assets/animations/loading_spinner.json",
                                height: 220,
                                width: 220),
                            const SpacerWidget(height: 35),
                            Text(
                              "Verifying Monitoring Consent Success...",
                              style: TextStyle(
                                fontFamily: fontFamily,
                                fontSize: AppFontSizes.h2,
                                fontWeight: AppFontWeights.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              "Please do not click back or close the app",
                              style: TextStyle(
                                fontFamily: fontFamily,
                                fontSize: AppFontSizes.b1,
                                fontWeight: AppFontWeights.medium,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () async {
                                  HapticFeedback.mediumImpact();
                                  ref.read(routerProvider).pop();
                                },
                                child: Icon(
                                  Icons.arrow_back_outlined,
                                  size: 25,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.65),
                                ),
                              ),
                              Expanded(
                                child: Container(),
                              ),
                              GestureDetector(
                                onTap: () {
                                 HapticFeedback.mediumImpact();
                                 ref.read(routerProvider).push(InvoiceLoanSupportRouter.raise_new_ticket);
                                },
                                child: Container(
                                  height: 25,
                                  width: 65,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.75),
                                      width: 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Help?",
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b1,
                                        fontWeight: AppFontWeights.extraBold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SpacerWidget(
                            height: 35,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 40,
                                  child: getLenderDetailsAssetURL(
                                      selectedOffer.bankName,
                                      selectedOffer.bankLogoURL),
                                ),
                                const SpacerWidget(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                          const SpacerWidget(
                            height: 10,
                          ),
                          Text(
                            "Monitoring Consent",
                            style: TextStyle(
                                fontFamily: fontFamily,
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: AppFontSizes.h1,
                                fontWeight: AppFontWeights.bold,
                                letterSpacing: 0.4),
                            softWrap: true,
                          ),
                          const SpacerWidget(
                            height: 15,
                          ),
                          Expanded(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Stack(
                                children: [
                                  _loadingAAURL
                                      ? const LinearProgressIndicator()
                                      : Container(),
                                  InAppWebView(
                                    key: _montoringConsentAAWebviewScreen,
                                    gestureRecognizers: const <Factory<
                                        VerticalDragGestureRecognizer>>{},
                                    initialSettings: InAppWebViewSettings(
                                      javaScriptEnabled: true,
                                      verticalScrollBarEnabled: true,
                                      disableHorizontalScroll: true,
                                      disableVerticalScroll: false,
                                    ),
                                    onLoadStop: (controller, url) {
                                      setState(() {
                                        _loadingAAURL = false;
                                        _currentUrl = url.toString();
                                      });
                                    },
                                    initialUrlRequest:
                                        URLRequest(url: WebUri(_currentUrl)),
                                    onLoadStart: (controller, url) async {
                                      setState(() {
                                        _loadingAAURL = true;
                                        _currentUrl = url.toString();
                                      });
                                    },
                                    onWebViewCreated: (controller) async {
                                      webViewController = controller;
                                    },
                                    shouldOverrideUrlLoading:
                                        (controller, navigationAction) async {
                                      var uri = navigationAction.request.url;
                                      if (uri != null &&
                                          uri.toString().contains(
                                              'https://ondc.invoicepe.in/aa-redirect')) {
                                        String? ecres =
                                            uri.queryParameters['ecres'];
                                        String? resdate =
                                            uri.queryParameters['resdate'];
                                        _checkMonitoringConsentSuccess(
                                            ecres, resdate);
                                      }
                                      return NavigationActionPolicy.ALLOW;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
          ),
        ),
      ),
    );
  }
}
