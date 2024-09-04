import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/global_state/theme/theme_state.dart';
import 'package:blocsol_loan_application/personal_loan/constants/routes/loan_request_router.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/new_loan/common/loan_service_errors/error_codes.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/new_loan/components/top_nav.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/events/loan_events/loan_events.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/events/server_sent_events/sse.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/new_loan/new_loan.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class PCKycVerified extends ConsumerStatefulWidget {
  const PCKycVerified({super.key});

  @override
  ConsumerState<PCKycVerified> createState() =>
      _PCKycVerifiedScreenState();
}

class _PCKycVerifiedScreenState
    extends ConsumerState<PCKycVerified> {
  final _cancelToken = CancelToken();

  void _performNextSteps() async {
    if (ref.read(personalNewLoanRequestProvider).verifyingAadharKYC) {
      return;
    }

    await Future.delayed(const Duration(seconds: 5));

     var response = await ref
          .read(personalNewLoanRequestProvider.notifier)
          .checkAadharKYCSuccess(_cancelToken);

      if (!response.success) {
        ref.read(routerProvider).push(
            PersonalNewLoanRequestRouter.loan_service_error,
            extra: PersonalLoanServiceErrorCodes.aadhar_kyc_failed);
      }
      return;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _performNextSteps();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    ref.watch(personalLoanServerSentEventsProvider);
    ref.watch(personalLoanEventsProvider);
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(
                20, RelativeSize.height(30, height), 20, 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                PersonalNewLoanRequestTopNav(onBackClick: () {
                  ref.read(routerProvider).pop();
                }),
                const SpacerWidget(
                  height: 80,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Lottie.asset(
                      'assets/animations/ok.json',
                      width: (width - 40),
                    ),
                  ],
                ),
                const SpacerWidget(
                  height: 60,
                ),
                SizedBox(
                  width: width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Aadhar KYC Verified",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: AppFontSizes.heading,
                          fontWeight: AppFontWeights.bold,
                          letterSpacing: 0.14,
                        ),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                      const SpacerWidget(
                        height: 5,
                      ),
                      Text(
                        "Performing next steps",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          color: const Color.fromRGBO(130, 130, 130, 1),
                          fontSize: AppFontSizes.h3,
                          fontWeight: AppFontWeights.medium,
                          letterSpacing: 0.14,
                        ),
                        textAlign: TextAlign.center,
                        softWrap: true,
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
