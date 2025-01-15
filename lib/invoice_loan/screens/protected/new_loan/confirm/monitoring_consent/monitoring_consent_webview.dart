import 'dart:async';

import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/global_state/theme/theme_state.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/loan_request_router.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/components/top_nav.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/loan_events/loan_events.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/server_sent_events/sse.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/loan_request.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/state/error_codes.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/state/loan_request_state.dart';
import 'package:blocsol_loan_application/invoice_loan/state/user/profile/profile_details.dart';
import 'package:blocsol_loan_application/utils/lender_utils.dart';
import 'package:blocsol_loan_application/utils/logger.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:blocsol_loan_application/utils/ui/webview_top_bar.dart';
import 'package:blocsol_loan_application/utils/ui/window_popup.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lottie/lottie.dart';
// import 'package:swipe_refresh/swipe_refresh.dart';

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
  final GlobalKey _webviewKey = GlobalKey();
  // final _controller = StreamController<SwipeRefreshState>.broadcast();

  // Stream<SwipeRefreshState> get _stream => _controller.stream;
  InAppWebViewController? _webViewController;
  bool _loading = true;

  Future<void> _checkMonitoringConsentSuccess(
      String? ecres, String? resdate) async {
    if (ref
        .read(invoiceNewLoanRequestProvider)
        .validatingMonitoringConsentSuccess) {
      return;
    }

    if (ecres == null || resdate == null) {
      ref.read(routerProvider).push(
          InvoiceNewLoanRequestRouter.loan_service_error,
          extra: InvoiceLoanServiceErrorCodes
              .monitoring_consent_verification_failed);
      return;
    }

    var checkSuccessResponse = await ref
        .read(invoiceNewLoanRequestProvider.notifier)
        .checkLoanMonitoringConsentSuccess(_cancelToken, ecres, resdate);

    if (!mounted || !context.mounted) return;

    logFirebaseEvent("invoice_loan_application_process", {
      "step": "checking_loan_monitoring_consent_success",
      "gst": ref.read(invoiceLoanUserProfileDetailsProvider).gstNumber,
      "success": checkSuccessResponse.success,
      "message": checkSuccessResponse.message,
      "data": checkSuccessResponse.data ?? {},
    });

    if (!checkSuccessResponse.success) {
      ref.read(routerProvider).push(
          InvoiceNewLoanRequestRouter.loan_service_error,
          extra: InvoiceLoanServiceErrorCodes
              .monitoring_consent_verification_failed);
      return;
    } else {
      ref.read(invoiceNewLoanRequestProvider.notifier).updateState(LoanRequestProgress.loanStepsCompleted);
      ref
          .read(routerProvider)
          .pushReplacement(InvoiceNewLoanRequestRouter.dashboard);
    }
  }

  // Future<void> _refresh() async {
  //   setState(() {
  //     _loading = true;
  //   });

  //   _webViewController?.loadUrl(
  //       urlRequest: URLRequest(url: WebUri(widget.url)));

  //   setState(() {
  //     _loading = false;
  //   });
  //   _controller.sink.add(SwipeRefreshState.hidden);
  // }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _webViewController?.loadUrl(
        urlRequest: URLRequest(
          url: WebUri(widget.url),
        ),
      );
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
            padding: EdgeInsets.only(
              top: RelativeSize.height(30, height),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: RelativeSize.width(20, width)),
                  child: InvoiceNewLoanRequestTopNav(
                    onBackClick: () {
                      ref.read(routerProvider).pop();
                    },
                  ),
                ),
                const SpacerWidget(height: 22),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: RelativeSize.width(20, width)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Provide monitoring consent",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.title,
                          fontWeight: AppFontWeights.extraBold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        softWrap: true,
                      ),
                      const SpacerWidget(
                        height: 10,
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
                    ],
                  ),
                ),
                const SpacerWidget(
                  height: 15,
                ),
                Container(
                  height: 5,
                  width: width,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(248, 248, 248, 1),
                    border: Border.symmetric(
                      horizontal: BorderSide(
                        color: Color.fromRGBO(230, 230, 230, 1),
                        width: 1,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: RelativeSize.height(550, height),
                    width: width,
                    child: ref
                            .read(invoiceNewLoanRequestProvider)
                            .validatingMonitoringConsentSuccess
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const SpacerWidget(height: 50),
                              Lottie.asset(
                                  "assets/animations/loading_spinner.json",
                                  height: 180,
                                  width: 180),
                              const SpacerWidget(height: 35),
                              Text(
                                "Verifying Monitoring Consent Success...",
                                style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: AppFontSizes.h2,
                                  fontWeight: AppFontWeights.bold,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              Text(
                                "Please do not click back or close the app",
                                style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: AppFontSizes.b1,
                                  fontWeight: AppFontWeights.medium,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ],
                          )
                        : Stack(
                            children: [
                              SizedBox(
                                width: width,
                                height: 900,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 50),
                                  child: InAppWebView(
                                    key: _webviewKey,
                                    gestureRecognizers: const <Factory<
                                        VerticalDragGestureRecognizer>>{},
                                    initialSettings: InAppWebViewSettings(
                                      javaScriptEnabled: true,
                                      verticalScrollBarEnabled: true,
                                      disableHorizontalScroll: true,
                                      disableVerticalScroll: false,
                                      javaScriptCanOpenWindowsAutomatically:
                                          true,
                                      supportMultipleWindows: true,
                                    ),
                                    onCreateWindow:
                                        (controller, createWindowAction) async {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return WindowPopup(
                                              createWindowAction:
                                                  createWindowAction);
                                        },
                                      );
                                      return true;
                                    },
                                    initialUrlRequest: URLRequest(
                                      url: WebUri(widget.url),
                                    ),
                                    onLoadStop: (controller, url) {
                                      setState(() {
                                        _loading = false;
                                      });
                                    },
                                    // initialize webview controller
                                    onWebViewCreated: (controller) {
                                      setState(() {
                                        _webViewController = controller;
                                      });
                                    },
                                    shouldOverrideUrlLoading:
                                        (controller, navigationAction) async {
                                      var uri = navigationAction.request.url;

                                      if (uri != null &&
                                          uri.toString().contains(
                                              'https://ondc.invoicepe.in/aa-redirect')) {
                                        // Extract query parameters
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
                                ),
                              ),
                              WebviewTopBar(controller: _webViewController),
                              _loading
                                  ? const LinearProgressIndicator()
                                  : Container(),
                            ],
                          ),
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
