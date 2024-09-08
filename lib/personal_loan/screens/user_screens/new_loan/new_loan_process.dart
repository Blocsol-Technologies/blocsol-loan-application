import 'package:blocsol_loan_application/invoice_loan/constants/theme.dart';
import 'package:blocsol_loan_application/personal_loan/constants/routes/index_router.dart';
import 'package:blocsol_loan_application/personal_loan/constants/routes/loan_request_router.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/new_loan/components/top_nav.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/events/loan_events/loan_events.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/events/server_sent_events/sse.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/new_loan/new_loan.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/new_loan/state/new_loan_state.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/snackbar_notifications/util.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PCNewLoanProcessScreen extends ConsumerStatefulWidget {
  const PCNewLoanProcessScreen({super.key});

  @override
  ConsumerState<PCNewLoanProcessScreen> createState() =>
      _PCNewLoanProcessScreenState();
}

class _PCNewLoanProcessScreenState
    extends ConsumerState<PCNewLoanProcessScreen> {

  void _performLoanAction() async {
    HapticFeedback.heavyImpact();

    final currentState = ref.read(personalNewLoanRequestProvider).currentState;

    switch (currentState) {
      case PersonalLoanRequestProgress.started:
        context.go(PersonalNewLoanRequestRouter.new_loan_data_consent);
        break;
      case PersonalLoanRequestProgress.formGenerated:
        context
            .go(PersonalNewLoanRequestRouter.new_loan_generate_offers_and_aa_consent);
        break;
      case PersonalLoanRequestProgress.bankConsent:
        context.go(PersonalNewLoanRequestRouter.new_loan_offers_home);
        break;
      case PersonalLoanRequestProgress.loanOfferSelect:
        context.go(PersonalNewLoanRequestRouter.new_loan_aadhar_kyc_webview);
        break;
      case PersonalLoanRequestProgress.aadharKYC:
        context.go(PersonalNewLoanRequestRouter.new_loan_share_bank_details);
        break;

      case PersonalLoanRequestProgress.bankAccountDetails:
        context.go(PersonalNewLoanRequestRouter.new_loan_repayment_setup);
        break;
      case PersonalLoanRequestProgress.repaymentSetup:
        context.go(PersonalNewLoanRequestRouter.new_loan_agreement);
        break;
      case PersonalLoanRequestProgress.loanAgreement:
        context
            .go(PersonalNewLoanRequestRouter.new_loan_final_processing_screen);
        break;
      case PersonalLoanRequestProgress.monitoringConsent:
        context
            .go(PersonalNewLoanRequestRouter.new_loan_final_disbursed_screen);
        break;
      default:
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: getSnackbarNotificationWidget(
              message: "Invalid State. Contact Support",
              notifType: SnackbarNotificationType.error),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final loanStateRef = ref.watch(personalNewLoanRequestProvider);
    ref.watch(personalLoanServerSentEventsProvider);
    ref.watch(personalLoanEventsProvider);

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
                  height: RelativeSize.height(258, height),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: RelativeSize.height(20, height)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: RelativeSize.width(30, width)),
                        child: PersonalNewLoanRequestTopNav(
                            onBackClick: () {
                              context.go(PersonalLoanIndexRouter.dashboard);
                            }),
                      ),
                      const SpacerWidget(
                        height: 30,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: RelativeSize.width(30, width)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Loan Process",
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
                              "One-time registration. Online loan application. No document upload needed.",
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
                      const SpacerWidget(
                        height: 30,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: RelativeSize.width(30, width)),
                        child: _SharePersonalDetails(
                            loanProgressState: loanStateRef.currentState),
                      ),
                      const SpacerWidget(
                        height: 12,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: RelativeSize.width(30, width)),
                        child: _SelectOffer(
                            loanProgressState: loanStateRef.currentState),
                      ),
                      const SpacerWidget(
                        height: 12,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: RelativeSize.width(30, width)),
                        child: _CompleteKYC(
                            loanProgressState: loanStateRef.currentState),
                      ),
                      const SpacerWidget(
                        height: 12,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: RelativeSize.width(30, width)),
                        child: _BankAccount(
                            loanProgressState: loanStateRef.currentState),
                      ),
                      const SpacerWidget(
                        height: 12,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: RelativeSize.width(30, width)),
                        child: _RepaymentSetup(
                            loanProgressState: loanStateRef.currentState),
                      ),
                      const SpacerWidget(
                        height: 12,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: RelativeSize.width(30, width)),
                        child: _LoanAgreement(
                            loanProgressState: loanStateRef.currentState),
                      ),
                      const SpacerWidget(
                        height: 12,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: RelativeSize.width(30, width)),
                        child: _LoanDisbursed(
                            loanProgressState: loanStateRef.currentState),
                      ),
                      const SpacerWidget(
                        height: 35,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.heavyImpact();
                              _performLoanAction();
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
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                            ),
                          )
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

