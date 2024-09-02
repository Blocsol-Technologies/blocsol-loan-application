import 'package:blocsol_loan_application/invoice_loan/constants/theme.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:flutter/material.dart';

class InvoiceLoanProfileInfoTextBox extends StatelessWidget {
  final String label;
  final String textVal;

  const InvoiceLoanProfileInfoTextBox(
      {super.key, required this.label, required this.textVal});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: AppFontSizes.b1,
              fontWeight: AppFontWeights.normal,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SpacerWidget(
            height: 3,
          ),
          Container(
            height: 40,
            width: width,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
              ),
            ),
            child: TextField(
              controller: TextEditingController(text: textVal),
              textAlign: TextAlign.start,
              readOnly: true,
              style: TextStyle(
                fontFamily: fontFamily,
                fontSize: AppFontSizes.h3,
                fontWeight: AppFontWeights.medium,
                color: Theme.of(context).colorScheme.primary,
              ),
              textDirection: TextDirection.ltr,
              decoration: const InputDecoration(
                counterText: "",
                contentPadding: EdgeInsets.symmetric(horizontal: 15),
                enabled: false,
                disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
