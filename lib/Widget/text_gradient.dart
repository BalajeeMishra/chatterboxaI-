import 'package:balajiicode/Widget/text_widget.dart';
import 'package:flutter/material.dart';


class GradientText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final bool softWrap ;

  const GradientText(
      this.text, {
        required this.style,
        required this.softWrap,
      });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [Colors.purple, Colors.cyan], // Gradient Colors
      ).createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        softWrap: softWrap,
        text,
        style: style.copyWith(color: Colors.white,fontSize: 17,fontFamily: "inter",fontWeight: FontWeight.w700),
      ),
    );
  }
}

class GradientIcon extends StatelessWidget {
  final VoidCallback ontap;
  final IconData icon;
  final double size;

   GradientIcon({super.key,required this.ontap,required this.icon,this.size = 24});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          colors: [Colors.purple, Colors.cyan], // Gradient Colors
        ).createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        ),
        child:Icon(icon,color: Colors.white,size: size,)
      )
    );
  }
}


