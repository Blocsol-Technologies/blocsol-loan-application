import 'package:blocsol_loan_application/invoice_loan/constants/routes/signup_router.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/auth/signup/components/section_heading.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/auth/signup/components/section_main.dart';
import 'package:blocsol_loan_application/invoice_loan/state/auth/signup/signup.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/theme.dart';
import 'package:blocsol_loan_application/utils/logger.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:go_router/go_router.dart';

class SignupMobileOtpValidation extends ConsumerStatefulWidget {
  const SignupMobileOtpValidation({super.key});

  @override
  ConsumerState<SignupMobileOtpValidation> createState() =>
      _SignupMobileOtpValidationState();
}

class _SignupMobileOtpValidationState
    extends ConsumerState<SignupMobileOtpValidation> with CodeAutoFill {
  final _textController = TextEditingController();
  final _cancelToken = CancelToken();

  bool _otpVerificationError = false;
  String _errMessage = "";

  Future<void> _verifyMobileOTP() async {
    var response = await ref
        .read(invoiceLoanSignupStateProvider.notifier)
        .verifyMobileOTP(_textController.text, _cancelToken);

    if (!mounted) return;

    logFirebaseEvent("invoice_loan_customer_signup", {
      "step": "verify_mobile_otp",
      "phone": ref.read(invoiceLoanSignupStateProvider).phoneNumber,
      "success": response.success,
      "message": response.message,
      "data": response.data ?? {},
    });

    if (response.success) {
      context.go(InvoiceLoanSignupRouter.email_validation);
      return;
    }

    setState(() {
      _otpVerificationError = true;
      _errMessage = response.message;
    });

    return;
  }

  @override
  void codeUpdated() {
    _textController.text = code ?? "";
  }

  @override
  void initState() {
    listenForCode();
    super.initState();
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

    final signupState = ref.read(invoiceLoanSignupStateProvider);

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
                  SectionHeading(
                    subHeading: "Let's Start",
                    heading: "Enter the OTP sent to ${signupState.phoneNumber}",
                  ),
                  const SpacerWidget(
                    height: 50,
                  ),
                  SectionMain(
                    textController: _textController,
                    textInputChild: _otpVerificationError
                        ? Text(
                            _errMessage,
                            textAlign: TextAlign.start,
                            softWrap: true,
                            style: TextStyle(
                                fontFamily: fontFamily,
                                fontSize: AppFontSizes.b1,
                                fontWeight: AppFontWeights.medium,
                                color: Colors.red),
                          )
                        : const SizedBox(),
                    showBackButton: true,
                    maxInputLength: 6,
                    keyboardType: TextInputType.number,
                    hintText: "6-DIGIT OTP",
                    onTextChanged: (val) {
                      setState(() {
                        _otpVerificationError = false;
                      });
                    },
                    isObscure: false,
                    hasErrored: _otpVerificationError,
                    performAction: () async {
                      await _verifyMobileOTP();
                    },
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    gap: 30,
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
