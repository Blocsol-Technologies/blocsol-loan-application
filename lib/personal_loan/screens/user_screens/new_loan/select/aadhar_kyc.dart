import 'dart:async';

import 'package:blocsol_loan_application/personal_loan/constants/routes/loan_request_router.dart';
import 'package:blocsol_loan_application/personal_loan/constants/theme.dart';
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

class PCNewLoanAadharKYCWebview extends ConsumerStatefulWidget {
  const PCNewLoanAadharKYCWebview({super.key});

  @override
  ConsumerState<PCNewLoanAadharKYCWebview> createState() =>
      _PCNewLoanAadharKYCWebviewState();
}

class _PCNewLoanAadharKYCWebviewState
    extends ConsumerState<PCNewLoanAadharKYCWebview> {
  InAppWebViewController? _webViewController;
  bool _verifyingAadharKYC = false;
  String _currentURL = "";

  final GlobalKey aadharWebviewKey = GlobalKey();
  final _cancelToken = CancelToken();

  Future<void> _checkAadharKYCSuccess() async {
    if (ref.read(personalNewLoanRequestProvider).aadharKYCFailure) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: getSnackbarNotificationWidget(
            message:
                "Aadhay KYC failed. Refetch Aadhar KYC Url or Restart the journey",
            notifType: SnackbarNotificationType.error),
        duration: const Duration(seconds: 5),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
      return;
    }

    if (_verifyingAadharKYC) {
      return;
    }

    setState(() {
      _verifyingAadharKYC = true;
    });

    var form03SubmissionResponse = await ref
        .read(personalNewLoanRequestProvider.notifier)
        .checkAadharKYCSuccess(_cancelToken);

    if (!mounted) return;

    if (!form03SubmissionResponse.success) {
      ref
          .read(personalNewLoanRequestProvider.notifier)
          .setAadharKYCFailure(true);
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: getSnackbarNotificationWidget(
            message: "Aadhar KYC unsuccessful",
            notifType: SnackbarNotificationType.error),
        duration: const Duration(seconds: 5),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
      return;
    }

    setState(() {
      _verifyingAadharKYC = false;
    });

    ref
        .read(personalNewLoanRequestProvider.notifier)
        .updateState(PersonalLoanRequestProgress.aadharKYC);
    context.go(PersonalNewLoanRequestRouter.new_loan_process);
  }

  void _fetchKYCURL() async {
    if (ref.read(personalNewLoanRequestProvider).fetchingAadharKYCURl) return;

    var response = await ref
        .read(personalNewLoanRequestProvider.notifier)
        .fetchAadharKYCURL(_cancelToken);

    if (mounted) {
      if (!response.success) {
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: getSnackbarNotificationWidget(
              message: "Unable to fetch Aadhar KYC Url.",
              notifType: SnackbarNotificationType.error),
          duration: const Duration(seconds: 5),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);

        return;
      } else {
        setState(() {
          _currentURL = response.data['url'];
        });
        _webViewController?.loadUrl(
            urlRequest: URLRequest(url: WebUri(response.data['url'])));
      }
    }
  }

  Future<void> _refetchKYCURL() async {
    if (!ref.read(personalNewLoanRequestProvider).aadharKYCFailure) {
      return;
    }

    var response = await ref
        .read(personalNewLoanRequestProvider.notifier)
        .refetchAadharKYCURL(_cancelToken);

    if (mounted) {
      if (!response.success) {
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: getSnackbarNotificationWidget(
              message: "Unable to refetch Aadhar KYC Url",
              notifType: SnackbarNotificationType.error),
          duration: const Duration(seconds: 15),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
        return;
      } else {
        _webViewController?.loadUrl(
            urlRequest: URLRequest(url: WebUri(response.data['url'])));
      }
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
    ref
        .read(personalNewLoanRequestProvider.notifier)
        .setVerifyingAadharKYC(false);
    _cancelToken.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final newLoanStateRef = ref.watch(personalNewLoanRequestProvider);
    ref.watch(personalLoanEventsProvider);
    ref.watch(personalLoanServerSentEventsProvider);

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
                                      text: "Have you completed your KYC?",
                                      onConfirm: () async {
                                        await _checkAadharKYCSuccess();
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
                              GestureDetector(
                                onTap: () {
                                  ref
                                      .read(personalNewLoanRequestProvider
                                          .notifier)
                                      .checkAadharKYCSuccess(_cancelToken);
                                },
                                child: Text(
                                  "Aadhar KYC",
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
                                          height: 200,
                                          width: 200),
                                      const SpacerWidget(height: 35),
                                      Text(
                                        "Your Aadhar KYC Failed!",
                                        style: TextStyle(
                                          fontFamily: fontFamily,
                                          fontSize: AppFontSizes.h3,
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
                                                fontSize: AppFontSizes.h3,
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
                                                fontSize: AppFontSizes.h3,
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
                                : _verifyingAadharKYC
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
                                                key: aadharWebviewKey,
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
                                                    url: WebUri(_currentURL)),
                                                onWebViewCreated:
                                                    (controller) async {
                                                  _webViewController =
                                                      controller;
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
                                          newLoanStateRef.fetchingAadharKYCURl
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
