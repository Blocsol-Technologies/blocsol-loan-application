import 'package:blocsol_loan_application/choice_screens/components/bottom_decoration.dart';
import 'package:blocsol_loan_application/global_state/internet_check/internet_check.dart';
import 'package:blocsol_loan_application/global_state/misc/misc.dart';
import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/global_state/theme/theme_state.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/signup_router.dart';
import 'package:blocsol_loan_application/personal_loan/constants/routes/signup_router.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupChoice extends ConsumerStatefulWidget {
  const SignupChoice({super.key});

  @override
  ConsumerState<SignupChoice> createState() => _SignupChoiceState();
}

class _SignupChoiceState extends ConsumerState<SignupChoice> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    ref.watch(internetCheckProvider);
    ref.watch(miscProvider);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          height: height,
          width: width,
          padding: EdgeInsets.only(top: RelativeSize.height(70, height)),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.surface,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Let us know your requirement",
                textAlign: TextAlign.center,
                softWrap: true,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: AppFontSizes.title,
                  fontFamily: fontFamily,
                  fontWeight: AppFontWeights.bold,
                ),
              ),
              const SpacerWidget(
                height: 25,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: RelativeSize.width(40, width)),
                child: Text(
                  "Get collateral-free loans in less than 5 minutes.",
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: AppFontSizes.h3,
                    fontFamily: fontFamily,
                    fontWeight: AppFontWeights.medium,
                  ),
                ),
              ),
              const SpacerWidget(
                height: 55,
              ),
              GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  ref
                      .read(routerProvider)
                      .push(InvoiceLoanSignupRouter.mobile_validation);
                },
                child: Container(
                  height: 40,
                  width: RelativeSize.width(280, width),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(0, 115, 165, 1),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Center(
                    child: Text(
                      "GST Invoice Loan",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: AppFontSizes.h3,
                        fontFamily: fontFamily,
                        fontWeight: AppFontWeights.medium,
                      ),
                    ),
                  ),
                ),
              ),
              const SpacerWidget(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  ref.read(routerProvider).push(PersonalLoanSignupRouter.intro);
                },
                child: Container(
                  height: 40,
                  width: RelativeSize.width(280, width),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Center(
                    child: Text(
                      "Personal Loan",
                      style: TextStyle(
                        color: const Color.fromRGBO(0, 115, 165, 1),
                        fontSize: AppFontSizes.h3,
                        fontFamily: fontFamily,
                        fontWeight: AppFontWeights.medium,
                      ),
                    ),
                  ),
                ),
              ),
              const SpacerWidget(
                height: 95,
              ),
              const Expanded(child: SizedBox()),
              const ChoiceScreenBottomDecoration(),
            ],
          ),
        ),
      ),
    );
  }
}
