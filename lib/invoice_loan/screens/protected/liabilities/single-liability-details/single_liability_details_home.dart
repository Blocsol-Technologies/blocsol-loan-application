import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/index_router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/liabilities_router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/support_router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/theme.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/liabilities/foreclosure/foreclose_bottom_sheet.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/loan_events/loan_events.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/server_sent_events/sse.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/liability/single/liability.dart';
import 'package:blocsol_loan_application/invoice_loan/state/support/support.dart';
import 'package:blocsol_loan_application/utils/lender_utils.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:go_router/go_router.dart';

class InvoiceLoanSingleLiabilityDetailsHome extends ConsumerStatefulWidget {
  const InvoiceLoanSingleLiabilityDetailsHome({super.key});

  @override
  ConsumerState<InvoiceLoanSingleLiabilityDetailsHome> createState() =>
      _SingleLiabilityDetailsHomeState();
}

class _SingleLiabilityDetailsHomeState
    extends ConsumerState<InvoiceLoanSingleLiabilityDetailsHome> {
  bool _performingStatusCheck = false;
  final _cancelToken = CancelToken();

  Future<void> _performStatusCheck() async {
    if (_performingStatusCheck) return;

    setState(() {
      _performingStatusCheck = true;
    });

    var response = await ref
        .read(invoiceLoanLiabilityProvider.notifier)
        .performStatusRequest(_cancelToken);

    if (!mounted) return;

    if (!response.success) {
      setState(() {
        _performingStatusCheck = false;
      });

      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        duration: const Duration(seconds: 10),
        content: AwesomeSnackbarContent(
          title: 'Error!',
          message: response.message,
          contentType: ContentType.failure,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
      return;
    }

    await Future.delayed(const Duration(seconds: 10));

    response = await ref
        .read(invoiceLoanLiabilityProvider.notifier)
        .fetchSingleLiabilityDetails(_cancelToken);

    if (!mounted) return;

    setState(() {
      _performingStatusCheck = false;
    });

    if (!response.success) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        duration: const Duration(seconds: 10),
        content: AwesomeSnackbarContent(
          title: 'Error!',
          message: response.message,
          contentType: ContentType.failure,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
      return;
    }

    return;
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
    final oldLoanStateRef = ref.watch(invoiceLoanLiabilityProvider);
    final selectedLiability = oldLoanStateRef.selectedLiability;

    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 20),
            physics: const BouncingScrollPhysics(),
            child: Column(
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
                          context.go(InvoiceLoanIndexRouter.liabilities);
                        },
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 20,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                HapticFeedback.mediumImpact();
                                ref
                                    .read(invoiceLoanSupportProvider.notifier)
                                    .setSupportContext(
                                        selectedLiability
                                            .offerDetails.transactionId,
                                        selectedLiability
                                            .offerDetails.offerProviderId);
                                ref.read(routerProvider).push(
                                    InvoiceLoanSupportRouter.raise_new_ticket);
                              },
                              child: Icon(
                                Icons.support_agent_outlined,
                                size: 20,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            const SpacerWidget(
                              width: 20,
                            ),
                            GestureDetector(
                              onTap: () async {
                                HapticFeedback.mediumImpact();
                                await _performStatusCheck();
                              },
                              child: Container(
                                height: RelativeSize.height(30, height),
                                width: RelativeSize.width(120, width),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    width: 1,
                                  ),
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Text(
                                    "Status Check",
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
                          ],
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
                          selectedLiability.offerDetails.bankName,
                          style: TextStyle(
                            fontFamily: fontFamily,
                            fontSize: AppFontSizes.h1,
                            fontWeight: AppFontWeights.medium,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.center,
                          softWrap: true,
                        ),
                        const SpacerWidget(
                          height: 10,
                        ),
                        Text(
                          selectedLiability.offerDetails.transactionId,
                          style: TextStyle(
                            fontFamily: fontFamily,
                            fontSize: AppFontSizes.b1,
                            fontWeight: AppFontWeights.normal,
                            color: Theme.of(context).colorScheme.onSurface,
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
                  height: 30,
                ),
                _performingStatusCheck
                    ? Container(
                        padding: const EdgeInsets.all(40),
                        height: RelativeSize.height(500, height),
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Lottie.asset(
                                "assets/animations/loading_spinner.json",
                                width: 200,
                                height: 200,
                                fit: BoxFit.contain),
                            const SpacerWidget(
                              height: 20,
                            ),
                            Text(
                              "Refetching loan details...",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: fontFamily,
                                fontSize: AppFontSizes.h3,
                                fontWeight: AppFontWeights.medium,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      )
                    : selectedLiability.offerDetails.disbursementErr
                        ? const LoanDisbursementError()
                        : selectedLiability.offerDetails.isLoanDisbursed()
                            ? const DisbursedLoanDetails()
                            : const LoanNotDisbursed(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoanDisbursementError extends ConsumerWidget {
  const LoanDisbursementError({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(30),
      width: double.infinity,
      height: RelativeSize.height(500, MediaQuery.of(context).size.height),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset("assets/animations/error.json",
              width: 150, height: 150, fit: BoxFit.contain),
          const SpacerWidget(
            height: 20,
          ),
          Text(
            "Disbursement of funds to your bank account failed. Please raise a support ticket to contact the lender and resolve the issue ",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: AppFontSizes.b1,
              fontWeight: AppFontWeights.medium,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SpacerWidget(
            height: 40,
          ),
          GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              ref
                  .read(routerProvider)
                  .push(InvoiceLoanSupportRouter.raise_new_ticket);
            },
            child: Container(
              height: 40,
              width: 150,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Text(
                  "Raise a Support Ticket",
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
        ],
      ),
    );
  }
}

class LoanNotDisbursed extends StatelessWidget {
  const LoanNotDisbursed({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      width: double.infinity,
      height: RelativeSize.height(500, MediaQuery.of(context).size.height),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset("assets/animations/hourglass.json",
              width: 200, height: 200, fit: BoxFit.contain),
          const SpacerWidget(
            height: 30,
          ),
          Text(
            "Waiting for the lender to release the amount to your bank account",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: AppFontSizes.b1,
              fontWeight: AppFontWeights.medium,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          )
        ],
      ),
    );
  }
}

class DisbursedLoanDetails extends ConsumerStatefulWidget {
  const DisbursedLoanDetails({super.key});

  @override
  ConsumerState<DisbursedLoanDetails> createState() =>
      _DisbursedLoanDetailsState();
}

class _DisbursedLoanDetailsState extends ConsumerState<DisbursedLoanDetails> {
  void _handlerAddReminder() {}

  void _handlePrepayClick() {
    ref
        .read(routerProvider)
        .push(InvoiceLoanLiabilitiesRouter.prepayment_amount_selection);
  }

  Future<void> _handleForecloseClick() async {
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
    ref.watch(invoiceLoanEventsProvider);
    ref.watch(invoiceLoanServerSentEventsProvider);

    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: RelativeSize.height(280, height),
          width: width,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Transform.scale(
                  scale: 1.5,
                  child: Container(
                    width: RelativeSize.width(353, width),
                    height: RelativeSize.width(353, width) * 0.62,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            "assets/images/invoice_loan/liabilities/background.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: RelativeSize.width(55, width)),
                child: Column(
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
                              percent: selectedLiability.offerDetails
                                  .getAmountPaidPercentage(),
                              center: SizedBox(
                                height: 100,
                                width: 100,
                                child: getLenderDetailsAssetURL(
                                    selectedLiability.offerDetails.bankName,
                                    selectedLiability.offerDetails.bankLogoURL),
                              ),
                              circularStrokeCap: CircularStrokeCap.round,
                              progressColor:
                                  const Color.fromRGBO(38, 36, 123, 1),
                            ),
                          ),
                        ),
                        const SpacerWidget(
                          width: 25,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Balance Left",
                                style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: AppFontSizes.b1,
                                  fontWeight: AppFontWeights.normal,
                                  color:
                                      Theme.of(context).colorScheme.onTertiary,
                                ),
                              ),
                              const SpacerWidget(
                                height: 15,
                              ),
                              Text(
                                "₹ ${selectedLiability.offerDetails.getBalanceLeft()}",
                                style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: AppFontSizes.h1,
                                  fontWeight: AppFontWeights.medium,
                                  color:
                                      Theme.of(context).colorScheme.onTertiary,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Amount Paid",
                                style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: AppFontSizes.b2,
                                  fontWeight: AppFontWeights.normal,
                                  color:
                                      Theme.of(context).colorScheme.onTertiary,
                                ),
                              ),
                              Text(
                                "₹ ${selectedLiability.offerDetails.getAmountPaid()}",
                                style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: AppFontSizes.h3,
                                  fontWeight: AppFontWeights.medium,
                                  color:
                                      Theme.of(context).colorScheme.onTertiary,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Total Repayment",
                                style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: AppFontSizes.b2,
                                  fontWeight: AppFontWeights.normal,
                                  color:
                                      Theme.of(context).colorScheme.onTertiary,
                                ),
                              ),
                              Text(
                                "₹ ${selectedLiability.offerDetails.totalRepayment}",
                                style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: AppFontSizes.h3,
                                  fontWeight: AppFontWeights.medium,
                                  color:
                                      Theme.of(context).colorScheme.onTertiary,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Next Due Date",
                                style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: AppFontSizes.b2,
                                  fontWeight: AppFontWeights.normal,
                                  color:
                                      Theme.of(context).colorScheme.onTertiary,
                                ),
                              ),
                              Text(
                                selectedLiability.offerDetails.getNextDueDate(),
                                style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: AppFontSizes.h3,
                                  fontWeight: AppFontWeights.medium,
                                  color:
                                      Theme.of(context).colorScheme.onTertiary,
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
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        ref
                            .read(routerProvider)
                            .push(InvoiceLoanLiabilitiesRouter.full_details);
                      },
                      child: Text(
                        "View Details and Documents",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.b1,
                          fontWeight: AppFontWeights.medium,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    const SpacerWidget(
                      height: 18,
                    ),
                    Container(
                      height: 3,
                      width: RelativeSize.width(225, width),
                      color:
                          Theme.of(context).colorScheme.scrim.withOpacity(0.5),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        // Installment Overview
        Container(
          width: width,
          padding:
              EdgeInsets.symmetric(horizontal: RelativeSize.width(55, width)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SpacerWidget(
                height: 10,
              ),
              Text(
                "Installment Overview",
                style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: AppFontSizes.b1,
                  fontWeight: AppFontWeights.medium,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SpacerWidget(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Next Installment",
                    style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: AppFontSizes.b1,
                      fontWeight: AppFontWeights.medium,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    "₹ ${selectedLiability.offerDetails.getNextPayment()}",
                    style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: AppFontSizes.h3,
                      fontWeight: AppFontWeights.medium,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SpacerWidget(
                height: 15,
              ),
              GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  _handlerAddReminder();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_month,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    const SpacerWidget(
                      width: 10,
                    ),
                    Text(
                      "Add a Reminded to the Calender",
                      style: TextStyle(
                        fontFamily: fontFamily,
                        fontSize: AppFontSizes.b2,
                        fontWeight: AppFontWeights.medium,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SpacerWidget(
                height: 18,
              ),
              SizedBox(
                width: width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        ref
                            .read(routerProvider)
                            .push(InvoiceLoanLiabilitiesRouter.payment_history);
                      },
                      child: Text(
                        "View Payments History",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.b1,
                          fontWeight: AppFontWeights.medium,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    const SpacerWidget(
                      height: 18,
                    ),
                    Container(
                      height: 3,
                      width: RelativeSize.width(225, width),
                      color:
                          Theme.of(context).colorScheme.scrim.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SpacerWidget(
          height: 35,
        ),

        selectedLiability.offerDetails.isLoanClosed()
            ? const SizedBox()
            : Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: RelativeSize.width(30, width)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.heavyImpact();
                        _handlePrepayClick();
                      },
                      child: Container(
                        height: RelativeSize.height(40, height),
                        width: RelativeSize.width(150, width),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            "Pay Now",
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
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.heavyImpact();
                        _handleForecloseClick();
                      },
                      child: Container(
                        height: RelativeSize.height(40, height),
                        width: RelativeSize.width(150, width),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            "Foreclose",
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
                  ],
                ),
              ),
      ],
    );
  }
}
