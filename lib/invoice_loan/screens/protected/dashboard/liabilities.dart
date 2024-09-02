import 'dart:async';

import 'package:blocsol_loan_application/invoice_loan/shared_components/liability_card.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/liability/all/all_liabilities.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/theme.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class DashboardLiabilities extends ConsumerStatefulWidget {
  const DashboardLiabilities({super.key});

  @override
  ConsumerState<DashboardLiabilities> createState() =>
      _DashboardLiabilitiesState();
}

class _DashboardLiabilitiesState extends ConsumerState<DashboardLiabilities> {
  final _cancelToken = CancelToken();

  Future<void> _fetchLiabilities() async {
    await ref
        .read(invoiceLoanLiabilitiesProvider.notifier)
        .fetchAllLiabilities(_cancelToken);

    // await Future.delayed(const Duration(seconds: 5));

    // if (mounted && context.mounted) {
    //   await _fetchLiabilities();
    // }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchLiabilities();
    });
    super.initState();
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
    final liabilitiesRef = ref.watch(invoiceLoanLiabilitiesProvider);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: RelativeSize.width(30, width)),
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "Loans",
              style: TextStyle(
                fontFamily: fontFamily,
                fontSize: AppFontSizes.h3,
                fontWeight: AppFontWeights.medium,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          const SpacerWidget(
            height: 10,
          ),
          liabilitiesRef.liabilities.isEmpty
              ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  height: RelativeSize.height(180, height),
                  width: width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Lottie.asset(
                          "assets/animations/invoice_offer_not_found.json",
                          height: 130,
                          width: 130),
                      Text(
                        "No Offers Found",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.h3,
                          fontWeight: AppFontWeights.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                       Text(
                        "Get A Loan Now!",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.b1,
                          fontWeight: AppFontWeights.normal,
                          color: const Color.fromRGBO(151, 151, 151, 1),
                        ),
                      )
                    ],
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: liabilitiesRef.liabilities.length > 5
                      ? 5
                      : liabilitiesRef.liabilities.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (ctx, idx) {
                    return LiabilityCard(
                      oldLoanDetails: liabilitiesRef.liabilities[idx],
                    );
                  },
                )
        ],
      ),
    );
  }
}
