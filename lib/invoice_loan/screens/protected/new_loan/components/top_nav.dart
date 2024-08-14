import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/loan_request_router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/support_router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/theme.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/components/progress_indicator.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/loan_request.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/state/loan_request_state.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InvoiceNewLoanRequestTopNav extends ConsumerWidget {
  final Function onBackClick;
  const InvoiceNewLoanRequestTopNav({super.key, required this.onBackClick});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newLoanStateRef = ref.watch(invoiceNewLoanRequestProvider).currentState;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () async {
            HapticFeedback.mediumImpact();
            await onBackClick();
          },
          child: Icon(
            Icons.arrow_back_outlined,
            size: 20,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.65),
          ),
        ),
        Expanded(
          child: Container(),
        ),
        newLoanStateRef.index >=
                LoanRequestProgress.loanOfferSelected.index
            ? GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  ref.read(routerProvider).push(InvoiceNewLoanRequestRouter
                      .loan_independent_key_fact_sheet);
                },
                child: Container(
                  height: 25,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
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
                      "Loan Details",
                      style: TextStyle(
                        fontFamily: fontFamily,
                        fontSize: AppFontSizes.b1,
                        fontWeight: AppFontWeights.extraBold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox(),
        const SpacerWidget(
          width: 12,
        ),
        const InvoiceNewLoanProgressIndicator(),
        const SpacerWidget(
          width: 12,
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
                color: Theme.of(context).colorScheme.primary.withOpacity(0.75),
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
    );
  }
}
