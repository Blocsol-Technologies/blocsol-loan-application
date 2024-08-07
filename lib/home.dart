import 'package:blocsol_loan_application/global_state/theme/theme_state.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/index_router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/login_router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/signup_router.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Container(
          height: height,
          width: width,
          padding: EdgeInsets.fromLTRB(
              RelativeSize.width(20, width),
              RelativeSize.height(20, height),
              RelativeSize.width(20, width),
              RelativeSize.height(40, height)),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: "INVOICE ",
                      style: TextStyle(
                        fontFamily: fontFamily,
                        color: const Color.fromRGBO(38, 36, 123, 1),
                        fontSize: AppFontSizes.h2,
                        fontWeight: AppFontWeights.bold,
                      ),
                      children: [
                        TextSpan(
                          text: "PE ",
                          style: TextStyle(
                            fontFamily: fontFamily,
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: AppFontSizes.h2,
                            fontWeight: AppFontWeights.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Expanded(
                    child: SizedBox(),
                  ),
                  Text(
                    "Welcome to",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontFamily: fontFamily,
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: AppFontSizes.title,
                      fontWeight: AppFontWeights.medium,
                    ),
                  ),
                  Text(
                    "InvoicePe!",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontFamily: fontFamily,
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: AppFontSizes.title,
                      fontWeight: AppFontWeights.medium,
                    ),
                  ),
                  const SpacerWidget(
                    height: 15,
                  ),
                  Text(
                    "Get Your Invoices Funded ",
                    style: TextStyle(
                      fontFamily: fontFamily,
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimary
                          .withOpacity(0.7),
                      fontSize: AppFontSizes.h1,
                      fontWeight: AppFontWeights.normal,
                    ),
                  ),
                  Text(
                    "Instantly ",
                    style: TextStyle(
                      fontFamily: fontFamily,
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimary
                          .withOpacity(0.7),
                      fontSize: AppFontSizes.h1,
                      fontWeight: AppFontWeights.normal,
                    ),
                  ),
                  const SpacerWidget(
                    height: 75,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: RelativeSize.width(115, width),
                        height: RelativeSize.height(55, height),
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(
                            right: RelativeSize.width(15, width)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const ActionButton(),
                            const Expanded(child: SizedBox()),
                            Container(
                              width: RelativeSize.width(115, width),
                              height: 1,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            const SpacerWidget(
                              height: 5,
                            ),
                            Container(
                              width: RelativeSize.width(115, width),
                              height: 1,
                              color: Theme.of(context).colorScheme.onPrimary,
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Positioned(
                top: RelativeSize.height(140, height),
                left: RelativeSize.width(40, width),
                child: Container(
                  width: 40,
                  height: 40,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Positioned(
                top: RelativeSize.height(160, height),
                left: RelativeSize.width(8, width),
                child: Container(
                  width: 40,
                  height: 40,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Positioned(
                top: RelativeSize.height(179, height),
                left: RelativeSize.width(85, width),
                child: Container(
                  width: 40,
                  height: 40,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Positioned(
                top: RelativeSize.height(200, height),
                left: RelativeSize.width(55, width),
                child: Container(
                  width: 40,
                  height: 40,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Positioned(
                top: RelativeSize.height(45, height),
                right: RelativeSize.width(35, width),
                child: Container(
                  width: 40,
                  height: 40,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Positioned(
                top: RelativeSize.height(65, height),
                right: RelativeSize.width(58, width),
                child: Container(
                  width: 40,
                  height: 40,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Positioned(
                top: RelativeSize.height(90, height),
                left: RelativeSize.width(20, width),
                child: Container(
                  width: 1,
                  height: RelativeSize.height(200, height),
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              Positioned(
                top: RelativeSize.height(90, height),
                left: RelativeSize.width(30, width),
                child: Container(
                  width: 1,
                  height: RelativeSize.height(200, height),
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ActionButton extends ConsumerStatefulWidget {
  const ActionButton({super.key});

  @override
  ConsumerState<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends ConsumerState<ActionButton> {
  bool _isPressed = false;

  void _continueClickHandler() async {
    if (_isPressed) return;

    setState(() {
      _isPressed = !_isPressed;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    context.go(InvoiceLoanLoginRouter.mobile_auth);
    return;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        HapticFeedback.heavyImpact();
        _continueClickHandler();
      },
      child: Stack(
        children: [
          Container(
            width: RelativeSize.width(100, width),
            height: RelativeSize.height(40, height),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: _isPressed ? RelativeSize.width(100, width) : 0,
            height: RelativeSize.height(40, height),
            decoration: BoxDecoration(
              color: _isPressed
                  ? Theme.of(context).colorScheme.surface
                  : Theme.of(context).colorScheme.onSurface,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(
            width: RelativeSize.width(100, width),
            height: RelativeSize.height(40, height),
            child: Center(
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 500),
                style: TextStyle(
                    color: _isPressed
                        ? Theme.of(context).colorScheme.onSurface
                        : Theme.of(context).colorScheme.surface,
                    fontSize: AppFontSizes.h3,
                    fontFamily: fontFamily,
                    fontWeight: AppFontWeights.normal),
                child: Text('Continue',
                    style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: AppFontSizes.h3,
                      fontWeight: AppFontWeights.medium,
                    )),
              ),
            ),
          )
        ],
      ),
    );
  }
}
