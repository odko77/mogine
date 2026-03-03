import 'package:flutter/material.dart';

/// Base дизайн: 360x640 (mobile portrait)
class SizeConfig {
  static double sw = 1; // scale width factor
  static double sh = 1; // scale height factor
  static double w = 0; // display width
  static double h = 0; // display height

  static const double baseW = 360.0;
  static const double baseH = 640.0;

  static void init(BuildContext context) {
    final mq = MediaQuery.of(context);
    w = mq.size.width;
    h = mq.size.height;

    final safeH = h - mq.padding.top - mq.padding.bottom;

    sw = w / baseW;
    sh = safeH / baseH;
  }

  static double dw(double v) => v * sw; // design width
  static double dh(double v) => v * sh; // design height
  static double sp(double v) => v * sw; // scaled font size
}
