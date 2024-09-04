import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/global_state/theme/theme_state.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/loan_request_router.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/components/continue_button.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/components/timer.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/components/top_nav.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/loan_events/loan_events.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/server_sent_events/sse.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/loan_request.dart';
import 'package:blocsol_loan_application/utils/text_formatters.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/snackbar_notifications/util.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class InvoiceNewLoanBankAccountDetails extends ConsumerStatefulWidget {
  const InvoiceNewLoanBankAccountDetails({super.key});

  @override
  ConsumerState<InvoiceNewLoanBankAccountDetails> createState() =>
      _InvoiceNewLoanBankAccountDetailsState();
}

class _InvoiceNewLoanBankAccountDetailsState
    extends ConsumerState<InvoiceNewLoanBankAccountDetails> {
  final _cancelToken = CancelToken();
  bool _verifyingBankAccount = false;
  bool _accountNumberReadOnly = false;
  bool _ifscCodeReadOnly = false;
  bool _gettingBankAccountFormDetails = false;

  final _bankAccountTextInputController = TextEditingController();
  final _ifscCodeTextInputController = TextEditingController();

  Future<void> _verifyBankAccountDetails() async {
    if (_verifyingBankAccount) {
      return;
    }

    setState(() {
      _verifyingBankAccount = true;
    });

    var bankVerificationResponse = await ref
        .read(invoiceNewLoanRequestProvider.notifier)
        .submitBankAccountDetails(_ifscCodeReadOnly, _cancelToken);

    if (!mounted) return;

    if (!bankVerificationResponse.success) {
      setState(() {
        _verifyingBankAccount = false;
      });

      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: getSnackbarNotificationWidget(
            message: bankVerificationResponse.message,
            notifType: SnackbarNotificationType.error),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
      return;
    }
  }

  Future<void> _fetchBankAccountFormDetails() async {
    if (_gettingBankAccountFormDetails) {
      return;
    }

    setState(() {
      _gettingBankAccountFormDetails = true;
    });

    var response = await ref
        .read(invoiceNewLoanRequestProvider.notifier)
        .fetchBankAccountFormDetails(_cancelToken);

    if (!mounted) return;

    setState(() {
      _gettingBankAccountFormDetails = false;
    });

    if (!response.success) {
      context.go(InvoiceNewLoanRequestRouter.loan_service_unavailable,
          extra: "unable to fetch bank account form details");

      return;
    }

    if (response.data['account_number_readonly']) {
      ref
          .read(invoiceNewLoanRequestProvider.notifier)
          .updateBankAccountNumber(response.data['account_number']);

      _bankAccountTextInputController.text = response.data['account_number'];

      setState(() {
        _accountNumberReadOnly = true;
      });
    }

    if (response.data['ifsc_readonly']) {
      ref
          .read(invoiceNewLoanRequestProvider.notifier)
          .updateBankIFSC(response.data['ifsc']);

      _ifscCodeTextInputController.text = response.data['ifsc'];

      setState(() {
        _ifscCodeReadOnly = true;
      });
    }

    return;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _fetchBankAccountFormDetails();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    ref.watch(invoiceLoanServerSentEventsProvider);
    ref.watch(invoiceLoanEventsProvider);
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
                RelativeSize.width(20, width),
                RelativeSize.height(30, height),
                RelativeSize.width(20, width),
                RelativeSize.height(50, height)),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                InvoiceNewLoanRequestTopNav(onBackClick: () {
                  ref.read(routerProvider).pop();
                }),
                const SpacerWidget(height: 12),
                const InvoiceNewLoanRequestCountdownTimer(),
                const SpacerWidget(height: 12),
                _gettingBankAccountFormDetails
                    ? SizedBox(
                        width: width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Lottie.asset(
                                "assets/animations/loading_spinner.json",
                                height: 160,
                                width: 160),
                            const SpacerWidget(height: 35),
                            Text(
                              "Fetching Bank Details Form!",
                              style: TextStyle(
                                fontFamily: fontFamily,
                                fontSize: AppFontSizes.h2,
                                fontWeight: AppFontWeights.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      )
                    : BankAccountDetailsForm(
                        bankAccountTextInputController:
                            _bankAccountTextInputController,
                        ifscCodeTextInputController:
                            _ifscCodeTextInputController,
                        verifyBankAccountDetails: _verifyBankAccountDetails,
                        verifyingBankAccount: _verifyingBankAccount,
                        accountNumberReadOnly: _accountNumberReadOnly,
                        ifscCodeReadOnly: _ifscCodeReadOnly,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BankAccountDetailsForm extends ConsumerWidget {
  final Function verifyBankAccountDetails;
  final TextEditingController bankAccountTextInputController;
  final TextEditingController ifscCodeTextInputController;
  final bool verifyingBankAccount;
  final bool accountNumberReadOnly;
  final bool ifscCodeReadOnly;

  const BankAccountDetailsForm(
      {super.key,
      required this.bankAccountTextInputController,
      required this.ifscCodeTextInputController,
      required this.verifyBankAccountDetails,
      required this.verifyingBankAccount,
      required this.accountNumberReadOnly,
      required this.ifscCodeReadOnly});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Share Loan Deposit A/c",
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: AppFontSizes.h1,
              fontWeight: AppFontWeights.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            softWrap: true,
          ),
          const SpacerWidget(height: 15),
          Text(
            "Enter your account where the loan needs to be disbursed by the lender",
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: AppFontSizes.h3,
              fontWeight: AppFontWeights.normal,
              color: Theme.of(context).colorScheme.onSurface,
              letterSpacing: 0.14,
            ),
            softWrap: true,
          ),
          const SpacerWidget(height: 35),
          Text(
            "ENTER ACCOUNT NUMBER",
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: AppFontSizes.h2,
              fontWeight: AppFontWeights.medium,
              color: Theme.of(context).colorScheme.onSurface,
              letterSpacing: 0.14,
            ),
            softWrap: true,
          ),
          const SpacerWidget(height: 15),
          TextField(
            keyboardType: TextInputType.number,
            textAlign: TextAlign.start,
            onChanged: (val) {
              ref
                  .read(invoiceNewLoanRequestProvider.notifier)
                  .updateBankAccountNumber(val);
            },
            controller: bankAccountTextInputController,
            readOnly: accountNumberReadOnly,
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: AppFontSizes.b1,
              fontWeight: AppFontWeights.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
            textDirection: TextDirection.ltr,
            decoration: InputDecoration(
              counterText: "",
              hintText: 'Bank Account Number',
              contentPadding: const EdgeInsets.symmetric(horizontal: 15),
              hintStyle: TextStyle(
                fontFamily: fontFamily,
                fontSize: AppFontSizes.b1,
                fontWeight: AppFontWeights.normal,
                color: Theme.of(context).colorScheme.scrim,
              ),
              fillColor: Theme.of(context).colorScheme.scrim.withOpacity(0.1),
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
          Text(
            "ENTER IFSC CODE",
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: AppFontSizes.h2,
              fontWeight: AppFontWeights.medium,
              color: Theme.of(context).colorScheme.onSurface,
              letterSpacing: 0.14,
            ),
            softWrap: true,
          ),
          const SpacerWidget(height: 15),
          TextField(
            keyboardType: TextInputType.text,
            textAlign: TextAlign.start,
            onChanged: (val) {
              ref
                  .read(invoiceNewLoanRequestProvider.notifier)
                  .updateBankIFSC(val);
            },
            controller: ifscCodeTextInputController,
            readOnly: ifscCodeReadOnly,
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: AppFontSizes.b1,
              fontWeight: AppFontWeights.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
            inputFormatters: [UpperCaseTextInputFormatter()],
            textDirection: TextDirection.ltr,
            decoration: InputDecoration(
              counterText: "",
              hintText: 'IFSC Code',
              contentPadding: const EdgeInsets.symmetric(horizontal: 15),
              hintStyle: TextStyle(
                fontFamily: fontFamily,
                fontSize: AppFontSizes.b1,
                fontWeight: AppFontWeights.normal,
                color: Theme.of(context).colorScheme.scrim,
              ),
              fillColor: Theme.of(context).colorScheme.scrim.withOpacity(0.1),
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
          const SpacerWidget(
            height: 140,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ContinueButton(
                onPressed: () async {
                  await verifyBankAccountDetails();
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
