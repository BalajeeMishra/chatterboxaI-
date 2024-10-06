

import 'package:balajiicode/Widget/appbar.dart';
import 'package:balajiicode/Constants/constantRow.dart';
import 'package:flutter/material.dart';

import 'PlayTabooScreen.dart';

class ChooseWordScreen extends StatelessWidget{

  List<Map<String,dynamic>> dataList = [
    {
      "title":"Sachin Tendulkar",
      "subtitle":"Easy"
    },
    {
      "title":"Tamarind",
      "subtitle":"Easy"
    },
    {
      "title":"Palam Jumeriah",
      "subtitle":"Hard"
    },
    {
      "title":"Elevator",
      "subtitle":"Easy"
    },
    {
      "title":"Pirate",
      "subtitle":"Medium"
    },
  ];

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
      body:  Column(
        children: [
           const SizedBox(
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
          SizedBox(
            height: 15.0,
          ),
          ListView.builder(
              itemCount: dataList.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context,index){
                var data = dataList[index];
                return Column(
                  children: [
                    InkWell(
                      onTap:(){
                        Navigator.push(context, MaterialPageRoute(builder:(context)=>PlayTabooScreen()));
                },
                      child: Container(
                          width: MediaQuery.of(context).size.width *0.9,
                          decoration: const BoxDecoration(
                              color: Color(0xffd3e2f5),
                              borderRadius: BorderRadius.all(Radius.circular(10.0))
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${data["title"]}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black,
                                      fontSize: 20
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "#${data["subtitle"]}",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xff646464),
                                      fontWeight: FontWeight.w400
                                  ),
                                )
                              ],
                            ),
                          )
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    )
                  ],
                );
              }
          )


        ],
      ),
    );
  }

}