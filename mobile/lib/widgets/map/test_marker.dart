import 'package:flutter/material.dart';

class CompanyPinMarker extends StatelessWidget {
  final String imageUrl;
  final double size;

  const CompanyPinMarker({super.key, required this.imageUrl, this.size = 70});

  @override
  Widget build(BuildContext context) {
    final double circleSize = size;
    final double stemHeight = size * 0.56;
    final double tipWidth = size * 0.55;
    final double totalHeight = circleSize + stemHeight;

    return SizedBox(
      width: circleSize,
      height: totalHeight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Circle logo
          Container(
            width: circleSize,
            height: circleSize,
            padding: EdgeInsets.all(size * 0.1),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: size * 0.05),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, Color(0xFFF5F5F5)],
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.25),
                  blurRadius: 15,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) {
                  return Container(
                    color: Colors.white,
                    child: const Center(
                      child: CircleAvatar(
                        radius: 999,
                        backgroundColor: Color(0xFF4285F4),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Triangular pin tip
          Transform.translate(
            offset: const Offset(0, -2),
            child: CustomPaint(
              size: Size(tipWidth, stemHeight),
              painter: _PinTipPainter(),
            ),
          ),
        ],
      ),
    );
  }
}

class _PinTipPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(w, 0)
      ..lineTo(w / 2, h)
      ..close();

    canvas.drawShadow(path, const Color(0x44000000), 6, true);

    final rect = Rect.fromLTWH(0, 0, w, h);
    final gradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.white, Color(0xFFD0D0D0)],
    );

    canvas.drawPath(path, Paint()..shader = gradient.createShader(rect));

    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0x22000000)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
