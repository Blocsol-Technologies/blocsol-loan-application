import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:blocsol_loan_application/personal_loan/contants/routes/loan_request_router.dart';
import 'package:blocsol_loan_application/personal_loan/contants/theme.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/account_details/account_details.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/events/loan_events/loan_events.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/events/server_sent_events/sse.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/new_loan/new_loan.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class PCNewLoanDataConsent extends ConsumerStatefulWidget {
  const PCNewLoanDataConsent({super.key});

  @override
  ConsumerState<PCNewLoanDataConsent> createState() =>
      _PCNewLoanDataConsentState();
}

class _PCNewLoanDataConsentState extends ConsumerState<PCNewLoanDataConsent> {
  final _cancelToken = CancelToken();

  bool _consentProvided = false;
  bool _addingConsentArtifact = false;

  void _handleNotificationBellPress() {
    print("Notification Bell Pressed");
  }

  Future<void> _provideConsent() async {
    if (_addingConsentArtifact) return;

    if (!_consentProvided) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Error!',
          message: "Please provide consent to continue.",
          contentType: ContentType.failure,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
      return;
    }

    var response = await ref
        .read(personalNewLoanRequestProvider.notifier)
        .provideDataConsent(_cancelToken);

    if (!mounted) return;

    setState(() {
      _addingConsentArtifact = true;
    });

    if (response.success) {
      context.go(PersonalNewLoanRequestRouter.new_loan_personal_details_form);
      return;
    }

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

  @override
  void dispose() {
    _cancelToken.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final borrowerAccountDetailsRef =
        ref.watch(personalLoanAccountDetailsProvider);
   ref.watch(personalLoanServerSentEventsProvider);
   ref.watch(personalLoanEventsProvider);
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Stack(
              children: [
                Container(
                  width: width,
                  height: RelativeSize.height(250, height),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: RelativeSize.height(20, height)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: RelativeSize.width(30, width)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                HapticFeedback.mediumImpact();
                                context.go(PersonalNewLoanRequestRouter.new_loan_process);
                              },
                              child: Icon(
                                Icons.arrow_back_ios,
                                size: 20,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                            SizedBox(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  IconButton(
                                    onPressed: () {
                                      HapticFeedback.mediumImpact();
                                      _handleNotificationBellPress();
                                    },
                                    icon: Icon(
                                      Icons.notifications_active,
                                      size: 25,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                                  ),
                                  const SpacerWidget(
                                    width: 15,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      HapticFeedback.mediumImpact();
                                    },
                                    child: Container(
                                      height: 28,
                                      width: 28,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Image.network(
                                          borrowerAccountDetailsRef
                                                  .imageURL.isEmpty
                                              ? "https://placehold.co/30x30/000000/FFFFFF.png"
                                              : borrowerAccountDetailsRef
                                                  .imageURL,
                                          fit: BoxFit.cover,
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
                      const SpacerWidget(
                        height: 30,
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
                              Text(
                                "Share Consent",
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
                              const SpacerWidget(
                                height: 10,
                              ),
                              Text(
                                "Provide consent to share your Data",
                                style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: AppFontSizes.b1,
                                  fontWeight: AppFontWeights.normal,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  letterSpacing: 0.24,
                                ),
                                textAlign: TextAlign.center,
                                softWrap: true,
                              ),
                              Text(
                                "Allow lenders to fetch CIC data.",
                                style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: AppFontSizes.b1,
                                  fontWeight: AppFontWeights.normal,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  letterSpacing: 0.24,
                                ),
                                textAlign: TextAlign.center,
                                softWrap: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SpacerWidget(
                        height: 25,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: RelativeSize.width(30, width)),
                        child: Container(
                          width: width,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(248, 248, 248, 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: RelativeSize.height(16, height),
                              horizontal: RelativeSize.width(20, width)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Credit Information Data Sharing Consent",
                                style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: AppFontSizes.h3,
                                  fontWeight: AppFontWeights.bold,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  letterSpacing: 0.13,
                                ),
                              ),
                              const SpacerWidget(
                                height: 5,
                              ),
                              Text(
                                "You hereby undertake and confirm that the information and data furnished by you to the platform is true and correct. The platform has been integrated with lenders who use Credit Information Companies (CIC) to conduct credit checks on b1 corporates/MSME and Individuals. You acknowledge and confirm that you have consented to the sharing of sensitive data provided by you with such lenders and CICs for the purposes of obtaining the name and account number of banks with whom you have an open cash credit or overdraft account. In addition, you consent to the data being used to facilitate the creation of a credit offer which may include the account to which the funds may be disbursed as per prevailing RBI norms.",
                                style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: AppFontSizes.b1,
                                  fontWeight: AppFontWeights.normal,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  letterSpacing: 0.1,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SpacerWidget(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: RelativeSize.width(30, width)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Checkbox(
                              fillColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                if (!states.contains(MaterialState.selected)) {
                                  return Colors.red;
                                }
                                // Color when not selected
                                return Theme.of(context)
                                    .colorScheme
                                    .primary; // Default or any color when selected
                              }),
                              checkColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              value: _consentProvided,
                              onChanged: (_) {
                                setState(() {
                                  _consentProvided = !_consentProvided;
                                });
                              },
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            Expanded(
                              child: Text(
                                'I understand and agree to buyer app’s Terms',
                                style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: AppFontSizes.b1,
                                  fontWeight: AppFontWeights.normal,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SpacerWidget(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <GestureDetector>[
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.heavyImpact();
                              _provideConsent();
                            },
                            child: Container(
                              width: RelativeSize.width(252, width),
                              height: RelativeSize.height(40, height),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                child: _addingConsentArtifact
                                    ? Lottie.asset(
                                        'assets/animations/loading_spinner.json',
                                        height: 50,
                                        width: 50)
                                    : Text(
                                        "Continue",
                                        style: TextStyle(
                                            fontFamily: fontFamily,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                            fontSize: AppFontSizes.b1,
                                            fontWeight: AppFontWeights.medium),
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
