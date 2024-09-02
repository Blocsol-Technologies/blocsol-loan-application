import 'package:blocsol_loan_application/personal_loan/constants/theme.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PlProfileTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final int maxInputLength;
  final bool readOnly;
  final String hintText;
  final bool obscureText;
  final List<TextInputFormatter> inputFormatters;

  const PlProfileTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.maxInputLength = 50,
    this.obscureText = false,
    this.inputFormatters = const [],
  });

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
          SizedBox(
            height: 40,
            width: width,
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              textAlign: TextAlign.start,
              obscureText: obscureText,
              readOnly: readOnly,
              style: TextStyle(
                fontFamily: fontFamily,
                fontSize: AppFontSizes.h3,
                fontWeight: AppFontWeights.medium,
                color: Theme.of(context).colorScheme.primary,
              ),
              textDirection: TextDirection.ltr,
              inputFormatters: inputFormatters,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: AppFontSizes.h3,
                  fontWeight: AppFontWeights.normal,
                  color: const Color.fromRGBO(35, 35, 35, 0.25),
                ),
                counterText: "",
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                enabled: true,
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromRGBO(90, 90, 90, 1)),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
