
import 'dart:ui';

import 'package:balajiicode/Widget/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../Constants/ImageConstant.dart';
import '../../Constants/constantRow.dart';
import '../../Model/AllGameModel.dart';
import '../../ViewModel/TabooGameChatPageVM.dart';
import '../../Widget/appbar.dart';

class TaboogamechatPage extends StatefulWidget{
  AllGameModel allGameModel;
  int index;
  TaboogamechatPage(this.allGameModel,this.index);

  @override
  State<StatefulWidget> createState()=> _TaboogamechatPage();

}

class _TaboogamechatPage extends State<TaboogamechatPage>{



   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<TabooGameChatPageVM>(context, listen: false).seInitialValue(widget.allGameModel,widget.index);
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
       appBar: backCustomAppBar(
           backButtonshow: true,
           centerTile: false,
           onPressed: (){
             Navigator.pop(context);
           },
           title: "Taboo"
       ),
       body: Container(
         width: MediaQuery.of(context).size.width,
         child: Stack(
           children: [
             Container(
               width: MediaQuery.of(context).size.width,
               child: Column(
                 children: [
                   SizedBox(
                     height: 10,
                   ),
                   EquiDistantRow(playstatus: true,feedbackstatus: false,practicestatus: false),
                   const SizedBox(
                     height: 10,
                   ),
                   const Divider(
                     height: 1,
                     color: Color(0xffc1c1c1),
                   ),
                   const SizedBox(
                     height: 10,
                   ),
                   Padding(
                     padding: EdgeInsets.only(left: 15,right: 50),
                     child: Consumer<TabooGameChatPageVM>(
                       builder: (context,vm,child){
                         return Row(
                           children: [
                             Expanded(
                               child: Container(
                                   decoration: const BoxDecoration(
                                       color: Color(0xffd3e2f5),
                                       borderRadius: BorderRadius.all(Radius.circular(10.0))
                                   ),
                                   child: Padding(
                                     padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                                     child: Column(
                                       children: [
                                         Row(
                                           children: [
                                             MyText(
                                               text: "${vm.initialdata.keys.first}:",
                                               fontWeight: FontWeight.w600,
                                               fontSize: 15,
                                             ),
                                             SizedBox(
                                               width: 2,
                                             ),
                                             Expanded(
                                               child:  MyText(
                                                 text: "${vm.initialdata.values.first}",
                                                 fontWeight: FontWeight.w400,
                                                 fontSize: 15,
                                               ),
                                             )
                                           ],
                                         ),
                                         Row(
                                           mainAxisAlignment: MainAxisAlignment.start,
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           children: [
                                             MyText(
                                               text: "${vm.initialdata.keys.last}:",
                                               fontWeight: FontWeight.w600,
                                               fontSize: 15,
                                             ),
                                             SizedBox(
                                               width: 4,
                                             ),
                                             Flexible(
                                               child:  MyText(
                                                 text: "${vm.initialdata.values.last}",
                                                 fontWeight: FontWeight.w400,
                                                 fontSize: 15,
                                               ),
                                             )
                                           ],
                                         )
                                       ],
                                     ),
                                   )
                               ),
                             ),
                           ],
                         );
                       },
                     ),
                   ),
                   SizedBox(
                     height: 10,
                   ),
                   Consumer<TabooGameChatPageVM>(
                     builder: (context,vm,child){
                       return Expanded(
                        // height: MediaQuery.of(context).size.height * 0.6,
                         child: ListView.builder(
                           itemCount: vm.dynamicDta.length,
                           shrinkWrap: true,
                           scrollDirection: Axis.vertical,
                           //physics: NeverScrollableScrollPhysics(),
                           itemBuilder: (context,index){
                             var data = vm.dynamicDta[index];
                             print("server side Data ${data['server']}");
                             return data['server'] == 0?
                             Column(
                               children: [
                                 Padding(
                                   padding: EdgeInsets.only(left: 50,right: 15),
                                   child: Row(
                                     mainAxisAlignment: MainAxisAlignment.end,
                                     children: [
                                       Expanded(
                                         child: Container(
                                             decoration: const BoxDecoration(
                                                 color: Color(0xffd3e2f5),
                                                 borderRadius: BorderRadius.all(Radius.circular(10.0))
                                             ),
                                             child: Padding(
                                               padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 10.0),
                                               child: Column(
                                                 children: [
                                                   Row(
                                                     children: [
                                                       Expanded(
                                                         child:  MyText(
                                                           text: "${data['data']}",
                                                           fontWeight: FontWeight.w400,
                                                           fontSize: 15,
                                                         ),
                                                       )
                                                     ],
                                                   ),
                                                 ],
                                               ),
                                             )
                                         ),
                                       ),
                                     ],
                                   ),
                                 ),
                                 SizedBox(
                                   height: 10,
                                 )
                               ],
                             ):
                             Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Padding(
                                   padding: EdgeInsets.only(left: 15.0,right: 50.0),
                                   child: Row(
                                     mainAxisAlignment: MainAxisAlignment.start,
                                     children: [
                                       Expanded(
                                         child: Container(
                                             decoration: const BoxDecoration(
                                                 color: Color(0xffd3e2f5),
                                                 borderRadius: BorderRadius.all(Radius.circular(10.0))
                                             ),
                                             child: Padding(
                                               padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 10.0),
                                               child: Column(
                                                 children: [
                                                   Row(
                                                     children: [
                                                       Expanded(
                                                         child:  MyText(
                                                           text: "${data['data']}",
                                                           fontWeight: FontWeight.w400,
                                                           fontSize: 15,
                                                         ),
                                                       )
                                                     ],
                                                   ),
                                                 ],
                                               ),
                                             )
                                         ),
                                       ),
                                     ],
                                   ),
                                 ),
                                 SizedBox(
                                   height: 10,
                                 )
                               ],
                             );
                           },
                         ),
                       );
                     },
                   ),
                   SizedBox(
                     height: 70,
                   )
                 ],
               ),
             ),
             Align(
               alignment: Alignment.bottomCenter,
               child: Padding(
                 padding: EdgeInsets.only(left: 15.0,right: 15.0,bottom: 10.0),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Expanded(
                         child: Consumer<TabooGameChatPageVM>(
                           builder: (context,vm,child){
                             return TextFormField(
                               controller: vm.controller,
                               decoration: InputDecoration(
                                 hintText: "Enter Your Answer",
                                 border: const OutlineInputBorder(
                                   borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                 ),
                                 focusedBorder: OutlineInputBorder(
                                   borderSide: BorderSide(color: Colors.deepPurple.shade300),
                                 ),
                               ),
                             );
                           },
                         )
                     ),
                     SizedBox(
                       width: 10,
                     ),
                     InkWell(
                       onTap: (){
                         Provider.of<TabooGameChatPageVM>(context, listen: false).chatPageAPI(context);
                       },
                       child:  Image(image: AssetImage(ImageConstant.doneButton)),
                     ),
                   ],
                 ),
               ),
             )
           ],
         ),
       )
     );
  }

}



