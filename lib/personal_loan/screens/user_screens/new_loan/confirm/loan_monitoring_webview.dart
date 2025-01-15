import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/theme.dart';
import 'package:blocsol_loan_application/personal_loan/constants/routes/loan_request_router.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/new_loan/components/top_nav.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/account_details/account_details.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/events/loan_events/loan_events.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/events/server_sent_events/sse.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/new_loan/new_loan.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/new_loan/state/new_loan_state.dart';
import 'package:blocsol_loan_application/utils/logger.dart';
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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:lottie/lottie.dart';

class PCNewLoanMonitoringConsentAAWebview extends ConsumerStatefulWidget {
  final String url;
  const PCNewLoanMonitoringConsentAAWebview({super.key, required this.url});

  @override
  ConsumerState<PCNewLoanMonitoringConsentAAWebview> createState() =>
      _PCNewLoanMonitoringConsentAAWebviewState();
}

class _PCNewLoanMonitoringConsentAAWebviewState
    extends ConsumerState<PCNewLoanMonitoringConsentAAWebview> {
  final GlobalKey _webViewKey = GlobalKey();
  final _cancelToken = CancelToken();
  final _urlController = TextEditingController();

  InAppWebViewController? _webViewController;
  bool _loading = true;
  String _currentUrl = "";
  bool _checkingConsentSuccess = false;
  bool _checkConsentError = false;

  void _checkConsentSuccess(String? ecres, String? resdate) async {
    if (_checkingConsentSuccess) return;

    setState(() {
      _checkingConsentSuccess = true;
      _checkConsentError = false;
    });

    if (ecres == null || resdate == null) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: getSnackbarNotificationWidget(
            message: "Unable to confirm consent creation",
            notifType: SnackbarNotificationType.error),
        duration: const Duration(seconds: 10),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);

      setState(() {
        _checkingConsentSuccess = false;
        _checkConsentError = true;
      });
    }

    var checkConsentResponse = await ref
        .read(personalNewLoanRequestProvider.notifier)
        .checkLoanMonitoringConsentSuccess(ecres!, resdate!, _cancelToken);

    if (!mounted || !context.mounted) return;
    
    logFirebaseEvent("personal_loan_application_process", {
      "step": "check_loan_monitoring_consent_success",
      "phoneNumber": ref.read(personalLoanAccountDetailsProvider).phone,
      "success": checkConsentResponse.success,
      "message": checkConsentResponse.message,
      "data": checkConsentResponse.data ?? {},
    });

    if (!checkConsentResponse.success) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: getSnackbarNotificationWidget(
            message: "Unable to confirm consent creation",
            notifType: SnackbarNotificationType.error),
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

    ref
        .read(personalNewLoanRequestProvider.notifier)
        .updateState(PersonalLoanRequestProgress.monitoringConsent);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _webViewController?.loadUrl(
        urlRequest: URLRequest(
          url: WebUri(_currentUrl),
        ),
      );
    });

    setState(() {
      _currentUrl = widget.url;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    ref.watch(personalNewLoanRequestProvider);
    ref.watch(personalLoanServerSentEventsProvider);
    ref.watch(personalLoanEventsProvider);
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: Stack(
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
                padding: EdgeInsets.symmetric(
                    vertical: RelativeSize.height(20, height)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: RelativeSize.width(30, width)),
                      child: PersonalNewLoanRequestTopNav(
                        onBackClick: () async {
                          ref.read(routerProvider).push(
                              PersonalNewLoanRequestRouter.new_loan_process);
                        },
                      ),
                    ),
                    const SpacerWidget(
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: RelativeSize.width(50, width)),
                      child: SizedBox(
                        width: width,
                        child: Center(
                          child: Text(
                            "Loan Monitoring Consent",
                            style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: AppFontSizes.h1,
                              fontWeight: AppFontWeights.medium,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            textAlign: TextAlign.center,
                            softWrap: true,
                          ),
                        ),
                      ),
                    ),
                    const SpacerWidget(
                      height: 30,
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: RelativeSize.width(15, width),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Theme.of(context).colorScheme.surface),
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                          child: _checkConsentError
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  height: height,
                                  width: width,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Lottie.asset(
                                          "assets/animations/error.json",
                                          height: 200,
                                          width: 200),
                                      const SpacerWidget(height: 20),
                                      Text(
                                        "You did not provide loan monitoring consent for the lenders. You need to restart the loan process",
                                        style: TextStyle(
                                          fontFamily: fontFamily,
                                          fontSize: AppFontSizes.h3,
                                          fontWeight: AppFontWeights.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                        textAlign: TextAlign.center,
                                        softWrap: true,
                                      ),
                                      const SpacerWidget(
                                        height: 70,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          HapticFeedback.mediumImpact();
                                          // _checkConsentSuccess(
                                          //     "irq1kXRco_HZxWm6m0VG-VyQk9ogCpoiaoEVr-7P-2QOSg0KE59u727hu7EKn7_5cMMiJZM7Bfv2XfPtc5aEUXuR1pNm4_jHyR0KQJyc3LK6azfJxIMBTS9s8WyAR6yM_JoBxHJY8QhSDX0xes6dOAw5YJKBwxXQRSpMVxOEpO3uFAV9zk6ISgXc0KVtqSC98ltIkyfYU-Adak0dtBIGPRODpJb22cQAy8kiVIyxOvRm321I425xXaFt0Wwu9THfUQ5YW41rzCTt-6HccnKAGk69DIgpN7eNMDYnndkxASk=",
                                          //     "090520241133660");

                                          ref
                                              .read(
                                                  personalNewLoanRequestProvider
                                                      .notifier)
                                              .reset();
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
                                              "Restart",
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
                                    ],
                                  ))
                              : _checkingConsentSuccess
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 20),
                                      height: height,
                                      width: width,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Lottie.asset(
                                              "assets/animations/loading_spinner.json",
                                              height: 250,
                                              width: 250),
                                          const SpacerWidget(height: 35),
                                          Text(
                                            "Verifying Consent Success...",
                                            style: TextStyle(
                                              fontFamily: fontFamily,
                                              fontSize: AppFontSizes.h3,
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
                                      ))
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Stack(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 50),
                                                  child: InAppWebView(
                                                    key: _webViewKey,
                                                    gestureRecognizers: const <Factory<
                                                        VerticalDragGestureRecognizer>>{},
                                                    initialSettings:
                                                        InAppWebViewSettings(
                                                      javaScriptEnabled: true,
                                                      verticalScrollBarEnabled:
                                                          true,
                                                      disableHorizontalScroll:
                                                          true,
                                                      disableVerticalScroll:
                                                          false,
                                                      javaScriptCanOpenWindowsAutomatically:
                                                          true,
                                                      supportMultipleWindows:
                                                          true,
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
                                                        (controller) {
                                                      _webViewController =
                                                          controller;
                                                    },
                                                    onLoadStop:
                                                        (controller, url) {
                                                      setState(() {
                                                        _loading = false;
                                                        _currentUrl =
                                                            url.toString();
                                                        _urlController.text =
                                                            _currentUrl;
                                                      });
                                                    },
                                                    initialUrlRequest:
                                                        URLRequest(
                                                      url: WebUri(_currentUrl),
                                                    ),
                                                    shouldOverrideUrlLoading:
                                                        (controller,
                                                            navigationAction) async {
                                                      var uri = navigationAction
                                                          .request.url;

                                                      if (uri != null &&
                                                          uri.toString().contains(
                                                              'https://ondc.invoicepe.in/aa-redirect')) {
                                                        // Extract query parameters
                                                        String? ecres =
                                                            uri.queryParameters[
                                                                'ecres'];
                                                        String? resdate =
                                                            uri.queryParameters[
                                                                'resdate'];

                                                        _checkConsentSuccess(
                                                            ecres, resdate);
                                                      }
                                                      return NavigationActionPolicy
                                                          .ALLOW;
                                                    },
                                                  ),
                                                ),
                                                WebviewTopBar(
                                                    controller:
                                                        _webViewController),
                                                _loading
                                                    ? const LinearProgressIndicator()
                                                    : Container(),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
