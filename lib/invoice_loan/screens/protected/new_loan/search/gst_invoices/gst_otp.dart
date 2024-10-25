import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/loan_request_router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/theme.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/components/continue_button.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/components/top_nav.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/loan_events/loan_events.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/server_sent_events/sse.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/loan_request.dart';
import 'package:blocsol_loan_application/invoice_loan/state/user/profile/profile_details.dart';
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

class GstOtpValidation extends ConsumerStatefulWidget {
  const GstOtpValidation({super.key});

  @override
  ConsumerState<GstOtpValidation> createState() => _GstOtpValidationState();
}

class _GstOtpValidationState extends ConsumerState<GstOtpValidation> {
  final _cancelToken = CancelToken();
  final _otpTextController = TextEditingController();
  final _textInputFocusNode = FocusNode();

  bool _verifyingOTP = false;
  bool _otpVerificationError = false;

  Future<void> verifyGSTOTP() async {
    if (!RegexProvider.otpRegex.hasMatch(_otpTextController.text)) {
      setState(() {
        _otpVerificationError = true;
      });
      return;
    }

    if (_verifyingOTP) {
      return;
    }

    setState(() {
      _verifyingOTP = true;
      _otpVerificationError = false;
    });

    var response = await ref
        .read(invoiceNewLoanRequestProvider.notifier)
        .verifyGstOtp(_otpTextController.text, _cancelToken);

    if (!mounted) return;

    logFirebaseEvent("invoice_loan_application_process", {
      "step": "verifying_gst_otp",
      "gst": ref.read(invoiceLoanUserProfileDetailsProvider).gstNumber,
      "success": response.success,
      "message": response.message,
      "data": response.data ?? {},
    });

    setState(() {
      _verifyingOTP = false;
    });

    if (response.success) {
      ref.read(routerProvider).pushReplacement(
          InvoiceNewLoanRequestRouter.downloading_gst_invoices);
      return;
    } else {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: getSnackbarNotificationWidget(
            message: response.message,
            notifType: SnackbarNotificationType.error),
        duration: const Duration(seconds: 5),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);

      return;
    }
  }

  @override
  void initState() {
    _otpTextController.addListener(() {
      if (RegexProvider.otpRegex.hasMatch(_otpTextController.text)) {
        _textInputFocusNode.unfocus();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _otpTextController.dispose();
    _cancelToken.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    ref.watch(invoiceNewLoanRequestProvider);
    ref.watch(invoiceLoanServerSentEventsProvider);
    ref.watch(invoiceLoanEventsProvider);
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: Container(
            height: height,
            width: width,
            padding: EdgeInsets.fromLTRB(
                RelativeSize.width(30, width),
                RelativeSize.height(30, height),
                RelativeSize.width(30, width),
                RelativeSize.height(50, height)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InvoiceNewLoanRequestTopNav(onBackClick: () {
                  ref.read(routerProvider).pop();
                }),
                const SpacerWidget(height: 70),
                SizedBox(
                  width: width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "We need the updated data",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.heading,
                          fontWeight: AppFontWeights.medium,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        softWrap: true,
                      ),
                      const SpacerWidget(
                        height: 5,
                      ),
                      Text(
                        "The data seems to be old for your offer. The updated data provides better offer opportunities.",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.b1,
                          fontWeight: AppFontWeights.normal,
                          color: const Color.fromRGBO(130, 130, 130, 1),
                        ),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
                const SpacerWidget(
                  height: 60,
                ),
                Container(
                  height: 2,
                  width: RelativeSize.width(150, width),
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SpacerWidget(
                  height: 40,
                ),
                SizedBox(
                  width: width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Verify GST OTP.",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.h1,
                          fontWeight: AppFontWeights.medium,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        softWrap: true,
                      ),
                      const SpacerWidget(
                        height: 5,
                      ),
                      Text(
                        "Enter the OTP sent on your registered mobile number.",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.b2,
                          fontWeight: AppFontWeights.normal,
                          color: const Color.fromRGBO(130, 130, 130, 1),
                        ),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
                const SpacerWidget(
                  height: 20,
                ),
                SizedBox(
                  height: RelativeSize.height(60, height),
                  width: width,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 7),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.start,
                          onChanged: (_) {
                            setState(() {
                              _otpVerificationError = false;
                            });
                          },
                          maxLength: 6,
                          controller: _otpTextController,
                          style: TextStyle(
                            fontFamily: fontFamily,
                            fontSize: AppFontSizes.b1,
                            fontWeight: AppFontWeights.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          textDirection: TextDirection.ltr,
                          focusNode: _textInputFocusNode,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            counterText: "",
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 15),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: _otpVerificationError
                                    ? Theme.of(context).colorScheme.error
                                    : const Color.fromRGBO(76, 76, 76, 1),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 15,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          color: Theme.of(context).colorScheme.surface,
                          child: Text(
                            "6-Digi OTP",
                            style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: AppFontSizes.b1,
                              fontWeight: AppFontWeights.normal,
                              color: const Color.fromRGBO(164, 164, 164, 1),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Expanded(child: SizedBox()),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ContinueButton(
                        onPressed: () async {
                          await verifyGSTOTP();
                        },
                        text: "Verify OTP",
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
