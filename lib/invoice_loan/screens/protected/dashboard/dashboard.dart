import 'package:blocsol_loan_application/invoice_loan/screens/protected/dashboard/gst_consent.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/dashboard/header.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/dashboard/lenders/lending_partners.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/dashboard/liabilities.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/dashboard/request_new_loan.dart';
import 'package:blocsol_loan_application/invoice_loan/shared_components/bottom_nav_bar.dart';
import 'package:blocsol_loan_application/invoice_loan/state/user/profile/profile_details.dart';
import 'package:blocsol_loan_application/utils/regex.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';

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

    var _ = await ref
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
    final profileDetailsRef = ref.watch(invoiceLoanUserProfileDetailsProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        bottomNavigationBar: const InvoiceLoanBottomNavBar(),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: RelativeSize.height(40, height),
          ),
          physics:   RegexProvider.gstRegex.hasMatch(profileDetailsRef.gstNumber) &&
                  !profileDetailsRef.dataConsentProvided
              ? const NeverScrollableScrollPhysics()
              : const BouncingScrollPhysics(),
          child: Stack(
            children: [
              const Column(
                children: [
                  SpacerWidget(
                    height: 40,
                  ),
                  DashboardHeader(),
                  SpacerWidget(
                    height: 27,
                  ),
                  LendersOnBoard(),
                  RequestNewLoanButton(),
                  DashboardLiabilities(),
                ],
              ),
              RegexProvider.gstRegex.hasMatch(profileDetailsRef.gstNumber) &&
                      !profileDetailsRef.dataConsentProvided
                  ? const GstConsentSheet()
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
