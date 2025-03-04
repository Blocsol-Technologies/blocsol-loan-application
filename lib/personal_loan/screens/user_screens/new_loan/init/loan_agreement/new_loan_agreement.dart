import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/theme.dart';
import 'package:blocsol_loan_application/personal_loan/constants/routes/loan_request_router.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/new_loan/components/top_nav.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/new_loan/init/loan_agreement/agreement_otp_modal_bottom_sheet.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/events/loan_events/loan_events.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/events/server_sent_events/sse.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/new_loan/new_loan.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/new_loan/state/new_loan_state.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/snackbar_notifications/util.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class PCNewLoanLoanAgreement extends ConsumerStatefulWidget {
  const PCNewLoanLoanAgreement({super.key});

  @override
  ConsumerState<PCNewLoanLoanAgreement> createState() =>
      _PCNewLoanLoanAgreementState();
}

class _PCNewLoanLoanAgreementState
    extends ConsumerState<PCNewLoanLoanAgreement> {
  final _cancelToken = CancelToken();
  final GlobalKey _agreementWebviewKey = GlobalKey();

  String _currentUrl = "";
  InAppWebViewController? _webViewController;

  Future<void> _iAgreeClickHandler(BuildContext context) async {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: PersonalLoanAgreementOTPModalBottomSheet(
              onSubmit: (String otp) {
                _submitAndVerifyLoanAgreementSuccess(otp);
              },
            ),
          );
        });
  }

  void _submitAndVerifyLoanAgreementSuccess(String otp) async {
    if (ref.read(personalNewLoanRequestProvider).verifyingAadharKYC) {
      return;
    }

    var submitForm07Response = await ref
        .read(personalNewLoanRequestProvider.notifier)
        .submitLoanAgreementAndCheckSuccess(otp, _cancelToken);

    if (!mounted || !context.mounted) return;

    if (!submitForm07Response.success) {
      ref
          .read(personalNewLoanRequestProvider.notifier)
          .setVerifyingAadharKYC(false);
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: getSnackbarNotificationWidget(
            message: "Unable to submit OTP",
            notifType: SnackbarNotificationType.error),
        duration: const Duration(seconds: 15),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }

    ref
        .read(personalNewLoanRequestProvider.notifier)
        .updateState(PersonalLoanRequestProgress.loanAgreement);

    if (mounted) {
      context.go(PersonalNewLoanRequestRouter.new_loan_process);
    }

    return;
  }

  void _fetchLoanAgreementURL() async {
    var response = await ref
        .read(personalNewLoanRequestProvider.notifier)
        .fetchLoanAgreementURL(_cancelToken);

    if (!mounted || !context.mounted) return;

    if (response.success) {
      if (response.data['redirect_form']) {
        context.go(PersonalNewLoanRequestRouter.new_loan_agreement_webview,
            extra: response.data['url']);
        return;
      }

      setState(() {
        _currentUrl = response.data['url'];
      });

      _webViewController?.loadUrl(
          urlRequest: URLRequest(url: WebUri(response.data['url'])));
    } else {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: getSnackbarNotificationWidget(
            message: "Unable to fetch loan agreement url",
            notifType: SnackbarNotificationType.error),
        duration: const Duration(seconds: 5),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);

      return;
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchLoanAgreementURL();
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
    final newLoanStateRef = ref.watch(personalNewLoanRequestProvider);
    ref.watch(personalLoanEventsProvider);
    ref.watch(personalLoanServerSentEventsProvider);

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
                        EdgeInsets.only(top: RelativeSize.height(20, height)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: RelativeSize.width(30, width)),
                          child: PersonalNewLoanRequestTopNav(
                            onBackClick: () async {
                              ref.read(routerProvider).push(
                                  PersonalNewLoanRequestRouter
                                      .new_loan_process);
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
                        SizedBox(
                          height: RelativeSize.height(450, height),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: RelativeSize.width(15, width)),
                            child: Container(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 10, right: 10),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Expanded(
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: newLoanStateRef
                                              .verifyingLoanAgreementSuccess
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
                                                  "Verifying Agreement Success...",
                                                  style: TextStyle(
                                                    fontFamily: fontFamily,
                                                    fontSize: AppFontSizes.h2,
                                                    fontWeight:
                                                        AppFontWeights.bold,
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
                                                    fontWeight:
                                                        AppFontWeights.medium,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurface,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Stack(
                                              children: [
                                                newLoanStateRef
                                                        .fetchingLoanAgreementForm
                                                    ? const LinearProgressIndicator()
                                                    : Container(),
                                                InAppWebView(
                                                  key: _agreementWebviewKey,
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
                                                  ),
                                                  onLoadStop:
                                                      (controller, url) {
                                                    setState(() {
                                                      _currentUrl =
                                                          url.toString();
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
                                                  },
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SpacerWidget(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                HapticFeedback.heavyImpact();
                                _iAgreeClickHandler(context);
                              },
                              child: Container(
                                height: RelativeSize.height(40, height),
                                width: RelativeSize.width(252, width),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Text(
                                    "Continue",
                                    style: TextStyle(
                                      fontFamily: fontFamily,
                                      fontSize: AppFontSizes.b1,
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
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
