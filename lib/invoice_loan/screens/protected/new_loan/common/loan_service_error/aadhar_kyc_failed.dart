import 'package:blocsol_loan_application/invoice_loan/constants/routes/loan_request_router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/theme.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/components/timer.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/components/top_nav.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/loan_events/loan_events.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/server_sent_events/sse.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/loan_request.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/snackbar_notifications/util.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:go_router/go_router.dart';

class InvoiceLoanAadharKycFailed extends ConsumerStatefulWidget {
  const InvoiceLoanAadharKycFailed({super.key});

  @override
  ConsumerState<InvoiceLoanAadharKycFailed> createState() =>
      _InvoiceLoanAadharKycFailedState();
}

class _InvoiceLoanAadharKycFailedState
    extends ConsumerState<InvoiceLoanAadharKycFailed> {
  final _cancelToken = CancelToken();
  bool _refetchingAaadharKycUrl = false;

  Future<void> _refetchKYCURL() async {
    if (!ref.read(invoiceNewLoanRequestProvider).aadharKYCFailure) {
      return;
    }

    setState(() {
      _refetchingAaadharKycUrl = true;
    });

    ref.read(invoiceNewLoanRequestProvider.notifier).setAadharKYCFailure(false);

    var response = await ref
        .read(invoiceNewLoanRequestProvider.notifier)
        .refetchAadharKycUrl(_cancelToken);

    if (!mounted || !context.mounted) return;

    setState(() {
      _refetchingAaadharKycUrl = false;
    });

    if (!response.success) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: getSnackbarNotificationWidget(
            message: "Unable to refetch Aadhar KYC URL. Contact Support.",
            notifType: SnackbarNotificationType.error),
        duration: const Duration(seconds: 15),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    ref.watch(invoiceLoanServerSentEventsProvider);
    ref.watch(invoiceLoanEventsProvider);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
              RelativeSize.width(20, width),
              RelativeSize.height(30, height),
              RelativeSize.width(20, width),
              RelativeSize.height(50, height)),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              InvoiceNewLoanRequestTopNav(
                onBackClick: () {
                  context.go(InvoiceNewLoanRequestRouter.loan_offer_select);
                },
              ),
              const SpacerWidget(height: 35),
              const InvoiceNewLoanRequestCountdownTimer(),
              const SpacerWidget(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Lottie.asset(
                    'assets/animations/unavailable.json',
                    width: (width - 80),
                  ),
                ],
              ),
              const SpacerWidget(
                height: 40,
              ),
              SizedBox(
                width: width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Lender has rejected your",
                      style: TextStyle(
                        fontFamily: fontFamily,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: AppFontSizes.heading,
                        fontWeight: AppFontWeights.bold,
                        letterSpacing: 0.14,
                      ),
                      textAlign: TextAlign.start,
                      softWrap: true,
                    ),
                    Text(
                      "Aadhar KYC!",
                      style: TextStyle(
                        fontFamily: fontFamily,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: AppFontSizes.heading,
                        fontWeight: AppFontWeights.bold,
                        letterSpacing: 0.14,
                      ),
                      textAlign: TextAlign.start,
                      softWrap: true,
                    ),
                    const SpacerWidget(
                      height: 5,
                    ),
                    Text(
                      "Choose your next step",
                      style: TextStyle(
                        fontFamily: fontFamily,
                        color: const Color.fromRGBO(130, 130, 130, 1),
                        fontSize: AppFontSizes.h3,
                        fontWeight: AppFontWeights.medium,
                        letterSpacing: 0.14,
                      ),
                      textAlign: TextAlign.start,
                      softWrap: true,
                    ),
                    const SpacerWidget(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () async {
                        HapticFeedback.heavyImpact();
                        await _refetchKYCURL();
                      },
                      child: Container(
                        height: 40,
                        width: RelativeSize.width(252, width),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).colorScheme.tertiary,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: _refetchingAaadharKycUrl
                              ? Lottie.asset(
                                  "assets/animations/loading_spinner.json",
                                  width: 40)
                              : Text(
                                  "Retry Aadhar KYC",
                                  style: TextStyle(
                                    fontFamily: fontFamily,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontSize: AppFontSizes.h3,
                                    fontWeight: AppFontWeights.bold,
                                    letterSpacing: 0.14,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SpacerWidget(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.heavyImpact();
                        context
                            .go(InvoiceNewLoanRequestRouter.loan_offer_select);
                      },
                      child: Container(
                        height: 40,
                        width: RelativeSize.width(252, width),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).colorScheme.surface,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Select Another Offer",
                            style: TextStyle(
                              fontFamily: fontFamily,
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: AppFontSizes.h3,
                              fontWeight: AppFontWeights.bold,
                              letterSpacing: 0.14,
                            ),
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
    );
  }
}
