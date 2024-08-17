import 'dart:async';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:blocsol_loan_application/personal_loan/contants/routes/loan_request_router.dart';
import 'package:blocsol_loan_application/personal_loan/contants/theme.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/account_details/account_details.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/events/loan_events/loan_events.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/events/server_sent_events/sse.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/new_loan/new_loan.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/new_loan/state/new_loan_state.dart';
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
        content: AwesomeSnackbarContent(
          title: 'Error!',
          message:
              "Aadhar KYC Failed. Refetch Aadhar KYC URL or Restart the journey",
          contentType: ContentType.failure,
        ),
        duration: const Duration(seconds: 10),
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

    bool success = false;
    int tries = 0;

    while (!success && tries < 5) {
      var form03SubmissionResponse = await ref
          .read(personalNewLoanRequestProvider.notifier)
          .checkAadharKYCSuccess(_cancelToken);

      if (form03SubmissionResponse.success) {
        success = true;
      } else {
        tries++;
        await Future.delayed(const Duration(seconds: 15));
      }
    }

    if (!mounted) return;

    if (!success) {
      ref
          .read(personalNewLoanRequestProvider.notifier)
          .setAadharKYCFailure(true);
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
            urlRequest: URLRequest(url: WebUri(response.data['url'])));
      }
    }
  }

  void _handleNotificationBellPress() {
    print("Notification Bell Pressed");
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
    final newLoanStateRef = ref.watch(personalNewLoanRequestProvider);
    final borrowerAccountDetailsRef =
        ref.watch(personalLoanAccountDetailsProvider);
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
                                            'Have you completed the KYC successfully?',
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
                                                context.go(
                                                    PersonalNewLoanRequestRouter
                                                        .new_loan_process);
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
                                                _checkAadharKYCSuccess();
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
                            SizedBox(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  IconButton(
                                    onPressed: () {
                                      HapticFeedback.mediumImpact();
                                      _handleNotificationBellPress();
                                    },
                                    icon: Icon(
                                      Icons.notifications_active,
                                      size: 25,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                                  ),
                                  const SpacerWidget(
                                    width: 15,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      HapticFeedback.mediumImpact();
                                    },
                                    child: Container(
                                      height: 28,
                                      width: 28,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Image.network(
                                          borrowerAccountDetailsRef
                                                  .imageURL.isEmpty
                                              ? "https://placehold.co/30x30/000000/FFFFFF.png"
                                              : borrowerAccountDetailsRef
                                                  .imageURL,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
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
                              color: Theme.of(context).colorScheme.background,
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
                                          newLoanStateRef.fetchingAadharKYCURl
                                              ? const LinearProgressIndicator()
                                              : Container(),
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                            ),
                                            child: InAppWebView(
                                              key: aadharWebviewKey,
                                              gestureRecognizers: const <Factory<
                                                  VerticalDragGestureRecognizer>>{},
                                              initialSettings:
                                                  InAppWebViewSettings(
                                                javaScriptEnabled: true,
                                                verticalScrollBarEnabled: true,
                                                disableHorizontalScroll: true,
                                                disableVerticalScroll: false,
                                              ),
                                              initialUrlRequest: URLRequest(
                                                  url: WebUri(_currentURL)),
                                              onWebViewCreated:
                                                  (controller) async {
                                                _webViewController = controller;
                                                _webViewController!.loadUrl(
                                                    urlRequest: URLRequest(
                                                        url: WebUri(
                                                            _currentURL)));
                                              },
                                            ),
                                          ),
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
