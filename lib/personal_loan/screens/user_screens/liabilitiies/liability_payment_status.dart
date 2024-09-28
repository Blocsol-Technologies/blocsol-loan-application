import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/personal_loan/constants/routes/liabilities_router.dart';
import 'package:blocsol_loan_application/personal_loan/constants/theme.dart';
import 'package:blocsol_loan_application/personal_loan/state/user/old_loan/old_loans.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:blocsol_loan_application/utils/functions.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonalLoanliabilityPaymentStatus extends ConsumerWidget {
  final bool success;

  const PersonalLoanliabilityPaymentStatus({super.key, required this.success});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final liabilityref = ref.watch(personalLoanLiabilitiesProvider);
    final selectedPaymentDetails = ref
        .watch(personalLoanLiabilitiesProvider.notifier)
        .getPaymentSuccessDetails();

    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            padding: EdgeInsets.only(top: RelativeSize.height(30, height)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
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
                          ref.read(routerProvider).pushReplacement(
                              PersonalLoanLiabilitiesRouter
                                  .liability_details_home);
                        },
                        child: Icon(
                          Icons.arrow_back,
                          size: 20,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                const SpacerWidget(
                  height: 50,
                ),
                SizedBox(
                  height: RelativeSize.width(120, width),
                  width: RelativeSize.width(120, width),
                  child: Center(
                    child: success
                        ? Image.asset(
                            "assets/images/success.png",
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            "assets/images/error.png",
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                const SpacerWidget(
                  height: 25,
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Color.fromRGBO(190, 190, 190, 1),
                              width: 2))),
                  child: Text(
                    "Payment ${success ? "Successful" : "Failed"}",
                    style: TextStyle(
                      fontFamily: fontFamily,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: AppFontWeights.bold,
                      fontSize: AppFontSizes.h2,
                    ),
                  ),
                ),
                const SpacerWidget(
                  height: 10,
                ),
                Text(
                  getFormattedTime(selectedPaymentDetails.dueDate),
                  style: TextStyle(
                    fontFamily: fontFamily,
                    color: const Color.fromRGBO(100, 100, 100, 1),
                    fontWeight: AppFontWeights.bold,
                    fontSize: AppFontSizes.h3,
                  ),
                ),
                const SpacerWidget(
                  height: 22,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: RelativeSize.width(50, width),
                  ),
                  child: ClipPath(
                    clipper: BottomClipper(),
                    child: Container(
                      width: width,
                      height: 130,
                      padding: EdgeInsets.only(
                          left: RelativeSize.width(25, width),
                          right: RelativeSize.width(25, width),
                          top: 30,
                          bottom: 10),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.tertiary),
                      child: Container(
                        height: height,
                        width: width,
                        decoration: BoxDecoration(
                          border: DashedBorder(
                            dashLength: 10,
                            bottom: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Amount",
                                  style: TextStyle(
                                    fontFamily: fontFamily,
                                    fontSize: AppFontSizes.b2,
                                    fontWeight: AppFontWeights.medium,
                                    color: const Color.fromRGBO(90, 90, 90, 1),
                                  ),
                                ),
                                SizedBox(
                                  width: 125,
                                  child: Text(
                                    "₹ ${selectedPaymentDetails.amount}",
                                    softWrap: true,
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b2,
                                        fontWeight: AppFontWeights.medium,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onTertiary),
                                  ),
                                )
                              ],
                            ),
                            const SpacerWidget(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "To",
                                  style: TextStyle(
                                    fontFamily: fontFamily,
                                    fontSize: AppFontSizes.b2,
                                    fontWeight: AppFontWeights.medium,
                                    color: const Color.fromRGBO(90, 90, 90, 1),
                                  ),
                                ),
                                SizedBox(
                                  width: 125,
                                  child: Text(
                                    liabilityref.selectedOldOffer.bankName,
                                    softWrap: true,
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b2,
                                        fontWeight: AppFontWeights.medium,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onTertiary),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: RelativeSize.width(50, width),
                  ),
                  child: ClipPath(
                    clipper: TopClipper(),
                    child: Container(
                      width: width,
                      height: 240,
                      padding: EdgeInsets.only(
                          left: RelativeSize.width(25, width),
                          right: RelativeSize.width(25, width),
                          top: 30,
                          bottom: 10),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.tertiary),
                      child: SizedBox(
                        height: height,
                        width: width,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Transaction Id",
                                  style: TextStyle(
                                    fontFamily: fontFamily,
                                    fontSize: AppFontSizes.b2,
                                    fontWeight: AppFontWeights.medium,
                                    color: const Color.fromRGBO(90, 90, 90, 1),
                                  ),
                                ),
                                SizedBox(
                                  width: 125,
                                  child: Text(
                                    selectedPaymentDetails.id,
                                    softWrap: true,
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b2,
                                        fontWeight: AppFontWeights.medium,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onTertiary),
                                  ),
                                )
                              ],
                            ),
                            const SpacerWidget(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Loan Id",
                                  style: TextStyle(
                                    fontFamily: fontFamily,
                                    fontSize: AppFontSizes.b2,
                                    fontWeight: AppFontWeights.medium,
                                    color: const Color.fromRGBO(90, 90, 90, 1),
                                  ),
                                ),
                                SizedBox(
                                  width: 125,
                                  child: Text(
                                    liabilityref.selectedOldOffer.offerId,
                                    softWrap: true,
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b2,
                                        fontWeight: AppFontWeights.medium,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onTertiary),
                                  ),
                                )
                              ],
                            ),
                            const SpacerWidget(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Email",
                                  style: TextStyle(
                                    fontFamily: fontFamily,
                                    fontSize: AppFontSizes.b2,
                                    fontWeight: AppFontWeights.medium,
                                    color: const Color.fromRGBO(90, 90, 90, 1),
                                  ),
                                ),
                                SizedBox(
                                  width: 125,
                                  child: Text(
                                    liabilityref.selectedOldOffer.contactDetails
                                        .customerSupportEmail,
                                    softWrap: true,
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b2,
                                        fontWeight: AppFontWeights.medium,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onTertiary),
                                  ),
                                )
                              ],
                            ),
                            const SpacerWidget(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Contact No.",
                                  style: TextStyle(
                                    fontFamily: fontFamily,
                                    fontSize: AppFontSizes.b2,
                                    fontWeight: AppFontWeights.medium,
                                    color: const Color.fromRGBO(90, 90, 90, 1),
                                  ),
                                ),
                                SizedBox(
                                  width: 125,
                                  child: Text(
                                    liabilityref
                                        .selectedOldOffer.contactDetails.phone,
                                    softWrap: true,
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: AppFontSizes.b2,
                                        fontWeight: AppFontWeights.medium,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onTertiary),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
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

class BottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    double sideRadius = 15.0;
    double midPoint = size.height;
    double cornerRadius = 15.0;

    path.moveTo(0, cornerRadius);
    path.lineTo(0, (midPoint - sideRadius));

    //LEFT ARC
    path.quadraticBezierTo(
        sideRadius, midPoint - sideRadius, sideRadius, midPoint);
    path.quadraticBezierTo(
        sideRadius, midPoint + sideRadius, 0, midPoint + sideRadius);

    path.lineTo(size.width, (midPoint + sideRadius));

    //RIGHT ARC
    path.quadraticBezierTo((size.width - sideRadius), (midPoint + sideRadius),
        (size.width - sideRadius), (midPoint));
    path.quadraticBezierTo((size.width - sideRadius), (midPoint - sideRadius),
        size.width, midPoint - sideRadius);

    path.lineTo(size.width, cornerRadius);

    //TopRight
    path.quadraticBezierTo(size.width, 0, size.width - cornerRadius, 0);

    path.lineTo(cornerRadius, 0);

    //TopLeft
    path.quadraticBezierTo(0, 0, 0, cornerRadius);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class TopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    double sideRadius = 15.0;
    double midPoint = 0;
    double cornerRadius = 15.0;

    path.moveTo(cornerRadius, 0);

    // LEFT ARC
    path.quadraticBezierTo(
        0 + sideRadius, (midPoint + sideRadius), 0, sideRadius);
    // path.quadraticBezierTo(
    //     sideRadius, midPoint - sideRadius, 0, midPoint - sideRadius);

    path.lineTo(0, size.height - cornerRadius);

    //BottomLeft
    path.quadraticBezierTo(0, size.height, cornerRadius, size.height);

    path.lineTo(size.width - cornerRadius, size.height);

    //BottomRight
    path.quadraticBezierTo(
        size.width, size.height, size.width, size.height - cornerRadius);

    path.lineTo(size.width, (midPoint + sideRadius));

    //RIGHT ARC
    path.quadraticBezierTo((size.width - sideRadius), (midPoint + sideRadius),
        (size.width - sideRadius), (midPoint));
    // path.quadraticBezierTo((size.width - sideRadius), (midPoint - sideRadius),
    //     size.width, midPoint - sideRadius);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
