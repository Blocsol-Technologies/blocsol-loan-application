import 'package:blocsol_loan_application/invoice_loan/constants/routes/index_router.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/auth/signup/components/animated_circle.dart';
import 'package:blocsol_loan_application/invoice_loan/state/auth/signup/signup.dart';
import 'package:blocsol_loan_application/personal_loan/contants/theme.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignupAccountCreated extends ConsumerStatefulWidget {
  const SignupAccountCreated({super.key});

  @override
  ConsumerState<SignupAccountCreated> createState() =>
      _SignupAccountCreatedState();
}

class _SignupAccountCreatedState extends ConsumerState<SignupAccountCreated> {
  final double _outerCircleDiameter = 250;
  final double _difference = 25;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final signupStateRef = ref.read(signupStateProvider);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Stack(
          children: [
            Positioned(
              top: RelativeSize.height(90, height),
              right: RelativeSize.width(150, width),
              child: Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 1,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
            Positioned(
              top: RelativeSize.height(210, height),
              left: 0,
              child: Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 1,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
            Positioned(
              top: RelativeSize.height(335, height),
              right: RelativeSize.width(55, width),
              child: Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 1,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
            Container(
              height: height,
              width: width,
              padding: EdgeInsets.only(top: RelativeSize.height(48, height)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: RelativeSize.width(20, width)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: "Invoice",
                            style: TextStyle(
                              fontFamily: fontFamily,
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: AppFontSizes.h2,
                              fontWeight: AppFontWeights.bold,
                            ),
                            children: [
                              TextSpan(
                                text: "Pe",
                                style: TextStyle(
                                  fontFamily: fontFamily,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: AppFontSizes.h2,
                                  fontWeight: AppFontWeights.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SpacerWidget(
                    height: 65,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AnimatedCircle(
                        delay: 0,
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromRGBO(0, 72, 103, 0.5),
                            Color.fromRGBO(155, 155, 155, 0)
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        diameter: _outerCircleDiameter,
                        child: AnimatedCircle(
                          delay: 100,
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromRGBO(1, 66, 94, 0.5),
                              Color.fromRGBO(155, 155, 155, 0)
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          diameter: _outerCircleDiameter - _difference,
                          child: AnimatedCircle(
                            delay: 200,
                            gradient: const LinearGradient(
                              colors: [
                                Color.fromRGBO(2, 70, 99, 0.5),
                                Color.fromRGBO(155, 155, 155, 0)
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            diameter: _outerCircleDiameter - (_difference * 2),
                            child: AnimatedCircle(
                              delay: 300,
                              gradient: const LinearGradient(
                                colors: [
                                  Color.fromRGBO(4, 65, 91, 0.5),
                                  Color.fromRGBO(155, 155, 155, 0)
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              diameter:
                                  _outerCircleDiameter - (_difference * 3),
                              child: AnimatedCircle(
                                delay: 400,
                                gradient: const LinearGradient(
                                  colors: [
                                    Color.fromRGBO(21, 86, 113, 0.5),
                                    Color.fromRGBO(155, 155, 155, 0)
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                diameter:
                                    _outerCircleDiameter - (_difference * 4),
                                child: Stack(
                                  children: [
                                    Container(
                                      height: _outerCircleDiameter -
                                          (_difference * 5),
                                      width: _outerCircleDiameter -
                                          (_difference * 5),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          colors: [
                                            Color.fromRGBO(255, 255, 255, 1),
                                            Color.fromRGBO(7, 92, 128, 0.9)
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          signupStateRef
                                                      .companyLegalName.length >
                                                  3
                                              ? signupStateRef.companyLegalName
                                                  .substring(0, 2)
                                                  .toUpperCase()
                                              : "AS",
                                          style: TextStyle(
                                              fontFamily: fontFamily,
                                              fontSize: AppFontSizes.title,
                                              fontWeight: AppFontWeights.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SpacerWidget(
                    height: 60,
                  ),
                  Text(
                    "Account Created",
                    style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: AppFontSizes.h3,
                      fontWeight: AppFontWeights.bold,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  Text(
                    "Successfully",
                    style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: AppFontSizes.h3,
                      fontWeight: AppFontWeights.bold,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  const SpacerWidget(
                    height: 140,
                  ),
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.heavyImpact();
                      context.go(InvoiceLoanIndexRouter.dashboard);
                    },
                    child: Container(
                      height: 35,
                      width: 220,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      child: Center(
                        child: Text(
                          "Continue",
                          style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: AppFontSizes.h3,
                              fontWeight: AppFontWeights.bold,
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
