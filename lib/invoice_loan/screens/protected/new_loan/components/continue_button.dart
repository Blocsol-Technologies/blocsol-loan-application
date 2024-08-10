import 'package:blocsol_loan_application/global_state/theme/theme_state.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class ContinueButton extends StatefulWidget {
  final String text;
  final Function onPressed;
  const ContinueButton(
      {super.key, required this.onPressed, this.text = "Continue"});

  @override
  State<ContinueButton> createState() => _ContinueButtonState();
}

class _ContinueButtonState extends State<ContinueButton> {
  bool _performingAction = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () async {
        HapticFeedback.heavyImpact();

        setState(() {
          _performingAction = true;
        });

        await widget.onPressed();

        if (!mounted) return;

        setState(() {
          _performingAction = false;
        });
      },
      child: Container(
        width: RelativeSize.width(250, width),
        height: RelativeSize.height(40, height),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: _performingAction
              ? Lottie.asset('assets/animations/loading_spinner.json',
                  height: 50, width: 50)
              : Text(
                  widget.text,
                  style: TextStyle(
                    fontFamily: fontFamily,
                    fontSize: AppFontSizes.b1,
                    fontWeight: AppFontWeights.medium,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
        ),
      ),
    );
  }
}
