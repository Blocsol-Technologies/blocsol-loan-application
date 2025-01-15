import 'package:blocsol_loan_application/invoice_loan/screens/protected/profile/account_aggregator/account_aggregator_box.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/profile/components/curved_background.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/profile/components/top_nav_bar.dart';
import 'package:blocsol_loan_application/invoice_loan/state/user/profile/profile_details.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/theme.dart';
import 'package:blocsol_loan_application/utils/lender_utils.dart';
import 'package:blocsol_loan_application/utils/logger.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/snackbar_notifications/util.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class InvoiceLoanProfileAASelect extends ConsumerStatefulWidget {
  final List<AccountAggregatorInfo> aaList;
  const InvoiceLoanProfileAASelect({super.key, required this.aaList});

  @override
  ConsumerState<InvoiceLoanProfileAASelect> createState() =>
      _InvoiceLoanprofileAASelectState();
}

class _InvoiceLoanprofileAASelectState
    extends ConsumerState<InvoiceLoanProfileAASelect> {
  final _cancelToken = CancelToken();

  bool _updatingAA = false;
  int _selectedIndex = -1;

  Future<void> _updateAccountAggregator() async {
    if (_selectedIndex == -1) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: getSnackbarNotificationWidget(
            message: "Please select an account aggregator to continue",
            notifType: SnackbarNotificationType.error),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);

      return;
    }

    final accountAggregatorName = widget.aaList[_selectedIndex].key;

    var response = await ref
        .read(invoiceLoanUserProfileDetailsProvider.notifier)
        .updateAccountAggregator(accountAggregatorName, _cancelToken);

    if (!mounted || !context.mounted) return;

    logFirebaseEvent("invoice_loan_profile", {
      "step": "updating_account_aggregator",
      "gst": ref.read(invoiceLoanUserProfileDetailsProvider).gstNumber,
      "success": response.success,
      "message": response.message,
      "data": response.data ?? {},
    });

    if (!response.success) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: getSnackbarNotificationWidget(
            message: response.message,
            notifType: SnackbarNotificationType.error),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    } else {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: getSnackbarNotificationWidget(
            message: response.message,
            notifType: SnackbarNotificationType.success),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }

    return;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      String aaId =
          ref.read(invoiceLoanUserProfileDetailsProvider).accountAggregatorId;

      String aaName = aaId.split("@").last.toUpperCase();

      int initialIndex =
          widget.aaList.indexWhere((element) => element.key == aaName);

      setState(() {
        _selectedIndex = initialIndex;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final _ = ref.watch(invoiceLoanUserProfileDetailsProvider);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            vertical: RelativeSize.height(25, height),
            horizontal: RelativeSize.width(25, width),
          ),
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const InvoiceLoanProfileTopNav(),
              const SpacerWidget(
                height: 35,
              ),
              Text(
                "Account Aggregator",
                style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: AppFontSizes.h2,
                  fontWeight: AppFontWeights.medium,
                  color: Theme.of(context).colorScheme.onTertiary,
                ),
              ),
              const SpacerWidget(
                height: 12,
              ),
              Text(
                "Choose one of the RBI approved Account Aggregators to share your financial information",
                textAlign: TextAlign.center,
                softWrap: true,
                style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: AppFontSizes.b2,
                  fontWeight: AppFontWeights.normal,
                  color: const Color.fromRGBO(80, 80, 80, 1),
                ),
              ),
              const SpacerWidget(
                height: 25,
              ),
              CurvedBackground(
                horizontalPadding: 11,
                child: Column(
                  children: [
                    SizedBox(
                      height: RelativeSize.height(380, height),
                      child: widget.aaList.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount: widget.aaList.length,
                              itemBuilder: (ctx, idx) {
                                AccountAggregatorInfo aa = widget.aaList[idx];

                                return AccountAggregatorBox(
                                  aaInfo: aa,
                                  index: idx,
                                  selectedIndex: _selectedIndex,
                                  onClick: () {
                                    setState(() {
                                      _selectedIndex = idx;
                                    });
                                  },
                                );
                              },
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Lottie.asset("assets/animations/404.json",
                                    height: 150, width: 150),
                                const SpacerWidget(
                                  height: 20,
                                ),
                                Text(
                                  "No account aggregators linked with your current bank account found",
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: fontFamily,
                                    fontSize: AppFontSizes.b1,
                                    fontWeight: AppFontWeights.medium,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                )
                              ],
                            ),
                    ),
                    const SpacerWidget(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () async {
                        HapticFeedback.heavyImpact();

                        if (_updatingAA) {
                          return;
                        }

                        setState(() {
                          _updatingAA = true;
                        });

                        await _updateAccountAggregator();

                        if (!mounted || !context.mounted) return;

                        setState(() {
                          _updatingAA = false;
                        });
                      },
                      child: Container(
                        height: 40,
                        width: RelativeSize.width(252, width),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: _updatingAA
                              ? Lottie.asset(
                                  "assets/animations/loading_spinner.json",
                                  height: 40)
                              : Text(
                                  "Save",
                                  style: TextStyle(
                                    fontFamily: fontFamily,
                                    fontSize: AppFontSizes.b1,
                                    fontWeight: AppFontWeights.medium,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
