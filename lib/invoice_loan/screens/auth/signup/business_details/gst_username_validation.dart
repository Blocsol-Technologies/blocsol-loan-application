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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignupGstUsernameValidation extends ConsumerStatefulWidget {
  const SignupGstUsernameValidation({super.key});

  @override
  ConsumerState<SignupGstUsernameValidation> createState() =>
      _SignupGstUsernameValidationState();
}

class _SignupGstUsernameValidationState
    extends ConsumerState<SignupGstUsernameValidation> {
  final _textController = TextEditingController();
  final _cancelToken = CancelToken();

  bool _isError = false;
  String _errMessage = "";

  Future<void> _sendGstOtp() async {
    var response = await ref
        .read(invoiceLoanSignupStateProvider.notifier)
        .sendGSTOTP(_textController.text, _cancelToken);

    if (!mounted) return;

    logFirebaseEvent("invoice_loan_customer_signup", {
      "step": "sending_gst_otp",
      "gst": ref.read(invoiceLoanSignupStateProvider).gstNumber,
      "gstUsername": _textController.text,
      "success": response.success,
      "message": response.message,
      "data": response.data ?? {},
    });

    if (response.success) {
      context.go(InvoiceLoanSignupRouter.gst_otp_verification);
      return;
    }

    setState(() {
      _isError = true;
      _errMessage = response.message;
    });

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
                    headingWidth: 200,
                    subHeading: "Let's Start",
                    heading: "Enter your GST Username",
                  ),
                  const SpacerWidget(
                    height: 45,
                  ),
                  SectionMain(
                    textController: _textController,
                    textInputChild: _isError
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
                        : Text(
                            "Please enter GST username to link a GSTIN to your Account ",
                            style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: AppFontSizes.b2,
                              fontWeight: AppFontWeights.normal,
                              color: const Color.fromRGBO(118, 118, 118, 1),
                            ),
                          ),
                    maxInputLength: 50,
                    keyboardType: TextInputType.text,
                    showBackButton: true,
                    hintText: "GST Username",
                    onTextChanged: (val) {
                      setState(() {
                        _isError = false;
                      });
                    },
                    isObscure: false,
                    hasErrored: _isError,
                    performAction: () async {
                      await _sendGstOtp();
                    },
                    inputFormatters: const [],
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
