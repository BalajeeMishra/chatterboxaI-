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


class AnimatedActivationMask extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final List<Color> colors;
  final BlendMode blendMode;

  const AnimatedActivationMask({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 2),
    this.colors = const [Colors.grey, Colors.white],
    this.blendMode = BlendMode.srcIn,
  });

  @override
  State<AnimatedActivationMask> createState() => _AnimatedActivationMaskState();
}

class _AnimatedActivationMaskState extends State<AnimatedActivationMask>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..forward(); // For infinite loop. Use .forward() if you want once.
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        return ShaderMask(
          blendMode: widget.blendMode,
          shaderCallback: (Rect bounds) {
            final animationValue = _controller.value;
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [ Color(0xff9840EB),Color(0xff09C8C8)],
              stops: [
                animationValue - 0.2,
                animationValue,
              ],
              tileMode: TileMode.clamp,
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}


