import 'package:blocsol_loan_application/global_state/internet_check/internet_check.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/dashboard/gst_consent.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/dashboard/header.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/dashboard/lenders/lending_partners.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/dashboard/liabilities.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/dashboard/request_new_loan.dart';
import 'package:blocsol_loan_application/invoice_loan/shared_components/bottom_nav_bar.dart';
import 'package:blocsol_loan_application/invoice_loan/state/user/profile/profile_details.dart';
import 'package:blocsol_loan_application/utils/regex.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InvoiceLoanDashboard extends ConsumerStatefulWidget {
  const InvoiceLoanDashboard({super.key});

  @override
  ConsumerState<InvoiceLoanDashboard> createState() =>
      _InvoiceLoanDashboardState();
}

class _InvoiceLoanDashboardState extends ConsumerState<InvoiceLoanDashboard> {
  final _cancelToken = CancelToken();

  Future<void> _handleRefresh() async {
    if (ref.read(invoiceLoanUserProfileDetailsProvider).fetchingData) {
      return;
    }

    await ref
        .read(invoiceLoanUserProfileDetailsProvider.notifier)
        .getCompanyDetails(_cancelToken);
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
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final profileDetailsRef = ref.watch(invoiceLoanUserProfileDetailsProvider);
    bool isInternetConnected = ref.watch(internetCheckProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        bottomNavigationBar: const InvoiceLoanBottomNavBar(),
        body: Stack(
          children: [
            LiquidPullToRefresh(
              color: Theme.of(context).colorScheme.surface,
              backgroundColor: Theme.of(context).colorScheme.primary,
              showChildOpacityTransition: false,
              onRefresh: () async {
                await _handleRefresh();
              },
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: RelativeSize.height(40, height),
                ),
                physics: RegexProvider.gstRegex
                            .hasMatch(profileDetailsRef.gstNumber) &&
                        !profileDetailsRef.dataConsentProvided
                    ? const NeverScrollableScrollPhysics()
                    : const BouncingScrollPhysics(),
                child: Stack(
                  children: [
                    const Column(
                      children: [
                        SpacerWidget(
                          height: 35,
                        ),
                        DashboardHeader(),
                        SpacerWidget(
                          height: 20,
                        ),
                        LendersOnBoard(),
                        RequestNewLoanButton(),
                        DashboardLiabilities(),
                      ],
                    ),
                    RegexProvider.gstRegex
                                .hasMatch(profileDetailsRef.gstNumber) &&
                            !profileDetailsRef.dataConsentProvided
                        ? const GstConsentSheet()
                        : const SizedBox()
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
