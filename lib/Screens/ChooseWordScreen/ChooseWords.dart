

import 'package:balajiicode/Widget/appbar.dart';
import 'package:balajiicode/Constants/constantRow.dart';
import 'package:balajiicode/Widget/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../ViewModel/AllGameVm.dart';
import 'PlayTabooScreen.dart';

class ChooseWordScreen extends StatefulWidget{

  String dataId;
  ChooseWordScreen(this.dataId);

  @override
  State<StatefulWidget> createState() => _ChooseWordScreen();

}

class _ChooseWordScreen extends State<ChooseWordScreen>{



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<AllGameVm>(context, listen: false).seInitialValue();
    Provider.of<AllGameVm>(context, listen: false).allGamePageAPI(context,widget.dataId);
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
      body:  Consumer<AllGameVm>(
        builder: (context,vm,child){
          return Column(
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
              vm.apiHitStatus ?
                  vm.homePageModel.allGame == null?
                      Center(
                        child: MyText(
                          text: 'No Game Found',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ):
              ListView.builder(
                  itemCount: vm.homePageModel.allGame!.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context,index){
                    var data = vm.homePageModel.allGame![index];
                    return Column(
                      children: [
                        InkWell(
                          onTap:(){
                            Navigator.push(context, MaterialPageRoute(builder:(context)=>PlayTabooScreen(vm.homePageModel,index)));
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
                                      "${data.mainContent}",
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
                                      "#${data.level}",
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
              ):
              SizedBox()


            ],
          );
        },
      ),
    );
  }


}