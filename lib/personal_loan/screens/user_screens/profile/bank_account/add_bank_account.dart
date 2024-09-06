import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/global_state/theme/theme_state.dart';
import 'package:blocsol_loan_application/personal_loan/constants/routes/profile_router.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/profile/components/curved_background.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/profile/components/text_field.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/profile/components/top_nav_bar.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/account_details/account_details.dart';
import 'package:blocsol_loan_application/utils/text_formatters.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/snackbar_notifications/util.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class PlProfileAddBankAccount extends ConsumerStatefulWidget {
  final String accountNumber;
  final String ifscCode;
  const PlProfileAddBankAccount(
      {super.key, required this.accountNumber, required this.ifscCode});

  @override
  ConsumerState<PlProfileAddBankAccount> createState() => _MyWidgetState();
}

class _MyWidgetState extends ConsumerState<PlProfileAddBankAccount> {
  final _accountNumberTextController = TextEditingController();
  final _ifscCodeTextController = TextEditingController();
  final _cancelToken = CancelToken();

  final List<String> _accountTypes = ["saving", "current"];

  bool _addingBankDetails = false;
  bool _setPrimaryBank = false;
  String _accountType = "saving";

  Future<void> _updateBankDetails() async {
    var response = await ref
        .read(personalLoanAccountDetailsProvider.notifier)
        .updateCompanyBankAccountDetails(
            _accountNumberTextController.text,
            _ifscCodeTextController.text,
            _setPrimaryBank,
            _accountType == "saving" ? 1 : 0,
            _cancelToken);

    if (!mounted) return;

    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: getSnackbarNotificationWidget(
          message: response.message,
          notifType: response.success
              ? SnackbarNotificationType.success
              : SnackbarNotificationType.error),
      duration: const Duration(seconds: 5),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);

    if (!mounted) return;

    ref
        .read(routerProvider)
        .pushReplacement(PersonalLoanProfileRouter.bankAccountSettings);

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
              const PlProfileTopNav(),
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
              PlCurvedBackground(
                horizontalPadding: 11,
                child: Column(
                  children: [
                    PlProfileTextField(
                      label: "ENTER ACCOUNT NUMBER",
                      hintText: "Account Number",
                      keyboardType: TextInputType.number,
                      readOnly: widget.accountNumber.isNotEmpty,
                      controller: _accountNumberTextController,
                    ),
                    const SpacerWidget(
                      height: 30,
                    ),
                    PlProfileTextField(
                      label: "ENTER IFSC CODE",
                      hintText: "Ifsc Code",
                      readOnly: widget.accountNumber.isNotEmpty,
                      controller: _ifscCodeTextController,
                      inputFormatters: [UpperCaseTextInputFormatter()],
                    ),
                    const SpacerWidget(
                      height: 16,
                    ),
                    const SpacerWidget(
                      height: 16,
                    ),
                    DropdownButton2<String>(
                      isExpanded: true,
                      underline: const SizedBox(),
                      iconStyleData: IconStyleData(
                        icon: Icon(
                          Icons.account_balance,
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: 20,
                        ),
                      ),
                      hint: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        height: 40,
                        width: width,
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .scrim
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              _accountType,
                              style: TextStyle(
                                fontFamily: fontFamily,
                                fontSize: AppFontSizes.b1,
                                fontWeight: AppFontWeights.bold,
                                color:
                                    Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      items: _accountTypes
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    fontSize: AppFontSizes.b1,
                                    fontWeight: AppFontWeights.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))
                          .toList(),
                      value: _accountType,
                      onChanged: (String? value) {
                        if (value == null) return;
                    
                        setState(() {
                          _accountType = value;
                        });
                      },
                      buttonStyleData: ButtonStyleData(
                        height: 40,
                        width: width,
                        padding: const EdgeInsets.only(left: 14, right: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      dropdownStyleData: DropdownStyleData(
                        maxHeight: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        offset: const Offset(0, 0),
                        scrollbarTheme: ScrollbarThemeData(
                          radius: const Radius.circular(5),
                          thumbVisibility:
                              WidgetStateProperty.all<bool>(true),
                        ),
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        height: 40,
                        padding: EdgeInsets.only(left: 10, right: 10),
                      ),
                    ),
                    const SpacerWidget(height: 20,),
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
