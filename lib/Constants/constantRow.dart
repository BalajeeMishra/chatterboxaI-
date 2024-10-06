
import "package:flutter/material.dart";


/*
sameDistantRow({context,playstatus=false,feedbackstatus=false,practicestatus=false}){
  var datawidth = MediaQuery.of(context).size.width;
  return  Row(
    children: [
      SizedBox(
        width: datawidth/7,
      ),
      SizedBox(
          child:  Text(
            "Play >",
             style: TextStyle(
               color: playstatus ? Colors.black:Colors.grey,
               fontWeight: FontWeight.w600,
               fontSize: 14
             ),
          )
      ),
      SizedBox(
        width: datawidth/7,
      ),
      SizedBox(
        //width: datawidth/7,
        child: Text(
          "Feedback >",
          style: TextStyle(
              color: feedbackstatus?Colors.black:Colors.grey,
              fontWeight: FontWeight.w600,
              fontSize: 14
          ),
        ),
      ),
      SizedBox(
        width: datawidth/7,
      ),
      SizedBox(
        //width: datawidth/7,
         child: Text(
            "Practice ",
            style: TextStyle(
                color: practicestatus?Colors.black:Colors.grey,
                fontWeight: FontWeight.w600,
                fontSize: 14
            ),
          )
      ),
      const SizedBox(
        //width: datawidth/7,
      ),
    ],
  );

}

 */

class EquiDistantRow extends StatelessWidget{
 final bool playstatus;
 final bool feedbackstatus;
 final bool practicestatus;

  const EquiDistantRow({super.key,required this.practicestatus,required this.feedbackstatus,required this.playstatus});




  @override
  Widget build(BuildContext context) {
    var datawidth = MediaQuery.of(context).size.width;
    return  Row(
      children: [
        SizedBox(
          width: datawidth/7,
        ),
        SizedBox(
            child:  Text(
              "Play >",
              style: TextStyle(
                  color: playstatus ? Colors.black:Colors.grey,
                  fontWeight: FontWeight.w600,
                  fontSize: 14
              ),
            )
        ),
        SizedBox(
          width: datawidth/7,
        ),
        SizedBox(
          //width: datawidth/7,
          child: Text(
            "Feedback >",
            style: TextStyle(
                color: feedbackstatus?Colors.black:Colors.grey,
                fontWeight: FontWeight.w600,
                fontSize: 14
            ),
          ),
        ),
        SizedBox(
          width: datawidth/7,
        ),
        SizedBox(
          //width: datawidth/7,
            child: Text(
              "Practice ",
              style: TextStyle(
                  color: practicestatus?Colors.black:Colors.grey,
                  fontWeight: FontWeight.w600,
                  fontSize: 14
              ),
            )
        ),
        SizedBox(
          //width: datawidth/7,
        ),
      ],
    );

  }


}