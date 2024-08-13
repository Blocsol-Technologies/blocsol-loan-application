import 'package:blocsol_loan_application/invoice_loan/constants/routes/liabilities_router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/theme.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/liability/single/liability.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class InvoiceLoanMissedEmiPaymentModalBottomSheet extends ConsumerStatefulWidget {
  final String url;
  const InvoiceLoanMissedEmiPaymentModalBottomSheet({super.key, required this.url});

  @override
  ConsumerState<InvoiceLoanMissedEmiPaymentModalBottomSheet> createState() =>
      _MissedEmiPaymentModalBottomSheet();
}

class _MissedEmiPaymentModalBottomSheet
    extends ConsumerState<InvoiceLoanMissedEmiPaymentModalBottomSheet> {

  Future<void> _continue() async {
    context.go(InvoiceLoanLiabilitiesRouter.missed_emi_payment, extra: widget.url);
  }

  @override
  Widget build(BuildContext context) {
    final oldLoanStateRef = ref.watch(invoiceLoanLiabilityProvider);
    final selectedLiability = oldLoanStateRef.selectedLiability;
    return Container(
      height: 260,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.fromLTRB(25, 25, 25, 40),
      color: Theme.of(context).colorScheme.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Disclaimer!",
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: AppFontSizes.h1,
              fontWeight: AppFontWeights.bold,
              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.75),
              letterSpacing: 0.14,
            ),
          ),
          const SpacerWidget(
            height: 30,
          ),
          Text(
            "When making missed EMI payment, you agree to pay Missed EMI Penalty charges which are ${selectedLiability..offerDetails.lateCharge}",
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: AppFontSizes.b1,
              fontWeight: AppFontWeights.medium,
              color: Theme.of(context).colorScheme.onPrimary,
              letterSpacing: 0.14,
            ),
          ),
          const SpacerWidget(
            height: 30,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () async {
                    await _continue();
                  },
                  child: Container(
                    height: 40,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                        "Make Payment",
                        style: TextStyle(
                            fontFamily: fontFamily,
                            fontSize: AppFontSizes.h3,
                            fontWeight: AppFontWeights.medium,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                        "Go Back",
                        style: TextStyle(
                            fontFamily: fontFamily,
                            fontSize: AppFontSizes.h3,
                            fontWeight: AppFontWeights.medium,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SpacerWidget(
            height: 15,
          ),
        ],
      ),
    );
  }
}
