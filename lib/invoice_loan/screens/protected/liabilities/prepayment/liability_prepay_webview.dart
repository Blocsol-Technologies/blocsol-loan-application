import 'dart:async';

import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/liabilities_router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/theme.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/loan_events/loan_events.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/server_sent_events/sse.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/liability/all/all_liabilities.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/liability/single/liability.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/webview_top_bar.dart';
import 'package:blocsol_loan_application/utils/ui/snackbar_notifications/util.dart';
import 'package:blocsol_loan_application/utils/ui/window_popup.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class InvoiceLoanLiabilityPrepaymentWebview extends ConsumerStatefulWidget {
  final String url;
  const InvoiceLoanLiabilityPrepaymentWebview({super.key, required this.url});

  @override
  ConsumerState<InvoiceLoanLiabilityPrepaymentWebview> createState() =>
      _InvoiceLoanLiabilityPrepaymentWebviewState();
}

class _InvoiceLoanLiabilityPrepaymentWebviewState
    extends ConsumerState<InvoiceLoanLiabilityPrepaymentWebview> {
  final GlobalKey _prepaymentWebviewKey = GlobalKey();
  final _cancelToken = CancelToken();
  final _interval = 15;

  bool _fetchingURL = false;
  InAppWebViewController? _webViewController;
  String _currentURL = "";
  Timer? _timer;

  Future<void> _checkPrepaymentSuccess() async {
    if (ref.read(invoiceLoanLiabilityProvider).prepaymentFailed ||
        ref.read(invoiceLoanLiabilityProvider).verifyingPrepaymentSuccess) {
      return;
    }

    var response = await ref
        .read(invoiceLoanLiabilityProvider.notifier)
        .checkPrepaymentSuccess(_cancelToken);

    if (!mounted || !context.mounted) return;

    if (!response.success) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: getSnackbarNotificationWidget(
            message: "Prepayment Unsuccessful. Contact Support",
            notifType: SnackbarNotificationType.error),
        duration: const Duration(seconds: 5),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
      return;
    }

    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: getSnackbarNotificationWidget(
          message: "Prepayment Successful",
          notifType: SnackbarNotificationType.success),
      duration: const Duration(seconds: 5),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);

    await ref
        .read(invoiceLoanLiabilityProvider.notifier)
        .fetchSingleLiabilityDetails(_cancelToken);

    if (!mounted || !context.mounted) return;

    ref.read(routerProvider).pushReplacement(
        InvoiceLoanLiabilitiesRouter.payment_success_overview,
        extra: PaymentSuccess(success: true, message: "Payment Successful"));

    return;
  }

  Future<void> _checkPrepaymentSuccessBackground() async {
    if (ref.read(invoiceLoanLiabilityProvider).prepaymentFailed ||
        ref.read(invoiceLoanLiabilityProvider).verifyingPrepaymentSuccess) {
      _timer?.cancel();
      return;
    }

    var response = await ref
        .read(invoiceLoanLiabilityProvider.notifier)
        .checkPrepaymentSuccess(_cancelToken);

    if (!mounted || !context.mounted) return;

    if (!response.success) {
      if (response.data == "suspend") {
        _timer?.cancel();
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: getSnackbarNotificationWidget(
              message: "Payment Unsuccessful. ${response.message}",
              notifType: SnackbarNotificationType.error),
          duration: const Duration(seconds: 5),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
        return;
      }

      if (response.data == "error") {
        _timer?.cancel();

        ref.read(routerProvider).pushReplacement(
            InvoiceLoanLiabilitiesRouter.payment_success_overview,
            extra: PaymentSuccess(success: false, message: response.message));

        return;
      }

      return;
    }

    _timer?.cancel();

    await ref
        .read(invoiceLoanLiabilityProvider.notifier)
        .fetchSingleLiabilityDetails(_cancelToken);

    if (!mounted || !context.mounted) return;

    ref.read(routerProvider).pushReplacement(
        InvoiceLoanLiabilitiesRouter.payment_success_overview,
        extra: PaymentSuccess(success: true, message: "Payment Successful"));

    return;
  }

  void startPollingForPaymentSuccess() {
    _timer = Timer.periodic(Duration(seconds: _interval), (timer) async {
      await _checkPrepaymentSuccessBackground();
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _webViewController?.loadUrl(
          urlRequest: URLRequest(url: WebUri(widget.url)));

      Future.delayed(const Duration(seconds: 10), () {
        startPollingForPaymentSuccess();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cancelToken.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    ref.watch(invoiceLoanLiabilitiesProvider);
    ref.watch(invoiceLoanLiabilityProvider);
    ref.watch(invoiceLoanEventsProvider);
    ref.watch(invoiceLoanServerSentEventsProvider);

    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SizedBox(
            height: height,
            width: width,
            child: Stack(
              children: [
                Container(
                  width: width,
                  height: RelativeSize.height(235, height),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.only(top: RelativeSize.height(30, height)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: RelativeSize.width(30, width)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () async {
                                HapticFeedback.mediumImpact();
                                await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          title: Text(
                                            'Confirm',
                                            style: TextStyle(
                                              fontFamily: fontFamily,
                                              fontSize: AppFontSizes.h2,
                                              fontWeight: AppFontWeights.bold,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                            ),
                                          ),
                                          content: Text(
                                            'Have you completed the Loan Prepayment successfully?',
                                            style: TextStyle(
                                              fontFamily: fontFamily,
                                              fontSize: AppFontSizes.b1,
                                              fontWeight: AppFontWeights.medium,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                            ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                HapticFeedback.mediumImpact();
                                                ref
                                                    .read(routerProvider)
                                                    .pushReplacement(
                                                        InvoiceLoanLiabilitiesRouter
                                                            .singleLiabilityDetails);
                                              },
                                              child: Text('Go Back',
                                                  style: TextStyle(
                                                    fontFamily: fontFamily,
                                                    fontSize: AppFontSizes.h3,
                                                    fontWeight:
                                                        AppFontWeights.bold,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onPrimary,
                                                  )),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                HapticFeedback.mediumImpact();
                                                Navigator.of(context).pop(true);
                                              },
                                              child: Text('No',
                                                  style: TextStyle(
                                                    fontFamily: fontFamily,
                                                    fontSize: AppFontSizes.h3,
                                                    fontWeight:
                                                        AppFontWeights.bold,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onPrimary,
                                                  )),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                HapticFeedback.mediumImpact();
                                                Navigator.of(context).pop(true);
                                                _checkPrepaymentSuccess();
                                              },
                                              child: Text('Yes',
                                                  style: TextStyle(
                                                    fontFamily: fontFamily,
                                                    fontSize: AppFontSizes.h3,
                                                    fontWeight:
                                                        AppFontWeights.bold,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onPrimary,
                                                  )),
                                            ),
                                          ]);
                                    });
                              },
                              child: Icon(
                                Icons.arrow_back_ios,
                                size: 20,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SpacerWidget(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: RelativeSize.width(50, width)),
                        child: SizedBox(
                          width: width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Loan Prepayment",
                                style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: AppFontSizes.h1,
                                  fontWeight: AppFontWeights.medium,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                                textAlign: TextAlign.center,
                                softWrap: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SpacerWidget(
                        height: 30,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: RelativeSize.width(15, width)),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: ref
                                    .watch(invoiceLoanLiabilityProvider)
                                    .prepaymentFailed
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      const SpacerWidget(height: 50),
                                      Lottie.asset(
                                          "assets/animations/error.json",
                                          height: 300,
                                          width: 300),
                                      const SpacerWidget(height: 35),
                                      Text(
                                        "Your Loan Prepayment Failed!",
                                        style: TextStyle(
                                          fontFamily: fontFamily,
                                          fontSize: AppFontSizes.h2,
                                          fontWeight: AppFontWeights.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                      ),
                                      const SpacerWidget(
                                        height: 30,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          HapticFeedback.mediumImpact();
                                          ref
                                              .read(routerProvider)
                                              .pushReplacement(
                                                  InvoiceLoanLiabilitiesRouter
                                                      .singleLiabilityDetails);
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 120,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Go Back?",
                                              style: TextStyle(
                                                fontFamily: fontFamily,
                                                fontSize: AppFontSizes.h2,
                                                fontWeight:
                                                    AppFontWeights.medium,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : ref
                                        .read(invoiceLoanLiabilityProvider)
                                        .verifyingPrepaymentSuccess
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          const SpacerWidget(height: 50),
                                          Lottie.asset(
                                              "assets/animations/loading_spinner.json",
                                              height: 250,
                                              width: 250),
                                          const SpacerWidget(height: 35),
                                          Text(
                                            "Verifying Prepayment Success...",
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
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 50),
                                              child: InAppWebView(
                                                key: _prepaymentWebviewKey,
                                                gestureRecognizers: const <Factory<
                                                    VerticalDragGestureRecognizer>>{},
                                                initialSettings:
                                                    InAppWebViewSettings(
                                                  javaScriptEnabled: true,
                                                  verticalScrollBarEnabled:
                                                      true,
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
                                                initialUrlRequest: URLRequest(
                                                    url: WebUri(_currentURL)),
                                                onLoadStop: (controller, url) {
                                                  setState(() {
                                                    _fetchingURL = false;
                                                  });
                                                },
                                                onWebViewCreated:
                                                    (controller) async {
                                                  _webViewController =
                                                      controller;
                                                  setState(() {
                                                    _currentURL = widget.url;
                                                    _fetchingURL = false;
                                                  });
                                                  _webViewController!.loadUrl(
                                                      urlRequest: URLRequest(
                                                          url: WebUri(
                                                              _currentURL)));
                                                },
                                              ),
                                            ),
                                          ),
                                          WebviewTopBar(
                                              controller: _webViewController),
                                          _fetchingURL
                                              ? const LinearProgressIndicator()
                                              : Container(),
                                        ],
                                      ),
                          ),
                        ),
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
