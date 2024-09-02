import 'package:flutter/material.dart';

class PlInwardCurvePainter extends CustomPainter {
  final Color color;

  PlInwardCurvePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    // Start at the top left corner
    path.moveTo(0, 0);

    // Define the control point and the end point for the quadratic bezier curve
    final controlPoint = Offset(size.width / 2, size.height * 0.085);
    final endPoint = Offset(size.width, 0);

    // Draw the curve
    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);

    // Draw the rest of the path (sides and bottom)
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
