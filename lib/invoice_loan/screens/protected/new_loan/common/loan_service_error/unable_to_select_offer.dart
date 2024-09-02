import 'package:blocsol_loan_application/global_state/router/router.dart';
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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class InvoiceLoanUnableToSelectOffer extends ConsumerStatefulWidget {
  const InvoiceLoanUnableToSelectOffer({super.key});

  @override
  ConsumerState<InvoiceLoanUnableToSelectOffer> createState() =>
      _InvoiceLoanUnableToSelectOfferState();
}

class _InvoiceLoanUnableToSelectOfferState
    extends ConsumerState<InvoiceLoanUnableToSelectOffer> {
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
                height: 60,
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
                    const SpacerWidget(
                      height: 5,
                    ),
                    Text(
                      "Please pick any other offer",
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
                      height: 5,
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
