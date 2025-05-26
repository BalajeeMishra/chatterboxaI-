import 'package:balajiicode/Widget/text_widget.dart';
import 'package:flutter/material.dart';


extension GradientExtension on Widget {
  Widget withGradient({
    BlendMode blendMode = BlendMode.srcIn,
  }) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [ Color(0xff9840EB),Color(0xff09C8C8)], // Gradient Colors
      ).createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      blendMode: blendMode,
      child: this,
    );
  }
}


