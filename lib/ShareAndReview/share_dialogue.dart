import 'package:balajiicode/Constants/ImageConstant.dart';
import 'package:balajiicode/ShareAndReview/share_and_review.dart';
import 'package:balajiicode/extensions/extension_util/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../Utils/app_images.dart';
import '../Widget/text_gradient.dart';
import '../Widget/text_widget.dart';
import '../extensions/common.dart';

void shareDialogue(BuildContext context) {
  showDialog(
    context: context,
    barrierColor: Colors.blue,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Stack(clipBehavior: Clip.none, children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.asset(
                    share_backgorund_dialogue,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.asset(
                      sharePopupImage,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ]),
              SizedBox(height: 12),
              Text(
                "Great Job!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                "You Practiced For 15+ Minutes 🎉",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
                icon: Icon(Icons.share, color: Colors.white),
                label: Text(
                  "Share Zap AI With Friends",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  ShareAndReview().share();
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

class ShareAndReviewScreen extends StatelessWidget {
  const ShareAndReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue,

        body:
           Center(
             child: Stack(
               clipBehavior: Clip.none,

               children:[
                 Lottie.asset("assets/lottiefile/confettie.json"),
               Column(
                 children: [
                   SizedBox(height: 60,),
                   Align(
                     alignment: Alignment.centerLeft,
                     child: InkWell(
                         onTap: ()=>pop(),
                         child: Image.asset(ImageConstant.closeButton,height: 24,width: 24,)),
                   ).paddingSymmetric(horizontal: 20),
                   SizedBox(height: MediaQuery.of(context).size.height*.2,),
                   Container(
                     height: MediaQuery.of(context).size.height*.45,
                     width: MediaQuery.of(context).size.width/1.14,
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(12),
                       color: Colors.white
                     ),
                     child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        Stack(
                            clipBehavior: Clip.none,

                            children: [
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Image.asset(
                                share_backgorund_dialogue,
                                height: 196,
                                width: 290,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Image.asset(
                                sharePopupImage,
                                height: 196,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ]),
                        SizedBox(height: 12),
                        MyText(
                         text: "Great Job!",
                         fontSize: 22, fontWeight: FontWeight.bold,
                        ),
                        MyText(
                          text: "You Practiced For 15+ Minutes 🎉",
                          fontSize: 16,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          ),
                          icon: Icon(Icons.share, color: Colors.white),
                          label: MyText(
                            text: "Share Zap AI With Friends",
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            ShareAndReview().share();
                          },
                        ),
                      ],
                               ),
                   ),
                 ],
               ),
      ]
             ),
           ),
        );
  }
}
