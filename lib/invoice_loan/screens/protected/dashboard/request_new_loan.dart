import 'dart:ui';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/loan_request_router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/profile_router.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/loan_request/loan_request.dart';
import 'package:blocsol_loan_application/invoice_loan/state/user/profile/profile_details.dart';
import 'package:blocsol_loan_application/personal_loan/contants/theme.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RequestNewLoanButton extends ConsumerStatefulWidget {
  const RequestNewLoanButton({super.key});

  @override
  ConsumerState<RequestNewLoanButton> createState() =>
      _RequestNewLoanButtonState();
}

class _RequestNewLoanButtonState extends ConsumerState<RequestNewLoanButton> {
  Future<void> _handleGetLoanPress() async {
    final cancelToken = CancelToken();

    await HapticFeedback.heavyImpact();

    var response = await ref
        .read(loanRequestProvider.notifier)
        .performGeneralSearch(false, cancelToken);

    if (!mounted) return;

    if (response.success) {
      if (response.data['redirection']) {
        await _handlePreviousLoanJourney();
        return;
      } else {
        if (ref
            .read(invoiceLoanUserProfileDetailsProvider)
            .accountAggregatorSetup) {
          context.go(InvoiceNewLoanRequestRouter.dashboard);
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
        content: AwesomeSnackbarContent(
          title: 'Error!',
          message: response.message,
          contentType: ContentType.failure,
        ),
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
                              context.go(InvoiceNewLoanRequestRouter.dashboard);
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
                                  .read(invoiceLoanUserProfileDetailsProvider)
                                  .accountAggregatorSetup) {
                                context
                                    .go(InvoiceNewLoanRequestRouter.dashboard);
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
                              context.go(InvoiceLoanProfileRouter
                                  .accountAggregatorSetupBankSelect);
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
                              context.go(InvoiceNewLoanRequestRouter.dashboard);
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
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final newLoanRequestRef = ref.watch(loanRequestProvider);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: RelativeSize.width(47, width),
        vertical: RelativeSize.height(28, height),
      ),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.heavyImpact();
          _handleGetLoanPress();
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(
            RelativeSize.width(25, width),
            RelativeSize.height(15, height),
            RelativeSize.width(20, width),
            RelativeSize.height(15, height),
          ),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  offset: const Offset(0, 4), // horizontal, vertical offset
                  blurRadius: 10, // blur radius
                  spreadRadius: 1, // spread radius
                ),
              ]),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    height: 35,
                    width: 35,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.currency_rupee_sharp,
                        size: 27,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ),
              const SpacerWidget(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Get New Loan",
                    style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: AppFontSizes.h2,
                      fontWeight: AppFontWeights.extraBold,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  const SpacerWidget(
                    height: 2,
                  ),
                  Text(
                    "Just a few steps away",
                    style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: AppFontSizes.b1,
                      fontWeight: AppFontWeights.medium,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(),
              ),
              newLoanRequestRef.requestingNewLoan
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.onPrimary),
                        strokeWidth: 4,
                      ),
                    )
                  : Icon(
                      Icons.arrow_forward_ios_sharp,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 25,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
