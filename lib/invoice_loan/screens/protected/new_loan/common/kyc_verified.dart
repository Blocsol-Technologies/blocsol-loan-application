import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/global_state/theme/theme_state.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/loan_request_router.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/components/top_nav.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/loan_events/loan_events.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/server_sent_events/sse.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/loan_request.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/state/error_codes.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class InvoiceLoanKycVerified extends ConsumerStatefulWidget {
  final IBCKycType kycType;
  const InvoiceLoanKycVerified({super.key, required this.kycType});

  @override
  ConsumerState<InvoiceLoanKycVerified> createState() =>
      _InvoiceLoanKycVerifiedScreenState();
}

class _InvoiceLoanKycVerifiedScreenState
    extends ConsumerState<InvoiceLoanKycVerified> {
  final _cancelToken = CancelToken();

  void _performNextSteps() async {
    if (ref.read(invoiceNewLoanRequestProvider).verifyingAadharKYC ||
        ref.read(invoiceNewLoanRequestProvider).verifyingEntityKYC) {
      return;
    }

    await Future.delayed(const Duration(seconds: 5));

    if (widget.kycType == IBCKycType.aadhar) {
      var response = await ref
          .read(invoiceNewLoanRequestProvider.notifier)
          .checkAadharKycSuccess(_cancelToken);

      if (!response.success) {
        ref.read(routerProvider).push(
            InvoiceNewLoanRequestRouter.loan_service_error,
            extra: InvoiceLoanServiceErrorCodes.aadhar_kyc_failed);
      }
      return;
    } else {
      var response = await ref
          .read(invoiceNewLoanRequestProvider.notifier)
          .checkEntityKycFormSuccess(_cancelToken);

      if (!response.success) {
        ref.read(routerProvider).push(
            InvoiceNewLoanRequestRouter.loan_service_error,
            extra: InvoiceLoanServiceErrorCodes.entity_kyc_error);
      }
      return;
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _performNextSteps();
    });
    super.initState();
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
          resizeToAvoidBottomInset: true,
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(
                20, RelativeSize.height(30, height), 20, 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                InvoiceNewLoanRequestTopNav(onBackClick: () {
                  ref.read(routerProvider).pop();
                }),
                const SpacerWidget(
                  height: 80,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Lottie.asset(
                      'assets/animations/ok.json',
                      width: (width - 40),
                    ),
                  ],
                ),
                const SpacerWidget(
                  height: 60,
                ),
                SizedBox(
                  width: width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.kycType == IBCKycType.aadhar ? "Aadhar" : "Entity"} KYC Verified",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: AppFontSizes.heading,
                          fontWeight: AppFontWeights.bold,
                          letterSpacing: 0.14,
                        ),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                      const SpacerWidget(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Performing next steps",
                            style: TextStyle(
                              fontFamily: fontFamily,
                              color: const Color.fromRGBO(130, 130, 130, 1),
                              fontSize: AppFontSizes.h3,
                              fontWeight: AppFontWeights.medium,
                              letterSpacing: 0.14,
                            ),
                            textAlign: TextAlign.center,
                            softWrap: true,
                          ),
                          const SpacerWidget(
                            width: 10,
                          ),
                          Lottie.asset("assets/animations/loading_spinner.json",
                              width: 30),
                        ],
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
