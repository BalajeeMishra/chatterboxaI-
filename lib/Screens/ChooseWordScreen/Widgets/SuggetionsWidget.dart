import 'package:balajiicode/Widget/text_widget.dart';
import 'package:balajiicode/extensions/extension_util/int_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../Constants/ImageConstant.dart';
import '../../../Utils/app_colors.dart';

class Suggetionswidget extends StatelessWidget {
  final VoidCallback onTap;
  final String text ;
  final bool isIcon;
  const Suggetionswidget({super.key,required this.text, required this.onTap,this.isIcon = false});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return InkWell(
         onTap:onTap ,
        child: Container(
             decoration:  BoxDecoration(
               borderRadius: BorderRadius.circular(20),
               color: lightGreyBackground
             ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 5),
              child: Row(
                children: [
                  if(isIcon)Image.asset(ImageConstant.forward_icon, height: 15, width: 15,color: Colors.black54,),
                  MyText(text: text),
                ],
              ),
            )
        )
    );
  }
}
