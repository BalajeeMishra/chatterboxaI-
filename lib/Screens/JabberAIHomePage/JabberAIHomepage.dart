
import 'package:balajiicode/Constants/ImageConstant.dart';
import 'package:balajiicode/Widget/appbar.dart';
import 'package:balajiicode/Screens/ChooseWordScreen/ChooseWords.dart';
import 'package:flutter/material.dart';

class JabberAIHomepage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _JabberAIHomepage();

}

class _JabberAIHomepage extends State<JabberAIHomepage>{


  List<Map<String,dynamic>> datalist = [
    {
      "title":"Taboo",
      "subtitle":"Make AI guess same word multiple times using different hints",
      "image":ImageConstant.tabooimage
    },
    {
      "title":"Who wants to be a Shakespeare",
      "subtitle":"9 Levels. Win each level by using a flashed word in an appropriate setence",
      "image":ImageConstant.shakespere
    },
    {
      "title":"Co-script a story",
      "subtitle":"Two charaters experience something spooky. Help AI complete the plot",
      "image":ImageConstant.scripstory
    },
    {
      "title":"Roleplays",
      "subtitle":"Practice real life conversation",
      "image":ImageConstant.roleplay
    },
    {
      "title":"Guess the word",
      "subtitle":"You guess a word by asking AI questions",
      "image":ImageConstant.guessworld
    },
    {
      "title":"Debate challenge",
      "subtitle":"You vs AI.One winner",
      "image":ImageConstant.debatechallenge
    },

  ];

  @override
  Widget build(BuildContext context) {
     return Scaffold(
       appBar: CustomAppBar(
         title: Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Image(image: AssetImage(ImageConstant.micImage)),
             SizedBox(width: 5.0,),
             Text(
               "Jabber AI",
               style: TextStyle(
                   fontSize: 18,
                   fontWeight: FontWeight.w400,
                   color: Colors.white
               ),
             )
           ],
         ),
         centerTile: true,
         backButtonshow: false
       ),
       body:  Padding(
         padding: EdgeInsets.symmetric(vertical: 10.0),
         child: ListView.builder(
             itemCount: datalist.length,
             scrollDirection: Axis.vertical,
             shrinkWrap: true,
             itemBuilder: (context,index){
               var data = datalist[index];
               return Padding(
                   padding:  const EdgeInsets.symmetric(horizontal: 20.0),
                   child:Column(
                     children: [
                       InkWell(
                         onTap: (){
                           Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChooseWordScreen()));
                         },
                         child:Container(
                             decoration: const BoxDecoration(
                                 color: Color(0xffd3e2f5),
                                 borderRadius: BorderRadius.all(Radius.circular(10.0))
                             ),
                             child: Padding(
                               padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 10.0),
                               child:  Row(
                                 children: [
                                   Expanded(
                                     flex: 2,
                                     child: Column(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [
                                         Text(
                                           "${data['title']}",
                                           style: TextStyle(
                                               fontWeight: FontWeight.w800,
                                               color: Colors.black,
                                               fontSize: 20
                                           ),
                                         ),
                                         SizedBox(
                                           height: 10,
                                         ),
                                         Text(
                                           "${data['subtitle']}",
                                           style: TextStyle(
                                               fontSize: 14,
                                               color: Color(0xff000000),
                                               fontWeight: FontWeight.w400
                                           ),
                                         )
                                       ],
                                     ),
                                   ),
                                   Image(image: AssetImage(data['image']))
                                 ],
                               ),
                             )
                         ),
                       ),
                       const SizedBox(
                         height: 15.0,
                       )
                     ],
                   )
               );
             }
         ),
       ),
     );
  }



}