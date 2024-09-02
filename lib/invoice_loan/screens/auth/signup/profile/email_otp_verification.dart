import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/signup_router.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/auth/signup/components/section_heading.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/auth/signup/components/section_main.dart';
import 'package:blocsol_loan_application/invoice_loan/state/auth/signup/signup.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/theme.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignupEmailOtpValidation extends ConsumerStatefulWidget {
  const SignupEmailOtpValidation({super.key});

  @override
  ConsumerState<SignupEmailOtpValidation> createState() =>
      _SignupEmailOtpValidationState();
}

class _SignupEmailOtpValidationState
    extends ConsumerState<SignupEmailOtpValidation> {
  final _textController = TextEditingController();
  final _cancelToken = CancelToken();

  bool _otpVerificationError = false;

  Future<void> _verifyEmailOTP() async {
    var response = await ref
        .read(signupStateProvider.notifier)
        .verifyEmailOTP(_textController.text, _cancelToken);

    if (!mounted) return;

    if (response.success) {
      context.go(InvoiceLoanSignupRouter.gst_validation);
      return;
    }

    setState(() {
      _otpVerificationError = true;
    });

    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Error!',
        message: response.message,
        contentType: ContentType.failure,
      ),
      duration: const Duration(seconds: 5),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);

    return;
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
    final signupStateRef = ref.read(signupStateProvider);
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
                    headingWidth: 300,
                    subHeading: "Let's Start",
                    heading: "Enter the OTP sent to ${signupStateRef.email}",
                  ),
                  const SpacerWidget(
                    height: 50,
                  ),
                  SectionMain(
                    textController: _textController,
                    textInputChild: const SizedBox(),
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
                      await _verifyEmailOTP();
                    },
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
