import 'dart:async';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/theme.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/components/alert_dialog.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/components/timer.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/components/top_nav.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/loan_events/loan_events.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/server_sent_events/sse.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/loan_request.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:lottie/lottie.dart';
import 'package:swipe_refresh/swipe_refresh.dart';

class InvoiceNewLoanEntityKyc extends ConsumerStatefulWidget {
  const InvoiceNewLoanEntityKyc({super.key});

  @override
  ConsumerState<InvoiceNewLoanEntityKyc> createState() =>
      _InvoiceNewLoanEntityKycState();
}

class _InvoiceNewLoanEntityKycState
    extends ConsumerState<InvoiceNewLoanEntityKyc> {
  final _cancelToken = CancelToken();
  final GlobalKey _webViewKey = GlobalKey();
  final _controller = StreamController<SwipeRefreshState>.broadcast();

  bool _loading = true;
  Stream<SwipeRefreshState> get _stream => _controller.stream;
  InAppWebViewController? _webViewController;
  // ignore: unused_field
  String _url = '';

  Future<void> _checkEntityKYCSuccess() async {
    if (ref.read(invoiceNewLoanRequestProvider).entityKYCFailure) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Error!',
          message: "Entity KYC Unsuccessful. Refetch the KYC URL",
          contentType: ContentType.failure,
        ),
        duration: const Duration(seconds: 15),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);

      return;
    }

    var response = await ref
        .read(invoiceNewLoanRequestProvider.notifier)
        .checkEntityKycFormSuccess(_cancelToken);

    if (!mounted) return;

    if (!response.success) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Error!',
          message: "Entity KYC Unsuccessful. Contact Support",
          contentType: ContentType.failure,
        ),
        duration: const Duration(seconds: 15),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);

      return;
    }

    return;
  }

  Future<void> _fetchEntityKYCURL() async {
    if (ref.read(invoiceNewLoanRequestProvider).fetchingEntityKYCURl) return;

    var response = await ref
        .read(invoiceNewLoanRequestProvider.notifier)
        .fetchEntityKycForm(_cancelToken);

    if (!mounted || !context.mounted) return;

    setState(() {
      _loading = false;
    });

    if (response.success) {
      _webViewController?.loadUrl(
          urlRequest: URLRequest(url: WebUri(response.data['url'])));

      setState(() {
        _url = response.data['url'];
      });
    } else {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Error!',
          message: "Unable to fetch Entity Kyc KYC URL. Contact Support.",
          contentType: ContentType.failure,
        ),
        duration: const Duration(seconds: 15),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }

  Future<void> _refetchKYCURL() async {
    if (!ref.read(invoiceNewLoanRequestProvider).entityKYCFailure) {
      return;
    }

    setState(() {
      _loading = true;
    });

    var response = await ref
        .read(invoiceNewLoanRequestProvider.notifier)
        .refetchEntityKycForm(_cancelToken);

    if (!mounted || !context.mounted) return;

    setState(() {
      _loading = false;
    });

    if (!response.success) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Error!',
          message: "Unable to refetch Entity KYC URL. Contact Support.",
          contentType: ContentType.failure,
        ),
        duration: const Duration(seconds: 15),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    } else {
      setState(() {
        _url = response.data['url'];
      });
      _webViewController?.loadUrl(
          urlRequest: URLRequest(url: WebUri(response.data['url'])));
    }
  }

  Future<void> _refresh() async {
    _fetchEntityKYCURL();
    _controller.sink.add(SwipeRefreshState.hidden);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _fetchEntityKYCURL();
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
          resizeToAvoidBottomInset: false,
          body: Container(
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
                                text: "Have you completed your Entity KYC?",
                                onConfirm: () async {
                                  await _checkEntityKYCSuccess();
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
                        "Entity KYC",
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
                        "Enter the required details for entity verification",
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
                        height: RelativeSize.height(530, height),
                        width: width,
                        child: ref
                                .watch(invoiceNewLoanRequestProvider)
                                .entityKYCFailure
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  const SpacerWidget(height: 20),
                                  Lottie.asset("assets/animations/error.json",
                                      height: 180, width: 180),
                                  const SpacerWidget(height: 35),
                                  Text(
                                    "Your Entity KYC Failed!",
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
                                      _refetchKYCURL();
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 120,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Try Again?",
                                          style: TextStyle(
                                            fontFamily: fontFamily,
                                            fontSize: AppFontSizes.h3,
                                            fontWeight: AppFontWeights.medium,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SpacerWidget(
                                    height: 30,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      HapticFeedback.mediumImpact();
                                      ref.read(routerProvider).pop();
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 120,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Cancel?",
                                          style: TextStyle(
                                            fontFamily: fontFamily,
                                            fontSize: AppFontSizes.h3,
                                            fontWeight: AppFontWeights.medium,
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
                            : newLoanStateRef.verifyingEntityKYC
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
                                        "Verifying Entity KYC Success...",
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
                                        child: InAppWebView(
                                          key: _webViewKey,
                                          gestureRecognizers: const <Factory<
                                              VerticalDragGestureRecognizer>>{},
                                          initialSettings: InAppWebViewSettings(
                                            javaScriptEnabled: true,
                                            verticalScrollBarEnabled: true,
                                            disableHorizontalScroll: true,
                                            disableVerticalScroll: false,
                                          ),
                                          onWebViewCreated: (controller) async {
                                            _webViewController = controller;
                                          },
                                        ),
                                      ),
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
        ),
      ),
    );
  }
}
