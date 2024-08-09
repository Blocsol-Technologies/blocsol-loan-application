import 'package:blocsol_loan_application/invoice_loan/screens/protected/profile/components/inward_curve_painter.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:flutter/material.dart';

class CurvedBackground extends StatelessWidget {
  final Widget child;
  final double horizontalPadding;
  const CurvedBackground({super.key, required this.child, this.horizontalPadding = 27});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: RelativeSize.height(510, height),
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      ),
      clipBehavior: Clip.antiAlias,
      child: CustomPaint(
        painter:
            InwardCurvePainter(color: Theme.of(context).colorScheme.surface),
        child: Padding(
          padding: EdgeInsets.only(
              top: RelativeSize.height(
                55,
                height,
              ),
              right: RelativeSize.width(horizontalPadding, width),
              left: RelativeSize.width(horizontalPadding, width)),
          child: child,
        ),
      ),
    );
  }
}
