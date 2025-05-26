import 'package:balajiicode/Utils/app_colors.dart';
import 'package:flutter/material.dart';


class MyText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final Color? decorationcolor;
  final TextOverflow? overflow;
  final TextOverflow? textOverflow;
  final int? maxLines;
  final double? wordSpacing;
  final double? textScaleFactor;
  final TextAlign? textAlign;
  final double? letterSpacing;
  final double? maxFontSize;
  final double? minFontSize;
  final double? lineHeight;
  final TextDecoration? textDecoration;
  final bool? softwrap;

  const MyText({
    super.key,
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.overflow,
    this.wordSpacing,
    this.textScaleFactor,
    this.textAlign,
    this.letterSpacing,
    this.textOverflow,
    this.maxLines,
    this.maxFontSize,
    this.minFontSize,
    this.lineHeight,
    this.textDecoration,
    this.softwrap,
    this.decorationcolor
  });

  @override
  Widget build(BuildContext context) {
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    return Text(
      text,
      overflow: overflow,
      maxLines: maxLines ?? defaultTextStyle.maxLines,
      textAlign: textAlign,
      softWrap: softwrap,
      style: TextStyle(
        decoration: textDecoration,
        decorationColor: decorationcolor,
        height: lineHeight,
        overflow: textOverflow,
        fontSize: fontSize ?? 16,
        color: color ?? textColor,
        fontWeight: fontWeight ?? FontWeight.w400,
        letterSpacing: letterSpacing ?? 0.2,
        fontFamily: "inter",
      ),
    );
  }
}
