import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/routes/index_router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/theme.dart';
import 'package:blocsol_loan_application/invoice_loan/state/user/liability_details/liability_details.dart';
import 'package:blocsol_loan_application/invoice_loan/state/user/profile/profile_details.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/snackbar_notifications/util.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardHeader extends ConsumerStatefulWidget {
  const DashboardHeader({super.key});

  @override
  ConsumerState<DashboardHeader> createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends ConsumerState<DashboardHeader> {
  Future<void> _fetchLiabilitiesData() async {
    if (ref
        .read(invoiceLoanUserLiabilityDetailsProvider)
        .fetchingLiabilityDetails) {
      return;
    }

    final cancelToken = CancelToken();

    var response = await ref
        .read(invoiceLoanUserLiabilityDetailsProvider.notifier)
        .getLiabilityDetails(cancelToken);

    if (!mounted || !context.mounted) return;

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

      return;
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchLiabilitiesData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final detailsRef = ref.watch(invoiceLoanUserProfileDetailsProvider);
    final liabilitiesRef = ref.watch(invoiceLoanUserLiabilityDetailsProvider);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: RelativeSize.width(30, width)),
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30,
                      width: 30,
                      child: Image.asset(
                        "assets/images/invoice_loan/dashboard/header/user_icon.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SpacerWidget(
                      width: 12,
                    ),
                    Text(
                      'Hi, ${detailsRef.legalName}!',
                      softWrap: true,
                      style: TextStyle(
                        fontFamily: fontFamily,
                        fontSize: AppFontSizes.h2,
                        fontWeight: AppFontWeights.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    )
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  ref.read(routerProvider).push(InvoiceLoanIndexRouter.profile);

                  return;
                },
                icon: Icon(
                  Icons.person_4_rounded,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 25,
                ),
              )
            ],
          ),
          const SpacerWidget(
            height: 25,
          ),
          liabilitiesRef.fetchingLiabilityDetails &&
                  liabilitiesRef.numOpenLiabilities < 0
              ? Text(
                  "Fetching Details...",
                  style: TextStyle(
                    fontFamily: fontFamily,
                    fontSize: AppFontSizes.h3,
                    fontWeight: AppFontWeights.medium,
                    color: const Color.fromRGBO(85, 85, 85, 1),
                  ),
                )
              : Text(
                  liabilitiesRef.numOpenLiabilities > 0
                      ? "You have ${liabilitiesRef.numOpenLiabilities} active loans"
                      : "You do not have any outstanding loans",
                  style: TextStyle(
                    fontFamily: fontFamily,
                    fontSize: AppFontSizes.h3,
                    fontWeight: AppFontWeights.medium,
                    color: const Color.fromRGBO(85, 85, 85, 1),
                  ),
                ),
          const SpacerWidget(
            height: 15,
          ),
          RichText(
            text: TextSpan(
              text: "₹ ",
              style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: AppFontSizes.h3,
                  fontWeight: AppFontWeights.medium,
                  color: Theme.of(context).colorScheme.onSurface),
              children: [
                liabilitiesRef.fetchingLiabilityDetails &&
                        liabilitiesRef.numOpenLiabilities < 0
                    ? TextSpan(
                        text: "Loading...",
                        style: TextStyle(
                            fontFamily: fontFamily,
                            fontSize: AppFontSizes.h2,
                            fontWeight: AppFontWeights.bold,
                            color: Theme.of(context).colorScheme.onSurface),
                      )
                    : TextSpan(
                        text: liabilitiesRef.numOutstandingValue
                            .toStringAsFixed(2),
                        style: TextStyle(
                            fontFamily: fontFamily,
                            fontSize: AppFontSizes.h2,
                            fontWeight: AppFontWeights.bold,
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
