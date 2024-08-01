// import 'package:blocsol_invoice_based_credit/utils/ui_utils/misc.dart';
// import 'package:flutter/material.dart';
// import 'package:blocsol_invoice_based_credit/screens/user/protected/liabilities/utils/bottom_triangle_pattern.dart';

// class LiabilityTopDecoration extends StatelessWidget {
//   const LiabilityTopDecoration({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//     return Container(
//       width: width,
//       height: RelativeSize.height(188, height),
//       decoration: BoxDecoration(
//         color: Theme.of(context).colorScheme.primary,
//       ),
//       child: Align(
//         alignment: Alignment.bottomCenter,
//         child: Row(
//             children: List.generate(35, (index) {
//           return CustomPaint(
//             painter: TrianglePainter(
//               strokeColor: Theme.of(context).colorScheme.onPrimary,
//               paintingStyle: PaintingStyle.fill,
//               strokeWidth: 0,
//             ),
//             child: SizedBox(
//               height: 8,
//               width: width / 35,
//             ),
//           );
//         })),
//       ),
//     );
//   }
// }
