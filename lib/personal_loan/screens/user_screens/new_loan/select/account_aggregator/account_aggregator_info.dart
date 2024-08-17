import 'package:blocsol_loan_application/personal_loan/contants/routes/loan_request_router.dart';
import 'package:blocsol_loan_application/personal_loan/contants/theme.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/account_details/account_details.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/events/loan_events/loan_events.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/events/server_sent_events/sse.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PCNewLoanAAInfo extends ConsumerWidget {
  const PCNewLoanAAInfo({super.key});

  void _handleNotificationBellPress() {
    print("Notification Bell Pressed");
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final borrowerAccountDetailsRef = ref.watch(personalLoanAccountDetailsProvider);
    ref.watch(personalLoanEventsProvider);
    ref.watch(personalLoanServerSentEventsProvider);

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
                    vertical: RelativeSize.height(20, height),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
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
                                "Account Aggregator",
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
                                "A new way to share bank account statements digitally",
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
                        height: 30,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: RelativeSize.width(30, width)),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width * 0.75,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 20),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Color.fromRGBO(248, 248, 248, 1),
                          ),
                          child: Image.asset(
                            'assets/images/aa/account_aggregator_process.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SpacerWidget(
                        height: 22,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(horizontal: 45),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Icon(Icons.arrow_forward_ios,
                                        size: 12,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary),
                                  ),
                                ),
                                const SpacerWidget(
                                  width: 12,
                                ),
                                Expanded(
                                  child: Text(
                                    "Share bank statements digitally, securely and instantly",
                                    style: TextStyle(
                                      fontFamily: fontFamily,
                                      fontSize: AppFontSizes.b1,
                                      fontWeight: AppFontWeights.normal,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      letterSpacing: 0.14,
                                    ),
                                    softWrap: true,
                                  ),
                                ),
                              ],
                            ),
                            const SpacerWidget(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Icon(Icons.arrow_forward_ios,
                                        size: 12,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary),
                                  ),
                                ),
                                const SpacerWidget(
                                  width: 12,
                                ),
                                Expanded(
                                  child: Text(
                                    "No branch visits needed",
                                    style: TextStyle(
                                      fontFamily: fontFamily,
                                      fontSize: AppFontSizes.b1,
                                      fontWeight: AppFontWeights.normal,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      letterSpacing: 0.14,
                                    ),
                                    softWrap: true,
                                  ),
                                ),
                              ],
                            ),
                            const SpacerWidget(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Icon(Icons.arrow_forward_ios,
                                        size: 12,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary),
                                  ),
                                ),
                                const SpacerWidget(
                                  width: 12,
                                ),
                                Expanded(
                                  child: Text(
                                    "RBI licensed entities",
                                    style: TextStyle(
                                      fontFamily: fontFamily,
                                      fontSize: AppFontSizes.b1,
                                      fontWeight: AppFontWeights.normal,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      letterSpacing: 0.14,
                                    ),
                                    softWrap: true,
                                  ),
                                ),
                              ],
                            ),
                            const SpacerWidget(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Icon(Icons.arrow_forward_ios,
                                        size: 12,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary),
                                  ),
                                ),
                                const SpacerWidget(
                                  width: 12,
                                ),
                                Expanded(
                                  child: Text(
                                    "Revoke consent at anytime",
                                    style: TextStyle(
                                      fontFamily: fontFamily,
                                      fontSize: AppFontSizes.b1,
                                      fontWeight: AppFontWeights.normal,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      letterSpacing: 0.14,
                                    ),
                                    softWrap: true,
                                  ),
                                ),
                              ],
                            ),
                            const SpacerWidget(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                RichText(
                                  softWrap: true,
                                  text: TextSpan(
                                    text: "Visit",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withOpacity(0.5),
                                      fontSize: AppFontSizes.b2,
                                      fontWeight: AppFontWeights.medium,
                                      letterSpacing: 0.14,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: " Sahamati ",
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontSize: AppFontSizes.b2,
                                          fontWeight: AppFontWeights.medium,
                                          letterSpacing: 0.14,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "or",
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withOpacity(0.5),
                                          fontSize: AppFontSizes.b2,
                                          fontWeight: AppFontWeights.medium,
                                          letterSpacing: 0.14,
                                        ),
                                      ),
                                      TextSpan(
                                        text: " RBI ",
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontSize: AppFontSizes.b2,
                                          fontWeight: AppFontWeights.medium,
                                          letterSpacing: 0.14,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "website to know more",
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withOpacity(0.5),
                                          fontSize: AppFontSizes.b2,
                                          fontWeight: AppFontWeights.medium,
                                          letterSpacing: 0.14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SpacerWidget(
                              height: 35,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    HapticFeedback.mediumImpact();
                                    context.go(PersonalNewLoanRequestRouter
                                        .new_loan_account_aggregator_bank_select);
                                  },
                                  child: Container(
                                    height: RelativeSize.height(40, height),
                                    width: RelativeSize.width(252, width),
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Continue",
                                        style: TextStyle(
                                          fontFamily: fontFamily,
                                          fontSize: AppFontSizes.b1,
                                          fontWeight: AppFontWeights.medium,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                        ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
