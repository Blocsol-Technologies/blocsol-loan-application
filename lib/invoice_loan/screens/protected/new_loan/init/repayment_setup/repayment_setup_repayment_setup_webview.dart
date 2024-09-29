import 'dart:async';

import 'package:blocsol_loan_application/invoice_loan/constants/theme.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/loan_request.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
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

class InvoiceNewLoanRepaymentSetupWebview extends ConsumerStatefulWidget {
  final String url;
  const InvoiceNewLoanRepaymentSetupWebview({super.key, required this.url});

  @override
  ConsumerState<InvoiceNewLoanRepaymentSetupWebview> createState() =>
      _InvoiceNewLoanRepaymentSetupWebviewState();
}

class _InvoiceNewLoanRepaymentSetupWebviewState
    extends ConsumerState<InvoiceNewLoanRepaymentSetupWebview> {
  final _cancelToken = CancelToken();
  final GlobalKey _repaymentURLWebviewKey = GlobalKey();
  final _controller = StreamController<SwipeRefreshState>.broadcast();

  Stream<SwipeRefreshState> get _stream => _controller.stream;

  InAppWebViewController? _webViewController;
  bool _loadingRepaymentURL = false;

  Future<void> _refresh() async {
    setState(() {
      _loadingRepaymentURL = true;
    });

    _webViewController?.loadUrl(
        urlRequest: URLRequest(url: WebUri(widget.url)));

    setState(() {
      _loadingRepaymentURL = false;
    });

    _controller.sink.add(SwipeRefreshState.hidden);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _webViewController?.loadUrl(
          urlRequest: URLRequest(url: WebUri(widget.url)));
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
    ref.watch(invoiceNewLoanRequestProvider);
    return SizedBox(
      width: width,
      child: SwipeRefresh.adaptive(
        shrinkWrap: true,
        stateStream: _stream,
        onRefresh: () {
          _refresh();
        },
        children: [
          ref.read(invoiceNewLoanRequestProvider).checkingRepaymentSetupSuccess
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SpacerWidget(height: 50),
                    Lottie.asset("assets/animations/loading_spinner.json",
                        height: 180, width: 180),
                    const SpacerWidget(height: 35),
                    Text(
                      "Verifying Repayment Success...",
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
                )
              : Stack(
                  children: [
                    SizedBox(
                      width: width,
                      height: 900,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: InAppWebView(
                          key: _repaymentURLWebviewKey,
                          gestureRecognizers: const <Factory<
                              VerticalDragGestureRecognizer>>{},
                          initialSettings: InAppWebViewSettings(
                            javaScriptEnabled: true,
                            verticalScrollBarEnabled: true,
                            disableHorizontalScroll: true,
                            disableVerticalScroll: false,
                            javaScriptCanOpenWindowsAutomatically: true,
                            supportMultipleWindows: true,
                          ),
                          onCreateWindow:
                              (controller, createWindowAction) async {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return WindowPopup(
                                    createWindowAction: createWindowAction);
                              },
                            );
                            return true;
                          },
                          onLoadStop: (controller, url) {
                            setState(() {
                              _loadingRepaymentURL = false;
                            });
                          },
                          initialUrlRequest:
                              URLRequest(url: WebUri(widget.url)),
                          onWebViewCreated: (controller) async {
                            _webViewController = controller;
                            controller.loadUrl(
                                urlRequest:
                                    URLRequest(url: WebUri(widget.url)));
                          },
                          onLoadStart: (controller, url) async {
                            setState(() {
                              _loadingRepaymentURL = true;
                            });
                          },
                        ),
                      ),
                    ),
                    WebviewTopBar(controller: _webViewController),
                    _loadingRepaymentURL
                        ? const LinearProgressIndicator()
                        : Container(),
                  ],
                ),
        ],
      ),
    );
  }
}
