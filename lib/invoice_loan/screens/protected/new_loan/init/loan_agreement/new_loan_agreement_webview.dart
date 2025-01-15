import 'dart:async';

import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/global_state/theme/theme_state.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/loan_request_router.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/components/alert_dialog.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/components/timer.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/components/top_nav.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/loan_events/loan_events.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/server_sent_events/sse.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/loan_request.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/state/error_codes.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/snackbar_notifications/util.dart';
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
import 'package:swipe_refresh/swipe_refresh.dart';

class InvoiceNewLoanAgreementWebview extends ConsumerStatefulWidget {
  final String url;
  const InvoiceNewLoanAgreementWebview({super.key, required this.url});

  @override
  ConsumerState<InvoiceNewLoanAgreementWebview> createState() =>
      _InvoiceNewLoanAgreementWebviewState();
}

class _InvoiceNewLoanAgreementWebviewState
    extends ConsumerState<InvoiceNewLoanAgreementWebview> {
  final _cancelToken = CancelToken();
  final GlobalKey _agreementWebviewKey = GlobalKey();
  final _controller = StreamController<SwipeRefreshState>.broadcast();

  Stream<SwipeRefreshState> get _stream => _controller.stream;
  InAppWebViewController? _webViewController;
  String _currentUrl = '';

  Future<void> _checkLoanAgreementSuccess() async {
    if (ref.read(invoiceNewLoanRequestProvider).loanAgreementFailure) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: getSnackbarNotificationWidget(
            message:
                "Loan Aggrement Signature Unsuccessful. Refetch the Agreement URL",
            notifType: SnackbarNotificationType.error),
        duration: const Duration(seconds: 5),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);

      return;
    }

    var loanAgreementSuccessResponse = await ref
        .read(invoiceNewLoanRequestProvider.notifier)
        .checkLoanAgreementSuccess(_cancelToken);

    if (!mounted || !context.mounted) return;

    if (!loanAgreementSuccessResponse.success) {
      ref.read(routerProvider).push(
          InvoiceNewLoanRequestRouter.loan_service_error,
          extra: InvoiceLoanServiceErrorCodes.loan_agreement_failed);
      return;
    }
  }

  Future<void> _refresh() async {
    _webViewController?.loadUrl(
        urlRequest: URLRequest(url: WebUri(_currentUrl)));

    _controller.sink.add(SwipeRefreshState.hidden);
  }

  @override
  initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      setState(() {
        _currentUrl = widget.url;
        _webViewController?.loadUrl(
            urlRequest: URLRequest(url: WebUri(widget.url)));
      });
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
    var newLoanStateRef = ref.watch(invoiceNewLoanRequestProvider);
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
            padding: EdgeInsets.only(
              top: RelativeSize.height(30, height),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: RelativeSize.width(20, width)),
                    child: InvoiceNewLoanRequestTopNav(onBackClick: () async {
                      await showDialog(
                          context: context,
                          barrierColor: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.5),
                          builder: (BuildContext context) {
                            return NewLoanAlertDialog(
                                text: "Have you signed the loan agreement?",
                                onConfirm: () async {
                                  await _checkLoanAgreementSuccess();
                                });
                          });
                    }),
                  ),
                  const SpacerWidget(height: 12),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: RelativeSize.width(20, width)),
                    child: const InvoiceNewLoanRequestCountdownTimer(),
                  ),
                  const SpacerWidget(height: 12),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: RelativeSize.width(20, width)),
                    child: Text(
                      "Loan Agreement",
                      style: TextStyle(
                          fontFamily: fontFamily,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: AppFontSizes.h1,
                          fontWeight: AppFontWeights.bold,
                          letterSpacing: 0.4),
                      softWrap: true,
                    ),
                  ),
                  const SpacerWidget(
                    height: 20,
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
                      width: width,
                      child: SwipeRefresh.adaptive(
                        shrinkWrap: true,
                        stateStream: _stream,
                        onRefresh: () {
                          _refresh();
                        },
                        children: [
                          newLoanStateRef.verifyingLoanAgreementSuccess
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
                                      "Verifying Agreement Success...",
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.h2,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                    Text(
                                      "Please do not click back or close the app",
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b1,
                                        fontWeight: AppFontWeights.medium,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                  ],
                                )
                              : Stack(
                                  children: [
                                    SizedBox(
                                      width: width,
                                      height: 1000,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 50),
                                        child: InAppWebView(
                                          key: _agreementWebviewKey,
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
                                          onCreateWindow: (controller,
                                              createWindowAction) async {
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
                                              url: WebUri(_currentUrl)),
                                          onWebViewCreated: (controller) async {
                                            _webViewController = controller;
                                            _webViewController?.loadUrl(
                                                urlRequest: URLRequest(
                                                    url: WebUri(widget.url)));
                                          },
                                        ),
                                      ),
                                    ),
                                    WebviewTopBar(
                                        controller: _webViewController),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
