import 'package:blocsol_loan_application/global_state/theme/theme_state.dart';
import 'package:blocsol_loan_application/personal_loan/constants/routes/index_router.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/new_loan/components/top_nav.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class PersonalLoanServiceUnavailable extends ConsumerStatefulWidget {
  final String message;
  const PersonalLoanServiceUnavailable({super.key, required this.message});

  @override
  ConsumerState<PersonalLoanServiceUnavailable> createState() =>
      _PersonalLoanServiceUnavailableScreenState();
}

class _PersonalLoanServiceUnavailableScreenState
    extends ConsumerState<PersonalLoanServiceUnavailable> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return PopScope(
        canPop: false,
        child: SafeArea(
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
                    showBackButton: false,
                    onBackClick: () {},
                  ),
                  const SpacerWidget(height: 35),
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
                          "Lender is unable to process the application online at the moment",
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
                          "We will take your application to the lender manually and notify you of the update",
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
                          onTap: () {
                            HapticFeedback.heavyImpact();
                            context.go(PersonalLoanIndexRouter.dashboard);
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
                                "Go Back",
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
        ));
  }
}
