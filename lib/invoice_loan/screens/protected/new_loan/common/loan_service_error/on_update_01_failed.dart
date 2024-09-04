import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/index_router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/loan_request_router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/theme.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/components/timer.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/components/top_nav.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/loan_events/loan_events.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/server_sent_events/sse.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class InvoiceLoanOnUpdate01Error extends ConsumerStatefulWidget {
  const InvoiceLoanOnUpdate01Error({super.key});

  @override
  ConsumerState<InvoiceLoanOnUpdate01Error> createState() =>
      _InvoiceLoanOnUpdate01ErrorState();
}

class _InvoiceLoanOnUpdate01ErrorState
    extends ConsumerState<InvoiceLoanOnUpdate01Error> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    ref.watch(invoiceLoanServerSentEventsProvider);
    ref.watch(invoiceLoanEventsProvider);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
              RelativeSize.width(20, width),
              RelativeSize.height(30, height),
              RelativeSize.width(20, width),
              RelativeSize.height(50, height)),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              InvoiceNewLoanRequestTopNav(
                showBackButton: false,
                onBackClick: () {
                  ref.read(routerProvider).pushReplacement(
                      InvoiceNewLoanRequestRouter.single_bank_offer_select);
                },
              ),
              const SpacerWidget(height: 35),
              const InvoiceNewLoanRequestCountdownTimer(),
              const SpacerWidget(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Lottie.asset(
                    'assets/animations/unavailable.json',
                    width: (width - 80),
                  ),
                ],
              ),
              const SpacerWidget(
                height: 40,
              ),
              SizedBox(
                width: width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "The lender is unable to move ahead with your offer selection",
                      style: TextStyle(
                        fontFamily: fontFamily,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: AppFontSizes.heading,
                        fontWeight: AppFontWeights.bold,
                        letterSpacing: 0.14,
                      ),
                      textAlign: TextAlign.start,
                      softWrap: true,
                    ),
                    Text(
                      "We did not get offer acceptance confirmation from the lender",
                      style: TextStyle(
                        fontFamily: fontFamily,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: AppFontSizes.heading,
                        fontWeight: AppFontWeights.bold,
                        letterSpacing: 0.14,
                      ),
                      textAlign: TextAlign.start,
                      softWrap: true,
                    ),
                    const SpacerWidget(
                      height: 5,
                    ),
                    Text(
                      "Choose your next step",
                      style: TextStyle(
                        fontFamily: fontFamily,
                        color: const Color.fromRGBO(130, 130, 130, 1),
                        fontSize: AppFontSizes.h3,
                        fontWeight: AppFontWeights.medium,
                        letterSpacing: 0.14,
                      ),
                      textAlign: TextAlign.start,
                      softWrap: true,
                    ),
                    const SpacerWidget(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () async {
                        HapticFeedback.heavyImpact();
                        ref.read(routerProvider).pushReplacement(
                            InvoiceNewLoanRequestRouter
                                .single_bank_offer_select);
                      },
                      child: Container(
                        height: 40,
                        width: RelativeSize.width(252, width),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).colorScheme.tertiary,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Select Other Offer",
                            style: TextStyle(
                              fontFamily: fontFamily,
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: AppFontSizes.h3,
                              fontWeight: AppFontWeights.bold,
                              letterSpacing: 0.14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SpacerWidget(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.heavyImpact();
                        context.go(InvoiceLoanIndexRouter.dashboard);
                      },
                      child: Container(
                        height: 40,
                        width: RelativeSize.width(252, width),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).colorScheme.surface,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Close Application",
                            style: TextStyle(
                              fontFamily: fontFamily,
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: AppFontSizes.h3,
                              fontWeight: AppFontWeights.bold,
                              letterSpacing: 0.14,
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
      ),
    );
  }
}