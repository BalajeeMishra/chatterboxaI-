import 'package:balajiicode/Constants/shared_pref_constrants.dart';
import 'package:balajiicode/ShareAndReview/share_dialogue.dart';
import 'package:balajiicode/extensions/shared_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/app_common.dart';

class ShareAndReview{

  final InAppReview inAppReview = InAppReview.instance;



  Future<void> checkAndShowPopup(BuildContext context) async {

    int lastPopupTime = getIntAsync(last_review_or_share_pop_up_timestamp);
    int lastGameTime = getIntAsync(last_game_complete_8_timestamp);
    int gameCounter = getIntAsync(game_complete_8_counter) ;
    bool showReview = getBoolAsync(show_review);

    print("lastpopupTime : $lastPopupTime lastGameTime: $lastGameTime gameCounter: $gameCounter ");

    if (lastPopupTime > lastGameTime) return;

    if (gameCounter == 1 || !showReview) {
      setValue(show_review, true);
      await showReviewPopup();
    } else if (gameCounter > 0 && gameCounter % 3 == 0) {
      await showSharePopup(context);
    }
  }

  Future<void> increaseGameCounter() async {
    int counter = getIntAsync(game_complete_8_counter) + 1;
    int timestamp = DateTime.now().millisecondsSinceEpoch;

     setValue(game_complete_8_counter, counter);
     setValue(last_game_complete_8_timestamp, timestamp);
  }

  Future<void> showReviewPopup() async {
    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview().then((e){
        setValue(last_review_or_share_pop_up_timestamp, DateTime.now().millisecondsSinceEpoch);
        toast("Review Submitted");
      });
    }
    else{
      toast("Review is not Available");
    }
  }

  Future<void> showSharePopup(BuildContext context) async {
    shareDialogue(context);
    setValue(last_review_or_share_pop_up_timestamp, DateTime.now().millisecondsSinceEpoch);
  }

  Future<bool> isReviewFeatureEnabled() async {
    //Add logic If Show_review comese from firebase
    setValue('Show_App_review_feature', 1);
    return getIntAsync('Show_App_review_feature') == 1;
  }

  void removeAllKeys(){
     removeKey('Show_App_review_feature');
     removeKey(show_review);
     removeKey(last_review_or_share_pop_up_timestamp);
     removeKey(last_game_complete_8_timestamp);
     removeKey(game_complete_8_counter);
     print("Removed");
  }
  void share(){
    Share.share("I practice speaking English with AI on this App and found it helpful. Check it out: https://play.google.com/store/apps/details?id=com.talkyplay.zapai&gl=IN");

  }
}
