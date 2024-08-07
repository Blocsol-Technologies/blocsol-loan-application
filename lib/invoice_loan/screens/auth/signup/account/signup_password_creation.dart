import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/signup_router.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/auth/signup/components/section_heading.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/auth/signup/components/section_main_background.dart';
import 'package:blocsol_loan_application/invoice_loan/state/auth/signup/signup.dart';
import 'package:blocsol_loan_application/personal_loan/contants/theme.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class SignupPasswordCreation extends ConsumerStatefulWidget {
  const SignupPasswordCreation({super.key});

  @override
  ConsumerState<SignupPasswordCreation> createState() =>
      _SignupPasswordCreationState();
}

class _SignupPasswordCreationState extends ConsumerState<SignupPasswordCreation>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final _cancelToken = CancelToken();
  final _textEditingController = TextEditingController();
  final _confirmTextEditingController = TextEditingController();

  late AnimationController _animationController;
  late Animation _animation;

  bool _settingPassword = false;
  bool _showPassword = false;
  bool _showConfirmedPassword = false;
  bool _isError = false;
  bool _animationComplete = false;

  Future<void> _setPassword() async {
    var response = await ref
        .read(signupStateProvider.notifier)
        .setAccountPassword(_textEditingController.text, _cancelToken);

    if (!mounted) return;

    if (response.success) {
      context.go(InvoiceLoanSignupRouter.account_created);
      return;
    }

    setState(() {
      _isError = true;
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
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _animation = CurvedAnimation(
        parent: _animationController, curve: Curves.easeOutExpo);

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
    _textEditingController.dispose();
    _confirmTextEditingController.dispose();
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
                    subHeading: "Let's Start",
                    heading: "Set your account password",
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
                            height: RelativeSize.height(40, height),
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
                                          controller: _textEditingController,
                                          onChanged: (val) {
                                            setState(() {
                                              _isError = false;
                                            });
                                          },
                                          obscureText: !_showPassword,
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
                                                color: _isError
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
                                            _showPassword = !_showPassword;
                                          });
                                        },
                                        icon: _showPassword
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
                                      "SET-PASSWORD",
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
                            height: 4,
                          ),
                          SizedBox(
                            height: RelativeSize.height(40, height),
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
                                          controller:
                                              _confirmTextEditingController,
                                          obscureText: !_showConfirmedPassword,
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
                                            focusedBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color.fromRGBO(
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
                                            _showConfirmedPassword =
                                                !_showConfirmedPassword;
                                          });
                                        },
                                        icon: _showConfirmedPassword
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
                                      "CONFIRM-PASSWORD",
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
                            height: 30,
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
                                      GestureDetector(
                                        onTap: () async {
                                          HapticFeedback.heavyImpact();

                                          if (_settingPassword) return;

                                          setState(() {
                                            _settingPassword = true;
                                          });
                                          await _setPassword();

                                          if (!mounted) return;

                                          setState(() {
                                            _settingPassword = false;
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
                                              if (_settingPassword)
                                                Lottie.asset(
                                                    'assets/animations/loading_spinner.json',
                                                    height: 40,
                                                    width: 40)
                                              else ...[
                                                Text(
                                                  "Continue",
                                                  style: TextStyle(
                                                    fontFamily: fontFamily,
                                                    fontSize: AppFontSizes.h3,
                                                    fontWeight:
                                                        AppFontWeights.medium,
                                                    color: const Color.fromRGBO(
                                                        104, 104, 104, 1),
                                                  ),
                                                ),
                                                const SpacerWidget(width: 3),
                                                const Icon(
                                                  Icons.arrow_forward_rounded,
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
