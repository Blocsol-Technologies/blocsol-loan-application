import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/global_state/theme/theme_state.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/index_router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/loan_request_router.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/components/continue_button.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/loan_events/loan_events.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/server_sent_events/sse.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/loan_request.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/state/loan_request_state.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class InvoiceNewLoanRequestDashboard extends ConsumerStatefulWidget {
  const InvoiceNewLoanRequestDashboard({super.key});

  @override
  ConsumerState<InvoiceNewLoanRequestDashboard> createState() =>
      _NewLoanProcessState();
}

class _NewLoanProcessState
    extends ConsumerState<InvoiceNewLoanRequestDashboard> {
  void _performLoanAction() async {
    HapticFeedback.heavyImpact();

    final currentState = ref.read(invoiceNewLoanRequestProvider).currentState;

    switch (currentState) {
      case LoanRequestProgress.started:
        ref
            .read(routerProvider)
            .push(InvoiceNewLoanRequestRouter.fetching_gst_invoices);
        return;
      case LoanRequestProgress.customerDetailsProvided:
        ref
            .read(routerProvider)
            .push(InvoiceNewLoanRequestRouter.loan_offer_select);
        return;
      case LoanRequestProgress.loanOfferSelected:
        ref.read(routerProvider).push(InvoiceNewLoanRequestRouter.aadhar_kyc);
        return;
      case LoanRequestProgress.aadharKycCompleted:
        ref.read(routerProvider).push(InvoiceNewLoanRequestRouter.entity_kyc);
        return;
      case LoanRequestProgress.entityKycCompleted:
        ref
            .read(routerProvider)
            .push(InvoiceNewLoanRequestRouter.bank_account_details);
        return;
      case LoanRequestProgress.bankAccountDetailsProvided:
        ref
            .read(routerProvider)
            .push(InvoiceNewLoanRequestRouter.repayment_setup);
        return;
      case LoanRequestProgress.repaymentSetupCompleted:
        ref
            .read(routerProvider)
            .push(InvoiceNewLoanRequestRouter.loan_agreement);
        return;
      case LoanRequestProgress.loanAgreementCompleted:
        ref
            .read(routerProvider)
            .push(InvoiceNewLoanRequestRouter.final_processing);
        return;
      case LoanRequestProgress.loanStepsCompleted:
        ref
            .read(routerProvider)
            .push(InvoiceNewLoanRequestRouter.final_details);
        return;
      default:
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'On Snap!',
            message: "Invalid State! Contact Support",
            contentType: ContentType.failure,
          ),
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
    final loanStateRef = ref.watch(invoiceNewLoanRequestProvider);
    ref.watch(invoiceLoanServerSentEventsProvider);
    ref.watch(invoiceLoanEventsProvider);
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                    RelativeSize.width(20, width),
                    RelativeSize.height(30, height),
                    RelativeSize.width(20, width),
                    RelativeSize.height(50, height)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                        onTap: () async {
                          HapticFeedback.mediumImpact();
                          context.go(InvoiceLoanIndexRouter.dashboard);
                        },
                        child: Icon(
                          Icons.arrow_back_rounded,
                          size: 20,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                    const SpacerWidget(height: 25),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: RelativeSize.width(15, width)),
                      child: Text(
                        "Loan Process",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.h1,
                          fontWeight: AppFontWeights.extraBold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        softWrap: true,
                      ),
                    ),
                    const SpacerWidget(
                      height: 5,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: RelativeSize.width(15, width)),
                      child: Text(
                        "Online loan application. No document upload needed.",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.b1,
                          fontWeight: AppFontWeights.normal,
                          color: Theme.of(context).colorScheme.onSurface,
                          letterSpacing: 0.14,
                        ),
                        softWrap: true,
                      ),
                    ),
                    const SpacerWidget(
                      height: 22,
                    ),
                    SearchPhase(loanProgressState: loanStateRef.currentState),
                    const SpacerWidget(
                      height: 12,
                    ),
                    SelectOffer(loanProgressState: loanStateRef.currentState),
                    const SpacerWidget(
                      height: 12,
                    ),
                    CompleteKYC(loanProgressState: loanStateRef.currentState),
                    const SpacerWidget(
                      height: 12,
                    ),
                    ShareBankDetails(
                        loanProgressState: loanStateRef.currentState),
                    const SpacerWidget(
                      height: 12,
                    ),
                    RepaymentSetup(
                        loanProgressState: loanStateRef.currentState),
                    const SpacerWidget(
                      height: 12,
                    ),
                    LoanAgreement(loanProgressState: loanStateRef.currentState),
                    const SpacerWidget(
                      height: 12,
                    ),
                    FinalStep(loanProgressState: loanStateRef.currentState),
                    const SpacerWidget(
                      height: 12,
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: RelativeSize.height(75, height),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ContinueButton(
                        onPressed: () {
                          _performLoanAction();
                        },
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SearchPhase extends StatelessWidget {
  final LoanRequestProgress loanProgressState;

  const SearchPhase({super.key, required this.loanProgressState});

  @override
  Widget build(BuildContext context) {
    return loanProgressState.index <
            LoanRequestProgress.customerDetailsProvided.index
        ? Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 20),
            child: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(28, 15, 28, 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Theme.of(context).colorScheme.tertiary,
                    border: Border.all(
                      width: 1,
                      color: const Color.fromRGBO(0, 165, 236, 1),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Request a Loan",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.h3,
                          fontWeight: AppFontWeights.extraBold,
                          color: Theme.of(context).colorScheme.onSurface,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SpacerWidget(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: loanProgressState.index >=
                                      LoanRequestProgress.invoiceSelect.index
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.surface,
                              border: Border.all(
                                width: 1,
                                color: const Color.fromRGBO(0, 165, 236, 1),
                              ),
                            ),
                            child: Center(
                              child: loanProgressState.index >=
                                      LoanRequestProgress.invoiceSelect.index
                                  ? Icon(
                                      Icons.check,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      size: 10,
                                    )
                                  : Text(
                                      "1",
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b1,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.75),
                                      ),
                                    ),
                            ),
                          ),
                          const SpacerWidget(
                            width: 20,
                          ),
                          Text(
                            "Share GST Invoices",
                            style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: AppFontSizes.b1,
                              fontWeight: AppFontWeights.bold,
                              letterSpacing: 0.11,
                              color: loanProgressState.index ==
                                      LoanRequestProgress.started.index
                                  ? const Color.fromRGBO(34, 34, 34, 1)
                                  : loanProgressState.index ==
                                          LoanRequestProgress
                                              .invoiceSelect.index
                                      ? Theme.of(context).colorScheme.primary
                                      : const Color.fromRGBO(144, 144, 144, 1),
                            ),
                          ),
                        ],
                      ),
                      const SpacerWidget(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: loanProgressState.index >=
                                      LoanRequestProgress
                                          .customerDetailsProvided.index
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.surface,
                              border: Border.all(
                                width: 1,
                                color: const Color.fromRGBO(0, 165, 236, 1),
                              ),
                            ),
                            child: Center(
                              child: loanProgressState.index >=
                                      LoanRequestProgress
                                          .customerDetailsProvided.index
                                  ? Icon(
                                      Icons.check,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      size: 10,
                                    )
                                  : Text(
                                      "2",
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b1,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.75),
                                      ),
                                    ),
                            ),
                          ),
                          const SpacerWidget(
                            width: 20,
                          ),
                          Text(
                            "Give consent for bank data",
                            style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: AppFontSizes.b1,
                              fontWeight: AppFontWeights.bold,
                              letterSpacing: 0.11,
                              color: loanProgressState.index ==
                                      LoanRequestProgress.invoiceSelect.index
                                  ? const Color.fromRGBO(34, 34, 34, 1)
                                  : loanProgressState.index >=
                                          LoanRequestProgress
                                              .customerDetailsProvided.index
                                      ? Theme.of(context).colorScheme.primary
                                      : const Color.fromRGBO(144, 144, 144, 1),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: -18,
                  top: 8,
                  child: Container(
                    height: 38,
                    width: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.surface,
                      border: Border.all(
                        width: 1,
                        color: const Color.fromRGBO(0, 115, 165, 1),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "1",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.h3,
                          fontWeight: AppFontWeights.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : InactiveStep(
            step: "Request a Loan",
            stepNumber: "1",
            stepCompleted: loanProgressState.index >=
                LoanRequestProgress.customerDetailsProvided.index,
          );
  }
}

class SelectOffer extends StatelessWidget {
  final LoanRequestProgress loanProgressState;

  const SelectOffer({super.key, required this.loanProgressState});

  @override
  Widget build(BuildContext context) {
    return loanProgressState.index >=
                LoanRequestProgress.customerDetailsProvided.index &&
            loanProgressState.index <
                LoanRequestProgress.loanOfferSelected.index
        ? Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 20),
            child: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(28, 15, 28, 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Theme.of(context).colorScheme.tertiary,
                    border: Border.all(
                      width: 1,
                      color: const Color.fromRGBO(0, 165, 236, 1),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Select Offers",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.h3,
                          fontWeight: AppFontWeights.extraBold,
                          color: Theme.of(context).colorScheme.onSurface,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SpacerWidget(
                        height: 12,
                      ),
                      Text(
                        "Share GST Invoices on which finance is required",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.b1,
                          fontWeight: AppFontWeights.bold,
                          letterSpacing: 0.11,
                          color: loanProgressState.index ==
                                  LoanRequestProgress.started.index
                              ? const Color.fromRGBO(34, 34, 34, 1)
                              : loanProgressState.index ==
                                      LoanRequestProgress.invoiceSelect.index
                                  ? Theme.of(context).colorScheme.primary
                                  : const Color.fromRGBO(144, 144, 144, 1),
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  left: -18,
                  top: 8,
                  child: Container(
                    height: 38,
                    width: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.surface,
                      border: Border.all(
                        width: 1,
                        color: const Color.fromRGBO(0, 115, 165, 1),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "2",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.h3,
                          fontWeight: AppFontWeights.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : InactiveStep(
            step: "Select Offers",
            stepNumber: "2",
            stepCompleted: loanProgressState.index >=
                LoanRequestProgress.customerDetailsProvided.index,
          );
  }
}

class CompleteKYC extends StatelessWidget {
  final LoanRequestProgress loanProgressState;

  const CompleteKYC({super.key, required this.loanProgressState});

  @override
  Widget build(BuildContext context) {
    return loanProgressState.index >=
                LoanRequestProgress.loanOfferSelected.index &&
            loanProgressState.index <
                LoanRequestProgress.entityKycCompleted.index
        ? Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 20),
            child: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(28, 15, 28, 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Theme.of(context).colorScheme.tertiary,
                    border: Border.all(
                      width: 1,
                      color: const Color.fromRGBO(0, 165, 236, 1),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Complete KYC",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.h3,
                          fontWeight: AppFontWeights.extraBold,
                          color: Theme.of(context).colorScheme.onSurface,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SpacerWidget(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: loanProgressState.index >=
                                      LoanRequestProgress
                                          .aadharKycCompleted.index
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.surface,
                              border: Border.all(
                                width: 1,
                                color: const Color.fromRGBO(0, 165, 236, 1),
                              ),
                            ),
                            child: Center(
                              child: loanProgressState.index >=
                                      LoanRequestProgress
                                          .aadharKycCompleted.index
                                  ? Icon(
                                      Icons.check,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      size: 10,
                                    )
                                  : Text(
                                      "1",
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b1,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.75),
                                      ),
                                    ),
                            ),
                          ),
                          const SpacerWidget(
                            width: 20,
                          ),
                          Text(
                            "Aadhar KYC",
                            style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: AppFontSizes.b1,
                              fontWeight: AppFontWeights.bold,
                              letterSpacing: 0.11,
                              color: loanProgressState.index ==
                                      LoanRequestProgress.invoiceSelect.index
                                  ? const Color.fromRGBO(34, 34, 34, 1)
                                  : loanProgressState.index >=
                                          LoanRequestProgress
                                              .aadharKycCompleted.index
                                      ? Theme.of(context).colorScheme.primary
                                      : const Color.fromRGBO(144, 144, 144, 1),
                            ),
                          ),
                        ],
                      ),
                      const SpacerWidget(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: loanProgressState.index >=
                                      LoanRequestProgress
                                          .entityKycCompleted.index
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.surface,
                              border: Border.all(
                                width: 1,
                                color: const Color.fromRGBO(0, 165, 236, 1),
                              ),
                            ),
                            child: Center(
                              child: loanProgressState.index >=
                                      LoanRequestProgress
                                          .entityKycCompleted.index
                                  ? Icon(
                                      Icons.check,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      size: 10,
                                    )
                                  : Text(
                                      "2",
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b1,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.75),
                                      ),
                                    ),
                            ),
                          ),
                          const SpacerWidget(
                            width: 20,
                          ),
                          Text(
                            "Udyam KYC",
                            style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: AppFontSizes.b1,
                              fontWeight: AppFontWeights.bold,
                              letterSpacing: 0.11,
                              color: loanProgressState.index ==
                                      LoanRequestProgress
                                          .aadharKycCompleted.index
                                  ? const Color.fromRGBO(34, 34, 34, 1)
                                  : loanProgressState.index >=
                                          LoanRequestProgress
                                              .entityKycCompleted.index
                                      ? Theme.of(context).colorScheme.primary
                                      : const Color.fromRGBO(144, 144, 144, 1),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: -18,
                  top: 8,
                  child: Container(
                    height: 38,
                    width: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.surface,
                      border: Border.all(
                        width: 1,
                        color: const Color.fromRGBO(0, 115, 165, 1),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "3",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.h3,
                          fontWeight: AppFontWeights.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : InactiveStep(
            step: "Complete KYC",
            stepNumber: "3",
            stepCompleted: loanProgressState.index >=
                LoanRequestProgress.entityKycCompleted.index,
          );
  }
}

class ShareBankDetails extends StatelessWidget {
  final LoanRequestProgress loanProgressState;

  const ShareBankDetails({super.key, required this.loanProgressState});

  @override
  Widget build(BuildContext context) {
    return loanProgressState.index >=
                LoanRequestProgress.entityKycCompleted.index &&
            loanProgressState.index <
                LoanRequestProgress.bankAccountDetailsProvided.index
        ? Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 20),
            child: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(28, 15, 28, 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Theme.of(context).colorScheme.tertiary,
                    border: Border.all(
                      width: 1,
                      color: const Color.fromRGBO(0, 165, 236, 1),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Share Loan Deposit Account",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.h3,
                          fontWeight: AppFontWeights.extraBold,
                          color: Theme.of(context).colorScheme.onSurface,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SpacerWidget(
                        height: 12,
                      ),
                      Text(
                        "Select a deposit account for the loan application",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.b1,
                          fontWeight: AppFontWeights.bold,
                          letterSpacing: 0.11,
                          color: loanProgressState.index ==
                                  LoanRequestProgress.entityKycCompleted.index
                              ? const Color.fromRGBO(34, 34, 34, 1)
                              : loanProgressState.index >=
                                      LoanRequestProgress
                                          .bankAccountDetailsProvided.index
                                  ? Theme.of(context).colorScheme.primary
                                  : const Color.fromRGBO(144, 144, 144, 1),
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  left: -18,
                  top: 8,
                  child: Container(
                    height: 38,
                    width: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.surface,
                      border: Border.all(
                        width: 1,
                        color: const Color.fromRGBO(0, 115, 165, 1),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "4",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.h3,
                          fontWeight: AppFontWeights.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : InactiveStep(
            step: "Share Loan Deposit Account",
            stepNumber: "4",
            stepCompleted: loanProgressState.index >=
                LoanRequestProgress.bankAccountDetailsProvided.index,
          );
  }
}

class RepaymentSetup extends StatelessWidget {
  final LoanRequestProgress loanProgressState;

  const RepaymentSetup({super.key, required this.loanProgressState});

  @override
  Widget build(BuildContext context) {
    return loanProgressState.index >=
                LoanRequestProgress.bankAccountDetailsProvided.index &&
            loanProgressState.index <
                LoanRequestProgress.repaymentSetupCompleted.index
        ? Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 20),
            child: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(28, 15, 28, 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Theme.of(context).colorScheme.tertiary,
                    border: Border.all(
                      width: 1,
                      color: const Color.fromRGBO(0, 165, 236, 1),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Setup Repayment",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.h3,
                          fontWeight: AppFontWeights.extraBold,
                          color: Theme.of(context).colorScheme.onSurface,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SpacerWidget(
                        height: 12,
                      ),
                      Text(
                        "Complete repayment setup for the loan application",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.b1,
                          fontWeight: AppFontWeights.bold,
                          letterSpacing: 0.11,
                          color: loanProgressState.index ==
                                  LoanRequestProgress
                                      .bankAccountDetailsProvided.index
                              ? const Color.fromRGBO(34, 34, 34, 1)
                              : loanProgressState.index >=
                                      LoanRequestProgress
                                          .repaymentSetupCompleted.index
                                  ? Theme.of(context).colorScheme.primary
                                  : const Color.fromRGBO(144, 144, 144, 1),
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  left: -18,
                  top: 8,
                  child: Container(
                    height: 38,
                    width: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.surface,
                      border: Border.all(
                        width: 1,
                        color: const Color.fromRGBO(0, 115, 165, 1),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "5",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.h3,
                          fontWeight: AppFontWeights.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : InactiveStep(
            step: "Setup Repayment",
            stepNumber: "5",
            stepCompleted: loanProgressState.index >=
                LoanRequestProgress.repaymentSetupCompleted.index,
          );
  }
}

class LoanAgreement extends StatelessWidget {
  final LoanRequestProgress loanProgressState;

  const LoanAgreement({super.key, required this.loanProgressState});

  @override
  Widget build(BuildContext context) {
    return loanProgressState.index >=
                LoanRequestProgress.repaymentSetupCompleted.index &&
            loanProgressState.index < LoanRequestProgress.disbursed.index
        ? Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 20),
            child: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(28, 15, 28, 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Theme.of(context).colorScheme.tertiary,
                    border: Border.all(
                      width: 1,
                      color: const Color.fromRGBO(0, 165, 236, 1),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Loan agreement",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.h3,
                          fontWeight: AppFontWeights.extraBold,
                          color: Theme.of(context).colorScheme.onSurface,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SpacerWidget(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: loanProgressState.index >=
                                      LoanRequestProgress
                                          .loanAgreementCompleted.index
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.surface,
                              border: Border.all(
                                width: 1,
                                color: const Color.fromRGBO(0, 165, 236, 1),
                              ),
                            ),
                            child: Center(
                              child: loanProgressState.index >=
                                      LoanRequestProgress
                                          .loanAgreementCompleted.index
                                  ? Icon(
                                      Icons.check,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      size: 10,
                                    )
                                  : Text(
                                      "1",
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b1,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.75),
                                      ),
                                    ),
                            ),
                          ),
                          const SpacerWidget(
                            width: 20,
                          ),
                          Text(
                            "Loan agreement",
                            style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: AppFontSizes.b1,
                              fontWeight: AppFontWeights.bold,
                              letterSpacing: 0.11,
                              color: loanProgressState.index ==
                                      LoanRequestProgress
                                          .repaymentSetupCompleted.index
                                  ? const Color.fromRGBO(34, 34, 34, 1)
                                  : loanProgressState.index >=
                                          LoanRequestProgress
                                              .loanAgreementCompleted.index
                                      ? Theme.of(context).colorScheme.primary
                                      : const Color.fromRGBO(144, 144, 144, 1),
                            ),
                          ),
                        ],
                      ),
                      const SpacerWidget(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: loanProgressState.index >=
                                      LoanRequestProgress
                                          .loanStepsCompleted.index
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.surface,
                              border: Border.all(
                                width: 1,
                                color: const Color.fromRGBO(0, 165, 236, 1),
                              ),
                            ),
                            child: Center(
                              child: loanProgressState.index >=
                                      LoanRequestProgress
                                          .loanStepsCompleted.index
                                  ? Icon(
                                      Icons.check,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      size: 10,
                                    )
                                  : Text(
                                      "2",
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b1,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.75),
                                      ),
                                    ),
                            ),
                          ),
                          const SpacerWidget(
                            width: 20,
                          ),
                          Text(
                            "Provide consent for Monitoring",
                            style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: AppFontSizes.b1,
                              fontWeight: AppFontWeights.bold,
                              letterSpacing: 0.11,
                              color: loanProgressState.index ==
                                      LoanRequestProgress
                                          .loanAgreementCompleted.index
                                  ? const Color.fromRGBO(34, 34, 34, 1)
                                  : loanProgressState.index >=
                                          LoanRequestProgress
                                              .loanStepsCompleted.index
                                      ? Theme.of(context).colorScheme.primary
                                      : const Color.fromRGBO(144, 144, 144, 1),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: -18,
                  top: 8,
                  child: Container(
                    height: 38,
                    width: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.surface,
                      border: Border.all(
                        width: 1,
                        color: const Color.fromRGBO(0, 115, 165, 1),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "6",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.h3,
                          fontWeight: AppFontWeights.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : InactiveStep(
            step: "Loan agreement",
            stepNumber: "6",
            stepCompleted: loanProgressState.index >=
                LoanRequestProgress.loanStepsCompleted.index,
          );
  }
}

class FinalStep extends StatelessWidget {
  final LoanRequestProgress loanProgressState;

  const FinalStep({super.key, required this.loanProgressState});

  @override
  Widget build(BuildContext context) {
    return loanProgressState.index == LoanRequestProgress.disbursed.index
        ? Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 20),
            child: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.surface.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      width: 1,
                      color: const Color.fromRGBO(0, 165, 236, 1),
                    ),
                  ),
                  child: Text(
                    "LOAN DISBURSED",
                    style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: AppFontSizes.b1,
                      fontWeight: AppFontWeights.medium,
                      color: Theme.of(context).colorScheme.onSurface,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                Positioned(
                  left: -18,
                  top: 5,
                  child: Container(
                    height: 38,
                    width: 38,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(0, 115, 165, 1),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.check,
                        color: Theme.of(context).colorScheme.onSurface,
                        size: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 20),
            child: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      width: 1,
                      color: Theme.of(context).colorScheme.scrim,
                    ),
                  ),
                  child: Text(
                    "LOAN SANCTIONED",
                    style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: AppFontSizes.b1,
                      fontWeight: AppFontWeights.medium,
                      color: Theme.of(context).colorScheme.onSurface,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                Positioned(
                  left: -18,
                  top: 5,
                  child: Container(
                    height: 38,
                    width: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.currency_rupee_sharp,
                        color: Theme.of(context).colorScheme.surface,
                        size: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}

class InactiveStep extends StatelessWidget {
  final String step;
  final String stepNumber;
  final bool stepCompleted;

  const InactiveStep(
      {super.key,
      required this.step,
      required this.stepNumber,
      this.stepCompleted = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 20),
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                width: 1,
                color: stepCompleted
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.scrim,
              ),
            ),
            child: Text(
              step,
              style: TextStyle(
                fontFamily: fontFamily,
                fontSize: AppFontSizes.b1,
                fontWeight:
                    stepCompleted ? AppFontWeights.bold : AppFontWeights.medium,
                color: stepCompleted
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                letterSpacing: 0.2,
              ),
            ),
          ),
          Positioned(
            left: -18,
            top: 5,
            child: Container(
              height: 38,
              width: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: stepCompleted
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.scrim,
              ),
              child: Center(
                child: stepCompleted
                    ? Icon(
                        Icons.check,
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 15,
                      )
                    : Text(
                        stepNumber,
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.h3,
                          fontWeight: AppFontWeights.bold,
                          color: Theme.of(context).colorScheme.surface,
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
