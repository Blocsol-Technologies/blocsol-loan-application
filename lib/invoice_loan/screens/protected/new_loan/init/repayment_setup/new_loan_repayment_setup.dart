import 'dart:async';
import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/global_state/theme/theme_state.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/loan_request_router.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/components/alert_dialog.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/components/continue_button.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/components/timer.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/components/top_nav.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/new_loan/init/repayment_setup/repayment_setup_repayment_setup_webview.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/loan_events/loan_events.dart';
import 'package:blocsol_loan_application/invoice_loan/state/events/server_sent_events/sse.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/loan_request.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/state/error_codes.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/state/loan_request_state.dart';
import 'package:blocsol_loan_application/invoice_loan/state/user/profile/profile_details.dart';
import 'package:blocsol_loan_application/utils/lender_utils.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/snackbar_notifications/util.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class InvoiceNewLoanRepaymentSetup extends ConsumerStatefulWidget {
  const InvoiceNewLoanRepaymentSetup({super.key});

  @override
  ConsumerState<InvoiceNewLoanRepaymentSetup> createState() =>
      _InvoiceNewLoanRepaymentSetupState();
}

class _InvoiceNewLoanRepaymentSetupState
    extends ConsumerState<InvoiceNewLoanRepaymentSetup> {
  final _cancelToken = CancelToken();

  bool _showRepaymentWebview = false;
  String _currentUrl = "";

  Future<void> _checkRepaymentSuccessStatus() async {
    if (ref.read(invoiceNewLoanRequestProvider).repaymentSetupFailure) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: getSnackbarNotificationWidget(
            message: "Repayment Setup Unsuccessful. Refetch the Repayment URL",
            notifType: SnackbarNotificationType.error),
        duration: const Duration(seconds: 5),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);

      return;
    }

    var checkRepaymentSetupSuccessResponse = await ref
        .read(invoiceNewLoanRequestProvider.notifier)
        .checkRepaymentSetupSuccess(_cancelToken);

    if (!mounted || !context.mounted) return;

    if (!checkRepaymentSetupSuccessResponse.success) {
      context.go(InvoiceNewLoanRequestRouter.loan_service_error,
          extra: InvoiceLoanServiceErrorCodes.repayment_setup_failed);
      return;
    }

    ref
        .read(invoiceNewLoanRequestProvider.notifier)
        .updateState(LoanRequestProgress.repaymentSetupCompleted);

    return;
  }

  void _fetchRepaymentFormUrl() async {
    if (ref.read(invoiceNewLoanRequestProvider).fetchingRepaymentSetupUrl) {
      return;
    }

    var fetchURLResponse = await ref
        .read(invoiceNewLoanRequestProvider.notifier)
        .fetchRepaymentSetupUrl(_cancelToken);

    if (!mounted || !context.mounted) return;

    if (fetchURLResponse.success) {
      setState(() {
        _currentUrl = fetchURLResponse.data['url'];
      });
    } else {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: getSnackbarNotificationWidget(
            message: "Unable to fetch Repayment Form URL. Contact Support",
            notifType: SnackbarNotificationType.error),
        duration: const Duration(seconds: 15),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchRepaymentFormUrl();
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
    final msmeBasicDetailsRef =
        ref.watch(invoiceLoanUserProfileDetailsProvider);
    ref.watch(invoiceLoanServerSentEventsProvider);
    ref.watch(invoiceLoanEventsProvider);
    final newLoanStateRef = ref.watch(invoiceNewLoanRequestProvider);
    final selectedOffer = newLoanStateRef.selectedOffer;
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            padding: EdgeInsets.only(
              top: RelativeSize.height(30, height),
            ),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: RelativeSize.width(20, width)),
                  child: InvoiceNewLoanRequestTopNav(onBackClick: () async {
                    if (_showRepaymentWebview) {
                      await showDialog(
                          context: context,
                          barrierColor: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.5),
                          builder: (BuildContext context) {
                            return NewLoanAlertDialog(
                                text:
                                    "Have you completed loan repayment setup?",
                                onConfirm: () async {
                                  await _checkRepaymentSuccessStatus();
                                });
                          });
                    } else {
                      ref.read(routerProvider).pop();
                    }
                  }),
                ),
                const SpacerWidget(height: 12),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: RelativeSize.width(20, width)),
                  child: const InvoiceNewLoanRequestCountdownTimer(),
                ),
                const SpacerWidget(height: 12),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: RelativeSize.width(20, width)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 30,
                        child: getLenderDetailsAssetURL(
                            selectedOffer.bankName, selectedOffer.bankLogoURL),
                      ),
                      const SpacerWidget(
                        width: 10,
                      ),
                    ],
                  ),
                ),
                const SpacerWidget(
                  height: 8,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: RelativeSize.width(20, width)),
                  child: Text(
                    "Setup Auto Repayment",
                    style: TextStyle(
                        fontFamily: fontFamily,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: AppFontSizes.h1,
                        fontWeight: AppFontWeights.bold,
                        letterSpacing: 0.4),
                    softWrap: true,
                  ),
                ),
                const SpacerWidget(
                  height: 16,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: RelativeSize.width(20, width)),
                  child: Text(
                    "Allow lender to auto-deduct repayment from your bank account ****${newLoanStateRef.bankAccountNumber.substring(newLoanStateRef.bankAccountNumber.length - 4)}",
                    style: TextStyle(
                        fontFamily: fontFamily,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: AppFontSizes.h3,
                        fontWeight: AppFontWeights.normal,
                        letterSpacing: 0.4),
                    softWrap: true,
                  ),
                ),
                const SpacerWidget(
                  height: 20,
                ),
                if (!_showRepaymentWebview) ...[
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: RelativeSize.width(20, width)),
                    child: Text(
                      "Repayment Details",
                      style: TextStyle(
                          fontFamily: fontFamily,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: AppFontSizes.h2,
                          fontWeight: AppFontWeights.bold,
                          letterSpacing: 0.14),
                    ),
                  ),
                  const SpacerWidget(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: RelativeSize.width(20, width)),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Text("Amount Payable:",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b1,
                                        fontWeight: AppFontWeights.medium)),
                              ),
                              const SpacerWidget(
                                width: 5,
                              ),
                              Expanded(
                                child: Text(
                                  "₹ ${selectedOffer.totalRepayment}",
                                  softWrap: true,
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontFamily: fontFamily,
                                      fontSize: AppFontSizes.b1,
                                      fontWeight: AppFontWeights.bold),
                                ),
                              ),
                            ],
                          ),
                          const SpacerWidget(
                            height: 15,
                          ),
                          const SpacerWidget(
                            height: 15,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Text("Autorepay End (Due Date After):",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b1,
                                        fontWeight: AppFontWeights.medium)),
                              ),
                              const SpacerWidget(
                                width: 5,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "From: ${selectedOffer.tenure}",
                                      softWrap: true,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontFamily: fontFamily,
                                          fontSize: AppFontSizes.b1,
                                          fontWeight: AppFontWeights.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SpacerWidget(
                            height: 15,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  "Sanctioned Cancellation Fee:",
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontFamily: fontFamily,
                                      fontSize: AppFontSizes.b1,
                                      fontWeight: AppFontWeights.medium),
                                ),
                              ),
                              const SpacerWidget(
                                width: 5,
                              ),
                              Expanded(
                                child: Text(
                                  newLoanStateRef.sanctionedCancellationFee,
                                  softWrap: true,
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontFamily: fontFamily,
                                      fontSize: AppFontSizes.b1,
                                      fontWeight: AppFontWeights.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SpacerWidget(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: RelativeSize.width(20, width)),
                    child: Text(
                      "Account Details",
                      style: TextStyle(
                          fontFamily: fontFamily,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: AppFontSizes.h2,
                          fontWeight: AppFontWeights.bold,
                          letterSpacing: 0.14),
                    ),
                  ),
                  const SpacerWidget(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: RelativeSize.width(20, width)),
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.2),
                                  width: 1))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Account Number",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: AppFontSizes.h3,
                              fontWeight: AppFontWeights.medium,
                              fontFamily: fontFamily,
                              letterSpacing: 0.14,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                newLoanStateRef.bankAccountNumber,
                                style: TextStyle(
                                  color: const Color.fromRGBO(145, 145, 145, 1),
                                  fontSize: AppFontSizes.h3,
                                  fontWeight: AppFontWeights.bold,
                                  fontFamily: fontFamily,
                                  letterSpacing: 0.165,
                                ),
                              ),
                              const SpacerWidget(
                                height: 3,
                              ),
                              Text(
                                newLoanStateRef.bankIFSC,
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.4),
                                  fontSize: AppFontSizes.b2,
                                  fontWeight: AppFontWeights.normal,
                                  fontFamily: fontFamily,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: RelativeSize.width(20, width)),
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.2),
                                  width: 1))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Account Holder Name",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: AppFontSizes.h3,
                              fontWeight: AppFontWeights.medium,
                              fontFamily: fontFamily,
                              letterSpacing: 0.14,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                msmeBasicDetailsRef.legalName,
                                style: TextStyle(
                                  color: const Color.fromRGBO(145, 145, 145, 1),
                                  fontSize: AppFontSizes.h3,
                                  fontWeight: AppFontWeights.bold,
                                  fontFamily: fontFamily,
                                  letterSpacing: 0.165,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SpacerWidget(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ContinueButton(onPressed: () {
                        setState(() {
                          _showRepaymentWebview = true;
                        });
                      }),
                    ],
                  ),
                ],
                if (_showRepaymentWebview) ...[
                  Container(
                    height: 5,
                    width: width,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(248, 248, 248, 1),
                      border: Border.symmetric(
                        horizontal: BorderSide(
                          color: Color.fromRGBO(230, 230, 230, 1),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      child:
                          InvoiceNewLoanRepaymentSetupWebview(url: _currentUrl))
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String getRepaymentTime(int start, int days) {
  DateTime startDate = DateTime.fromMillisecondsSinceEpoch(start * 1000);

  // Calculate the end date by adding the number of days
  DateTime endDate = startDate.add(Duration(days: days));

  // Format the end date
  String formattedEndDate = DateFormat('d MMM, yyyy').format(endDate);

  return formattedEndDate;
}

