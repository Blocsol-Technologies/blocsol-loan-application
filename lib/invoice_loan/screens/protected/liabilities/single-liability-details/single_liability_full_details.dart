import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/liabilities_router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/theme.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/liabilities/foreclosure/foreclose_bottom_sheet.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/liabilities/utils/top_decoration.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/liability/single/liability.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class InvoiceLoanLiabilityFullDetails extends ConsumerStatefulWidget {
  const InvoiceLoanLiabilityFullDetails({super.key});

  @override
  ConsumerState<InvoiceLoanLiabilityFullDetails> createState() =>
      _InvoiceLoanLiabilityFullDetailsState();
}

class _InvoiceLoanLiabilityFullDetailsState
    extends ConsumerState<InvoiceLoanLiabilityFullDetails> {
  Future<void> _forecloseLoan() async {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: InvoiceLoanForecloseModalBottomSheet(
              forecloseAmount: ref
                  .read(invoiceLoanLiabilityProvider)
                  .selectedLiability
                  .offerDetails
                  .getBalanceLeft(),
            ),
          );
        });

    return;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final oldLoanStateRef = ref.watch(invoiceLoanLiabilityProvider);
    final selectedLiability = oldLoanStateRef.selectedLiability;

    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Stack(
              children: [
                const LiabilityTopDecoration(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: RelativeSize.height(30, height),
                          left: RelativeSize.width(30, width),
                          right: RelativeSize.width(30, width)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              context.go(InvoiceLoanLiabilitiesRouter
                                  .singleLiabilityDetails);
                            },
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: 20,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SpacerWidget(
                      height: 30,
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
                            Text(
                              "Documents and Details",
                              style: TextStyle(
                                fontFamily: fontFamily,
                                fontSize: AppFontSizes.h1,
                                fontWeight: AppFontWeights.medium,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                              textAlign: TextAlign.center,
                              softWrap: true,
                            ),
                            const SpacerWidget(
                              height: 10,
                            ),
                            Text(
                              'Loan ID: ${selectedLiability.offerDetails.transactionId}',
                              style: TextStyle(
                                fontFamily: fontFamily,
                                fontSize: AppFontSizes.b1,
                                fontWeight: AppFontWeights.normal,
                                color: Theme.of(context).colorScheme.onPrimary,
                                letterSpacing: 0.24,
                              ),
                              textAlign: TextAlign.center,
                              softWrap: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SpacerWidget(
                      height: 75,
                    ),
                    Container(
                      height: RelativeSize.height(200, height),
                      width: width,
                      padding: EdgeInsets.symmetric(
                          horizontal: RelativeSize.width(55, width)),
                      child: Stack(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    height: RelativeSize.height(45, height),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Amount Paid",
                                          style: TextStyle(
                                            fontFamily: fontFamily,
                                            fontSize: AppFontSizes.b2,
                                            fontWeight: AppFontWeights.normal,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onTertiary,
                                          ),
                                        ),
                                        Text(
                                          "₹ ${selectedLiability.offerDetails.getAmountPaid()}",
                                          style: TextStyle(
                                            fontFamily: fontFamily,
                                            fontSize: AppFontSizes.h3,
                                            fontWeight: AppFontWeights.medium,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onTertiary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SpacerWidget(
                                    width: 20,
                                  ),
                                  SizedBox(
                                    height: RelativeSize.height(45, height),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Total Repayment",
                                          style: TextStyle(
                                            fontFamily: fontFamily,
                                            fontSize: AppFontSizes.b2,
                                            fontWeight: AppFontWeights.normal,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onTertiary,
                                          ),
                                        ),
                                        Text(
                                          "₹ ${selectedLiability.offerDetails.totalRepayment}",
                                          style: TextStyle(
                                            fontFamily: fontFamily,
                                            fontSize: AppFontSizes.h3,
                                            fontWeight: AppFontWeights.medium,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onTertiary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SpacerWidget(
                                    width: 20,
                                  ),
                                  SizedBox(
                                    height: RelativeSize.height(45, height),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Amount Due",
                                          style: TextStyle(
                                            fontFamily: fontFamily,
                                            fontSize: AppFontSizes.b2,
                                            fontWeight: AppFontWeights.normal,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onTertiary,
                                          ),
                                        ),
                                        Text(
                                          "₹ ${selectedLiability.offerDetails.getBalanceLeft()}",
                                          style: TextStyle(
                                            fontFamily: fontFamily,
                                            fontSize: AppFontSizes.h3,
                                            fontWeight: AppFontWeights.medium,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onTertiary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              const SpacerWidget(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    height: RelativeSize.height(45, height),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Next Due Date",
                                          style: TextStyle(
                                            fontFamily: fontFamily,
                                            fontSize: AppFontSizes.b2,
                                            fontWeight: AppFontWeights.normal,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onTertiary,
                                          ),
                                        ),
                                        Text(
                                          selectedLiability.offerDetails
                                              .getNextDueDate(),
                                          style: TextStyle(
                                            fontFamily: fontFamily,
                                            fontSize: AppFontSizes.h3,
                                            fontWeight: AppFontWeights.medium,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onTertiary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SpacerWidget(
                                    width: 20,
                                  ),
                                  SizedBox(
                                    height: RelativeSize.height(45, height),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Next EMI",
                                          style: TextStyle(
                                            fontFamily: fontFamily,
                                            fontSize: AppFontSizes.b2,
                                            fontWeight: AppFontWeights.normal,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onTertiary,
                                          ),
                                        ),
                                        Text(
                                          "₹ ${selectedLiability.offerDetails.getNextPayment()}",
                                          style: TextStyle(
                                            fontFamily: fontFamily,
                                            fontSize: AppFontSizes.h3,
                                            fontWeight: AppFontWeights.medium,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onTertiary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SpacerWidget(
                                height: 42,
                              ),
                              Container(
                                height: 3,
                                width: RelativeSize.width(225, width),
                                color: Theme.of(context)
                                    .colorScheme
                                    .scrim
                                    .withOpacity(0.5),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: width,
                      padding: EdgeInsets.symmetric(
                          horizontal: RelativeSize.width(35, width)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "1. Loan Details",
                            style: TextStyle(
                                fontFamily: fontFamily,
                                fontSize: AppFontSizes.b2,
                                fontWeight: AppFontWeights.medium,
                                color: Theme.of(context).colorScheme.onSurface),
                          ),
                          const SpacerWidget(
                            height: 15,
                          ),
                          Container(
                            width: width,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(233, 233, 250, 1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: RelativeSize.width(25, width),
                                vertical: RelativeSize.height(18, height)),
                            child: Column(
                              children: [
                                // Lender
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Lender",
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b2,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        selectedLiability.offerDetails.bankName,
                                        softWrap: true,
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                          fontFamily: fontFamily,
                                          fontSize: AppFontSizes.b2,
                                          fontWeight: AppFontWeights.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 17),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.15),
                                  height: 1,
                                  width: width,
                                ),
                                // Loan Amount
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Loan Amount",
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b2,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                    Text(
                                      "₹ ${selectedLiability.offerDetails.getNumericalValOrDefault(selectedLiability.offerDetails.deposit)}",
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b2,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 17),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.15),
                                  height: 1,
                                  width: width,
                                ),
                                // Interest
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Interest",
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b2,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                    Text(
                                      "₹ ${selectedLiability.offerDetails.interest}",
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b2,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 17),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.15),
                                  height: 1,
                                  width: width,
                                ),
                                // Annual Percentage Rate
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Annual Percentage Rate (APR)",
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b2,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                    Text(
                                      selectedLiability
                                          .offerDetails.annualPercentageRate,
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b2,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 17),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.15),
                                  height: 1,
                                  width: width,
                                ),
                                // Application Fee
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Application Fee",
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b2,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                    Text(
                                      "₹ ${selectedLiability.offerDetails.getNumericalValOrDefault(selectedLiability.offerDetails.applicationFee)}",
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b2,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 17),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.15),
                                  height: 1,
                                  width: width,
                                ),
                                // Processing Fee
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Processing Fee",
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b2,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                    Text(
                                      "₹ ${selectedLiability.offerDetails.getNumericalValOrDefault(selectedLiability.offerDetails.processingFee)}",
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b2,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 17),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.15),
                                  height: 1,
                                  width: width,
                                ),
                                // Insurance Fee
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Insurance Charges",
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b2,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                    Text(
                                      "₹ ${selectedLiability.offerDetails.getNumericalValOrDefault(selectedLiability.offerDetails.insuranceCharges)}",
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b2,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 17),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.15),
                                  height: 1,
                                  width: width,
                                ),
                                // Other Charges
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Other Charges",
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b2,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                    Text(
                                      "₹ ${selectedLiability.offerDetails.getNumericalValOrDefault(selectedLiability.offerDetails.otherCharges)}",
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b2,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 17),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.15),
                                  height: 1,
                                  width: width,
                                ),
                                // Total Disbursed Amount
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Total Disbursed Amount",
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b2,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                    Text(
                                      "₹ ${selectedLiability.offerDetails.netDisbursedAmount}",
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b2,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 17),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.15),
                                  height: 1,
                                  width: width,
                                ),
                                // Total Repayment Amount
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Total Repayment Amount",
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b2,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                    Text(
                                      "₹ ${selectedLiability.offerDetails.totalRepayment}",
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b2,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 17),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.15),
                                  height: 1,
                                  width: width,
                                ),
                                // Tenure
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Tenure",
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b2,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                    Text(
                                      selectedLiability.offerDetails.tenure,
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b2,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 17),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.15),
                                  height: 1,
                                  width: width,
                                ),

                                // Repayment Frequency
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Repayment Frequency",
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b2,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                    Text(
                                      selectedLiability
                                          .offerDetails.repaymentFrequency,
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b2,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 17),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.15),
                                  height: 1,
                                  width: width,
                                ),

                                // Number of Installments
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Number of Installments",
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b2,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        selectedLiability
                                            .offerDetails.numInstallments,
                                        softWrap: true,
                                        style: TextStyle(
                                          fontFamily: fontFamily,
                                          fontSize: AppFontSizes.b2,
                                          fontWeight: AppFontWeights.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 17),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.15),
                                  height: 1,
                                  width: width,
                                ),

                                // Cool off period
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Cool off Period",
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b2,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        selectedLiability
                                            .offerDetails.coolOffPeriod,
                                        softWrap: true,
                                        style: TextStyle(
                                          fontFamily: fontFamily,
                                          fontSize: AppFontSizes.b2,
                                          fontWeight: AppFontWeights.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 17),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.15),
                                  height: 1,
                                  width: width,
                                ),

                                // Transaction Id
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Transaction Id",
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b2,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 120,
                                      child: Text(
                                        selectedLiability
                                            .offerDetails.transactionId,
                                        softWrap: true,
                                        style: TextStyle(
                                          fontFamily: fontFamily,
                                          fontSize: AppFontSizes.b2,
                                          fontWeight: AppFontWeights.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 17),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.15),
                                  height: 1,
                                  width: width,
                                ),

                                // Lender Id
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Lender Id",
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b2,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 120,
                                      child: Text(
                                        selectedLiability
                                            .offerDetails.offerProviderId,
                                        softWrap: true,
                                        style: TextStyle(
                                          fontFamily: fontFamily,
                                          fontSize: AppFontSizes.b2,
                                          fontWeight: AppFontWeights.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 17),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.15),
                                  height: 1,
                                  width: width,
                                ),

                                // Terms and Conditions
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Terms",
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b2,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        HapticFeedback.mediumImpact();
                                        ref.read(routerProvider).push(
                                            InvoiceLoanLiabilitiesRouter
                                                .general_webview,
                                            extra: selectedLiability
                                                .offerDetails.terms);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 15),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                        child: Text(
                                          "Terms",
                                          softWrap: true,
                                          style: TextStyle(
                                            fontFamily: fontFamily,
                                            fontSize: AppFontSizes.b2,
                                            fontWeight: AppFontWeights.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                          ),
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 17),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.15),
                                  height: 1,
                                  width: width,
                                ),
                              ],
                            ),
                          ),
                          const SpacerWidget(
                            height: 15,
                          ),
                          Text(
                            "2. Penalty Details",
                            style: TextStyle(
                                fontFamily: fontFamily,
                                fontSize: AppFontSizes.b2,
                                fontWeight: AppFontWeights.medium,
                                color: Theme.of(context).colorScheme.onSurface),
                          ),
                          const SpacerWidget(
                            height: 15,
                          ),
                          Container(
                            width: width,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(233, 233, 250, 1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: RelativeSize.width(25, width),
                                vertical: RelativeSize.height(18, height)),
                            child: Column(
                              children: [
                                // Late Charge
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Late Charge",
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b2,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        selectedLiability
                                            .offerDetails.lateCharge,
                                        softWrap: true,
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                          fontFamily: fontFamily,
                                          fontSize: AppFontSizes.b2,
                                          fontWeight: AppFontWeights.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 17),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.15),
                                  height: 1,
                                  width: width,
                                ),
                                // Prepayment Penalty
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Prepayment Penalty",
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b2,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                    Text(
                                      selectedLiability.offerDetails
                                          .getNumericalValOrDefault(
                                              selectedLiability.offerDetails
                                                  .prepaymentPenalty),
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b2,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 17),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.15),
                                  height: 1,
                                  width: width,
                                ),
                                // Other penalty fee
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Other Penalty Fee",
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b2,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                    Text(
                                      selectedLiability
                                          .offerDetails.otherPenaltyFee,
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b2,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 17),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.15),
                                  height: 1,
                                  width: width,
                                ),
                                // Interest Rate Conversion
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Interest Rate Conversion Charge",
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b2,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                    Text(
                                      selectedLiability.offerDetails
                                          .getNumericalValOrDefault(
                                              selectedLiability.offerDetails
                                                  .interestRateConversionCharge),
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b2,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 17),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.15),
                                  height: 1,
                                  width: width,
                                ),
                                // Cancellation Details

                                Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.2),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  width: width,
                                  padding: const EdgeInsets.only(
                                      bottom: 15, top: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        width: 100,
                                        child: Text(
                                          "Cancellation charge after Loan Sanction",
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            fontSize: AppFontSizes.b2,
                                            fontWeight: AppFontWeights.bold,
                                            fontFamily: fontFamily,
                                            letterSpacing: 0.14,
                                          ),
                                          softWrap: true,
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            selectedLiability
                                                .offerDetails
                                                .cancellationTerms
                                                .sanctionedCancellationPercent,
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                              fontSize: AppFontSizes.b2,
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

                                Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.2),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  width: width,
                                  padding: const EdgeInsets.only(
                                      bottom: 15, top: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        width: 100,
                                        child: Text(
                                          "Cancellation charge after Loan Disbursement",
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            fontSize: AppFontSizes.b2,
                                            fontWeight: AppFontWeights.bold,
                                            fontFamily: fontFamily,
                                            letterSpacing: 0.14,
                                          ),
                                          softWrap: true,
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            selectedLiability
                                                .offerDetails
                                                .cancellationTerms
                                                .disbursedCancellationPercent,
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                              fontSize: AppFontSizes.b2,
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
                              ],
                            ),
                          ),
                          const SpacerWidget(
                            height: 15,
                          ),
                          Text(
                            "3. Documents",
                            style: TextStyle(
                                fontFamily: fontFamily,
                                fontSize: AppFontSizes.b2,
                                fontWeight: AppFontWeights.medium,
                                color: Theme.of(context).colorScheme.onSurface),
                          ),
                          const SpacerWidget(
                            height: 15,
                          ),
                          Container(
                            width: width,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(233, 233, 250, 1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: RelativeSize.width(25, width),
                                vertical: RelativeSize.height(18, height)),
                            child: Column(
                              children: [
                                // Document Details
                                ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: selectedLiability
                                        .offerDetails.documents.length,
                                    itemBuilder: (context, index) {
                                      final documentItem = selectedLiability
                                          .offerDetails.documents[index];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25),
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSurface
                                                          .withOpacity(0.2),
                                                      width: 1))),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              const SizedBox(height: 10),
                                              SizedBox(
                                                width: 280,
                                                child: Text(
                                                  "${documentItem.descriptor.code}: ${documentItem.descriptor.longDesc}",
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurface,
                                                    fontSize: AppFontSizes.b2,
                                                    fontWeight:
                                                        AppFontWeights.bold,
                                                    fontFamily: fontFamily,
                                                    letterSpacing: 0.14,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  softWrap: true,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              GestureDetector(
                                                onTap: () {
                                                  HapticFeedback.mediumImpact();
                                                  ref.read(routerProvider).push(
                                                      InvoiceLoanLiabilitiesRouter
                                                          .general_webview,
                                                      extra: documentItem.url);
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 4,
                                                      horizontal: 5),
                                                  decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .surface,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      border: Border.all(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                          width: 1)),
                                                  child: Center(
                                                    child: Text(
                                                      "View",
                                                      style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                        fontSize:
                                                            AppFontSizes.b1,
                                                        fontWeight:
                                                            AppFontWeights.bold,
                                                        fontFamily: fontFamily,
                                                        letterSpacing: 0.165,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              ],
                            ),
                          ),
                          const SpacerWidget(
                            height: 15,
                          ),
                          Text(
                            "4. Grievance Officer",
                            style: TextStyle(
                                fontFamily: fontFamily,
                                fontSize: AppFontSizes.b2,
                                fontWeight: AppFontWeights.medium,
                                color: Theme.of(context).colorScheme.onSurface),
                          ),
                          const SpacerWidget(
                            height: 15,
                          ),
                          Container(
                            width: width,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(233, 233, 250, 1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: RelativeSize.width(25, width),
                                vertical: RelativeSize.height(18, height)),
                            child: Column(
                              children: [
                                // Name
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Contact Person",
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b2,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        selectedLiability
                                            .offerDetails.contactInfo.name,
                                        softWrap: true,
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                          fontFamily: fontFamily,
                                          fontSize: AppFontSizes.b2,
                                          fontWeight: AppFontWeights.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 17),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.15),
                                  height: 1,
                                  width: width,
                                ),
                                // Email
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Email",
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b2,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                    Text(
                                      selectedLiability
                                          .offerDetails.contactInfo.email,
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b2,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 17),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.15),
                                  height: 1,
                                  width: width,
                                ),
                                // Phone Number
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Phone Number",
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b2,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                    Text(
                                      selectedLiability.offerDetails.contactInfo
                                          .contactNumber,
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b2,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 17),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.15),
                                  height: 1,
                                  width: width,
                                ),
                                // Customer Support Email
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Customer Support Email",
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b2,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 120,
                                      child: Text(
                                        selectedLiability.offerDetails
                                            .contactInfo.customerSupportEmail,
                                        softWrap: true,
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                          fontFamily: fontFamily,
                                          fontSize: AppFontSizes.b2,
                                          fontWeight: AppFontWeights.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 17),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.15),
                                  height: 1,
                                  width: width,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Customer Support Phone",
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b2,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 120,
                                      child: Text(
                                        selectedLiability.offerDetails
                                            .contactInfo.customerSupportNumber,
                                        softWrap: true,
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                          fontFamily: fontFamily,
                                          fontSize: AppFontSizes.b2,
                                          fontWeight: AppFontWeights.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 17),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.15),
                                  height: 1,
                                  width: width,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Customer Support Link",
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b2,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 120,
                                      child: GestureDetector(
                                        onTap: () {
                                          HapticFeedback.heavyImpact();
                                          ref.read(routerProvider).push(
                                              InvoiceLoanLiabilitiesRouter
                                                  .general_webview,
                                              extra: selectedLiability
                                                  .offerDetails
                                                  .contactInfo
                                                  .customerSupportLink);
                                        },
                                        child: Container(
                                          height:
                                              RelativeSize.height(30, height),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                width: 1),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Chat Now",
                                              style: TextStyle(
                                                fontFamily: fontFamily,
                                                fontSize: AppFontSizes.b2,
                                                fontWeight: AppFontWeights.bold,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 17),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.15),
                                  height: 1,
                                  width: width,
                                ),
                              ],
                            ),
                          ),
                          const SpacerWidget(
                            height: 15,
                          ),
                          Text(
                            "5. Support",
                            style: TextStyle(
                                fontFamily: fontFamily,
                                fontSize: AppFontSizes.b2,
                                fontWeight: AppFontWeights.medium,
                                color: Theme.of(context).colorScheme.onSurface),
                          ),
                          const SpacerWidget(
                            height: 15,
                          ),
                          Container(
                            width: width,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(233, 233, 250, 1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: RelativeSize.width(25, width),
                                vertical: RelativeSize.height(18, height)),
                            child: Column(
                              children: [
                                // Name
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Contact Person",
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b2,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        selectedLiability
                                            .offerDetails.lspContactInfo.name,
                                        softWrap: true,
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                          fontFamily: fontFamily,
                                          fontSize: AppFontSizes.b2,
                                          fontWeight: AppFontWeights.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 17),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.15),
                                  height: 1,
                                  width: width,
                                ),
                                // Email
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Email",
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b2,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                    Text(
                                      selectedLiability
                                          .offerDetails.lspContactInfo.email,
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b2,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 17),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.15),
                                  height: 1,
                                  width: width,
                                ),
                                // Phone Number
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Phone Number",
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b2,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                    Text(
                                      selectedLiability
                                          .offerDetails.lspContactInfo.number,
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b2,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 17),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.15),
                                  height: 1,
                                  width: width,
                                ),
                                // Address
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Address",
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b2,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 120,
                                      child: Text(
                                        selectedLiability.offerDetails
                                            .lspContactInfo.address,
                                        softWrap: true,
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                          fontFamily: fontFamily,
                                          fontSize: AppFontSizes.b2,
                                          fontWeight: AppFontWeights.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 17),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.15),
                                  height: 1,
                                  width: width,
                                ),
                              ],
                            ),
                          ),
                          const SpacerWidget(
                            height: 50,
                          ),
                          selectedLiability.offerDetails.isLoanClosed()
                              ? const SizedBox()
                              : GestureDetector(
                                  onTap: () {
                                    HapticFeedback.heavyImpact();
                                    _forecloseLoan();
                                  },
                                  child: Container(
                                    height: RelativeSize.height(40, height),
                                    width: RelativeSize.width(252, width),
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Foreclose Loan",
                                        style: TextStyle(
                                          fontFamily: fontFamily,
                                          fontSize: AppFontSizes.b1,
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
                            height: 50,
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
