import 'dart:async';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/global_state/theme/theme_state.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/support_router.dart';
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
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

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

  InAppWebViewController? _webViewController;

  Future<void> _checkAadharKYCSuccess() async {
    if (ref.read(invoiceNewLoanRequestProvider).aadharKYCFailure) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Error!',
          message: "Aadhar KYC Unsuccessful. Refetch the KYC URL",
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
        .checkAadharKycSuccess(_cancelToken);

    if (!mounted) return;

    if (!response.success) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Error!',
          message: "Aadhar KYC Unsuccessful. Contact Support",
          contentType: ContentType.failure,
        ),
        duration: const Duration(seconds: 15),
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

  void _fetchKYCURL() async {
    if (ref.read(invoiceNewLoanRequestProvider).fetchingAadharKYCURl) return;

    ref
        .read(invoiceNewLoanRequestProvider.notifier)
        .setFetchingAadharKYCUrl(true);

    var response = await ref
        .read(invoiceNewLoanRequestProvider.notifier)
        .fetchAadharKycUrl(_cancelToken);

    ref
        .read(invoiceNewLoanRequestProvider.notifier)
        .setFetchingAadharKYCUrl(false);

    if (!mounted) return;

    if (!response.success) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Error!',
          message: "Unable to fetch Aadhar KYC URL. Contact Support.",
          contentType: ContentType.failure,
        ),
        duration: const Duration(seconds: 15),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    } else {
      _webViewController?.loadUrl(
          urlRequest: URLRequest(url: WebUri(response.data['url'])));
    }
  }

  Future<void> _refetchKYCURL() async {
    if (!ref.read(invoiceNewLoanRequestProvider).aadharKYCFailure) {
      return;
    }

    ref
        .read(invoiceNewLoanRequestProvider.notifier)
        .setFetchingAadharKYCUrl(true);

    var response = await ref
        .read(invoiceNewLoanRequestProvider.notifier)
        .refetchAadharKycUrl(_cancelToken);

    ref
        .read(invoiceNewLoanRequestProvider.notifier)
        .setFetchingAadharKYCUrl(false);

    if (!mounted) return;

    if (!response.success) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Error!',
          message: "Unable to refetch Aadhar KYC URL. Contact Support.",
          contentType: ContentType.failure,
        ),
        duration: const Duration(seconds: 15),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
      return;
    } else {
      _webViewController?.loadUrl(
          urlRequest: URLRequest(url: WebUri(response.data)));
      return;
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _fetchKYCURL();
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
            padding: EdgeInsets.fromLTRB(
                RelativeSize.width(20, width),
                RelativeSize.height(20, height),
                RelativeSize.width(20, width),
                RelativeSize.height(50, height)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () async {
                        HapticFeedback.mediumImpact();
                        await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.surface,
                                  title: Text(
                                    'Confirm',
                                    style: TextStyle(
                                      fontFamily: fontFamily,
                                      fontSize: AppFontSizes.h1,
                                      fontWeight: AppFontWeights.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                  ),
                                  content: Text(
                                    'Have you completed the KYC successfully?',
                                    style: TextStyle(
                                      fontFamily: fontFamily,
                                      fontSize: AppFontSizes.h3,
                                      fontWeight: AppFontWeights.medium,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        ref.read(routerProvider).pop();
                                      },
                                      child: Text('Go Back',
                                          style: TextStyle(
                                            fontFamily: fontFamily,
                                            fontSize: AppFontSizes.h1,
                                            fontWeight: AppFontWeights.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          )),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      },
                                      child: Text('No',
                                          style: TextStyle(
                                            fontFamily: fontFamily,
                                            fontSize: AppFontSizes.h1,
                                            fontWeight: AppFontWeights.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          )),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                        _checkAadharKYCSuccess();
                                      },
                                      child: Text('Yes',
                                          style: TextStyle(
                                            fontFamily: fontFamily,
                                            fontSize: AppFontSizes.h1,
                                            fontWeight: AppFontWeights.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          )),
                                    ),
                                  ]);
                            });
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
                        ref
                            .read(routerProvider)
                            .push(InvoiceLoanSupportRouter.raise_new_ticket);
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
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SpacerWidget(height: 22),
                Text(
                  "Aadhaar KYC",
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
                    child: ref
                            .watch(invoiceNewLoanRequestProvider)
                            .aadharKYCFailure
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const SpacerWidget(height: 20),
                              Lottie.asset("assets/animations/error.json",
                                  height: 200, width: 200),
                              const SpacerWidget(height: 35),
                              Text(
                                "Your Aadhar KYC Failed!",
                                style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: AppFontSizes.h2,
                                  fontWeight: AppFontWeights.bold,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
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
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(10),
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
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(10),
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
                        : newLoanStateRef.verifyingAadharKYC
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  const SpacerWidget(height: 50),
                                  Lottie.asset(
                                      "assets/animations/loading_spinner.json",
                                      height: 250,
                                      width: 250),
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
                                  newLoanStateRef.fetchingAadharKYCURl
                                      ? const LinearProgressIndicator()
                                      : Container(),
                                  InAppWebView(
                                    key: _aadharWebviewKey,
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
