import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/global_state/theme/theme_state.dart';
import 'package:blocsol_loan_application/personal_loan/contants/routes/signup_router.dart';
import 'package:blocsol_loan_application/personal_loan/state/auth/signup/signup.dart';
import 'package:blocsol_loan_application/utils/regex.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:sms_autofill/sms_autofill.dart';

class PCSignupMobileOTPAuth extends ConsumerStatefulWidget {
  const PCSignupMobileOTPAuth({super.key});

  @override
  ConsumerState<PCSignupMobileOTPAuth> createState() =>
      _PCSignupMobileOTPAuthState();
}

class _PCSignupMobileOTPAuthState extends ConsumerState<PCSignupMobileOTPAuth> {
  final _otpTextInputController = TextEditingController();
  final _otpTextInputFocusNode = FocusNode();
  final _cancelToken = CancelToken();

  bool _otpVerificationError = false;
  bool _verifyingOTP = false;
  bool _resendingOTP = false;
  String _deviceSignature = "";

  Future<void> _verifyMobileOTP() async {
    if (_verifyingOTP) return;

    setState(() {
      _verifyingOTP = true;
    });

    var response = await ref.read(personalLoanSignupProvider.notifier).verifyMobileOTP(
        ref.read(personalLoanSignupProvider).phoneNumber,
        _otpTextInputController.text,
        _cancelToken);

    setState(() {
      _verifyingOTP = false;
    });

    if (!mounted) return;

    if (response.success) {
      ref.read(routerProvider).push(PersonalLoanSignupRouter.personal_details);
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

  Future<void> _resendMobileOTP() async {
    if (_resendingOTP) return;

    setState(() {
      _resendingOTP = true;
    });

    var response = await ref.read(personalLoanSignupProvider.notifier).sendMobileOTP(
        ref.read(personalLoanSignupProvider).phoneNumber,
        _deviceSignature,
        _cancelToken);

    setState(() {
      _resendingOTP = false;
    });

    if (!mounted) return;

    if (!response.success) {
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
  }

  void addSignature() async {
    String sign = await SmsAutoFill().getAppSignature;
    setState(() {
      _deviceSignature = sign;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      addSignature();
    });
    _otpTextInputFocusNode.requestFocus();
    _otpTextInputController.addListener(() {
      if (RegexProvider.otpRegex.hasMatch(_otpTextInputController.text)) {
        _otpTextInputFocusNode.unfocus();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _otpTextInputController.dispose();
    _otpTextInputFocusNode.dispose();
    _cancelToken.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    ref.watch(personalLoanSignupProvider);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          padding: EdgeInsets.fromLTRB(
            RelativeSize.width(25, width),
            RelativeSize.height(30, height),
            RelativeSize.width(35, width),
            RelativeSize.height(30, height),
          ),
          height: height,
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: Theme.of(context).colorScheme.onSurface,
                        size: 30,
                      ),
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        ref.read(routerProvider).push(PersonalLoanSignupRouter.mobile_auth);
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.support_agent_outlined,
                        color: Theme.of(context).colorScheme.onSurface,
                        size: 30,
                      ),
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        // TODO: Implement Support Click
                      },
                    ),
                  ],
                ),
              ),
              const SpacerWidget(height: 45),
              Text(
                "Verify your Mobile OTP",
                style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: AppFontSizes.h1,
                  fontWeight: AppFontWeights.medium,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SpacerWidget(height: 20),
              TextField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.start,
                maxLength: 6,
                controller: _otpTextInputController,
                onChanged: (val) {
                  setState(() {
                    _otpVerificationError = false;
                  });
                },
                style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: AppFontSizes.b1,
                  fontWeight: AppFontWeights.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
                textDirection: TextDirection.ltr,
                focusNode: _otpTextInputFocusNode,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  counterText: "",
                  hintText: 'OTP',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                  hintStyle: TextStyle(
                    fontFamily: fontFamily,
                    fontSize: AppFontSizes.b1,
                    fontWeight: AppFontWeights.normal,
                    color: Theme.of(context).colorScheme.scrim,
                  ),
                  fillColor:
                      Theme.of(context).colorScheme.scrim.withOpacity(0.1),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _otpVerificationError
                          ? Theme.of(context).colorScheme.error
                          : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
              const SpacerWidget(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      text: "Didn't receive OTP?",
                      style: TextStyle(
                        fontFamily: fontFamily,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: AppFontSizes.b2,
                        fontWeight: AppFontWeights.medium,
                      ),
                      children: [
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              HapticFeedback.lightImpact();
                              _resendMobileOTP();
                            },
                          text: " Resend OTP",
                          style: TextStyle(
                            fontFamily: fontFamily,
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: AppFontSizes.b2,
                            fontWeight: AppFontWeights.medium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              _verifyingOTP
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Lottie.asset('assets/animations/loading_spinner.json',
                            height: 60, width: 60),
                        const SpacerWidget(width: 5),
                        Text(
                          "Verifying OTP...",
                          style: TextStyle(
                            fontFamily: fontFamily,
                            fontSize: AppFontSizes.b1,
                            fontWeight: AppFontWeights.normal,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
              _resendingOTP
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Lottie.asset('assets/animations/loading_spinner.json',
                            height: 60, width: 60),
                        const SpacerWidget(width: 5),
                        Text(
                          "Resending OTP...",
                          style: TextStyle(
                            fontFamily: fontFamily,
                            fontSize: AppFontSizes.b1,
                            fontWeight: AppFontWeights.normal,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
              const Expanded(child: SizedBox()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.heavyImpact();
                      _verifyMobileOTP();
                    },
                    child: Container(
                      width: RelativeSize.width(250, width),
                      height: RelativeSize.height(40, height),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          "Verify OTP",
                          style: TextStyle(
                            fontFamily: fontFamily,
                            fontSize: AppFontSizes.b1,
                            fontWeight: AppFontWeights.medium,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
