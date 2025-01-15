import 'dart:async';

import 'package:blocsol_loan_application/invoice_loan/constants/theme.dart';
import 'package:blocsol_loan_application/personal_loan/constants/routes/loan_request_router.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/new_loan/components/alert_dialog.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/new_loan/components/top_nav.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/events/loan_events/loan_events.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/events/server_sent_events/sse.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/new_loan/new_loan.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/new_loan/state/new_loan_state.dart';
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
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class PCNewLoanAgreementWebview extends ConsumerStatefulWidget {
  final String url;
  const PCNewLoanAgreementWebview({super.key, required this.url});

  @override
  ConsumerState<PCNewLoanAgreementWebview> createState() =>
      _PCNewLoanAgreementWebviewState();
}

class _PCNewLoanAgreementWebviewState
    extends ConsumerState<PCNewLoanAgreementWebview> {
  bool _loadingAgreementURL = false;
  final _cancelToken = CancelToken();
  final GlobalKey _loanAgreementWebviewKey = GlobalKey();

  InAppWebViewController? _webViewController;

  String _currentUrl = "";

  bool _verifyingLoanAgreementSuccess = false;

  Future<void> _checkLoanAgreementSuccess() async {
    if (_verifyingLoanAgreementSuccess) {
      return;
    }

    setState(() {
      _verifyingLoanAgreementSuccess = true;
    });

    var checkForm07SubmissionSuccessResponse = await ref
        .read(personalNewLoanRequestProvider.notifier)
        .checkLoanAgreementSuccess(_cancelToken);

    if (!mounted || !context.mounted) return;

    setState(() {
      _verifyingLoanAgreementSuccess = true;
    });

    if (!checkForm07SubmissionSuccessResponse.success) {
      if (mounted) {
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: getSnackbarNotificationWidget(
              message: "Loan repayment setup unsuccessful.",
              notifType: SnackbarNotificationType.error),
          duration: const Duration(seconds: 15),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);

        return;
      }
    }

    ref
        .read(personalNewLoanRequestProvider.notifier)
        .updateState(PersonalLoanRequestProgress.loanAgreement);

    if (mounted) {
      context.go(PersonalNewLoanRequestRouter.new_loan_process);
    }
  }

  Future<void> _refetchLoanAgreement() async {
    if (!ref.read(personalNewLoanRequestProvider).loanAgreementFailure) {
      return;
    }

    ref
        .read(personalNewLoanRequestProvider.notifier)
        .updateLoanAgreementFailure(false);

    var response = await ref
        .read(personalNewLoanRequestProvider.notifier)
        .refetchLoanAgreementURL(_cancelToken);

    if (!mounted || !context.mounted) return;

    if (!response.success) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: getSnackbarNotificationWidget(
            message: "Unable to refetch loan agreement Url",
            notifType: SnackbarNotificationType.error),
        duration: const Duration(seconds: 15),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);

      return;
    } else {
      setState(() {
        _currentUrl = response.data['url'];
      });
      _webViewController?.loadUrl(
          urlRequest: URLRequest(url: WebUri(response.data['url'])));
    }
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
    ref.read(personalNewLoanRequestProvider.notifier).setCheckingLoanAgreementSuccess(false);
    _cancelToken.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    ref.watch(personalLoanServerSentEventsProvider);
    ref.watch(personalLoanEventsProvider);
    ref.watch(personalNewLoanRequestProvider);
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
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
                      EdgeInsets.only(top: RelativeSize.height(20, height)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: RelativeSize.width(30, width)),
                        child: PersonalNewLoanRequestTopNav(
                          onBackClick: () async {
                            await showDialog(
                                context: context,
                                barrierColor: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.5),
                                builder: (BuildContext context) {
                                  return PersonalNewLoanRequestAlertDialog(
                                      text:
                                          "Have you signed the Loan Agreement?",
                                      onConfirm: () async {
                                        await _checkLoanAgreementSuccess();
                                      });
                                });
                          },
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
                                "Loan Agreement",
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
                                    .watch(personalNewLoanRequestProvider)
                                    .aadharKYCFailure
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
                                        "Your Loan Agreement Sign Failed!",
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
                                          _refetchLoanAgreement();
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
                                              "Try Again?",
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
                                      const SpacerWidget(
                                        height: 30,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          HapticFeedback.mediumImpact();
                                          context.go(
                                              PersonalNewLoanRequestRouter
                                                  .new_loan_process);
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
                                              "Cancel?",
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
                                      )
                                    ],
                                  )
                                : _verifyingLoanAgreementSuccess
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
                                            "Verifying Loan Agreement Success...",
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
                                                key: _loanAgreementWebviewKey,
                                                gestureRecognizers: const <Factory<
                                                    VerticalDragGestureRecognizer>>{},
                                                initialSettings:
                                                    InAppWebViewSettings(
                                                  javaScriptEnabled: true,
                                                  verticalScrollBarEnabled:
                                                      true,
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
                                                onLoadStop: (_, __) {
                                                  setState(() {
                                                    _loadingAgreementURL =
                                                        false;
                                                  });
                                                },
                                                onWebViewCreated:
                                                    (controller) async {
                                                  _webViewController =
                                                      controller;
                                                  _webViewController!.loadUrl(
                                                      urlRequest: URLRequest(
                                                          url: WebUri(
                                                              _currentUrl)));
                                                  setState(() {
                                                    _loadingAgreementURL =
                                                        false;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                          WebviewTopBar(
                                              controller: _webViewController),
                                          _loadingAgreementURL
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
