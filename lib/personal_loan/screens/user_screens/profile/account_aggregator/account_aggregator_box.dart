import 'package:blocsol_loan_application/invoice_loan/constants/theme.dart';
import 'package:blocsol_loan_application/utils/lender_utils.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AccountAggregatorBox extends StatelessWidget {
  final int selectedIndex;
  final int index;
  final AccountAggregatorInfo aaInfo;
  final Function onClick;

  const AccountAggregatorBox(
      {super.key,
      required this.aaInfo,
      required this.index,
      required this.selectedIndex,
      required this.onClick});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        onClick();
      },
      child: Container(
        padding: EdgeInsets.all(RelativeSize.width(16, width)),
        width: width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
              width: 50,
              child: Center(
                child: Image.asset(
                    getAccountAggregatorInfo(aaInfo.name).assetPath,
                    fit: BoxFit.contain),
              ),
            ),
            const SpacerWidget(
              width: 20,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    aaInfo.name,
                    style: TextStyle(
                        fontFamily: fontFamily,
                        fontSize: AppFontSizes.h3,
                        fontWeight: AppFontWeights.medium,
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                  const SpacerWidget(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Play Store Rating:",
                        style: TextStyle(
                            fontFamily: fontFamily,
                            fontSize: AppFontSizes.b2,
                            fontWeight: AppFontWeights.normal,
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      const SpacerWidget(
                        width: 5,
                      ),
                      SizedBox(
                        height: 20,
                        width: 50,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: 5,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (ctx, idx) {
                            return Icon(
                              Icons.star,
                              color: idx < aaInfo.playStoreRating
                                  ? Colors.yellow.shade700
                                  : Theme.of(context).colorScheme.primary,
                              size: 10,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SpacerWidget(
              width: 12,
            ),
            Container(
              height: 15,
              width: 15,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selectedIndex == index
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Center(
                child: Container(
                  height: 7,
                  width: 7,
                  decoration: BoxDecoration(
                    color: selectedIndex == index
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
