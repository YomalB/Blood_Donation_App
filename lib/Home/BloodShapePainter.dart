import 'package:flutter/material.dart';

class BloodShapePainter extends CustomPainter {
  final Color bgColor;
  final String text;

  BloodShapePainter({required this.bgColor, required this.text});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = bgColor
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width * 0.5, size.height * 0.35)
      ..cubicTo(size.width * 0.15, size.height * -0.25, size.width * -0.35,
          size.height * 0.45, size.width * 0.5, size.height * 0.95)
      ..moveTo(size.width * 0.5, size.height * 0.35)
      ..cubicTo(size.width * 0.85, size.height * -0.25, size.width * 1.35,
          size.height * 0.45, size.width * 0.5, size.height * 0.95);

    canvas.drawPath(path, paint);

    // Draw the text
    final textSpan = TextSpan(
      text: text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    final xCenter = (size.width - textPainter.width) / 2;
    final yCenter = (size.height - textPainter.height) / 2;

    textPainter.paint(canvas, Offset(xCenter, yCenter));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
