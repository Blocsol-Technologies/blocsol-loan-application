import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/theme.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/profile/components/curved_background.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/profile/components/text_field.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/profile/components/top_nav_bar.dart';
import 'package:blocsol_loan_application/invoice_loan/state/user/profile/profile_details.dart';
import 'package:blocsol_loan_application/utils/regex.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class InvoiceLoanProfileChangePassword extends ConsumerStatefulWidget {
  const InvoiceLoanProfileChangePassword({super.key});

  @override
  ConsumerState<InvoiceLoanProfileChangePassword> createState() =>
      _InvoiceLoanProfileChangePasswordState();
}

class _InvoiceLoanProfileChangePasswordState
    extends ConsumerState<InvoiceLoanProfileChangePassword> {
  final _oldPasswordTextController = TextEditingController();
  final _newPasswordTextController = TextEditingController();
  final _confirmNewPasswordTextController = TextEditingController();
  final _cancelToken = CancelToken();

  bool _changingPassword = false;
  bool _oldPasswordVisible = false;
  bool _newPasswordVisible = false;
  bool _confirmNewPasswordVisible = false;

  Future<void> _changeAccountPassword() async {
    if (!RegexProvider.passwordRegex
        .hasMatch(_oldPasswordTextController.text)) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Error!',
          message: "invalid old password",
          contentType: ContentType.failure,
        ),
        duration: const Duration(seconds: 3),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);

      return;
    }

    if (!RegexProvider.passwordRegex
        .hasMatch(_newPasswordTextController.text)) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Error!',
          message: "invalid new password",
          contentType: ContentType.failure,
        ),
        duration: const Duration(seconds: 3),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);

      return;
    }

    if (!(_newPasswordTextController.text ==
        _confirmNewPasswordTextController.text)) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Error!',
          message: "passwords do not match",
          contentType: ContentType.failure,
        ),
        duration: const Duration(seconds: 3),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);

      return;
    }

    var response = await ref
        .read(invoiceLoanUserProfileDetailsProvider.notifier)
        .changeAccountPassword(_oldPasswordTextController.text, _newPasswordTextController.text, _cancelToken);

    if (!mounted || !context.mounted) {
      return;
    }

    if (response.success) {
      _oldPasswordTextController.clear();
      _newPasswordTextController.clear();
      _confirmNewPasswordTextController.clear();
    }

    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: response.success ? 'Success!' : 'Error!',
        message: response.message,
        contentType: response.success ? ContentType.success : ContentType.failure,
      ),
      duration: const Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);

    return;
  }

  @override
  void dispose() {
    _oldPasswordTextController.dispose();
    _newPasswordTextController.dispose();
    _confirmNewPasswordTextController.dispose();
    _cancelToken.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final _ = ref.watch(invoiceLoanUserProfileDetailsProvider);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            vertical: RelativeSize.height(25, height),
            horizontal: RelativeSize.width(25, width),
          ),
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const InvoiceLoanProfileTopNav(),
              const SpacerWidget(
                height: 35,
              ),
              Text(
                "Change Password",
                style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: AppFontSizes.h2,
                  fontWeight: AppFontWeights.medium,
                  color: Theme.of(context).colorScheme.onTertiary,
                ),
              ),
              const SpacerWidget(
                height: 25,
              ),
              CurvedBackground(
                horizontalPadding: 11,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: InvoiceLoanProfileTextField(
                            label: "OLD PASSWORD",
                            hintText: "******",
                            obscureText: !_oldPasswordVisible,
                            keyboardType: TextInputType.visiblePassword,
                            readOnly: false,
                            controller: _oldPasswordTextController,
                          ),
                        ),
                        const SpacerWidget(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            setState(() {
                              _oldPasswordVisible = !_oldPasswordVisible;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(top: 15),
                            child: Icon(
                              _oldPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              size: 20,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                        const SpacerWidget(
                          width: 10,
                        ),
                      ],
                    ),
                    const SpacerWidget(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: InvoiceLoanProfileTextField(
                            label: "NEW PASSWORD",
                            hintText: "******",
                            obscureText: !_newPasswordVisible,
                            keyboardType: TextInputType.visiblePassword,
                            readOnly: false,
                            controller: _newPasswordTextController,
                          ),
                        ),
                        const SpacerWidget(
                          width: 10,
                        ),
                        GestureDetector(
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              setState(() {
                                _newPasswordVisible = !_newPasswordVisible;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(top: 15),
                              child: Icon(
                                _newPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                size: 20,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            )),
                        const SpacerWidget(
                          width: 10,
                        ),
                      ],
                    ),
                    const SpacerWidget(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: InvoiceLoanProfileTextField(
                            label: "CONFIRM NEW PASSWORD",
                            hintText: "******",
                            obscureText: !_confirmNewPasswordVisible,
                            keyboardType: TextInputType.visiblePassword,
                            readOnly: false,
                            controller: _confirmNewPasswordTextController,
                          ),
                        ),
                        const SpacerWidget(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            setState(() {
                              _confirmNewPasswordVisible =
                                  !_confirmNewPasswordVisible;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(top: 15),
                            child: Icon(
                              _confirmNewPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              size: 20,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                        const SpacerWidget(
                          width: 10,
                        ),
                      ],
                    ),
                    const SpacerWidget(
                      height: 130,
                    ),
                    GestureDetector(
                      onTap: () async {
                        HapticFeedback.heavyImpact();
                        if (_changingPassword) {
                          return;
                        }

                        setState(() {
                          _changingPassword = true;
                        });

                        await _changeAccountPassword();

                        if (!mounted) {
                          return;
                        }

                        setState(() {
                          _changingPassword = false;
                        });
                      },
                      child: Container(
                        height: 40,
                        width: RelativeSize.width(240, width),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: _changingPassword
                              ? Lottie.asset(
                                  "assets/animations/loading_spinner.json",
                                  height: 40)
                              : Text(
                                  "SAVE",
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
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
