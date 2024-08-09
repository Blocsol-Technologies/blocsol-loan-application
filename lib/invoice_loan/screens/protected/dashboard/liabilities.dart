import 'dart:async';

import 'package:blocsol_loan_application/invoice_loan/screens/protected/shared/liability_card.dart';
import 'package:blocsol_loan_application/invoice_loan/state/loans/liability/all/all_liabilities.dart';
import 'package:blocsol_loan_application/personal_loan/contants/theme.dart';
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

    await Future.delayed(const Duration(seconds: 5));

    if (mounted && context.mounted) {
      await _fetchLiabilities();
    }
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
              "Liabilities",
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
          SizedBox(
            width: width,
            height: RelativeSize.height(200, height),
            child: liabilitiesRef.liabilities.isEmpty
                ? Center(
                    child: Lottie.asset(
                        "assets/animations/loading_spinner.json",
                        height: 50,
                        width: 50),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: liabilitiesRef.liabilities.length,
                    itemBuilder: (ctx, idx) {
                      return Container(
                        height: RelativeSize.height(200, height),
                        margin: const EdgeInsets.only(right: 30),
                        child: LiabilityCard(
                          oldLoanDetails: liabilitiesRef.liabilities[idx],
                        ),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}
