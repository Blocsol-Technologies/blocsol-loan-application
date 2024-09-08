import 'dart:ui';

import 'package:blocsol_loan_application/personal_loan/constants/routes/profile_router.dart';
import 'package:blocsol_loan_application/personal_loan/constants/theme.dart';
import 'package:blocsol_loan_application/personal_loan/constants/routes/loan_request_router.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/account_details/account_details.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/new_loan/new_loan.dart';
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

class GetNewPersonalLoanButton extends ConsumerStatefulWidget {
  final double screenHeight;
  final double screenWidth;
  const GetNewPersonalLoanButton(
      {super.key, required this.screenHeight, required this.screenWidth});

  @override
  ConsumerState<GetNewPersonalLoanButton> createState() =>
      _GetNewPersonalLoanButtonState();
}

class _GetNewPersonalLoanButtonState
    extends ConsumerState<GetNewPersonalLoanButton> {
  final _cancelToken = CancelToken();

  bool _sendingSearchRequest = false;

  Future<void> _handleGetLoanPress() async {
    if (_sendingSearchRequest) {
      return;
    }

    setState(() {
      _sendingSearchRequest = true;
    });

    final cancelToken = CancelToken();

    var response = await ref
        .read(personalNewLoanRequestProvider.notifier)
        .performGeneralSearch(false, cancelToken);

    if (!mounted) return;

    setState(() {
      _sendingSearchRequest = false;
    });

    if (response.success) {
      if (response.data['redirection']) {
        await _handlePreviousLoanJourney();
        return;
      } else {
        if (ref
            .read(personalLoanAccountDetailsProvider)
            .accountAggregatorSetup) {
          context.go(PersonalNewLoanRequestRouter.new_loan_process);
          return;
        } else {
          await _setupAccountAggregator();
          return;
        }
      }
    } else {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: getSnackbarNotificationWidget(
            message: response.message,
            notifType: SnackbarNotificationType.error),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);

      return;
    }
  }

  Future<void> _handlePreviousLoanJourney() async {
    await showDialog(
        context: context,
        barrierColor: Colors.transparent,
        builder: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SpacerWidget(
                height: 70,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surface
                            .withOpacity(0.4),
                        border: Border.all(
                          color: const Color.fromRGBO(234, 234, 234, 1),
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Start from where you left off?",
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: AppFontSizes.h3,
                              fontWeight: AppFontWeights.medium,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          const SpacerWidget(
                            height: 5,
                          ),
                          Text(
                            "Pick your loan journey from the where you left.",
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: AppFontSizes.b1,
                              fontWeight: AppFontWeights.normal,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          const SpacerWidget(
                            height: 15,
                          ),
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.heavyImpact();
                              context.go(PersonalNewLoanRequestRouter
                                  .new_loan_process);
                              return;
                            },
                            child: Container(
                              height: 32,
                              width: 200,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Center(
                                child: Text(
                                  "YES",
                                  style: TextStyle(
                                    fontFamily: fontFamily,
                                    fontSize: AppFontSizes.b1,
                                    fontWeight: AppFontWeights.bold,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SpacerWidget(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.heavyImpact();

                              if (ref
                                  .read(personalLoanAccountDetailsProvider)
                                  .accountAggregatorSetup) {
                                context.go(PersonalNewLoanRequestRouter
                                    .new_loan_process);
                                return;
                              } else {
                                _setupAccountAggregator();
                                return;
                              }
                            },
                            child: Container(
                              height: 32,
                              width: 200,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.onPrimary,
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Center(
                                child: Text(
                                  "NO",
                                  style: TextStyle(
                                    fontFamily: fontFamily,
                                    fontSize: AppFontSizes.b1,
                                    fontWeight: AppFontWeights.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
    return;
  }

  Future<void> _setupAccountAggregator() async {
    await showDialog(
        context: context,
        barrierColor: Colors.transparent,
        builder: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SpacerWidget(
                height: 70,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surface
                            .withOpacity(0.4),
                        border: Border.all(
                          color: const Color.fromRGBO(234, 234, 234, 1),
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 25),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Setup Account Aggregator for better loan offers from more banks.",
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: AppFontSizes.h3,
                              fontWeight: AppFontWeights.medium,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          const SpacerWidget(
                            height: 15,
                          ),
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.heavyImpact();
                              context.go(
                                  PersonalLoanProfileRouter
                                      .accountAggregatorSelect,
                                  extra: ref
                                      .read(personalLoanAccountDetailsProvider)
                                      .primaryBankAccount
                                      .bankName);
                              return;
                            },
                            child: Container(
                              height: 32,
                              width: 200,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Center(
                                child: Text(
                                  "Select Account Aggregator",
                                  style: TextStyle(
                                    fontFamily: fontFamily,
                                    fontSize: AppFontSizes.b1,
                                    fontWeight: AppFontWeights.bold,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SpacerWidget(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.heavyImpact();
                              context.go(PersonalNewLoanRequestRouter
                                  .new_loan_process);
                              return;
                            },
                            child: Container(
                              height: 32,
                              width: 200,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.onPrimary,
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Center(
                                child: Text(
                                  "Skip",
                                  style: TextStyle(
                                    fontFamily: fontFamily,
                                    fontSize: AppFontSizes.b1,
                                    fontWeight: AppFontWeights.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
    return;
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(personalNewLoanRequestProvider);
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        _handleGetLoanPress();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: RelativeSize.width(30, widget.screenWidth),
          vertical: RelativeSize.height(25, widget.screenHeight),
        ),
        height: RelativeSize.height(90, widget.screenHeight),
        width: RelativeSize.width(310, widget.screenWidth),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Get New Loan!",
              style: TextStyle(
                fontFamily: fontFamily,
                fontSize: AppFontSizes.h2,
                fontWeight: AppFontWeights.bold,
                color: Theme.of(context).colorScheme.onTertiary,
              ),
            ),
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  shape: BoxShape.circle),
              child: Center(
                child: _sendingSearchRequest
                    ? Lottie.asset('assets/animations/loading_spinner.json',
                        height: 40, width: 40)
                    : Icon(
                        Icons.arrow_forward_ios,
                        color: Theme.of(context).colorScheme.onSurface,
                        size: 15,
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

String getPreviousTxString(String status, String state) {
  if (status == "search") {
    switch (state) {
      case "approved":
        return "You need to provide consent on Account Aggregator";
      case "search_complete":
        return "You were selecting offers from different lenders";
    }
  }

  if (status == "select") {
    if (state == "on_select_02") {
      return "You selected an offer and now need to perform Individual KYC";
    }

    return "You were selecting offers from different lenders";
  }

  if (status == "init") {
    switch (state) {
      case "on_init_01":
        return "You completed aadhar KYC and now need to complete Udyam Entity KYC.";
      case "on_init_02":
        return "You completed Udyam Entity KYC and now need to provide Bank Account details.";
      case "on_init_03":
        return "You provided Bank Account Details and now need to set up Repayment.";
      case "on_init_04":
        return "You set up Repayment and now need to sign the Loan Agreement.";
    }
  }

  return "";
}
