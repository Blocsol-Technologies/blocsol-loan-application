import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/personal_loan/constants/routes/loan_request_router.dart';
import 'package:blocsol_loan_application/personal_loan/constants/theme.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/new_loan/components/timer.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/new_loan/components/top_nav.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/events/loan_events/loan_events.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/events/server_sent_events/sse.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';


class PersonalLoanOnSelect03Error extends ConsumerStatefulWidget {
  const PersonalLoanOnSelect03Error({super.key});

  @override
  ConsumerState<PersonalLoanOnSelect03Error> createState() =>
      _PersonalLoanOnSelect03ErrorState();
}

class _PersonalLoanOnSelect03ErrorState
    extends ConsumerState<PersonalLoanOnSelect03Error> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    ref.watch(personalLoanServerSentEventsProvider);
    ref.watch(personalLoanEventsProvider);

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
              PersonalNewLoanRequestTopNav(
                onBackClick: () {
                  ref.read(routerProvider).pushReplacement(
                      PersonalNewLoanRequestRouter.new_loan_offers_home);
                },
              ),
              const SpacerWidget(height: 35),
              const PersonalNewLoanRequestCountdownTimer(),
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
