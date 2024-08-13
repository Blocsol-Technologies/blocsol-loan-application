import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/global_state/theme/theme_state.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/loan_request_router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/support_router.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/loan_events/loan_events.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/server_sent_events/sse.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/loan_request.dart';
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
import 'package:lottie/lottie.dart';

class InvoiceNewLoanAgreement extends ConsumerStatefulWidget {
  const InvoiceNewLoanAgreement({super.key});

  @override
  ConsumerState<InvoiceNewLoanAgreement> createState() =>
      _InvoiceNewLoanAgreementState();
}

class _InvoiceNewLoanAgreementState
    extends ConsumerState<InvoiceNewLoanAgreement> {
  final _cancelToken = CancelToken();
  final GlobalKey _agreementWebviewKey = GlobalKey();

  InAppWebViewController? _webViewController;

  void _fetchLoanAgreementURL() async {
    var response = await ref
        .read(invoiceNewLoanRequestProvider.notifier)
        .fetchLoanAgreementUrl(_cancelToken);

    if (!mounted) return;

    if (response.success) {
      if (response.data['redirect_form']) {
        ref.read(routerProvider).pushReplacement(
            InvoiceNewLoanRequestRouter.loan_agreement_webview,
            extra: response.data['url']);
        return;
      }

      _webViewController?.loadUrl(
          urlRequest: URLRequest(url: WebUri(response.data['url'])));
    } else {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Error!',
          message: "Unable to fetch Loan Agreement URL. Contact Support.",
          contentType: ContentType.failure,
        ),
        duration: const Duration(seconds: 15),
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
    final newLoanStateRef = ref.watch(invoiceNewLoanRequestProvider);
    ref.watch(invoiceLoanServerSentEventsProvider);
    ref.watch(invoiceLoanEventsProvider);
    final selectedOffer = newLoanStateRef.selectedOffer;
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
                RelativeSize.height(0, height)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () async {
                          HapticFeedback.mediumImpact();
                          ref.read(routerProvider).pop();
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
                ),
                const SpacerWidget(
                  height: 32,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 40,
                        child: getLenderDetailsAssetURL(
                            selectedOffer.bankName, selectedOffer.bankLogoURL),
                      ),
                      const SpacerWidget(
                        width: 10,
                      ),
                    ],
                  ),
                ),
                const SpacerWidget(
                  height: 20,
                ),
                Text(
                  "Loan Agreement",
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Deposit A/c :",
                      style: TextStyle(
                          fontFamily: fontFamily,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: AppFontSizes.b1,
                          fontWeight: AppFontWeights.normal,
                          letterSpacing: 0.14),
                      softWrap: true,
                    ),
                    const SpacerWidget(
                      width: 8,
                    ),
                    SizedBox(
                      height: 25,
                      child: getLenderDetailsAssetURL(newLoanStateRef.bankName,
                          newLoanStateRef.selectedOffer.bankLogoURL),
                    ),
                    const SpacerWidget(
                      width: 8,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            newLoanStateRef.bankName,
                            style: TextStyle(
                                fontFamily: fontFamily,
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: AppFontSizes.h3,
                                fontWeight: AppFontWeights.medium,
                                letterSpacing: 0.165),
                          ),
                          Text(
                            "Acc No - ${newLoanStateRef.bankAccountNumber}",
                            style: TextStyle(
                                fontFamily: fontFamily,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.35),
                                fontSize: AppFontSizes.b1,
                                fontWeight: AppFontWeights.medium,
                                letterSpacing: 0.15),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SpacerWidget(
                  height: 35,
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                    width: MediaQuery.of(context).size.width,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.03),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: newLoanStateRef.verifyingLoanAgreementSuccess
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Lottie.asset(
                                          "assets/animations/loading_spinner.json",
                                          height: 150,
                                          width: 150),
                                      const SpacerWidget(height: 35),
                                      Text(
                                        "Verifying...",
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
                                : InAppWebView(
                                    key: _agreementWebviewKey,
                                    gestureRecognizers: const <Factory<
                                        VerticalDragGestureRecognizer>>{},
                                    initialSettings: InAppWebViewSettings(
                                      javaScriptEnabled: true,
                                      verticalScrollBarEnabled: true,
                                      disableHorizontalScroll: true,
                                      disableVerticalScroll: false,
                                    ),
                                    initialUrlRequest:
                                        URLRequest(url: WebUri("")),
                                    onWebViewCreated: (controller) async {
                                      _webViewController = controller;
                                    },
                                  ),
                          ),
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
    );
  }
}
