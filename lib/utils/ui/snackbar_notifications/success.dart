import 'package:blocsol_loan_application/personal_loan/constants/theme.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SuccessNotification extends StatelessWidget {
  final String message;
  const SuccessNotification({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(RelativeSize.width(14, width)),
      decoration: BoxDecoration(
          color: const Color.fromRGBO(240, 247, 242, 1),
          border: Border.all(
            color: const Color.fromRGBO(209, 228, 212, 1),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 30,
            width: 30,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromRGBO(83, 221, 109, 1),
            ),
            child: Center(
              child: Container(
                height: 18,
                width: 18,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.white),
                child: const Center(
                  child: Icon(
                    Icons.shield_rounded,
                    size: 12,
                    color: Color.fromRGBO(83, 221, 109,1),
                  ),
                ),
              ),
            ),
          ),
          const SpacerWidget(
            width: 13,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Congratulations",
                  style: TextStyle(
                    fontFamily: fontFamily,
                    fontSize: AppFontSizes.b1,
                    fontWeight: AppFontWeights.bold,
                    color: Colors.black,
                  ),
                ),
                const SpacerWidget(
                  height: 3,
                ),
                Text(
                  message,
                  style: TextStyle(
                    fontFamily: fontFamily,
                    fontSize: AppFontSizes.b1,
                    fontWeight: AppFontWeights.medium,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          const SpacerWidget(
            width: 10,
          ),
          GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
            child: const Icon(
              Icons.close,
              size: 16,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
