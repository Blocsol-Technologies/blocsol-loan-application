import 'dart:async';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/loan_request_router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/theme.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/components/top_nav.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/loan_events/loan_events.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/server_sent_events/sse.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/loan_request.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/state/loan_request_state.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:lottie/lottie.dart';
import 'package:swipe_refresh/swipe_refresh.dart';

class AccountAggregatorWebview extends ConsumerStatefulWidget {
  final String url;
  const AccountAggregatorWebview({super.key, required this.url});

  @override
  ConsumerState<AccountAggregatorWebview> createState() =>
      _NewLoanAccountAggregatorWebviewScreenState();
}

class _NewLoanAccountAggregatorWebviewScreenState
    extends ConsumerState<AccountAggregatorWebview> {
  final _cancelToken = CancelToken();
  final GlobalKey webViewKey = GlobalKey();
  final _controller = StreamController<SwipeRefreshState>.broadcast();

  // Stream<SwipeRefreshState> get _stream => _controller.stream;
  InAppWebViewController? _webViewController;
  bool _loading = true;
  bool _checkingConsentSuccess = false;
  bool _checkConsentError = false;

  void _checkConsentSuccess(String? ecres, String? resdate) async {
    if (_checkingConsentSuccess) return;

    setState(() {
      _checkingConsentSuccess = true;
      _checkConsentError = false;
    });

    if (ecres == null || resdate == null) {
      if (mounted) {
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'On Snap!',
            message: "Unable to confirm consent creation.",
            contentType: ContentType.failure,
          ),
          duration: const Duration(seconds: 10),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);

        setState(() {
          _checkingConsentSuccess = false;
          _checkConsentError = true;
        });

        return;
      }
    }

    var checkConsentResponse = await ref
        .read(invoiceNewLoanRequestProvider.notifier)
        .checkConsentSuccess(ecres!, resdate!, _cancelToken);

    if (!checkConsentResponse.success) {
      if (mounted) {
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'On Snap!',
            message: "Unable to confirm consent creation.",
            contentType: ContentType.failure,
          ),
          duration: const Duration(seconds: 20),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);

        setState(() {
          _checkingConsentSuccess = false;
          _checkConsentError = true;
        });

        return;
      }
    }

    ref
        .read(invoiceNewLoanRequestProvider.notifier)
        .updateState(LoanRequestProgress.customerDetailsProvided);

    if (!mounted) return;

    setState(() {
      _checkingConsentSuccess = true;
    });

    ref.read(routerProvider).pushReplacement(
          InvoiceNewLoanRequestRouter.loan_offer_select,
        );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _webViewController?.loadUrl(
        urlRequest: URLRequest(
          url: WebUri(widget.url),
        ),
      );

      setState(() {
        _loading = false;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    ref.watch(invoiceLoanServerSentEventsProvider);
    ref.watch(invoiceLoanEventsProvider);

    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          resizeToAvoidBottomInset: false,
          body: Container(
            height: height,
            width: width,
            padding: EdgeInsets.only(top: RelativeSize.height(30, height)),
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
                        "Provide consent",
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
                      Text(
                        "You might be asked to create an account if it doesnt exist!",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.h3,
                          fontWeight: AppFontWeights.normal,
                          color: const Color.fromRGBO(78, 78, 78, 1),
                          letterSpacing: 0.14,
                        ),
                        softWrap: true,
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
                    child: _checkConsentError
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const SpacerWidget(height: 50),
                              Lottie.asset("assets/animations/error.json",
                                  height: 200, width: 200),
                              const SpacerWidget(height: 20),
                              SizedBox(
                                width: 250,
                                child: Text(
                                  "You did not provide AA consent for the lenders. You need to restart the loan process",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: fontFamily,
                                    fontSize: AppFontSizes.h3,
                                    fontWeight: AppFontWeights.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface,
                                  ),
                                  softWrap: true,
                                ),
                              ),
                              const SpacerWidget(
                                height: 50,
                              ),
                              GestureDetector(
                                onTap: () {
                                  ref
                                      .read(invoiceNewLoanRequestProvider
                                          .notifier)
                                      .reset();
                                  context.go(InvoiceNewLoanRequestRouter
                                      .dashboard);
                                },
                                child: Container(
                                  height: 40,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Restart",
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.h2,
                                        fontWeight: AppFontWeights.medium,
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
                        : _checkingConsentSuccess
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
                                    "Verifying Consent Success...",
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
                                      key: webViewKey,
                                      gestureRecognizers: const <Factory<
                                          VerticalDragGestureRecognizer>>{},
                                      initialSettings: InAppWebViewSettings(
                                        javaScriptEnabled: true,
                                        verticalScrollBarEnabled: true,
                                        disableHorizontalScroll: true,
                                        disableVerticalScroll: false,
                                      ),
                                      initialUrlRequest: URLRequest(
                                        url: WebUri(widget.url),
                                      ),
                                      shouldOverrideUrlLoading: (controller,
                                          navigationAction) async {
                                        var uri =
                                            navigationAction.request.url;
                  
                                        if (uri != null &&
                                            uri.toString().contains(
                                                'https://ondc.invoicepe.in/aa-redirect')) {
                                          // Extract query parameters
                                          String? ecres =
                                              uri.queryParameters['ecres'];
                                          String? resdate = uri
                                              .queryParameters['resdate'];
                  
                                          _checkConsentSuccess(
                                              ecres, resdate);
                                        }
                                        return NavigationActionPolicy.ALLOW;
                                      },
                                    ),
                                  ),
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