class _SharePersonalDetails extends StatelessWidget {
  final PersonalLoanRequestProgress loanProgressState;

  const _SharePersonalDetails({required this.loanProgressState});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return loanProgressState.index <
            PersonalLoanRequestProgress.bankConsent.index
        ? Container(
            width: double.infinity,
            padding: EdgeInsets.only(left: RelativeSize.width(20, width)),
            child: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(
                      RelativeSize.width(28, width),
                      RelativeSize.height(15, height),
                      RelativeSize.width(28, width),
                      RelativeSize.height(20, height)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withOpacity(0.2),
                    border: Border.all(
                      width: 1,
                      color: Theme.of(context).colorScheme.primaryContainer,
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
                          color: Theme.of(context).colorScheme.onPrimary,
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
                                      PersonalLoanRequestProgress
                                          .formGenerated.index
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primaryContainer
                                  : Theme.of(context).colorScheme.surface,
                              border: Border.all(
                                width: 1,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                              ),
                            ),
                            child: Center(
                              child: loanProgressState.index >=
                                      PersonalLoanRequestProgress
                                          .formGenerated.index
                                  ? Icon(
                                      Icons.check,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
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
                            "Share Personal Details",
                            style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: AppFontSizes.b1,
                              fontWeight: AppFontWeights.bold,
                              letterSpacing: 0.21,
                              color: loanProgressState.index ==
                                      PersonalLoanRequestProgress.started.index
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : loanProgressState.index ==
                                          PersonalLoanRequestProgress
                                              .formGenerated.index
                                      ? Theme.of(context).colorScheme.onPrimary
                                      : const Color.fromRGBO(144, 144, 144, 1),
                            ),
                          ),
                        ],
                      ),
                      const SpacerWidget(
                        height: 15,
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
                                      PersonalLoanRequestProgress
                                          .bankConsent.index
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primaryContainer
                                  : Theme.of(context).colorScheme.surface,
                              border: Border.all(
                                width: 1,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                              ),
                            ),
                            child: Center(
                              child: loanProgressState.index >=
                                      PersonalLoanRequestProgress
                                          .bankConsent.index
                                  ? Icon(
                                      Icons.check,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
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
                              letterSpacing: 0.21,
                              color: loanProgressState.index ==
                                      PersonalLoanRequestProgress
                                          .formGenerated.index
                                  ? const Color.fromRGBO(34, 34, 34, 1)
                                  : loanProgressState.index >=
                                          PersonalLoanRequestProgress
                                              .bankConsent.index
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
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.surface,
                      border: Border.all(
                        width: 1,
                        color: Theme.of(context).colorScheme.primaryContainer,
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
        : Container(
            width: double.infinity,
            padding: EdgeInsets.only(left: RelativeSize.width(20, width)),
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
                    "Request a Loan",
                    style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: AppFontSizes.b1,
                      fontWeight: loanProgressState.index >=
                              PersonalLoanRequestProgress.bankConsent.index
                          ? AppFontWeights.bold
                          : AppFontWeights.medium,
                      color: loanProgressState.index >=
                              PersonalLoanRequestProgress.bankConsent.index
                          ? Theme.of(context).colorScheme.surface
                          : Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.7),
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                Positioned(
                  left: -18,
                  top: 5,
                  child: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: loanProgressState.index >=
                              PersonalLoanRequestProgress.bankConsent.index
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Theme.of(context).colorScheme.scrim,
                    ),
                    child: Center(
                      child: loanProgressState.index >=
                              PersonalLoanRequestProgress.bankConsent.index
                          ? Icon(
                              Icons.check,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                              size: 15,
                            )
                          : Text(
                              "1",
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

class _SelectOffer extends StatelessWidget {
  final PersonalLoanRequestProgress loanProgressState;

  const _SelectOffer({required this.loanProgressState});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return loanProgressState.index >=
                PersonalLoanRequestProgress.bankConsent.index &&
            loanProgressState.index <
                PersonalLoanRequestProgress.loanOfferSelect.index
        ? Container(
            width: double.infinity,
            padding: EdgeInsets.only(left: RelativeSize.width(20, width)),
            child: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(
                      RelativeSize.width(28, width),
                      RelativeSize.height(15, height),
                      RelativeSize.width(28, width),
                      RelativeSize.height(20, height)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withOpacity(0.2),
                    border: Border.all(
                      width: 1,
                      color: Theme.of(context).colorScheme.primaryContainer,
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
                          color: Theme.of(context).colorScheme.surface,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SpacerWidget(
                        height: 12,
                      ),
                      Text(
                        "Select Loan offer from Lender",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.b1,
                          fontWeight: AppFontWeights.bold,
                          letterSpacing: 0.21,
                          color: loanProgressState.index ==
                                  PersonalLoanRequestProgress.started.index
                              ? const Color.fromRGBO(34, 34, 34, 1)
                              : loanProgressState.index ==
                                      PersonalLoanRequestProgress
                                          .formGenerated.index
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
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.surface,
                      border: Border.all(
                        width: 1,
                        color: Theme.of(context).colorScheme.primaryContainer,
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
        : Container(
            width: double.infinity,
            padding: EdgeInsets.only(left: RelativeSize.width(20, width)),
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
                    "Select Offer",
                    style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: AppFontSizes.b1,
                      fontWeight: loanProgressState.index >=
                              PersonalLoanRequestProgress.loanOfferSelect.index
                          ? AppFontWeights.bold
                          : AppFontWeights.medium,
                      color: loanProgressState.index >=
                              PersonalLoanRequestProgress.loanOfferSelect.index
                          ? Theme.of(context).colorScheme.surface
                          : Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.7),
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                Positioned(
                  left: -18,
                  top: 5,
                  child: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: loanProgressState.index >=
                              PersonalLoanRequestProgress.loanOfferSelect.index
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Theme.of(context).colorScheme.scrim,
                    ),
                    child: Center(
                      child: loanProgressState.index >=
                              PersonalLoanRequestProgress.loanOfferSelect.index
                          ? Icon(
                              Icons.check,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                              size: 15,
                            )
                          : Text(
                              "2",
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

class _CompleteKYC extends StatelessWidget {
  final PersonalLoanRequestProgress loanProgressState;

  const _CompleteKYC({required this.loanProgressState});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return loanProgressState.index >=
                PersonalLoanRequestProgress.loanOfferSelect.index &&
            loanProgressState.index <
                PersonalLoanRequestProgress.aadharKYC.index
        ? Container(
            width: double.infinity,
            padding: EdgeInsets.only(left: RelativeSize.width(20, width)),
            child: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(
                      RelativeSize.width(28, width),
                      RelativeSize.height(15, height),
                      RelativeSize.width(28, width),
                      RelativeSize.height(20, height)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withOpacity(0.2),
                    border: Border.all(
                      width: 1,
                      color: Theme.of(context).colorScheme.primaryContainer,
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
                                      PersonalLoanRequestProgress
                                          .aadharKYC.index
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primaryContainer
                                  : Theme.of(context).colorScheme.surface,
                              border: Border.all(
                                width: 1,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                              ),
                            ),
                            child: Center(
                              child: loanProgressState.index >=
                                      PersonalLoanRequestProgress
                                          .aadharKYC.index
                                  ? Icon(
                                      Icons.check,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
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
                              letterSpacing: 0.21,
                              color: loanProgressState.index ==
                                      PersonalLoanRequestProgress
                                          .formGenerated.index
                                  ? const Color.fromRGBO(34, 34, 34, 1)
                                  : loanProgressState.index >=
                                          PersonalLoanRequestProgress
                                              .aadharKYC.index
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
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.surface,
                      border: Border.all(
                        width: 1,
                        color: Theme.of(context).colorScheme.primaryContainer,
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
        : _InactiveStep(
            step: "Complete KYC",
            stepNumber: "3",
            stepCompleted: loanProgressState.index >=
                PersonalLoanRequestProgress.aadharKYC.index,
          );
  }
}

class _BankAccount extends StatelessWidget {
  final PersonalLoanRequestProgress loanProgressState;

  const _BankAccount({required this.loanProgressState});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return loanProgressState.index >=
                PersonalLoanRequestProgress.aadharKYC.index &&
            loanProgressState.index <
                PersonalLoanRequestProgress.bankAccountDetails.index
        ? Container(
            width: double.infinity,
            padding: EdgeInsets.only(left: RelativeSize.width(20, width)),
            child: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(
                      RelativeSize.width(28, width),
                      RelativeSize.height(15, height),
                      RelativeSize.width(28, width),
                      RelativeSize.height(20, height)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withOpacity(0.2),
                    border: Border.all(
                      width: 1,
                      color: Theme.of(context).colorScheme.primaryContainer,
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
                          letterSpacing: 0.21,
                          color: loanProgressState.index ==
                                  PersonalLoanRequestProgress
                                      .bankAccountDetails.index
                              ? const Color.fromRGBO(34, 34, 34, 1)
                              : loanProgressState.index >=
                                      PersonalLoanRequestProgress
                                          .bankAccountDetails.index
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
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.surface,
                      border: Border.all(
                        width: 1,
                        color: Theme.of(context).colorScheme.primaryContainer,
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
        : _InactiveStep(
            step: "Share Loan Deposit Account",
            stepNumber: "4",
            stepCompleted: loanProgressState.index >=
                PersonalLoanRequestProgress.bankAccountDetails.index,
          );
  }
}

class _RepaymentSetup extends StatelessWidget {
  final PersonalLoanRequestProgress loanProgressState;

  const _RepaymentSetup({required this.loanProgressState});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return loanProgressState.index >=
                PersonalLoanRequestProgress.bankAccountDetails.index &&
            loanProgressState.index <
                PersonalLoanRequestProgress.repaymentSetup.index
        ? Container(
            width: double.infinity,
            padding: EdgeInsets.only(left: RelativeSize.width(20, width)),
            child: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(
                      RelativeSize.width(28, width),
                      RelativeSize.height(15, height),
                      RelativeSize.width(28, width),
                      RelativeSize.height(20, height)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withOpacity(0.2),
                    border: Border.all(
                      width: 1,
                      color: Theme.of(context).colorScheme.primaryContainer,
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
                          letterSpacing: 0.21,
                          color: loanProgressState.index ==
                                  PersonalLoanRequestProgress
                                      .bankAccountDetails.index
                              ? const Color.fromRGBO(34, 34, 34, 1)
                              : loanProgressState.index >=
                                      PersonalLoanRequestProgress
                                          .repaymentSetup.index
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
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.surface,
                      border: Border.all(
                        width: 1,
                        color: Theme.of(context).colorScheme.primaryContainer,
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
        : _InactiveStep(
            step: "Setup Repayment",
            stepNumber: "5",
            stepCompleted: loanProgressState.index >=
                PersonalLoanRequestProgress.repaymentSetup.index,
          );
  }
}

class _LoanAgreement extends StatelessWidget {
  final PersonalLoanRequestProgress loanProgressState;

  const _LoanAgreement({required this.loanProgressState});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return loanProgressState.index >=
                PersonalLoanRequestProgress.repaymentSetup.index &&
            loanProgressState.index <
                PersonalLoanRequestProgress.disbursed.index
        ? Container(
            width: double.infinity,
            padding: EdgeInsets.only(left: RelativeSize.width(20, width)),
            child: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(
                      RelativeSize.width(28, width),
                      RelativeSize.height(15, height),
                      RelativeSize.width(28, width),
                      RelativeSize.height(20, height)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withOpacity(0.2),
                    border: Border.all(
                      width: 1,
                      color: Theme.of(context).colorScheme.primaryContainer,
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
                                      PersonalLoanRequestProgress
                                          .loanAgreement.index
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primaryContainer
                                  : Theme.of(context).colorScheme.surface,
                              border: Border.all(
                                width: 1,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                              ),
                            ),
                            child: Center(
                              child: loanProgressState.index >=
                                      PersonalLoanRequestProgress
                                          .loanAgreement.index
                                  ? Icon(
                                      Icons.check,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
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
                              letterSpacing: 0.21,
                              color: loanProgressState.index ==
                                      PersonalLoanRequestProgress
                                          .repaymentSetup.index
                                  ? const Color.fromRGBO(34, 34, 34, 1)
                                  : loanProgressState.index >=
                                          PersonalLoanRequestProgress
                                              .loanAgreement.index
                                      ? Theme.of(context).colorScheme.primary
                                      : const Color.fromRGBO(144, 144, 144, 1),
                            ),
                          ),
                        ],
                      ),
                      const SpacerWidget(
                        height: 15,
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
                                      PersonalLoanRequestProgress
                                          .monitoringConsent.index
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primaryContainer
                                  : Theme.of(context).colorScheme.surface,
                              border: Border.all(
                                width: 1,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                              ),
                            ),
                            child: Center(
                              child: loanProgressState.index >=
                                      PersonalLoanRequestProgress
                                          .monitoringConsent.index
                                  ? Icon(
                                      Icons.check,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
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
                          Expanded(
                            child: Text(
                              "Provide consent for Monitoring",
                              softWrap: true,
                              style: TextStyle(
                                fontFamily: fontFamily,
                                fontSize: AppFontSizes.b1,
                                fontWeight: AppFontWeights.bold,
                                letterSpacing: 0.21,
                                color: loanProgressState.index ==
                                        PersonalLoanRequestProgress
                                            .loanAgreement.index
                                    ? const Color.fromRGBO(34, 34, 34, 1)
                                    : loanProgressState.index >=
                                            PersonalLoanRequestProgress
                                                .monitoringConsent.index
                                        ? Theme.of(context).colorScheme.primary
                                        : const Color.fromRGBO(
                                            144, 144, 144, 1),
                              ),
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
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.surface,
                      border: Border.all(
                        width: 1,
                        color: Theme.of(context).colorScheme.primaryContainer,
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
        : _InactiveStep(
            step: "Loan agreement",
            stepNumber: "6",
            stepCompleted: loanProgressState.index >=
                PersonalLoanRequestProgress.monitoringConsent.index,
          );
  }
}

class _LoanDisbursed extends StatelessWidget {
  final PersonalLoanRequestProgress loanProgressState;

  const _LoanDisbursed({required this.loanProgressState});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return loanProgressState.index ==
            PersonalLoanRequestProgress.disbursed.index
        ? Container(
            width: double.infinity,
            padding: EdgeInsets.only(left: RelativeSize.width(20, width)),
            child: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                      horizontal: RelativeSize.width(30, width),
                      vertical: RelativeSize.height(15, height)),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withOpacity(0.8),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      width: 1,
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                  ),
                  child: Text(
                    "LOAN SANCTIONED",
                    style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: AppFontSizes.b1,
                      fontWeight: AppFontWeights.medium,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                Positioned(
                  left: -18,
                  top: 5,
                  child: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.primaryContainer),
                    child: Center(
                      child: Icon(
                        Icons.check,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
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
            padding: EdgeInsets.only(left: RelativeSize.width(20, width)),
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
                    height: 35,
                    width: 35,
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

class _InactiveStep extends StatelessWidget {
  final String step;
  final String stepNumber;
  final bool stepCompleted;

  const _InactiveStep(
      {required this.step,
      required this.stepNumber,
      this.stepCompleted = false});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: RelativeSize.width(20, width)),
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
                color: Theme.of(context).colorScheme.scrim,
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
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: stepCompleted
                    ? Theme.of(context).colorScheme.primaryContainer
                    : Theme.of(context).colorScheme.scrim,
              ),
              child: Center(
                child: stepCompleted
                    ? Icon(
                        Icons.check,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
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
