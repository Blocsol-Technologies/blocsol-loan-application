import 'dart:async';

import 'package:blocsol_loan_application/global_state/theme/theme_state.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/components/alert_dialog.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/components/timer.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/components/top_nav.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/loan_events/loan_events.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/server_sent_events/sse.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/loan_request.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/state/loan_request_state.dart';
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

class InvoiceNewLoanAadharKyc extends ConsumerStatefulWidget {
  const InvoiceNewLoanAadharKyc({super.key});

  @override
  ConsumerState<InvoiceNewLoanAadharKyc> createState() =>
      _InvoiceNewLoanAadharKycState();
}

class _InvoiceNewLoanAadharKycState
    extends ConsumerState<InvoiceNewLoanAadharKyc> {
  final _cancelToken = CancelToken();
  final GlobalKey _aadharWebviewKey = GlobalKey();
  final _controller = StreamController<SwipeRefreshState>.broadcast();

  bool _loading = true;
  Stream<SwipeRefreshState> get _stream => _controller.stream;
  InAppWebViewController? _webViewController;
  // ignore: unused_field
  String _aadharKycUrl = "";

  Future<void> _checkAadharKYCSuccess() async {
    if (ref.read(invoiceNewLoanRequestProvider).aadharKYCFailure) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: getSnackbarNotificationWidget(
            message: "Aadhar KYC Unsuccessful. Refetch the KYC URL",
            notifType: SnackbarNotificationType.error),
        duration: const Duration(seconds: 5),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);

      return;
    }

    var response = await ref
        .read(invoiceNewLoanRequestProvider.notifier)
        .checkAadharKycSuccess(_cancelToken);

    if (!mounted) return;

    if (!response.success) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: getSnackbarNotificationWidget(
            message: "Aadhar KYC Unsuccessful. Contact Support",
            notifType: SnackbarNotificationType.error),
        duration: const Duration(seconds: 5),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }

    ref
        .read(invoiceNewLoanRequestProvider.notifier)
        .updateState(LoanRequestProgress.aadharKycCompleted);

    return;
  }

  Future<void> _fetchKYCURL() async {
    if (ref.read(invoiceNewLoanRequestProvider).fetchingAadharKYCURl) return;

    var response = await ref
        .read(invoiceNewLoanRequestProvider.notifier)
        .fetchAadharKycUrl(_cancelToken);

    if (!mounted || !context.mounted) return;

    setState(() {
      _loading = false;
    });

    if (!response.success) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: getSnackbarNotificationWidget(
            message: "Unable to fetch Aadhar KYC URL. Contact Support.",
            notifType: SnackbarNotificationType.error),
        duration: const Duration(seconds: 5),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    } else {
      _webViewController?.loadUrl(
          urlRequest: URLRequest(url: WebUri(response.data['url'])));

      setState(() {
        _aadharKycUrl = response.data['url'];
      });
    }
  }

  Future<void> _refresh() async {
    _fetchKYCURL();

    _controller.sink.add(SwipeRefreshState.hidden);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _fetchKYCURL();
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.close();
    _cancelToken.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final newLoanStateRef = ref.watch(invoiceNewLoanRequestProvider);
    ref.watch(invoiceLoanServerSentEventsProvider);
    ref.watch(invoiceLoanEventsProvider);
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: SingleChildScrollView(
              child: Container(
                height: height,
                width: width,
                padding: EdgeInsets.only(
                  top: RelativeSize.height(30, height),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: RelativeSize.width(20, width)),
                      child: InvoiceNewLoanRequestTopNav(
                        onBackClick: () async {
                          await showDialog(
                              context: context,
                              barrierColor: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.5),
                              builder: (BuildContext context) {
                                return NewLoanAlertDialog(
                                    text: "Have you completed your KYC?",
                                    onConfirm: () async {
                                      await _checkAadharKYCSuccess();
                                    });
                              });
                        },
                      ),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Aadhaar KYC",
                            style: TextStyle(
                                fontFamily: fontFamily,
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: AppFontSizes.heading,
                                fontWeight: AppFontWeights.bold,
                                letterSpacing: 0.4),
                            softWrap: true,
                          ),
                          const SpacerWidget(
                            height: 16,
                          ),
                          Text(
                            "Enter Aadhaar details and request an otp or TOTP for verification",
                            softWrap: true,
                            style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: AppFontSizes.h3,
                              fontWeight: AppFontWeights.normal,
                              color: Theme.of(context).colorScheme.onSurface,
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
                      child: SwipeRefresh.adaptive(
                        shrinkWrap: true,
                        stateStream: _stream,
                        onRefresh: () {
                          _refresh();
                        },
                        children: [
                          SizedBox(
                            height: RelativeSize.height(480, height),
                            width: width,
                            child: newLoanStateRef.verifyingAadharKYC
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      const SpacerWidget(height: 50),
                                      Lottie.asset(
                                          "assets/animations/loading_spinner.json",
                                          height: 180,
                                          width: 180),
                                      const SpacerWidget(height: 35),
                                      Text(
                                        "Verifying KYC Success...",
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
                                        height: 900,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 50),
                                          child: InAppWebView(
                                            key: _aadharWebviewKey,
                                            gestureRecognizers: const <Factory<
                                                VerticalDragGestureRecognizer>>{},
                                            initialSettings:
                                                InAppWebViewSettings(
                                              javaScriptEnabled: true,
                                              verticalScrollBarEnabled: true,
                                              disableHorizontalScroll: true,
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
                                            onWebViewCreated:
                                                (controller) async {
                                              _webViewController = controller;
                                            },
                                          ),
                                        ),
                                      ),
                                      WebviewTopBar(
                                          controller: _webViewController),
                                      _loading
                                          ? const LinearProgressIndicator()
                                          : Container(),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
