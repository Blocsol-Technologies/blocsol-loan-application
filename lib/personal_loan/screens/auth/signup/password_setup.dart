import 'package:blocsol_loan_application/personal_loan/constants/routes/index_router.dart';
import 'package:blocsol_loan_application/personal_loan/constants/theme.dart';
import 'package:blocsol_loan_application/personal_loan/state/auth/signup/signup.dart';
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
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class PCSignupPasswordSetup extends ConsumerStatefulWidget {
  const PCSignupPasswordSetup({super.key});

  @override
  ConsumerState<PCSignupPasswordSetup> createState() =>
      _PCSignupPasswordSetupState();
}

class _PCSignupPasswordSetupState extends ConsumerState<PCSignupPasswordSetup> {
  final _enterPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _enterPasswordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  final _cancelToken = CancelToken();

  bool _enterPasswordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _creatingAccount = false;

  Future<void> _createAccount() async {
    setState(() {
      _creatingAccount = true;
    });

    if (_confirmPasswordFocusNode.hasFocus) _confirmPasswordFocusNode.unfocus();
    if (_enterPasswordFocusNode.hasFocus) _enterPasswordFocusNode.unfocus();

    if (_confirmPasswordController.text != _enterPasswordController.text) {
      setState(() {
        _creatingAccount = false;
      });

      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: getSnackbarNotificationWidget(
            message: "passwords do not match",
            notifType: SnackbarNotificationType.error),
        duration: const Duration(seconds: 5),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);

      return;
    }

    var response = await ref
        .read(personalLoanSignupProvider.notifier)
        .setPassword(_confirmPasswordController.text, _cancelToken);

    if (!mounted) return;

    setState(() {
      _creatingAccount = false;
    });

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
        context.go(PersonalLoanIndexRouter.dashboard);
        return;
      } else {
        context.go(PersonalLoanIndexRouter.permissions);
        return;
      }
    }

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
  void dispose() {
    _enterPasswordController.dispose();
    _confirmPasswordController.dispose();
    _enterPasswordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.support_agent_outlined,
                        color: Theme.of(context).colorScheme.onSurface,
                        size: 30,
                      ),
                      onPressed: () async {
                        HapticFeedback.mediumImpact();
                        const whatsappUrl = "https://wa.me/918360458365";

                        await launchUrl(Uri.parse(whatsappUrl));
                      },
                    ),
                  ],
                ),
              ),
              const SpacerWidget(height: 45),
              Text(
                "Password Setup",
                style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: AppFontSizes.h1,
                  fontWeight: AppFontWeights.medium,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SpacerWidget(height: 5),
              Text(
                "Your account password must be atleast 8 characters and have 1 Uppercase, 1 Number and 1 Special Character.",
                softWrap: true,
                style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: AppFontSizes.b1,
                  fontWeight: AppFontWeights.normal,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SpacerWidget(height: 30),
              // Enter Password
              Container(
                height: 40,
                width: width,
                padding: const EdgeInsets.fromLTRB(15, 0, 20, 0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.scrim.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                      width: RelativeSize.width(250, width),
                      child: Center(
                        child: TextField(
                          obscureText: !_enterPasswordVisible,
                          keyboardType: TextInputType.text,
                          textAlign: TextAlign.start,
                          maxLength: 20,
                          controller: _enterPasswordController,
                          focusNode: _enterPasswordFocusNode,
                          style: TextStyle(
                            fontFamily: fontFamily,
                            fontSize: AppFontSizes.b1,
                            fontWeight: AppFontWeights.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          textDirection: TextDirection.ltr,
                          decoration: InputDecoration(
                            counterText: "",
                            hintText: 'Password',
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 0),
                            hintStyle: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: AppFontSizes.b1,
                              fontWeight: AppFontWeights.normal,
                              color: Theme.of(context).colorScheme.scrim,
                            ),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                    ),
                    _enterPasswordVisible
                        ? IconButton(
                            icon: Icon(
                              Icons.visibility,
                              size: 20,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            onPressed: () {
                              setState(() {
                                _enterPasswordVisible = false;
                              });
                            },
                          )
                        : IconButton(
                            icon: Icon(
                              Icons.visibility_off,
                              size: 20,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            onPressed: () {
                              setState(() {
                                _enterPasswordVisible = true;
                              });
                            },
                          )
                  ],
                ),
              ),
              const SpacerWidget(height: 30),

              // Confirm Password
              Container(
                height: 40,
                width: width,
                padding: const EdgeInsets.fromLTRB(15, 0, 20, 0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.scrim.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                      width: RelativeSize.width(250, width),
                      child: Center(
                        child: TextField(
                          keyboardType: TextInputType.text,
                          textAlign: TextAlign.start,
                          maxLength: 20,
                          obscureText: !_confirmPasswordVisible,
                          controller: _confirmPasswordController,
                          focusNode: _confirmPasswordFocusNode,
                          style: TextStyle(
                            fontFamily: fontFamily,
                            fontSize: AppFontSizes.b1,
                            fontWeight: AppFontWeights.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          textDirection: TextDirection.ltr,
                          decoration: InputDecoration(
                            counterText: "",
                            hintText: 'Confirm Password',
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 0),
                            hintStyle: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: AppFontSizes.b1,
                              fontWeight: AppFontWeights.normal,
                              color: Theme.of(context).colorScheme.scrim,
                            ),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                    ),
                    _confirmPasswordVisible
                        ? IconButton(
                            icon: Icon(
                              Icons.visibility,
                              size: 20,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            onPressed: () {
                              setState(() {
                                _confirmPasswordVisible = false;
                              });
                            },
                          )
                        : IconButton(
                            icon: Icon(
                              Icons.visibility_off,
                              size: 20,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            onPressed: () {
                              setState(() {
                                _confirmPasswordVisible = true;
                              });
                            },
                          )
                  ],
                ),
              ),

              const Expanded(child: SizedBox()),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.heavyImpact();
                      _createAccount();
                    },
                    child: Container(
                      width: RelativeSize.width(250, width),
                      height: RelativeSize.height(40, height),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: _creatingAccount
                            ? Lottie.asset(
                                'assets/animations/loading_spinner.json',
                                height: 50,
                                width: 50)
                            : Text(
                                "Continue",
                                style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: AppFontSizes.b1,
                                  fontWeight: AppFontWeights.medium,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
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
