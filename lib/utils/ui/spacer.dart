import 'package:flutter/material.dart';

class SpacerWidget extends StatelessWidget {
  final double height;
  final double width;

  const SpacerWidget({super.key, this.height = 0, this.width = 0});

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      height: (height / 736) * screenHeight,
      width: (width / 414) * screenWidth,
    );
  }
}
