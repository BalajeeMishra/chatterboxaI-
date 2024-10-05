

import 'package:flutter/material.dart';

import 'ImageConstant.dart';

CustomAppBar({title,backButtonshow = false,centerTile = false,onPressed}){
  return PreferredSize(
    preferredSize: const Size.fromHeight(50.0),
    child: AppBar(
      flexibleSpace: Container(
        decoration:  BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImageConstant.appbarBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: title,
      centerTitle: centerTile??false,
    ),
  );
}


backCustomAppBar({title,backButtonshow = false,centerTile = false,onPressed}){
  return PreferredSize(
    preferredSize: const Size.fromHeight(50.0),
    child: AppBar(
      leading: backButtonshow? InkWell(
        onTap: onPressed,
        child: Image(image: AssetImage(ImageConstant.backButtonIcon)),
      ):SizedBox(),
      flexibleSpace: Container(
        decoration:  BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImageConstant.appbarBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
      ),
      title:  Text(
        title,
        style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.white
        ),
      ),
      centerTitle: centerTile??false,
    ),
  );
}

