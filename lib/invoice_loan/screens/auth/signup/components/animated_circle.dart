import 'package:flutter/material.dart';

// Delay should be in milliseconds
class AnimatedCircle extends StatefulWidget {
  final double diameter;
  final int delay;
  final Gradient gradient;
  final Widget child;

  const AnimatedCircle(
      {super.key,
      required this.child,
      required this.delay,
      required this.gradient,
      required this.diameter});

  @override
  State<AnimatedCircle> createState() => _AnimatedCircleState();
}

class _AnimatedCircleState extends State<AnimatedCircle> {
  double _diameter = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Future.delayed(Duration(milliseconds: widget.delay));
      if (!mounted || !context.mounted) return;
      setState(() {
        _diameter = widget.diameter;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        height: _diameter,
        width: _diameter,
        alignment: Alignment.center,
        transformAlignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: widget.gradient,
        ),
        child: Center(child: widget.child));
  }
}
