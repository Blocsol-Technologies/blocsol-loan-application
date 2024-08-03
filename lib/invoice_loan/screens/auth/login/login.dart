import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/auth/login/components/login_modal_bottom_sheet.dart';
import 'package:blocsol_loan_application/invoice_loan/state/auth/login/login.dart';
import 'package:blocsol_loan_application/personal_loan/contants/theme.dart';
import 'package:blocsol_loan_application/utils/regex.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class InvoiceLoanLogin extends ConsumerStatefulWidget {
  const InvoiceLoanLogin({super.key});

  @override
  ConsumerState<InvoiceLoanLogin> createState() => _LoginState();
}

class _LoginState extends ConsumerState<InvoiceLoanLogin> {
  final _cancelToken = CancelToken();
  final _phoneTextController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  bool _isPasswordInFocus = false;
  bool _passwordVisible = false;
  bool _sendingOTP = false;
  bool _isPasswordErr = false;

  Future<void> _sendOTP() async {
    setState(() {
      _sendingOTP = true;
    });

    var response = await ref.read(loginProvider.notifier).validatePassword(
        _phoneTextController.text, _passwordController.text, _cancelToken);

    if (!mounted) return;

    setState(() {
      _sendingOTP = false;
    });

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

      setState(() {
        _isPasswordErr = true;
      });

      return;
    }

    showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: LoginOTPModalBottomSheet(
              password: _passwordController.text,
              phoneNumber: response.data,
            ),
          );
        });

    return;
  }

  void addSignature() async {
    String deviceId = await SmsAutoFill().getAppSignature;
    ref.read(loginProvider.notifier).setDeviceId(deviceId);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      addSignature();
    });
    _phoneTextController.addListener(() {
      if (RegexProvider.phoneRegex.hasMatch(_phoneTextController.text)) {
        _phoneFocusNode.unfocus();
      }
    });
    _passwordFocusNode.addListener(() {
      if (_passwordFocusNode.hasFocus) {
        setState(() {
          _isPasswordInFocus = true;
        });
      } else {
        setState(() {
          _isPasswordInFocus = false;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _phoneTextController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    _phoneFocusNode.dispose();
    _cancelToken.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
              const SpacerWidget(height: 65),
              Text(
                "InvoiceLoanLogin",
                style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: AppFontSizes.h1,
                  fontWeight: AppFontWeights.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SpacerWidget(height: 5),
              Text(
                "Provide your GST number and Password in order to login to your account.",
                softWrap: true,
                style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: AppFontSizes.b1,
                  fontWeight: AppFontWeights.normal,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SpacerWidget(height: 30),
              // Enter Phone Number
              TextField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.start,
                maxLength: 10,
                controller: _phoneTextController,
                style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: AppFontSizes.b1,
                  fontWeight: AppFontWeights.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
                textDirection: TextDirection.ltr,
                focusNode: _phoneFocusNode,
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
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
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
                  border: Border.all(
                    color: _isPasswordErr
                        ? Theme.of(context).colorScheme.error
                        : _isPasswordInFocus
                            ? Theme.of(context).colorScheme.primary
                            : Colors.transparent,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      height: 40,
                      width: RelativeSize.width(250, width),
                      child: TextField(
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.start,
                        maxLength: 20,
                        obscureText: !_passwordVisible,
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        onChanged: (val) {
                          setState(() {
                            _isPasswordErr = false;
                          });
                        },
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
                    _passwordVisible
                        ? IconButton(
                            icon: Icon(
                              Icons.visibility,
                              size: 20,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = false;
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
                                _passwordVisible = true;
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
                      _sendOTP();
                    },
                    child: Container(
                      width: RelativeSize.width(250, width),
                      height: RelativeSize.height(40, height),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: _sendingOTP
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
