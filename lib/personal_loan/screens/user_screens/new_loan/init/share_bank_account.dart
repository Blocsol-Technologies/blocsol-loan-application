import 'package:blocsol_loan_application/personal_loan/constants/routes/loan_request_router.dart';
import 'package:blocsol_loan_application/personal_loan/constants/theme.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/new_loan/components/top_nav.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/new_loan/init/utils.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/account_details/account_details.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/events/loan_events/loan_events.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/events/server_sent_events/sse.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/new_loan/new_loan.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/new_loan/state/new_loan_state.dart';
import 'package:blocsol_loan_application/utils/common_misc.dart';
import 'package:blocsol_loan_application/utils/logger.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/snackbar_notifications/util.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class PCNewLoanBankAccountDetails extends ConsumerStatefulWidget {
  const PCNewLoanBankAccountDetails({super.key});

  @override
  ConsumerState<PCNewLoanBankAccountDetails> createState() =>
      _PCNewLoanBankAccountDetailsState();
}

class _PCNewLoanBankAccountDetailsState
    extends ConsumerState<PCNewLoanBankAccountDetails> {
  final _cancelToken = CancelToken();
  final _bankAccountNumberController = TextEditingController();
  final _bankIFSCController = TextEditingController();

  String _selectedBankAccountType = "";
  bool _bankVerificationError = false;
  bool _verifyingBankAccount = false;

  Future<void> _verifyBankAccountDetails() async {
    if (_verifyingBankAccount) {
      return;
    }

    setState(() {
      _verifyingBankAccount = true;
      _bankVerificationError = false;
    });

    var verifyBankDetailsAndSubmitForm = await ref
        .read(personalNewLoanRequestProvider.notifier)
        .verifyBankAccountDetails(
            _selectedBankAccountType.toLowerCase(),
            _bankAccountNumberController.text,
            _bankIFSCController.text,
            _cancelToken);

    if (!mounted || !context.mounted) return;

    logFirebaseEvent("personal_loan_application_process", {
      "step": "verify_bank_account_details",
      "phoneNumber": ref.read(personalLoanAccountDetailsProvider).phone,
      "success": verifyBankDetailsAndSubmitForm.success,
      "message": verifyBankDetailsAndSubmitForm.message,
      "data": verifyBankDetailsAndSubmitForm.data ?? {},
    });

    if (!(verifyBankDetailsAndSubmitForm.success)) {
      setState(() {
        _bankVerificationError = true;
        _verifyingBankAccount = false;
      });

      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: getSnackbarNotificationWidget(
            message: verifyBankDetailsAndSubmitForm.message,
            notifType: SnackbarNotificationType.error),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);

      return;
    } else {
      setState(() {
        _bankVerificationError = false;
        _verifyingBankAccount = false;
      });

      ref
          .read(personalNewLoanRequestProvider.notifier)
          .updateState(PersonalLoanRequestProgress.bankAccountDetails);
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref
              .read(personalLoanAccountDetailsProvider)
              .primaryBankAccount
              .accountType ==
          BankAccountType.savings) {
        setState(() {
          _selectedBankAccountType = "Saving";
        });
      } else {
        setState(() {
          _selectedBankAccountType = "Current";
        });
      }

      _bankAccountNumberController.text = ref
          .read(personalLoanAccountDetailsProvider)
          .primaryBankAccount
          .accountNumber;
      _bankIFSCController.text = ref
          .read(personalLoanAccountDetailsProvider)
          .primaryBankAccount
          .ifscCode;
    });

    super.initState();
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final borrowerAccountDetailsRef =
        ref.watch(personalLoanAccountDetailsProvider);
    ref.watch(personalLoanServerSentEventsProvider);
    ref.watch(personalLoanEventsProvider);
    ref.watch(personalNewLoanRequestProvider);
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  width: width,
                  height: RelativeSize.height(200, height),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.only(top: RelativeSize.height(20, height)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: RelativeSize.width(30, width)),
                        child: PersonalNewLoanRequestTopNav(
                          onBackClick: () {
                            context.go(PersonalNewLoanRequestRouter
                                .new_loan_offers_home);
                          },
                        ),
                      ),
                      const SpacerWidget(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: RelativeSize.width(50, width)),
                        child: SizedBox(
                          width: width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  ref
                                      .read(personalNewLoanRequestProvider
                                          .notifier)
                                      .updateState(PersonalLoanRequestProgress
                                          .bankAccountDetails);
                                  context.go(PersonalNewLoanRequestRouter
                                      .new_loan_process);
                                },
                                child: Text(
                                  "Share Loan Deposit A/c",
                                  style: TextStyle(
                                    fontFamily: fontFamily,
                                    fontSize: AppFontSizes.h1,
                                    fontWeight: AppFontWeights.medium,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                  textAlign: TextAlign.center,
                                  softWrap: true,
                                ),
                              ),
                              Text(
                                "Enter your account where the loan needs to be disbursed by the lender",
                                style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: AppFontSizes.b1,
                                  fontWeight: AppFontWeights.normal,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                                textAlign: TextAlign.center,
                                softWrap: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SpacerWidget(
                        height: 90,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: RelativeSize.width(30, width)),
                        child: Text(
                          "Name at Bank",
                          style: TextStyle(
                            fontFamily: fontFamily,
                            fontSize: AppFontSizes.h3,
                            fontWeight: AppFontWeights.medium,
                            color: Theme.of(context).colorScheme.onSurface,
                            letterSpacing: 0.14,
                          ),
                          softWrap: true,
                        ),
                      ),
                      const SpacerWidget(height: 7),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: RelativeSize.width(30, width)),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.start,
                          controller: TextEditingController(
                              text: borrowerAccountDetailsRef.name),
                          style: TextStyle(
                            fontFamily: fontFamily,
                            fontSize: AppFontSizes.b1,
                            fontWeight: AppFontWeights.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          textDirection: TextDirection.ltr,
                          readOnly: true,
                          decoration: InputDecoration(
                            counterText: "",
                            hintText: '',
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 15),
                            hintStyle: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: AppFontSizes.b1,
                              fontWeight: AppFontWeights.normal,
                              color: Theme.of(context).colorScheme.scrim,
                            ),
                            fillColor: Theme.of(context)
                                .colorScheme
                                .scrim
                                .withOpacity(0.1),
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
                      ),
                      const SpacerWidget(height: 15),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: RelativeSize.width(30, width)),
                        child: Text(
                          "Type of Account",
                          style: TextStyle(
                            fontFamily: fontFamily,
                            fontSize: AppFontSizes.h3,
                            fontWeight: AppFontWeights.medium,
                            color: Theme.of(context).colorScheme.onSurface,
                            letterSpacing: 0.14,
                          ),
                          softWrap: true,
                        ),
                      ),
                      const SpacerWidget(height: 7),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: RelativeSize.width(30, width)),
                        child: DropdownButton2<String>(
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
                                  _selectedBankAccountType,
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
                          items: InitUtils.bankAccountTypes
                              .map((item) => DropdownMenuItem<String>(
                                    value: item.text,
                                    child: Text(
                                      item.text,
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
                          value: _selectedBankAccountType,
                          onChanged: (String? value) {
                            if (value == null) return;

                            setState(() {
                              _selectedBankAccountType = value;
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
                      ),
                      const SpacerWidget(height: 15),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: RelativeSize.width(30, width)),
                        child: Text(
                          "Enter Account Number",
                          style: TextStyle(
                            fontFamily: fontFamily,
                            fontSize: AppFontSizes.h3,
                            fontWeight: AppFontWeights.medium,
                            color: Theme.of(context).colorScheme.onSurface,
                            letterSpacing: 0.14,
                          ),
                          softWrap: true,
                        ),
                      ),
                      const SpacerWidget(height: 7),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: RelativeSize.width(30, width)),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.start,
                          maxLength: 20,
                          controller: _bankAccountNumberController,
                          readOnly: ref
                              .read(personalLoanAccountDetailsProvider)
                              .primaryBankAccount
                              .accountNumber
                              .isNotEmpty,
                          style: TextStyle(
                            fontFamily: fontFamily,
                            fontSize: AppFontSizes.b1,
                            fontWeight: AppFontWeights.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          textDirection: TextDirection.ltr,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            counterText: "",
                            hintText: 'Bank Account number',
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 15),
                            hintStyle: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: AppFontSizes.b1,
                              fontWeight: AppFontWeights.normal,
                              color: Theme.of(context).colorScheme.scrim,
                            ),
                            fillColor: Theme.of(context)
                                .colorScheme
                                .scrim
                                .withOpacity(0.1),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: _bankVerificationError
                                    ? Theme.of(context).colorScheme.error
                                    : Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SpacerWidget(height: 15),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: RelativeSize.width(30, width)),
                        child: Text(
                          "Enter IFSC Code",
                          style: TextStyle(
                            fontFamily: fontFamily,
                            fontSize: AppFontSizes.h3,
                            fontWeight: AppFontWeights.medium,
                            color: Theme.of(context).colorScheme.onSurface,
                            letterSpacing: 0.14,
                          ),
                          softWrap: true,
                        ),
                      ),
                      const SpacerWidget(height: 7),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: RelativeSize.width(30, width)),
                        child: TextField(
                          keyboardType: TextInputType.text,
                          textAlign: TextAlign.start,
                          maxLength: 15,
                          controller: _bankIFSCController,
                          readOnly: ref
                              .read(personalLoanAccountDetailsProvider)
                              .primaryBankAccount
                              .accountNumber
                              .isNotEmpty,
                          style: TextStyle(
                            fontFamily: fontFamily,
                            fontSize: AppFontSizes.b1,
                            fontWeight: AppFontWeights.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          textDirection: TextDirection.ltr,
                          inputFormatters: [
                            UpperCaseTextInputFormatter(),
                          ],
                          decoration: InputDecoration(
                            counterText: "",
                            hintText: 'IFSC',
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 15),
                            hintStyle: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: AppFontSizes.b1,
                              fontWeight: AppFontWeights.normal,
                              color: Theme.of(context).colorScheme.scrim,
                            ),
                            fillColor: Theme.of(context)
                                .colorScheme
                                .scrim
                                .withOpacity(0.1),
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
                      ),
                      const SpacerWidget(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.heavyImpact();
                              _verifyBankAccountDetails();
                            },
                            child: Container(
                              height: RelativeSize.height(40, height),
                              width: RelativeSize.width(252, width),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                child: _verifyingBankAccount
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
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                        ),
                                      ),
                              ),
                            ),
                          )
                        ],
                      ),
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

class UpperCaseTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
