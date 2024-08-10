import 'package:blocsol_loan_application/global_state/theme/theme_state.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/loan_events/loan_events.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/server_sent_events/sse.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/loan_request.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InvoiceNewLoanProcessing extends ConsumerStatefulWidget {
  const InvoiceNewLoanProcessing({super.key});

  @override
  ConsumerState<InvoiceNewLoanProcessing> createState() =>
      _InvoiceNewLoanProcessingState();
}

class _InvoiceNewLoanProcessingState
    extends ConsumerState<InvoiceNewLoanProcessing> {
  @override
  Widget build(BuildContext context) {
    ref.watch(invoiceNewLoanRequestProvider);
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
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Lottie.asset(
                  "assets/animations/processing_form.json",
                  height: 250,
                  width: 250,
                ),
                const SizedBox(height: 50),
                Text(
                  "Processing Loan with Lender...",
                  style: TextStyle(
                    fontFamily: fontFamily,
                    fontSize: AppFontSizes.h1,
                    fontWeight: AppFontWeights.bold,
                    letterSpacing: 0.4,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  "Please do not press back or exit",
                  style: TextStyle(
                    fontFamily: fontFamily,
                    fontSize: AppFontSizes.h3,
                    fontWeight: AppFontWeights.medium,
                    letterSpacing: 0.4,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
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
