import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:flutter/material.dart';

class SectionMainBackground extends StatelessWidget {
  final Widget child;
  final Function onAnimationComplete;
  const SectionMainBackground(
      {super.key, required this.onAnimationComplete, required this.child});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOutCubic,
      onEnd: () {
        onAnimationComplete();
      },
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Padding(
            padding: EdgeInsets.only(
                top: RelativeSize.height(250, height) * (1 - value)),
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              padding: EdgeInsets.symmetric(
                  vertical: RelativeSize.height(30, height),
                  horizontal: RelativeSize.width(20, width)),
              child: child,
            ),
          ),
        );
      },
      child: child,
    );
  }
}
