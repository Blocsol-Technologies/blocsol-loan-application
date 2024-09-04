import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/profile_router.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/profile/components/curved_background.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/profile/components/text_field.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/profile/components/top_nav_bar.dart';
import 'package:blocsol_loan_application/invoice_loan/state/user/profile/profile_details.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/theme.dart';
import 'package:blocsol_loan_application/utils/text_formatters.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/snackbar_notifications/util.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class InvoiceLoanProfileAddBankAccount extends ConsumerStatefulWidget {
  final String accountNumber;
  final String ifscCode;
  const InvoiceLoanProfileAddBankAccount(
      {super.key, required this.accountNumber, required this.ifscCode});

  @override
  ConsumerState<InvoiceLoanProfileAddBankAccount> createState() =>
      _MyWidgetState();
}

class _MyWidgetState extends ConsumerState<InvoiceLoanProfileAddBankAccount> {
  final _accountNumberTextController = TextEditingController();
  final _ifscCodeTextController = TextEditingController();
  final _cancelToken = CancelToken();

  bool _addingBankDetails = false;
  bool _setPrimaryBank = false;

  Future<void> _updateBankDetails() async {
    var response = await ref
        .read(invoiceLoanUserProfileDetailsProvider.notifier)
        .updateCompanyBankAccountDetails(_accountNumberTextController.text,
            _ifscCodeTextController.text, _setPrimaryBank, _cancelToken);

    if (!mounted) return;

    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: getSnackbarNotificationWidget(
        message: response.message,
        notifType: response.success
            ? SnackbarNotificationType.success
            : SnackbarNotificationType.error,
      ),
      duration: const Duration(seconds: 5),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);

    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    ref
        .read(routerProvider)
        .pushReplacement(InvoiceLoanProfileRouter.bankAccountSettings);

    return;
  }

  @override
  void initState() {
    _accountNumberTextController.text = widget.accountNumber;
    _ifscCodeTextController.text = widget.ifscCode;
    super.initState();
  }

  @override
  void dispose() {
    _accountNumberTextController.dispose();
    _ifscCodeTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
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
                "Add Bank Account",
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
                    InvoiceLoanProfileTextField(
                      label: "ENTER ACCOUNT NUMBER",
                      hintText: "Account Number",
                      keyboardType: TextInputType.number,
                      readOnly: widget.accountNumber.isNotEmpty,
                      controller: _accountNumberTextController,
                    ),
                    const SpacerWidget(
                      height: 30,
                    ),
                    InvoiceLoanProfileTextField(
                      label: "ENTER IFSC CODE",
                      hintText: "Ifsc Code",
                      readOnly: widget.accountNumber.isNotEmpty,
                      controller: _ifscCodeTextController,
                      inputFormatters: [UpperCaseTextInputFormatter()],
                    ),
                    const SpacerWidget(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            setState(() {
                              _setPrimaryBank = !_setPrimaryBank;
                            });
                          },
                          child: Container(
                            height: 15,
                            width: 15,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _setPrimaryBank
                                  ? Colors.green
                                  : const Color.fromRGBO(220, 220, 220, 1),
                            ),
                          ),
                        ),
                        const SpacerWidget(
                          width: 5,
                        ),
                        Text(
                          "Set as Primary Account",
                          style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: AppFontSizes.b2,
                              color: Theme.of(context).colorScheme.onSurface),
                        )
                      ],
                    ),
                    const SpacerWidget(
                      height: 130,
                    ),
                    GestureDetector(
                      onTap: () async {
                        HapticFeedback.heavyImpact();
                        if (_addingBankDetails) {
                          return;
                        }

                        setState(() {
                          _addingBankDetails = true;
                        });

                        await _updateBankDetails();

                        if (!mounted) {
                          return;
                        }

                        setState(() {
                          _addingBankDetails = false;
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
                          child: _addingBankDetails
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
