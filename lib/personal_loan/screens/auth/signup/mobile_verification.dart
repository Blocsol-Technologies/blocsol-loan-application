import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/global_state/theme/theme_state.dart';
import 'package:blocsol_loan_application/personal_loan/constants/routes/signup_router.dart';
import 'package:blocsol_loan_application/personal_loan/state/auth/signup/signup.dart';
import 'package:blocsol_loan_application/utils/logger.dart';
import 'package:blocsol_loan_application/utils/regex.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/snackbar_notifications/util.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:sms_autofill/sms_autofill.dart';

class PCSignupMobileAuth extends ConsumerStatefulWidget {
  const PCSignupMobileAuth({super.key});

  @override
  ConsumerState<PCSignupMobileAuth> createState() => _PCSignupMobileAuthState();
}

class _PCSignupMobileAuthState extends ConsumerState<PCSignupMobileAuth> {
  final _phoneTextInputController = TextEditingController();
  final _phoneTextInputFocusNode = FocusNode();
  final _cancelToken = CancelToken();

  String _deviceSignature = "";
  bool _phoneVerificationError = false;
  bool _sendingOTP = false;

  Future<void> _sendMobileOTP() async {
    if (_sendingOTP) return;

    setState(() {
      _sendingOTP = true;
    });

    var response = await ref
        .read(personalLoanSignupProvider.notifier)
        .sendMobileOTP(
            _phoneTextInputController.text, _deviceSignature, _cancelToken);

    if (!mounted || !context.mounted) return;

    setState(() {
      _sendingOTP = false;
    });

    logFirebaseEvent("personal_loan_signup", {
      "step": "sending_mobile_otp",
      "phoneNumber": _phoneTextInputController.text,
      "success": response.success,
      "message": response.message,
      "data": response.data ?? {},
    });

    if (response.success) {
      ref.read(routerProvider).push(PersonalLoanSignupRouter.mobile_otp_auth);
      return;
    }

    setState(() {
      _phoneVerificationError = true;
    });

    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: getSnackbarNotificationWidget(
          message: response.message, notifType: SnackbarNotificationType.error),
      duration: const Duration(seconds: 5),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);

    return;
  }

  void addSignature() async {
    String sign = await SmsAutoFill().getAppSignature;
    if (!mounted || !context.mounted) return;
    setState(() {
      _deviceSignature = sign;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      addSignature();
    });
    _phoneTextInputFocusNode.requestFocus();
    _phoneTextInputController.addListener(() {
      if (RegexProvider.phoneRegex.hasMatch(_phoneTextInputController.text)) {
        _phoneTextInputFocusNode.unfocus();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _phoneTextInputController.dispose();
    _phoneTextInputFocusNode.dispose();
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
                        ref.read(routerProvider).pop();
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.support_agent_outlined,
                        color: Theme.of(context).colorScheme.onSurface,
                        size: 30,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              const SpacerWidget(height: 45),
              Text(
                "Verify your Mobile Number",
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
                maxLength: 10,
                controller: _phoneTextInputController,
                onChanged: (val) {
                  setState(() {
                    _phoneVerificationError = false;
                  });
                },
                style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: AppFontSizes.b1,
                  fontWeight: AppFontWeights.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
                textDirection: TextDirection.ltr,
                focusNode: _phoneTextInputFocusNode,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  counterText: "",
                  hintText: 'Phone Number',
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
                      color: _phoneVerificationError
                          ? Theme.of(context).colorScheme.error
                          : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
              const SpacerWidget(height: 5),
              _sendingOTP
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Lottie.asset('assets/animations/loading_spinner.json',
                            height: 60, width: 60),
                        const SpacerWidget(width: 5),
                        Text(
                          "Sending OTP...",
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
                      _sendMobileOTP();
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
                          "Verify Number",
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
