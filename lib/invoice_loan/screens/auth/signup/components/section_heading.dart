import 'package:blocsol_loan_application/personal_loan/contants/theme.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:flutter/material.dart';

class SectionHeading extends StatelessWidget {
  final String subHeading;
  final String heading;
  final double headingWidth;

  const SectionHeading(
      {super.key,
      required this.subHeading,
      required this.heading,
      this.headingWidth = 172});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      curve: Curves.easeInOutCubic,
      duration: const Duration(seconds: 1),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Container(
            padding: EdgeInsets.only(
                top: 25 * (1 - value),
                left: RelativeSize.width(30, width),
                right: RelativeSize.width(30, width)),
            width: width,
            child: child,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subHeading,
            softWrap: true,
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: AppFontSizes.b2,
              fontWeight: AppFontWeights.normal,
              color: const Color.fromRGBO(225, 225, 225, 1),
            ),
          ),
          const SpacerWidget(
            height: 5,
          ),
          SizedBox(
            width: headingWidth,
            child: Text(
              heading,
              softWrap: true,
              style: TextStyle(
                fontFamily: fontFamily,
                fontSize: AppFontSizes.h1,
                fontWeight: AppFontWeights.medium,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
