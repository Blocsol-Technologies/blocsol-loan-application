import 'package:blocsol_loan_application/invoice_loan/constants/routes/login_router.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/auth/login/components/section_main_background.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/auth/login/components/section_heading.dart';
import 'package:blocsol_loan_application/invoice_loan/state/auth/login/login.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/theme.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/snackbar_notifications/util.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:sms_autofill/sms_autofill.dart';

class LoginPasswordValidation extends ConsumerStatefulWidget {
  const LoginPasswordValidation({super.key});

  @override
  ConsumerState<LoginPasswordValidation> createState() =>
      _LoginPasswordValidationState();
}

class _LoginPasswordValidationState
    extends ConsumerState<LoginPasswordValidation>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final _textController = TextEditingController();
  final _cancelToken = CancelToken();

  late AnimationController _animationController;
  late Animation _animation;

  bool _sendingOtp = false;
  bool _validationError = false;
  bool _passwordVisible = false;
  bool _animationComplete = false;

  Future<void> _verifyPassword() async {
    var response = await ref
        .read(invoiceLoanLoginProvider.notifier)
        .validatePassword(ref.read(invoiceLoanLoginProvider).phoneNumber,
            _textController.text, _cancelToken);

 
    if (!mounted) return;

    if (response.success) {
      context.go(InvoiceLoanLoginRouter.otp_validation);
      return;
    }

    setState(() {
      _validationError = true;
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
    String deviceId = await SmsAutoFill().getAppSignature;
    ref.read(invoiceLoanLoginProvider.notifier).setDeviceId(deviceId);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _animation = CurvedAnimation(
        parent: _animationController, curve: Curves.easeOutExpo);

    addSignature();
    super.initState();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    // ignore: deprecated_member_use
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    if (bottomInset > 0.0) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
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
                    headingWidth: 200,
                    subHeading: "Login to your account",
                    heading: "Verify your password",
                  ),
                  const SpacerWidget(
                    height: 50,
                  ),
                  Expanded(
                    child: SectionMainBackground(
                      onAnimationComplete: () {
                        setState(() {
                          _animationComplete = true;
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: RelativeSize.height(47, height),
                            width: width,
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 7),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          keyboardType:
                                              TextInputType.visiblePassword,
                                          textAlign: TextAlign.start,
                                          controller: _textController,
                                          onChanged: (val) {
                                            setState(() {
                                              _validationError = false;
                                            });
                                          },
                                          obscureText: !_passwordVisible,
                                          style: TextStyle(
                                            fontFamily: fontFamily,
                                            fontSize: AppFontSizes.b1,
                                            fontWeight: AppFontWeights.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                          textDirection: TextDirection.ltr,
                                          decoration: InputDecoration(
                                            counterText: "",
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 15),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: _validationError
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .error
                                                    : const Color.fromRGBO(
                                                        76, 76, 76, 1),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SpacerWidget(
                                        width: 5,
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          HapticFeedback.lightImpact();
                                          setState(() {
                                            _passwordVisible =
                                                !_passwordVisible;
                                          });
                                        },
                                        icon: _passwordVisible
                                            ? Icon(
                                                Icons.visibility,
                                                size: 25,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
                                              )
                                            : Icon(
                                                Icons.visibility_off,
                                                size: 25,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
                                              ),
                                      )
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  left: 15,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2),
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    child: Text(
                                      "PASSWORD",
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b1,
                                        fontWeight: AppFontWeights.normal,
                                        color: const Color.fromRGBO(
                                            164, 164, 164, 1),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SpacerWidget(
                            height: 70,
                          ),
                          _animationComplete
                              ? Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AnimatedBuilder(
                                        animation: _animation,
                                        builder: (context, child) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                                top: RelativeSize.height(
                                                        230, height) *
                                                    (1 -
                                                        _animationController
                                                            .value)),
                                          );
                                        },
                                      ),
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              HapticFeedback.mediumImpact();
                                              context.go(InvoiceLoanLoginRouter
                                                  .mobile_auth);
                                            },
                                            child: Container(
                                              height: 40,
                                              width: 90,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: const Color.fromRGBO(
                                                      128, 128, 128, 1),
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                    Icons.arrow_back,
                                                    size: 21,
                                                    color: Color.fromRGBO(
                                                        104, 104, 104, 1),
                                                  ),
                                                  const SpacerWidget(width: 3),
                                                  Text(
                                                    "Back",
                                                    style: TextStyle(
                                                      fontFamily: fontFamily,
                                                      fontSize: AppFontSizes.h3,
                                                      fontWeight:
                                                          AppFontWeights.medium,
                                                      color:
                                                          const Color.fromRGBO(
                                                              104, 104, 104, 1),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SpacerWidget(
                                            width: 20,
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              HapticFeedback.heavyImpact();

                                              if (_sendingOtp) return;

                                              setState(() {
                                                _sendingOtp = true;
                                              });

                                              await _verifyPassword();

                                              if (!mounted) return;

                                              setState(() {
                                                _sendingOtp = false;
                                              });
                                            },
                                            child: Container(
                                              height: 40,
                                              width: 105,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: const Color.fromRGBO(
                                                      128, 128, 128, 1),
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  if (_sendingOtp)
                                                    Lottie.asset(
                                                        'assets/animations/loading_spinner.json',
                                                        height: 40,
                                                        width: 40)
                                                  else ...[
                                                    Text(
                                                      "Continue",
                                                      style: TextStyle(
                                                        fontFamily: fontFamily,
                                                        fontSize:
                                                            AppFontSizes.h3,
                                                        fontWeight:
                                                            AppFontWeights
                                                                .medium,
                                                        color: const Color
                                                            .fromRGBO(
                                                            104, 104, 104, 1),
                                                      ),
                                                    ),
                                                    const SpacerWidget(
                                                        width: 3),
                                                    const Icon(
                                                      Icons
                                                          .arrow_forward_rounded,
                                                      size: 21,
                                                      color: Color.fromRGBO(
                                                          104, 104, 104, 1),
                                                    )
                                                  ]
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox()
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
