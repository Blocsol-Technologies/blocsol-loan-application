import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/theme.dart';
import 'package:blocsol_loan_application/personal_loan/contants/routes/index_router.dart';
import 'package:blocsol_loan_application/personal_loan/contants/routes/loan_request_router.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/components/bottom_navigation_bar.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/components/liability_card.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/account_details/account_details.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/new_loan/new_loan.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/new_loan/state/new_loan_state.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/old_loan/old_loans.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:dio/dio.dart';

class PCHomeScreen extends ConsumerStatefulWidget {
  const PCHomeScreen({super.key});

  @override
  ConsumerState<PCHomeScreen> createState() => _PCHomeScreenState();
}

class _PCHomeScreenState extends ConsumerState<PCHomeScreen> {
  final _cancelToken = CancelToken();

  bool _noOffersFound = false;

  void _handleNotificationBellPress() {
    // TODO: Implement Notification Bell Press
  }

  Future<void> _fetchBorrowerData() async {
    var response = await ref
        .read(personalLoanAccountDetailsProvider.notifier)
        .getBorrowerDetails(_cancelToken);

    if (!mounted) return;

    if (!response.success) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Error!',
          message: response.message,
          contentType: ContentType.failure,
        ),
        duration: const Duration(seconds: 5),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);

      return;
    }

    response = await ref
        .read(personalLoanLiabilitiesProvider.notifier)
        .fetchOffers(_cancelToken);

    if (!mounted) return;

    if ((response.data as List<dynamic>).isEmpty) {
      setState(() {
        _noOffersFound = true;
      });
    }

    setState(() {});
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchBorrowerData();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var oldLoanStateRef = ref.read(personalLoanLiabilitiesProvider);
    var borrowerAccountDetailsRef =
        ref.watch(personalLoanAccountDetailsProvider);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: const BorrowerBottomNavigationBar(),
        body: SizedBox(
          height: height,
          width: width,
          child: Column(
            children: <Widget>[
              // Hero
              SizedBox(
                width: width,
                height: RelativeSize.height(280, height),
                child: Stack(
                  children: [
                    Container(
                      width: width,
                      height: RelativeSize.height(245, height),
                      padding: EdgeInsets.all(RelativeSize.width(30, width)),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
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
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                              const SpacerWidget(
                                width: 25,
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
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Image.network(
                                      borrowerAccountDetailsRef.imageURL.isEmpty
                                          ? "https://placehold.co/30x30/000000/FFFFFF.png"
                                          : borrowerAccountDetailsRef.imageURL,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SpacerWidget(
                            height: 25,
                          ),
                          Text(
                            "Welcome",
                            style: TextStyle(
                                fontFamily: fontFamily,
                                fontSize: AppFontSizes.h1,
                                fontWeight: AppFontWeights.medium,
                                color: Theme.of(context).colorScheme.onPrimary),
                          ),
                          const SpacerWidget(
                            height: 5,
                          ),
                          Text(
                            borrowerAccountDetailsRef.name.isEmpty
                                ? "Loading..."
                                : borrowerAccountDetailsRef.name,
                            style: TextStyle(
                                fontFamily: fontFamily,
                                fontSize: AppFontSizes.h1,
                                fontWeight: AppFontWeights.medium,
                                color: Theme.of(context).colorScheme.onPrimary),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: SizedBox(
                        width: width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            _GetNewLoanButton(
                                screenHeight: height, screenWidth: width)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SpacerWidget(
                height: 10,
              ),

              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: RelativeSize.width(50, width)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "My Loans",
                      style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.b1,
                          fontWeight: AppFontWeights.normal,
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        ref
                            .read(routerProvider)
                            .push(PersonalLoanIndexRouter.liabilities_screen);
                      },
                      child: Text(
                        "Show All",
                        style: TextStyle(
                            fontFamily: fontFamily,
                            fontSize: AppFontSizes.b1,
                            fontWeight: AppFontWeights.medium,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    )
                  ],
                ),
              ),
              const SpacerWidget(
                height: 15,
              ),
              Expanded(
                child: Container(
                    width: width,
                    padding: EdgeInsets.symmetric(
                        horizontal: RelativeSize.width(30, width)),
                    child: _noOffersFound
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Lottie.asset('assets/animations/empty.json',
                                  height: 180, width: 180),
                              const SpacerWidget(
                                height: 20,
                              ),
                              Text(
                                "No Loan Offers Found!",
                                style: TextStyle(
                                    fontFamily: fontFamily,
                                    fontSize: AppFontSizes.h2,
                                    fontWeight: AppFontWeights.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                              ),
                            ],
                          )
                        : oldLoanStateRef.oldLoans.isNotEmpty
                            ? SingleChildScrollView(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: oldLoanStateRef.oldLoans.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                            RelativeSize.width(30, width),
                                      ),
                                      child: PersonalLoanLiabilityCard(
                                        screenHeight: height,
                                        screenWidth: width,
                                        oldLoanDetails:
                                            oldLoanStateRef.oldLoans[index],
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Lottie.asset(
                                      'assets/animations/loading_spinner.json',
                                      height: 150,
                                      width: 150),
                                  const SpacerWidget(
                                    height: 20,
                                  ),
                                  Text(
                                    "Fetching Loan Offers!",
                                    style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.h2,
                                        fontWeight: AppFontWeights.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface),
                                  ),
                                ],
                              )),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _GetNewLoanButton extends ConsumerStatefulWidget {
  final double screenHeight;
  final double screenWidth;
  const _GetNewLoanButton(
      {required this.screenHeight, required this.screenWidth});

  @override
  ConsumerState<_GetNewLoanButton> createState() => _GetNewLoanButtonState();
}

class _GetNewLoanButtonState extends ConsumerState<_GetNewLoanButton> {
  final _cancelToken = CancelToken();

  bool _sendingSearchRequest = false;

  Future<void> _handleGetNewLoan() async {
    if (_sendingSearchRequest) return;

    setState(() {
      _sendingSearchRequest = true;
    });

    var response = await ref
        .read(personalNewLoanRequestProvider.notifier)
        .performGeneralSearch(false, _cancelToken);

    if (!mounted) return;

    setState(() {
      _sendingSearchRequest = false;
    });

    if (response.success) {
      if (response.data['redirection']) {
        await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  title: Text(
                    'Pevious Tx Exists',
                    style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: AppFontSizes.h1,
                      fontWeight: AppFontWeights.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  content: Text(
                    'Do you want to continue your previous action? ${getPreviousTxString(response.data['status'], response.data['state'])}',
                    style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: AppFontSizes.h3,
                      fontWeight: AppFontWeights.medium,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text('Go Back',
                          style: TextStyle(
                            fontFamily: fontFamily,
                            fontSize: AppFontSizes.h1,
                            fontWeight: AppFontWeights.bold,
                            color: Theme.of(context).colorScheme.primary,
                          )),
                    ),
                    TextButton(
                      onPressed: () async {
                        var newResponse = await ref
                            .read(personalNewLoanRequestProvider.notifier)
                            .performGeneralSearch(true, _cancelToken);

                        if (!context.mounted) return;

                        if (mounted) {
                          if (newResponse.success) {
                            context.go(
                                PersonalNewLoanRequestRouter.new_loan_process);
                          } else {
                            final snackBar = SnackBar(
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              content: AwesomeSnackbarContent(
                                title: 'Error!',
                                message: newResponse.message,
                                contentType: ContentType.failure,
                              ),
                            );

                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(snackBar);
                          }
                        }
                      },
                      child: Text('No',
                          style: TextStyle(
                            fontFamily: fontFamily,
                            fontSize: AppFontSizes.h1,
                            fontWeight: AppFontWeights.bold,
                            color: Theme.of(context).colorScheme.primary,
                          )),
                    ),
                    TextButton(
                      onPressed: () {
                        switch (response.data['status']) {
                          case "search":
                            switch (response.data['state']) {
                              case "approved":
                                ref
                                    .read(
                                        personalNewLoanRequestProvider.notifier)
                                    .updateState(PersonalLoanRequestProgress
                                        .formGenerated);
                                context.go(
                                    PersonalNewLoanRequestRouter
                                        .new_loan_account_aggregator_bank_select,
                                    extra: true);
                              case "search_complete":
                                ref
                                    .read(
                                        personalNewLoanRequestProvider.notifier)
                                    .updateState(PersonalLoanRequestProgress
                                        .bankConsent);
                                context.go(PersonalNewLoanRequestRouter
                                    .new_loan_process);
                              default:
                                context.go(PersonalNewLoanRequestRouter
                                    .new_loan_process);
                            }
                          case "select":
                            switch (response.data['state']) {
                              case "on_select_02":
                                ref
                                    .read(
                                        personalNewLoanRequestProvider.notifier)
                                    .updateState(PersonalLoanRequestProgress
                                        .loanOfferSelect);
                                context.go(PersonalNewLoanRequestRouter
                                    .new_loan_process);

                              default:
                                ref
                                    .read(
                                        personalNewLoanRequestProvider.notifier)
                                    .updateState(PersonalLoanRequestProgress
                                        .bankConsent);
                                context.go(PersonalNewLoanRequestRouter
                                    .new_loan_process);
                            }

                          case "init":
                            switch (response.data['state']) {
                              case "on_init_01":
                                ref
                                    .read(
                                        personalNewLoanRequestProvider.notifier)
                                    .updateState(
                                        PersonalLoanRequestProgress.aadharKYC);
                                context.go(PersonalNewLoanRequestRouter
                                    .new_loan_process);
                              case "on_init_02":
                                ref
                                    .read(
                                        personalNewLoanRequestProvider.notifier)
                                    .updateState(PersonalLoanRequestProgress
                                        .bankAccountDetails);
                                context.go(PersonalNewLoanRequestRouter
                                    .new_loan_process);
                              case "on_init_03":
                                ref
                                    .read(
                                        personalNewLoanRequestProvider.notifier)
                                    .updateState(PersonalLoanRequestProgress
                                        .repaymentSetup);
                                context.go(PersonalNewLoanRequestRouter
                                    .new_loan_process);
                              default:
                                ref
                                    .read(
                                        personalNewLoanRequestProvider.notifier)
                                    .updateState(
                                        PersonalLoanRequestProgress.aadharKYC);
                                context.go(PersonalNewLoanRequestRouter
                                    .new_loan_process);
                            }
                        }
                      },
                      child: Text('Yes',
                          style: TextStyle(
                            fontFamily: fontFamily,
                            fontSize: AppFontSizes.h1,
                            fontWeight: AppFontWeights.bold,
                            color: Theme.of(context).colorScheme.primary,
                          )),
                    ),
                  ]);
            });
      } else {
        context.go(PersonalNewLoanRequestRouter.new_loan_process);
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
    }
    return;
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        _handleGetNewLoan();
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
