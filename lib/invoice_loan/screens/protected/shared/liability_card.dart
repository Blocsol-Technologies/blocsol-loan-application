import 'package:blocsol_loan_application/invoice_loan/constants/routes/liabilities_router.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/liability/single/liability.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_details.dart';
import 'package:blocsol_loan_application/personal_loan/contants/theme.dart';
import 'package:blocsol_loan_application/utils/lender_utils.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/percent_indicator.dart';

class LiabilityCard extends ConsumerWidget {
  final LoanDetails oldLoanDetails;
  const LiabilityCard({super.key, required this.oldLoanDetails});

  void _handleDetailsClickHandler(BuildContext context, WidgetRef ref) {
    ref
        .read(invoiceLoanLiabilityProvider.notifier)
        .updateSelectedOffer(oldLoanDetails);
    context.go(InvoiceLoanLiabilitiesRouter.singleLiabilityDetails);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: RelativeSize.height(190, height),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: RelativeSize.height(190, height),
              padding: EdgeInsets.symmetric(
                horizontal: RelativeSize.width(20, width),
                vertical: RelativeSize.height(15, height),
              ),
              width: RelativeSize.width(310, width),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    width: 1,
                    color: oldLoanDetails.offerDetails.isLoanClosed()
                        ? Theme.of(context).colorScheme.primary
                        : oldLoanDetails.offerDetails.isLoanDisbursed()
                            ? Theme.of(context).colorScheme.secondary
                            : Colors.purple.shade500,
                  )),
              child: Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: 80,
                          width: 80,
                          child: Center(
                            child: CircularPercentIndicator(
                              radius: 40,
                              lineWidth: 8,
                              animation: true,
                              percent: oldLoanDetails.offerDetails
                                  .getAmountPaidPercentage(),
                              backgroundColor:
                                  const Color.fromARGB(255, 183, 182, 229),
                              center: SizedBox(
                                height: 40,
                                width: 40,
                                child: getLenderDetailsAssetURL(
                                    oldLoanDetails.offerDetails.bankName,
                                    oldLoanDetails.offerDetails.bankLogoURL),
                              ),
                              circularStrokeCap: CircularStrokeCap.round,
                              progressColor:
                                  const Color.fromRGBO(102, 51, 153, 1),
                            ),
                          ),
                        ),
                      ),
                      const SpacerWidget(
                        width: 15,
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              oldLoanDetails.offerDetails.bankName,
                              style: TextStyle(
                                fontFamily: fontFamily,
                                fontSize: AppFontSizes.b1,
                                fontWeight: AppFontWeights.medium,
                                color: Theme.of(context).colorScheme.onTertiary,
                              ),
                            ),
                            const SpacerWidget(
                              height: 12,
                            ),
                            Text(
                              "Loan Amount",
                              style: TextStyle(
                                fontFamily: fontFamily,
                                fontSize: AppFontSizes.b1,
                                fontWeight: AppFontWeights.normal,
                                color: Theme.of(context).colorScheme.onTertiary,
                              ),
                            ),
                            Text(
                              "₹ ${oldLoanDetails.offerDetails.deposit}",
                              style: TextStyle(
                                fontFamily: fontFamily,
                                fontSize: AppFontSizes.b1,
                                fontWeight: AppFontWeights.medium,
                                color: Theme.of(context).colorScheme.onTertiary,
                              ),
                            ),
                            const SpacerWidget(
                              height: 5,
                            ),
                            Text(
                              oldLoanDetails.offerDetails.isLoanClosed()
                                  ? "Closed"
                                  : oldLoanDetails.offerDetails
                                          .isLoanDisbursed()
                                      ? "Disbursed"
                                      : "Sanctioned",
                              style: TextStyle(
                                fontFamily: fontFamily,
                                fontSize: AppFontSizes.b1,
                                fontWeight: AppFontWeights.medium,
                                color: Theme.of(context).colorScheme.onTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SpacerWidget(
                    height: 15,
                  ),
                  Container(
                    height: 1,
                    width: width,
                    color: Theme.of(context)
                        .colorScheme
                        .onTertiary
                        .withOpacity(0.3),
                  ),
                  const SpacerWidget(
                    height: 10,
                  ),
                  Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text("Due Amount",
                              style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: AppFontSizes.b2,
                                  fontWeight: AppFontWeights.normal,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onTertiary)),
                          Text(
                              "₹ ${oldLoanDetails.offerDetails.getBalanceLeft()}",
                              style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: AppFontSizes.b2,
                                  fontWeight: AppFontWeights.bold,
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                        ],
                      ),
                      const SpacerWidget(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text("Due Date",
                              style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: AppFontSizes.b2,
                                  fontWeight: AppFontWeights.normal,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onTertiary)),
                          Text(oldLoanDetails.offerDetails.getNextDueDate(),
                              style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: AppFontSizes.b2,
                                  fontWeight: AppFontWeights.bold,
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    _handleDetailsClickHandler(context, ref);
                  },
                  child: Container(
                    height: RelativeSize.height(25, height),
                    width: RelativeSize.width(105, width),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: Center(
                      child: Text(
                        "Details",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.b2,
                          fontWeight: AppFontWeights.medium,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
