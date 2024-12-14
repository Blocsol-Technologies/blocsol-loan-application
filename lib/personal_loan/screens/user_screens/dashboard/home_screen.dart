import 'package:blocsol_loan_application/global_state/internet_check/internet_check.dart';
import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/theme.dart';
import 'package:blocsol_loan_application/personal_loan/constants/routes/index_router.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/components/bottom_navigation_bar.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/components/liability_card.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/dashboard/get_new_loan_button.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/account_details/account_details.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/old_loan/old_loans.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/snackbar_notifications/util.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    ref.read(routerProvider).push(PersonalLoanIndexRouter.notifications);
  }

  Future<void> _fetchBorrowerData() async {

    // Adding slight delay to properly sync data fetch on the dashboard
    await Future.delayed(const Duration(seconds: 2));

    var response = await ref
        .read(personalLoanAccountDetailsProvider.notifier)
        .getBorrowerDetails(_cancelToken);

    if (!mounted) return;

    if (!response.success) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: getSnackbarNotificationWidget(
            message: response.message,
            notifType: SnackbarNotificationType.error),
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
    bool isInternetConnected = ref.watch(internetCheckProvider);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: const BorrowerBottomNavigationBar(),
        body: Stack(
          children: [
              LiquidPullToRefresh(
              color: Theme.of(context).colorScheme.surface,
              backgroundColor: Theme.of(context).colorScheme.primary,
              showChildOpacityTransition: false,
              onRefresh: () async {
                await _fetchBorrowerData();
              },
              child: SizedBox(
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
                            padding:
                                EdgeInsets.all(RelativeSize.width(30, width)),
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
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      ),
                                    ),
                                    const SpacerWidget(
                                      width: 25,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        HapticFeedback.mediumImpact();
                                        ref.read(routerProvider).push(PersonalLoanIndexRouter.profile_screen);
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
                                const SpacerWidget(
                                  height: 25,
                                ),
                                Text(
                                  "Welcome",
                                  style: TextStyle(
                                      fontFamily: fontFamily,
                                      fontSize: AppFontSizes.h1,
                                      fontWeight: AppFontWeights.medium,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
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
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
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
                                  GetNewPersonalLoanButton(
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
                              ref.read(routerProvider).push(
                                  PersonalLoanIndexRouter.liabilities_screen);
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
                                        itemCount:
                                            oldLoanStateRef.oldLoans.length,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
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
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: isInternetConnected
                  ? const SizedBox()
                  : Container(
                      width: width,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.error,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'No internet connection',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: AppFontSizes.b1,
                              fontWeight: AppFontWeights.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

