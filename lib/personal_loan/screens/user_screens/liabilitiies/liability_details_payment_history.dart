import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/personal_loan/constants/routes/liabilities_router.dart';
import 'package:blocsol_loan_application/personal_loan/constants/theme.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/liabilitiies/components/missed_emi_payment_modal_bottom_sheet.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/events/loan_events/loan_events.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/events/server_sent_events/sse.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/old_loan/old_loans.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/utils/loan/loan_details.dart';
import 'package:blocsol_loan_application/utils/lender_utils.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/snackbar_notifications/util.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/percent_indicator.dart';

class PCLiabilityPaymentDetails extends ConsumerStatefulWidget {
  const PCLiabilityPaymentDetails({super.key});

  @override
  ConsumerState<PCLiabilityPaymentDetails> createState() =>
      _PCLiabilityPaymentDetailsState();
}

class _PCLiabilityPaymentDetailsState
    extends ConsumerState<PCLiabilityPaymentDetails> {
  final _cancelToken = CancelToken();

  Future<void> _missedEmiHandler(PaymentDetails paymentDetails) async {
    if (ref.read(personalLoanLiabilitiesProvider).initiatingMissedEmiPayment) {
      return;
    }

    ref
        .read(personalLoanLiabilitiesProvider.notifier)
        .updateMissedEmiPaymentId(paymentDetails.id);

    var response = await ref
        .read(personalLoanLiabilitiesProvider.notifier)
        .initiateMissedEMIPayment(_cancelToken);

    if (!mounted || !context.mounted) return;

    if (!response.success) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: getSnackbarNotificationWidget(
            message: response.message,
            notifType: SnackbarNotificationType.error),
        duration: const Duration(seconds: 5),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
      return;
    }

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
            child: PersonalLoanMissedEmiPaymentModalBottomSheet(
              url: response.data['url'],
            ),
          );
        });

    return;
  }

  Future<void> _repayLoanHandler() async {
    PaymentDetails? paymentDetails;

    for (final payment in ref
        .watch(personalLoanLiabilitiesProvider)
        .selectedOldOffer
        .loanPayments
        .paymentDetails) {
      if (payment.status == LoanPaymentStatus.missed) {
        paymentDetails = payment;
        break;
      }
    }

    if (paymentDetails != null) {
      await _missedEmiHandler(paymentDetails);
      return;
    } else {
      ref
          .read(routerProvider)
          .push(PersonalLoanLiabilitiesRouter.liability_prepayment);
      return;
    }
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    ref.watch(personalLoanEventsProvider);
    ref.watch(personalLoanServerSentEventsProvider);
    final oldLoanStateRef = ref.watch(personalLoanLiabilitiesProvider);
    final selectedOldOffer = oldLoanStateRef.selectedOldOffer;

    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Stack(
              children: [
                Container(
                  width: width,
                  height: RelativeSize.height(170, height),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(130),
                      bottomRight: Radius.circular(130),
                    ),
                  ),
                ),
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
                              ref.read(routerProvider).pop();
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
                          horizontal: RelativeSize.width(40, width)),
                      child: SizedBox(
                        width: width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              selectedOldOffer.bankName,
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
                              selectedOldOffer.offerProviderId,
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
                      height: 55,
                    ),
                    Container(
                      height: RelativeSize.height(340, height),
                      width: width,
                      padding: EdgeInsets.symmetric(
                          horizontal: RelativeSize.width(40, width)),
                      child: Stack(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 120,
                                    width: 120,
                                    child: Center(
                                      child: CircularPercentIndicator(
                                        radius: 60,
                                        lineWidth: 12,
                                        animation: true,
                                        percent: selectedOldOffer
                                            .getAmountPaidPercentage(),
                                        center: SizedBox(
                                          height: 100,
                                          width: 100,
                                          child: getLenderDetailsAssetURL(
                                              selectedOldOffer.bankName,
                                              selectedOldOffer.bankLogoURL),
                                        ),
                                        circularStrokeCap:
                                            CircularStrokeCap.round,
                                        progressColor: const Color.fromRGBO(
                                            170, 174, 138, 1),
                                      ),
                                    ),
                                  ),
                                  const SpacerWidget(
                                    width: 48,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "Balance Left",
                                          style: TextStyle(
                                            fontFamily: fontFamily,
                                            fontSize: AppFontSizes.b1,
                                            fontWeight: AppFontWeights.normal,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onTertiary,
                                          ),
                                        ),
                                        const SpacerWidget(
                                          height: 15,
                                        ),
                                        Text(
                                          "₹ ${selectedOldOffer.getBalanceLeft()}",
                                          style: TextStyle(
                                            fontFamily: fontFamily,
                                            fontSize: AppFontSizes.h2,
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
                                          "Amount Paid",
                                          style: TextStyle(
                                            fontFamily: fontFamily,
                                            fontSize: AppFontSizes.b1,
                                            fontWeight: AppFontWeights.normal,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onTertiary,
                                          ),
                                        ),
                                        Text(
                                          "₹ ${selectedOldOffer.getAmountPaid()}",
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
                                          "Repayment",
                                          style: TextStyle(
                                            fontFamily: fontFamily,
                                            fontSize: AppFontSizes.b1,
                                            fontWeight: AppFontWeights.normal,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onTertiary,
                                          ),
                                        ),
                                        Text(
                                          "₹ ${selectedOldOffer.totalRepaymentAmount}",
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
                                          "Next Due Date",
                                          style: TextStyle(
                                            fontFamily: fontFamily,
                                            fontSize: AppFontSizes.b1,
                                            fontWeight: AppFontWeights.normal,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onTertiary,
                                          ),
                                        ),
                                        Text(
                                          selectedOldOffer.getNextDueDate(),
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
                                height: 42,
                              ),
                              Container(
                                width: RelativeSize.width(300, width),
                                height: 5,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color:
                                        const Color.fromRGBO(207, 210, 186, 1)),
                                clipBehavior: Clip.antiAlias,
                                child: Row(
                                  children: [
                                    Container(
                                      width: RelativeSize.width(
                                          300 *
                                              selectedOldOffer
                                                  .getPaidEMIPercentage(),
                                          width),
                                      height: 5,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                    ),
                                  ],
                                ),
                              ),
                              const SpacerWidget(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SpacerWidget(
                                    width: 5,
                                  ),
                                  Text(
                                    "${selectedOldOffer.getNumPaidEMIS()} EMI Paid of ${selectedOldOffer.getNumEMIS()}",
                                    style: TextStyle(
                                      fontFamily: fontFamily,
                                      fontSize: AppFontSizes.b1,
                                      fontWeight: AppFontWeights.normal,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onTertiary,
                                    ),
                                  ),
                                ],
                              ),
                              const SpacerWidget(
                                height: 40,
                              ),
                              Text(
                                "Payment Details",
                                style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: AppFontSizes.b1,
                                  fontWeight: AppFontWeights.medium,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SpacerWidget(
                                height: 18,
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
                          ),
                        ],
                      ),
                    ),
                    const SpacerWidget(
                      height: 30,
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount:
                            selectedOldOffer.loanPayments.paymentDetails.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: RelativeSize.width(30, width)),
                            child: SizedBox(
                              width: width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    selectedOldOffer.formatDate(selectedOldOffer
                                        .loanPayments
                                        .paymentDetails[index]
                                        .dueDate),
                                    style: TextStyle(
                                      fontFamily: fontFamily,
                                      fontSize: AppFontSizes.b1,
                                      fontWeight: AppFontWeights.normal,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onTertiary,
                                    ),
                                  ),
                                  const SpacerWidget(
                                    height: 5,
                                  ),
                                  Container(
                                    width: width,
                                    height: RelativeSize.height(50, height),
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            RelativeSize.width(35, width)),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: const Color.fromRGBO(
                                            255, 253, 228, 1)),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          height: 50,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Monthly Installment",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontFamily: fontFamily,
                                                  fontSize: AppFontSizes.b1,
                                                  fontWeight:
                                                      AppFontWeights.normal,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface,
                                                ),
                                              ),
                                              const SpacerWidget(
                                                height: 5,
                                              ),
                                              Text(
                                                "$index of ${selectedOldOffer.getNumEMIS()}",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontFamily: fontFamily,
                                                  fontSize: AppFontSizes.b1,
                                                  fontWeight:
                                                      AppFontWeights.medium,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 50,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "₹ ${selectedOldOffer.getNumericalValOrDefault(
                                                  selectedOldOffer
                                                      .loanPayments
                                                      .paymentDetails[index]
                                                      .amount,
                                                )}",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontFamily: fontFamily,
                                                  fontSize: AppFontSizes.b1,
                                                  fontWeight:
                                                      AppFontWeights.medium,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface,
                                                ),
                                              ),
                                              const SpacerWidget(
                                                height: 5,
                                              ),
                                              Text(
                                                selectedOldOffer
                                                    .getPaymentStatus(
                                                        selectedOldOffer
                                                            .loanPayments
                                                            .paymentDetails[
                                                                index]
                                                            .status),
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontFamily: fontFamily,
                                                  fontSize: AppFontSizes.b1,
                                                  fontWeight:
                                                      AppFontWeights.normal,
                                                  color: selectedOldOffer
                                                      .getPaymentStatusColor(
                                                          selectedOldOffer
                                                              .loanPayments
                                                              .paymentDetails[
                                                                  index]
                                                              .status),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  selectedOldOffer.loanPayments
                                              .paymentDetails[index].status ==
                                          LoanPaymentStatus.missed
                                      ? GestureDetector(
                                          onTap: () {
                                            HapticFeedback.heavyImpact();
                                            _missedEmiHandler(selectedOldOffer
                                                .loanPayments
                                                .paymentDetails[index]);
                                          },
                                          child: Container(
                                            width: width,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Center(
                                              child: oldLoanStateRef
                                                      .initiatingMissedEmiPayment
                                                  ? Lottie.asset(
                                                      'assets/animations/loading_spinner.json',
                                                      height: 50,
                                                      width: 50)
                                                  : Text(
                                                      "Make Missed EMI Payment",
                                                      style: TextStyle(
                                                        fontFamily: fontFamily,
                                                        fontSize:
                                                            AppFontSizes.b1,
                                                        fontWeight:
                                                            AppFontWeights
                                                                .medium,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onSecondary,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                  const SpacerWidget(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                    const SpacerWidget(
                      height: 45,
                    ),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.heavyImpact();
                        _repayLoanHandler();
                      },
                      child: Container(
                        height: RelativeSize.height(40, height),
                        width: RelativeSize.width(252, width),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            "Continue",
                            style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: AppFontSizes.b1,
                              fontWeight: AppFontWeights.medium,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SpacerWidget(
                      height: 45,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
