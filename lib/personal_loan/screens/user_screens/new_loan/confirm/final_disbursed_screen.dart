import 'package:blocsol_loan_application/invoice_loan/constants/theme.dart';
import 'package:blocsol_loan_application/personal_loan/constants/routes/index_router.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/events/loan_events/loan_events.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/events/server_sent_events/sse.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/new_loan/new_loan.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class PCNewLoanDisbursedScreen extends ConsumerStatefulWidget {
  const PCNewLoanDisbursedScreen({super.key});

  @override
  ConsumerState<PCNewLoanDisbursedScreen> createState() =>
      _PCNewLoanDisbursedScreenState();
}

class _PCNewLoanDisbursedScreenState
    extends ConsumerState<PCNewLoanDisbursedScreen> {
  void _continueClickHandler() async {
    ref.read(personalNewLoanRequestProvider.notifier).reset();
    context.go(PersonalLoanIndexRouter.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final newLoanStateRef = ref.watch(personalNewLoanRequestProvider);
    ref.watch(personalLoanEventsProvider);
    final _ = ref.watch(personalLoanServerSentEventsProvider);
    final selectedOffer = newLoanStateRef.selectedOffer;

    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Theme.of(context).colorScheme.surface,
          bottomNavigationBar: GestureDetector(
            onTap: () {
              _continueClickHandler();
            },
            child: Container(
              height: RelativeSize.height(70, height),
              width: width,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Center(
                child: Text(
                  "Continue",
                  style: TextStyle(
                    fontFamily: fontFamily,
                    fontSize: AppFontSizes.h2,
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: AppFontWeights.bold,
                  ),
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Lottie.asset(
                      "assets/animations/money_growth_person.json",
                      height: 200,
                      width: 250,
                    ),
                  ),
                ),
                const SizedBox(height: 23),
                Text(
                  "Loan Details",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: AppFontSizes.h1,
                    fontWeight: AppFontWeights.extraBold,
                    fontFamily: fontFamily,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 23),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    height: 75,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.2),
                                width: 1))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Status",
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.4),
                            fontSize: AppFontSizes.h3,
                            fontWeight: AppFontWeights.medium,
                            fontFamily: fontFamily,
                            letterSpacing: 0.14,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "Sanctioned",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: AppFontSizes.h3,
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
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    height: 75,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.2),
                                width: 1))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Lender",
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.4),
                            fontSize: AppFontSizes.h3,
                            fontWeight: AppFontWeights.medium,
                            fontFamily: fontFamily,
                            letterSpacing: 0.14,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "₹ ${selectedOffer.deposit}",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: AppFontSizes.h3,
                                fontWeight: AppFontWeights.bold,
                                fontFamily: fontFamily,
                                letterSpacing: 0.165,
                              ),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              selectedOffer.bankName,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.4),
                                fontSize: AppFontSizes.b2,
                                fontWeight: AppFontWeights.normal,
                                fontFamily: fontFamily,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    height: 75,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.2),
                                width: 1))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Total Loan",
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.4),
                            fontSize: AppFontSizes.h3,
                            fontWeight: AppFontWeights.medium,
                            fontFamily: fontFamily,
                            letterSpacing: 0.14,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "₹ ${selectedOffer.deposit}",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: AppFontSizes.h3,
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
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    height: 75,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.2),
                                width: 1))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Deposit Account",
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.4),
                            fontSize: AppFontSizes.h3,
                            fontWeight: AppFontWeights.medium,
                            fontFamily: fontFamily,
                            letterSpacing: 0.14,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              newLoanStateRef.bankAccountNumber,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: AppFontSizes.h3,
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
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    height: 75,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.2),
                                width: 1))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Interest",
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.4),
                            fontSize: AppFontSizes.h3,
                            fontWeight: AppFontWeights.medium,
                            fontFamily: fontFamily,
                            letterSpacing: 0.14,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "₹ ${selectedOffer.interest}",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: AppFontSizes.h3,
                                fontWeight: AppFontWeights.bold,
                                fontFamily: fontFamily,
                                letterSpacing: 0.165,
                              ),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              "@${selectedOffer.interestRate} p.a.",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.4),
                                fontSize: AppFontSizes.b2,
                                fontWeight: AppFontWeights.normal,
                                fontFamily: fontFamily,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    height: 75,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.2),
                                width: 1))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Total Repayment",
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.4),
                            fontSize: AppFontSizes.h3,
                            fontWeight: AppFontWeights.medium,
                            fontFamily: fontFamily,
                            letterSpacing: 0.14,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "₹ ${selectedOffer.totalRepaymentAmount}",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: AppFontSizes.h3,
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
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    height: 75,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.2),
                                width: 1))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Due Date",
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.4),
                            fontSize: AppFontSizes.h3,
                            fontWeight: AppFontWeights.medium,
                            fontFamily: fontFamily,
                            letterSpacing: 0.14,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              selectedOffer.tenure,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: AppFontSizes.h3,
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
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    height: 75,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.2),
                                width: 1))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Loan ID",
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.4),
                            fontSize: AppFontSizes.h3,
                            fontWeight: AppFontWeights.medium,
                            fontFamily: fontFamily,
                            letterSpacing: 0.14,
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                newLoanStateRef.selectedOffer.transactionId,
                                softWrap: true,
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontSize: AppFontSizes.h3,
                                  fontWeight: AppFontWeights.bold,
                                  fontFamily: fontFamily,
                                  letterSpacing: 0.165,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
