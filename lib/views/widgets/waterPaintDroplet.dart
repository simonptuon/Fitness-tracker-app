import 'dart:math';
import 'package:flutter/material.dart';

class WaterDropPainter extends CustomPainter {
  final Animation<double> animation;
  final double progress;

  WaterDropPainter(this.animation, this.progress) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    // Paint for the droplet fill
    Paint dropletPaint = Paint()
      ..color = const Color.fromARGB(255, 210, 210, 210).withOpacity(0.8);

    // Paint for the droplet outline
    Paint outlinePaint = Paint()
      ..color = const Color.fromARGB(255, 202, 202, 202)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10; // Adjust the stroke width as needed

    Path dropletPath = Path();

    // Draw the droplet shape with increased width
    dropletPath.moveTo(size.width / 2, 0);
    dropletPath.quadraticBezierTo(size.width * 1.2, size.height * 0.9,
        size.width * 0.5, size.height * 0.9); // Adjusted control point
    dropletPath.quadraticBezierTo(size.width * -0.25, size.height * 0.9,
        size.width / 2, 0); // Adjusted control point
    dropletPath.close();

    // Draw the droplet outline
    canvas.drawPath(dropletPath, outlinePaint);

    // Clip to keep the wave inside the droplet
    canvas.save();
    canvas.clipPath(dropletPath);
    canvas.drawPath(dropletPath, dropletPaint);

    // Wave effect
    Paint wavePaint = Paint()
      ..color = Colors.blueAccent
      ..style = PaintingStyle.fill;

    Path wavePath = Path();
    double waveHeight = size.height * (1 - progress);

    wavePath.moveTo(0, waveHeight);

    for (double i = 0; i <= size.width; i++) {
      double y = sin((i / size.width * 4 * pi) + animation.value * 2 * pi) *
              3 + // Increased frequency, reduced amplitude
          waveHeight;
      wavePath.lineTo(i, y);
    }

    wavePath.lineTo(size.width, size.height);
    wavePath.lineTo(0, size.height);
    wavePath.close();

    canvas.drawPath(wavePath, wavePaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
