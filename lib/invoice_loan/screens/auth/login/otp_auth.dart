import 'package:blocsol_loan_application/global_state/internet_check/internet_check.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/index_router.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/auth/login/components/section_heading.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/auth/login/components/section_main.dart';
import 'package:blocsol_loan_application/invoice_loan/state/auth/login/login.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/theme.dart';
import 'package:blocsol_loan_application/utils/logger.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/snackbar_notifications/util.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:go_router/go_router.dart';

class LoginMobileOtpValidation extends ConsumerStatefulWidget {
  const LoginMobileOtpValidation({super.key});

  @override
  ConsumerState<LoginMobileOtpValidation> createState() =>
      _LoginMobileOtpValidationState();
}

class _LoginMobileOtpValidationState
    extends ConsumerState<LoginMobileOtpValidation> with CodeAutoFill {
  final _textController = TextEditingController();
  final _cancelToken = CancelToken();

  bool _otpVerificationError = false;

  Future<void> _verifyMobileOTP() async {
    var response = await ref
        .read(invoiceLoanLoginProvider.notifier)
        .validateLoginOTP(_textController.text, _cancelToken);
    
    if (!mounted || !context.mounted) return;

    logFirebaseEvent(
      "invoice_loan_customer_login",
      {
        "phone": ref.read(invoiceLoanLoginProvider).phoneNumber,
        "success": response.success,
        "message": response.message,
        "data": response.data ?? {},
      },
    );

    if (response.success) {
      final permissions = [
        Permission.locationWhenInUse,
        Permission.camera,
        Permission.mediaLibrary,
      ];

      // Check if all permissions are granted
      bool allGranted = true;

      for (var permission in permissions) {
        if (!(await permission.isGranted)) {
          allGranted = false;
          break;
        }
      }

      if (!mounted || !context.mounted) return;

      if (allGranted) {
        context.go(InvoiceLoanIndexRouter.dashboard);
        return;
      } else {
        context.go(InvoiceLoanIndexRouter.permissions);
        return;
      }
    }

    setState(() {
      _otpVerificationError = true;
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
    final loginState = ref.watch(invoiceLoanLoginProvider);
    ref.watch(internetCheckProvider);

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
                    heading: "Enter the OTP sent to ${loginState.phoneNumber}",
                  ),
                  const SpacerWidget(
                    height: 50,
                  ),
                  SectionMain(
                    textController: _textController,
                    textInputChild: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Lottie.asset('assets/animations/loading_spinner.json',
                        //     height: 30, width: 30),
                        // const SizedBox(
                        //   width: 7,
                        // ),
                        // Text(
                        //   "Auto reading OTP",
                        //   style: TextStyle(
                        //       fontFamily: fontFamily,
                        //       fontWeight: AppFontWeights.medium,
                        //       fontSize: AppFontSizes.b1,
                        //       color: const Color.fromRGBO(150, 150, 150, 1)),
                        // ),
                      ],
                    ),
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
