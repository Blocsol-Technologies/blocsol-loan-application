import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/liabilities_router.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/liability/single/liability.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_details.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/theme.dart';
import 'package:blocsol_loan_application/utils/lender_utils.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LiabilityCard extends ConsumerWidget {
  final LoanDetails oldLoanDetails;
  final Color bgColor;
  final Color seperatorColor;
  const LiabilityCard({super.key, required this.oldLoanDetails, this.bgColor = Colors.white, this.seperatorColor = Colors.transparent});

  void _handleDetailsClickHandler(BuildContext context, WidgetRef ref) {
    ref
        .read(invoiceLoanLiabilityProvider.notifier)
        .updateSelectedOffer(oldLoanDetails);
    ref
        .read(routerProvider)
        .push(InvoiceLoanLiabilitiesRouter.singleLiabilityDetails);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();

        _handleDetailsClickHandler(context, ref);
      },
      child: Container(
          width: width,
          padding: EdgeInsets.symmetric(
            horizontal: RelativeSize.width(20, width),
            vertical: RelativeSize.height(15, height),
          ),
          decoration: BoxDecoration(
            color: bgColor,
            border: Border(
              bottom: BorderSide(
                color: seperatorColor,
                width: 5,
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 35,
                width: 35,
                child: getLenderDetailsAssetURL(
                    oldLoanDetails.offerDetails.bankName,
                    oldLoanDetails.offerDetails.bankLogoURL),
              ),
              const SpacerWidget(
                width: 5,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          width: 130,
                          child: Text(
                            oldLoanDetails.offerDetails.bankName,
                            softWrap: true,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: AppFontSizes.b1,
                              fontWeight: AppFontWeights.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        const SpacerWidget(
                          width: 6,
                        ),
                        Expanded(
                          child: Text(
                            "₹ ${oldLoanDetails.offerDetails.getRoundedLoanValue()}",
                            style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: AppFontSizes.b1,
                              fontWeight: AppFontWeights.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SpacerWidget(
                      height: 7,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${oldLoanDetails.idt} . ${oldLoanDetails.inum}",
                          softWrap: true,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: fontFamily,
                            fontSize: AppFontSizes.b1,
                            fontWeight: AppFontWeights.normal,
                            color: const Color.fromRGBO(120, 120, 120, 1),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            ref
                                .read(invoiceLoanLiabilityProvider.notifier)
                                .updateSelectedOffer(oldLoanDetails);
                            ref.read(routerProvider).push(
                                InvoiceLoanLiabilitiesRouter
                                    .singleLiabilityDetails);
                          },
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                            color: Color.fromRGBO(120, 120, 120, 1),
                          ),
                        ),
                      ],
                    ),
                    const SpacerWidget(
                      height: 7,
                    ),
                    Text(
                      "Repayment: ${oldLoanDetails.offerDetails.getNextDueDate()}",
                      softWrap: true,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: fontFamily,
                        fontSize: AppFontSizes.b1,
                        fontWeight: AppFontWeights.normal,
                        color: const Color.fromRGBO(120, 120, 120, 1),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
