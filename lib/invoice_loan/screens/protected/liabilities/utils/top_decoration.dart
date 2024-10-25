import 'package:blocsol_loan_application/invoice_loan/screens/protected/liabilities/utils/bottom_triangle_pattern.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:flutter/material.dart';

class LiabilityTopDecoration extends StatelessWidget {
  final double decorHeight;
  const LiabilityTopDecoration({super.key,  this.decorHeight = 188});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      width: width,
      height: RelativeSize.height(decorHeight, height),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Row(
            children: List.generate(35, (index) {
          return CustomPaint(
            painter: TrianglePainter(
              strokeColor: Theme.of(context).colorScheme.onPrimary,
              paintingStyle: PaintingStyle.fill,
              strokeWidth: 0,
            ),
            child: SizedBox(
              height: 8,
              width: width / 35,
            ),
          );
        })),
      ),
    );
  }
}
