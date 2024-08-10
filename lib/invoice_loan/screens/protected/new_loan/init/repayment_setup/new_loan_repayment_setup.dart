import 'dart:async';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/global_state/theme/theme_state.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/loan_request_router.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/components/continue_button.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/loan_events/loan_events.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/server_sent_events/sse.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/loan_request.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/state/error_codes.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/state/loan_request_state.dart';
import 'package:blocsol_loan_application/invoice_loan/state/user/profile/profile_details.dart';
import 'package:blocsol_loan_application/utils/lender_utils.dart';
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
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class InvoiceNewLoanRepaymentSetup extends ConsumerStatefulWidget {
  const InvoiceNewLoanRepaymentSetup({super.key});

  @override
  ConsumerState<InvoiceNewLoanRepaymentSetup> createState() =>
      _InvoiceNewLoanRepaymentSetupState();
}

class _InvoiceNewLoanRepaymentSetupState
    extends ConsumerState<InvoiceNewLoanRepaymentSetup> {
  final _cancelToken = CancelToken();
  final GlobalKey _repaymentURLWebviewKey = GlobalKey();

  bool _showRepaymentWebview = false;
  bool _loadingRepaymentURL = false;
  InAppWebViewController? _webViewController;
  String _currentUrl = "";

  void _checkRepaymentSuccessStatus() async {
    if (ref.read(invoiceNewLoanRequestProvider).repaymentSetupFailure) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Error!',
          message: "Repayment Setup Unsuccessful. Refetch the Repayment URL",
          contentType: ContentType.failure,
        ),
        duration: const Duration(seconds: 15),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);

      return;
    }

    var checkRepaymentSetupSuccessResponse = await ref
        .read(invoiceNewLoanRequestProvider.notifier)
        .checkRepaymentSetupSuccess(_cancelToken);

    if (!mounted) return;

    if (!checkRepaymentSetupSuccessResponse.success) {
      context.go(InvoiceNewLoanRequestRouter.loan_service_error,
          extra: LoanServiceErrorCodes.repayment_setup_failed);
      return;
    }

    ref
        .read(invoiceNewLoanRequestProvider.notifier)
        .updateState(LoanRequestProgress.repaymentSetupCompleted);

    return;
  }

  void _fetchRepaymentFormUrl() async {
    if (_loadingRepaymentURL) {
      return;
    }

    setState(() {
      _loadingRepaymentURL = true;
    });

    var fetchURLResponse = await ref
        .read(invoiceNewLoanRequestProvider.notifier)
        .fetchRepaymentSetupUrl(_cancelToken);

    if (!mounted) return;

    setState(() {
      _loadingRepaymentURL = false;
    });

    if (fetchURLResponse.success) {
      setState(() {
        _currentUrl = fetchURLResponse.data['url'];
      });
      _webViewController?.loadUrl(
          urlRequest: URLRequest(url: WebUri(fetchURLResponse.data['url'])));
    } else {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Error!',
          message: "Unable to fetch Repayment Form URL. Contact Support",
          contentType: ContentType.failure,
        ),
        duration: const Duration(seconds: 15),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }

  Future<void> _refetchRepaymentSetupURL() async {
    if (!ref.read(invoiceNewLoanRequestProvider).repaymentSetupFailure) {
      return;
    }

    ref
        .read(invoiceNewLoanRequestProvider.notifier)
        .setRepaymentSetupFailure(false);

    setState(() {
      _loadingRepaymentURL = true;
    });

    var response = await ref
        .read(invoiceNewLoanRequestProvider.notifier)
        .refetchRepaymentSetupForm(_cancelToken);

    setState(() {
      _loadingRepaymentURL = false;
    });

    if (!mounted) return;

    if (!response.success) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Error!',
          message: "Unable to refetch Repayment Mandate URL. Contact Support.",
          contentType: ContentType.failure,
        ),
        duration: const Duration(seconds: 15),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    } else {
      _webViewController?.loadUrl(
          urlRequest: URLRequest(url: WebUri(response.data)));
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchRepaymentFormUrl();
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
    final msmeBasicDetailsRef =
        ref.watch(invoiceLoanUserProfileDetailsProvider);
    ref.watch(invoiceLoanServerSentEventsProvider);
    ref.watch(invoiceLoanEventsProvider);
    final newLoanStateRef = ref.watch(invoiceNewLoanRequestProvider);
    final selectedOffer = newLoanStateRef.selectedOffer;
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            padding: EdgeInsets.fromLTRB(
                RelativeSize.width(20, width),
                RelativeSize.height(20, height),
                RelativeSize.width(20, width),
                RelativeSize.height(0, height)),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () async {
                        HapticFeedback.mediumImpact();
                        if (_showRepaymentWebview) {
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
                                      'Have you successfully set up Repayment?',
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
                                          HapticFeedback.mediumImpact();
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
                                          _checkRepaymentSuccessStatus();
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
                        } else {
                          ref.read(routerProvider).pop();
                        }
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
                    Container(
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
                  ],
                ),
                const SpacerWidget(
                  height: 35,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                      child: getLenderDetailsAssetURL(
                          selectedOffer.bankName, selectedOffer.bankLogoURL),
                    ),
                    const SpacerWidget(
                      width: 10,
                    ),
                  ],
                ),
                const SpacerWidget(
                  height: 8,
                ),
                Text(
                  "Setup Auto Repayment",
                  style: TextStyle(
                      fontFamily: fontFamily,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: AppFontSizes.h1,
                      fontWeight: AppFontWeights.bold,
                      letterSpacing: 0.4),
                  softWrap: true,
                ),
                const SpacerWidget(
                  height: 16,
                ),
                Text(
                  "Allow lender to auto-deduct repayment from your ${newLoanStateRef.bankName} ending ****${newLoanStateRef.bankAccountNumber.substring(newLoanStateRef.bankAccountNumber.length - 4)}",
                  style: TextStyle(
                      fontFamily: fontFamily,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: AppFontSizes.h3,
                      fontWeight: AppFontWeights.normal,
                      letterSpacing: 0.4),
                  softWrap: true,
                ),
                const SpacerWidget(
                  height: 35,
                ),
                if (!_showRepaymentWebview) ...[
                  Text(
                    "Repayment Details",
                    style: TextStyle(
                        fontFamily: fontFamily,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: AppFontSizes.h2,
                        fontWeight: AppFontWeights.bold,
                        letterSpacing: 0.14),
                  ),
                  const SpacerWidget(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Text("Amount Payable:",
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontFamily: fontFamily,
                                      fontSize: AppFontSizes.b1,
                                      fontWeight: AppFontWeights.medium)),
                            ),
                            const SpacerWidget(
                              width: 5,
                            ),
                            Expanded(
                              child: Text(
                                "₹ ${selectedOffer.totalRepayment}",
                                softWrap: true,
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontFamily: fontFamily,
                                    fontSize: AppFontSizes.b1,
                                    fontWeight: AppFontWeights.bold),
                              ),
                            ),
                          ],
                        ),
                        const SpacerWidget(
                          height: 15,
                        ),
                        const SpacerWidget(
                          height: 15,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Text("Autorepay End (Due Date After):",
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontFamily: fontFamily,
                                      fontSize: AppFontSizes.b1,
                                      fontWeight: AppFontWeights.medium)),
                            ),
                            const SpacerWidget(
                              width: 5,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "From: ${selectedOffer.tenure}",
                                    softWrap: true,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b1,
                                        fontWeight: AppFontWeights.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SpacerWidget(
                          height: 15,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                "Sanctioned Cancellation Fee:",
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontFamily: fontFamily,
                                    fontSize: AppFontSizes.b1,
                                    fontWeight: AppFontWeights.medium),
                              ),
                            ),
                            const SpacerWidget(
                              width: 5,
                            ),
                            Expanded(
                              child: Text(
                                newLoanStateRef.sanctionedCancellationFee,
                                softWrap: true,
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontFamily: fontFamily,
                                    fontSize: AppFontSizes.b1,
                                    fontWeight: AppFontWeights.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SpacerWidget(
                    height: 20,
                  ),
                  Text(
                    "Account Details",
                    style: TextStyle(
                        fontFamily: fontFamily,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: AppFontSizes.h2,
                        fontWeight: AppFontWeights.bold,
                        letterSpacing: 0.14),
                  ),
                  const SpacerWidget(
                    height: 20,
                  ),
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.2),
                                width: 1))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Account Number",
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.4),
                            fontSize: AppFontSizes.h3,
                            fontWeight: AppFontWeights.medium,
                            fontFamily: fontFamily,
                            letterSpacing: 0.14,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              newLoanStateRef.bankAccountNumber,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: AppFontSizes.h3,
                                fontWeight: AppFontWeights.bold,
                                fontFamily: fontFamily,
                                letterSpacing: 0.165,
                              ),
                            ),
                            const SpacerWidget(
                              height: 3,
                            ),
                            Text(
                              newLoanStateRef.bankIFSC,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.4),
                                fontSize: AppFontSizes.b2,
                                fontWeight: AppFontWeights.normal,
                                fontFamily: fontFamily,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.2),
                                width: 1))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Account Holder Name",
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.4),
                            fontSize: AppFontSizes.h3,
                            fontWeight: AppFontWeights.medium,
                            fontFamily: fontFamily,
                            letterSpacing: 0.14,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              msmeBasicDetailsRef.legalName,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: AppFontSizes.h3,
                                fontWeight: AppFontWeights.bold,
                                fontFamily: fontFamily,
                                letterSpacing: 0.165,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SpacerWidget(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ContinueButton(onPressed: () {
                        setState(() {
                          _showRepaymentWebview = true;
                        });
                      }),
                    ],
                  ),
                ],
                if (_showRepaymentWebview) ...[
                  Expanded(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ref
                              .watch(invoiceNewLoanRequestProvider)
                              .entityKYCFailure
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                const SpacerWidget(height: 50),
                                Lottie.asset("assets/animations/error.json",
                                    height: 300, width: 300),
                                const SpacerWidget(height: 35),
                                Text(
                                  "Your Repayment Mandate Setup Failed!",
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
                                    HapticFeedback.mediumImpact();
                                    _refetchRepaymentSetupURL();
                                  },
                                  child: Container(
                                    height: 40,
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
                                const SpacerWidget(
                                  height: 30,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    HapticFeedback.mediumImpact();
                                    ref.read(routerProvider).pop();
                                  },
                                  child: Container(
                                    height: 40,
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
                                          fontSize: AppFontSizes.h2,
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
                          : ref
                                  .read(invoiceNewLoanRequestProvider)
                                  .checkingRepaymentSetupSuccess
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
                                      "Verifying Repayment Success...",
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
                                    _loadingRepaymentURL
                                        ? const LinearProgressIndicator()
                                        : Container(),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height,
                                      width: MediaQuery.of(context).size.width,
                                      child: InAppWebView(
                                        key: _repaymentURLWebviewKey,
                                        gestureRecognizers: const <Factory<
                                            VerticalDragGestureRecognizer>>{},
                                        initialSettings: InAppWebViewSettings(
                                          javaScriptEnabled: true,
                                          verticalScrollBarEnabled: true,
                                          disableHorizontalScroll: true,
                                          disableVerticalScroll: false,
                                        ),
                                        onLoadStop: (controller, url) {
                                          setState(() {
                                            _loadingRepaymentURL = false;
                                          });
                                        },
                                        initialUrlRequest: URLRequest(
                                            url: WebUri(_currentUrl)),
                                        onWebViewCreated: (controller) async {
                                          _webViewController = controller;
                                          controller.loadUrl(
                                              urlRequest: URLRequest(
                                                  url: WebUri(_currentUrl)));
                                        },
                                        onLoadStart: (controller, url) async {
                                          setState(() {
                                            _loadingRepaymentURL = true;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                    ),
                  )
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String getRepaymentTime(int start, int days) {
  DateTime startDate = DateTime.fromMillisecondsSinceEpoch(start * 1000);

  // Calculate the end date by adding the number of days
  DateTime endDate = startDate.add(Duration(days: days));

  // Format the end date
  String formattedEndDate = DateFormat('d MMM, yyyy').format(endDate);

  return formattedEndDate;
}

String getFromattedTime(int time) {
  DateTime date = DateTime.fromMillisecondsSinceEpoch(time * 1000);
  String formattedEndDate = DateFormat('d MMM, yyyy').format(date);

  return formattedEndDate;
}
