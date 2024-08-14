import 'package:blocsol_loan_application/global_state/theme/theme_state.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/liabilities/utils/top_decoration.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/shared/liability_card.dart';
import 'package:blocsol_loan_application/invoice_loan/shared_components/bottom_nav_bar.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/liability/all/all_liabilities.dart';
import 'package:blocsol_loan_application/invoice_loan/state/user/profile/profile_details.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class InvoiceLoanLiabilitiesHome extends ConsumerStatefulWidget {
  const InvoiceLoanLiabilitiesHome({super.key});

  @override
  ConsumerState<InvoiceLoanLiabilitiesHome> createState() =>
      _InvoiceLoanLiabilitiesHomeState();
}

class _InvoiceLoanLiabilitiesHomeState
    extends ConsumerState<InvoiceLoanLiabilitiesHome> {
  final _cancelToken = CancelToken();

  void _handleNotificationBellPress() {}

  Future<void> _handleRefresh() async {
    if (ref.read(invoiceLoanLiabilitiesProvider).fetchingLiabilitiess) {
      return;
    }

    await ref
        .read(invoiceLoanLiabilitiesProvider.notifier)
        .fetchAllLiabilities(_cancelToken);

    await ref
        .read(invoiceLoanLiabilitiesProvider.notifier)
        .fetchAllClosedLiabilities(_cancelToken);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleRefresh();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final liabiliiesStateRef = ref.watch(invoiceLoanLiabilitiesProvider);
    final companyDetailsRef = ref.watch(invoiceLoanUserProfileDetailsProvider);

    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          bottomNavigationBar: const InvoiceLoanBottomNavBar(),
          body: SizedBox(
            child: Stack(
              children: [
                const LiabilityTopDecoration(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: RelativeSize.height(30, height),
                          left: RelativeSize.width(30, width),
                          right: RelativeSize.width(30, width)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
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
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                      child: Text(
                                    companyDetailsRef.tradeName[0],
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontSize: AppFontSizes.h3,
                                        fontWeight: AppFontWeights.bold,
                                        letterSpacing: 0.14,
                                        fontFamily: fontFamily),
                                  )),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SpacerWidget(
                      height: 25,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: RelativeSize.width(30, width),
                          right: RelativeSize.width(30, width)),
                      child: SizedBox(
                        width: width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Your Loans",
                              style: TextStyle(
                                fontFamily: fontFamily,
                                fontSize: AppFontSizes.h1,
                                fontWeight: AppFontWeights.medium,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                              textAlign: TextAlign.center,
                              softWrap: true,
                            ),
                            Text(
                              "GST: ${companyDetailsRef.gstNumber}",
                              style: TextStyle(
                                fontFamily: fontFamily,
                                fontSize: AppFontSizes.h3,
                                fontWeight: AppFontWeights.normal,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimary
                                    .withOpacity(0.75),
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
                      height: 75,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: liabiliiesStateRef.fetchingLiabilitiess
                            ? SizedBox(
                                width: width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Lottie.asset(
                                      'assets/animations/searching_data.json',
                                      width:
                                          (MediaQuery.of(context).size.width -
                                                  40) *
                                              0.85,
                                    ),
                                    const SpacerWidget(
                                      height: 30,
                                    ),
                                    Text(
                                      "Fetching Loan Data",
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        fontSize: AppFontSizes.h2,
                                        fontWeight: AppFontWeights.bold,
                                        letterSpacing: 0.14,
                                      ),
                                      textAlign: TextAlign.center,
                                      softWrap: true,
                                    ),
                                  ],
                                ),
                              )
                            : liabiliiesStateRef.liabilities.isEmpty
                                ? SizedBox(
                                    width: width,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Lottie.asset(
                                          'assets/animations/invoice_offer_not_found.json',
                                          width: (MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  40) *
                                              0.85,
                                        ),
                                        Text(
                                          "No Loans Found",
                                          style: TextStyle(
                                            fontFamily: fontFamily,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            fontSize: AppFontSizes.h2,
                                            fontWeight: AppFontWeights.bold,
                                            letterSpacing: 0.14,
                                          ),
                                          textAlign: TextAlign.center,
                                          softWrap: true,
                                        ),
                                        Text(
                                          "Get a New Loan!",
                                          style: TextStyle(
                                            fontFamily: fontFamily,
                                            color: const Color.fromRGBO(
                                                151, 151, 151, 1),
                                            fontSize: AppFontSizes.b1,
                                            fontWeight: AppFontWeights.bold,
                                            letterSpacing: 0.14,
                                          ),
                                          textAlign: TextAlign.center,
                                          softWrap: true,
                                        ),
                                      ],
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount:
                                        liabiliiesStateRef.liabilities.length,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal:
                                              RelativeSize.width(30, width),
                                        ),
                                        child: LiabilityCard(
                                          oldLoanDetails: liabiliiesStateRef
                                              .liabilities[index],
                                        ),
                                      );
                                    },
                                  ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
