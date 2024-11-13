import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/login_router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/signup_router.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/auth/login/components/section_heading.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/auth/login/components/section_main.dart';
import 'package:blocsol_loan_application/invoice_loan/state/auth/login/login.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/theme.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class LoginMobileValidation extends ConsumerStatefulWidget {
  const LoginMobileValidation({super.key});

  @override
  ConsumerState<LoginMobileValidation> createState() =>
      _LoginMobileValidationState();
}

class _LoginMobileValidationState extends ConsumerState<LoginMobileValidation> {
  final _cancelToken = CancelToken();
  final _textController = TextEditingController();

  Future<void> _setPhoneNumber() async {
    ref.read(invoiceLoanLoginProvider.notifier).setPhoneNumber(_textController.text);
    context.go(InvoiceLoanLoginRouter.password);
  }

  @override
  void dispose() {
    _textController.dispose();
    _cancelToken.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final _ = ref.watch(invoiceLoanLoginProvider);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  const SectionHeading(
                    subHeading: "Login to your account",
                    heading: "Tell us your mobile number",
                  ),
                  const SpacerWidget(
                    height: 50,
                  ),
                  SectionMain(
                      textController: _textController,
                      showBackButton: true,
                      textInputChild: GestureDetector(
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          ref.read(routerProvider).push(InvoiceLoanSignupRouter.mobile_validation);
                        },
                        child: Text(
                          "Want to create an account? Signup!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: fontFamily,
                            fontSize: AppFontSizes.b2,
                            fontWeight: AppFontWeights.medium,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ),
                      maxInputLength: 10,
                      keyboardType: TextInputType.number,
                      hintText: "MOBILE NUMBER",
                      onTextChanged: (val) {},
                      isObscure: false,
                      hasErrored: false,
                      performAction: () {
                        _setPhoneNumber();
                      },
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly])
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
