import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/personal_loan/constants/routes/liabilities_router.dart';
import 'package:blocsol_loan_application/personal_loan/constants/theme.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/account_details/account_details.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/old_loan/old_loans.dart';
import 'package:blocsol_loan_application/utils/logger.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class PersonalLoanForecloseLoanModalBottomSheet extends ConsumerStatefulWidget {
  final String forecloseAmount;
  const PersonalLoanForecloseLoanModalBottomSheet(
      {super.key, required this.forecloseAmount});

  @override
  ConsumerState<PersonalLoanForecloseLoanModalBottomSheet> createState() =>
      _PersonalLoanForecloseLoanModalBottomSheet();
}

class _PersonalLoanForecloseLoanModalBottomSheet
    extends ConsumerState<PersonalLoanForecloseLoanModalBottomSheet> {
  bool _errorOccured = false;
  String _errorString = "";
  final _cancelToken = CancelToken();

  Future<void> _forecloseLoan() async {
    if (ref.read(personalLoanLiabilitiesProvider).initiatingForeclosure) {
      return;
    }

    setState(() {
      _errorOccured = false;
      _errorString = "";
    });

    var response = await ref
        .read(personalLoanLiabilitiesProvider.notifier)
        .initiateForeclosure(_cancelToken);

    if (!mounted) return;

    logFirebaseEvent("personal_loan_liabilities", {
      "step": "sending_foreclose_loan_request",
      "phoneNumber": ref.read(personalLoanAccountDetailsProvider).phone,
      "success": response.success,
      "message": response.message,
      "data": response.data ?? {},
    });

    if (!response.success) {
      setState(() {
        _errorOccured = true;
        _errorString = response.message;
      });

      return;
    }

    ref.read(routerProvider).push(
        PersonalLoanLiabilitiesRouter.liability_foreclose_webview,
        extra: response.data);
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final oldLoanStateRef = ref.watch(personalLoanLiabilitiesProvider);
    final selectedOffer = oldLoanStateRef.selectedOldOffer;
    return Container(
      height:
          _errorOccured || oldLoanStateRef.initiatingForeclosure ? 400 : 360,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.fromLTRB(25, 25, 25, 40),
      color: Theme.of(context).colorScheme.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Disclaimer!",
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: AppFontSizes.h1,
              fontWeight: AppFontWeights.bold,
              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.75),
              letterSpacing: 0.14,
            ),
          ),
          const SpacerWidget(
            height: 15,
          ),
          Text(
            "Amount: ${widget.forecloseAmount} INR!",
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: AppFontSizes.h1,
              fontWeight: AppFontWeights.bold,
              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.75),
              letterSpacing: 0.14,
            ),
          ),
          const SpacerWidget(
            height: 15,
          ),
          Text(
            "What is foreclosure?",
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: AppFontSizes.h3,
              fontWeight: AppFontWeights.normal,
              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.75),
              letterSpacing: 0.14,
            ),
          ),
          const SpacerWidget(
            height: 15,
          ),
          Text(
            "Foreclosure Means that you want to repay the loan back in full and complete this loan journey. You also agree to pay any foreclosure penalty charges. Foreclosure penalty is ${selectedOffer.prepaymentPenalty}",
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: AppFontSizes.b1,
              fontWeight: AppFontWeights.medium,
              color: Theme.of(context).colorScheme.onPrimary,
              letterSpacing: 0.14,
            ),
          ),
          const SpacerWidget(
            height: 30,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () async {
                    await _forecloseLoan();
                  },
                  child: Container(
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                        "Foreclose",
                        style: TextStyle(
                            fontFamily: fontFamily,
                            fontSize: AppFontSizes.h3,
                            fontWeight: AppFontWeights.medium,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                        "Go Back",
                        style: TextStyle(
                            fontFamily: fontFamily,
                            fontSize: AppFontSizes.h3,
                            fontWeight: AppFontWeights.medium,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SpacerWidget(
            height: 15,
          ),
          _errorOccured
              ? Text(
                  _errorString,
                  style: TextStyle(
                    fontFamily: fontFamily,
                    fontSize: AppFontSizes.h3,
                    fontWeight: AppFontWeights.normal,
                    color: Theme.of(context).colorScheme.error,
                  ),
                )
              : oldLoanStateRef.initiatingForeclosure
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Lottie.asset('assets/animations/loading_spinner.json',
                            height: 50, width: 50),
                        const SpacerWidget(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            "Sending Foreclosure Request. Do not press back or close the app",
                            style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: AppFontSizes.b1,
                              fontWeight: AppFontWeights.normal,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SpacerWidget(),
        ],
      ),
    );
  }
}
