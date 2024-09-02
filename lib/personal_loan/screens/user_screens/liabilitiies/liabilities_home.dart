import 'package:blocsol_loan_application/personal_loan/constants/routes/index_router.dart';
import 'package:blocsol_loan_application/personal_loan/constants/theme.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/components/bottom_navigation_bar.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/components/liability_card.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/account_details/account_details.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/old_loan/old_loans.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PCLiabilityHome extends ConsumerStatefulWidget {
  const PCLiabilityHome({super.key});

  @override
  ConsumerState<PCLiabilityHome> createState() => _PCLiabilityHomeState();
}

class _PCLiabilityHomeState extends ConsumerState<PCLiabilityHome> {
  void _handleNotificationBellPress() {
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final oldLoanStateRef = ref.watch(personalLoanLiabilitiesProvider);
    final borrowerAccountDetailsRef =
        ref.watch(personalLoanAccountDetailsProvider);

    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          bottomNavigationBar: const BorrowerBottomNavigationBar(),
          body: SizedBox(
            child: Stack(
              children: [
                Container(
                  width: width,
                  height: RelativeSize.height(235, height),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: RelativeSize.height(30, height),
                          left: RelativeSize.width(30, width),
                          right: RelativeSize.width(30, width)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              
                              context.go(PersonalLoanIndexRouter.dashboard);
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
                            const SpacerWidget(
                              height: 10,
                            ),
                            Text(
                              "Keep a track of your loans easily.",
                              style: TextStyle(
                                fontFamily: fontFamily,
                                fontSize: AppFontSizes.b1,
                                fontWeight: AppFontWeights.normal,
                                color: Theme.of(context).colorScheme.onPrimary,
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
                      height: 40,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: oldLoanStateRef.oldLoans.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: RelativeSize.width(30, width),
                              ),
                              child: PersonalLoanLiabilityCard(
                                screenHeight: height,
                                screenWidth: width,
                                oldLoanDetails: oldLoanStateRef.oldLoans[index],
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
