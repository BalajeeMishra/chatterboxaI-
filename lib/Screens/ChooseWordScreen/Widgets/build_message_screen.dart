// import 'package:balajiicode/extensions/extension_util/int_extensions.dart';
// import 'package:balajiicode/extensions/extension_util/widget_extensions.dart';
// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../../Utils/app_colors.dart';
// import '../../../ViewModel/PlayTabooScreenVM.dart';
// import '../../../Widget/text_widget.dart';
// import '../../../extensions/text_styles.dart';
//
// class BuildMassageScreen extends StatefulWidget {
//   BuildMassageScreen({super.key});
//
//   @override
//   State<BuildMassageScreen> createState() => _BuildMassageScreenState();
// }
//
// class _BuildMassageScreenState extends State<BuildMassageScreen> {
//   final FocusNode _focusNode = FocusNode();
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _focusNode.requestFocus();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: WillPopScope(
//             onWillPop: () async {
//               var chatPageVM =
//               Provider.of<PlayTabooScreenVM>(context, listen: false);
//               String messageText = chatPageVM.controller.text.trim();
//               chatPageVM.controller.clear();
//               _focusNode.unfocus();
//               Navigator.pop(context, messageText);
//               return false;
//             },
//             child: SafeArea(child: _buildMessageInput(context))));
//   }
//
//   Widget _buildMessageInput(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(15),
//       child: Column(
//         children: [
//           Expanded(
//             child: Consumer<PlayTabooScreenVM>(
//               builder: (context, vm, child) {
//                 return TextField(
//                   textAlign: TextAlign.left,
//                   textAlignVertical: TextAlignVertical.center,
//                   style: TextStyle(
//                     fontSize: 16,
//                     height: 20 / 16,
//                     fontFamily: 'inter',
//                   ),
//                   cursorColor: primaryColor,
//                   cursorHeight: 30,
//                   cursorWidth: 4,
//                   focusNode: _focusNode,
//                   controller: vm.controller,
//                   maxLines: null,
//                   decoration: InputDecoration(
//                     isDense: true,
//                     contentPadding: EdgeInsets.only(
//                         top: 80, bottom: 0, left: 10, right: 10),
//                     hintText: "",
//                     hintStyle: secondaryTextStyle(
//                         size: 16, height: 20 / 16, fontFamily: 'inter'),
//                     labelStyle: secondaryTextStyle(
//                         size: 16, height: 20 / 16, fontFamily: 'inter'),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10.0),
//                       borderSide: BorderSide(
//                         color: primaryColor,
//                         width: 3,
//                       ),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10.0),
//                       borderSide: BorderSide(
//                         color: primaryColor,
//                         width: 3,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               DottedBorder(
//                 color: gradientStartColor,
//                 strokeWidth: 2,
//                 dashPattern: [2, 2],
//                 // strokeCap: StrokeCap.round,
//                 borderType: BorderType.RRect,
//                 radius: Radius.circular(12),
//                 child: ClipRRect(
//                   child: Container(
//                     padding: EdgeInsets.only(left: 4, right: 4),
//                     // decoration: BoxDecoration(border: Border.all()),
//                     // decoration: boxDecorationWithRoundedCorners(
//                     //     // backgroundColor: Color(0xFFe0ddf5)
//                     //
//                     // ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Image.asset('assets/images/voice.gif', width: 40),
//                         MyText(
//                           text: "Use keyboard's voice typing",
//                           fontSize: 14,
//                         ),
//                         4.width,
//                         Icon(
//                           Icons.help_outlined,
//                           size: 20,
//                         ).onTap(() {
//                           showInstructionDialog();
//                         }),
//                         // ShowCaseWidget(builder: (context) {
//                         //   return Showcase(
//                         //     key: _one,
//                         //     title: "How should i Speak?",
//                         //     description:
//                         //         "\nPlease locate the Mic icon on your keyboard.\n\n"
//                         //         "Not seeing a Mic icon?\n\n"
//                         //         "Reason 1\n"
//                         //         "(Gboard) Long press comma and open settings. Turn on voice typing inside settings.\n\n"
//                         //         "Reason 2\n"
//                         //         "Check your App settings and locate your keyboard App. Make sure you have given microphone permission.\n\n"
//                         //         "Reason 3\n"
//                         //         "Inside Keyboard settings, go to Text suggestions and then turn on show suggestion strip.",
//                         //     // description:_buildRichDescription(),
//                         //     // RichText(
//                         //     //   text: TextSpan(
//                         //     //     children: [
//                         //     //       TextSpan(
//                         //     //         text: "Reason 1: ",
//                         //     //         style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
//                         //     //       ),
//                         //     //       TextSpan(
//                         //     //         text: "Long press comma and open settings to turn on voice typing.\n\n",
//                         //     //         style: TextStyle(color: Colors.black),
//                         //     //       ),
//                         //     //       TextSpan(
//                         //     //         text: "Reason 2: ",
//                         //     //         style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
//                         //     //       ),
//                         //     //       TextSpan(
//                         //     //         text: "Check your app settings and ensure microphone permission is enabled.\n\n",
//                         //     //         style: TextStyle(color: Colors.black),
//                         //     //       ),
//                         //     //       TextSpan(
//                         //     //         text: "Reason 3: ",
//                         //     //         style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
//                         //     //       ),
//                         //     //       TextSpan(
//                         //     //         text: "Go to text suggestions in keyboard settings and enable 'show suggestion strip'.",
//                         //     //         style: TextStyle(color: Colors.black),
//                         //     //       ),
//                         //     //     ],
//                         //     //   ),
//                         //     // ),
//                         //     //
//                         //     child: Column(
//                         //       children: [
//                         //         Icon(
//                         //           Icons.help_outlined,
//                         //           size: 20,
//                         //         ).onTap(() {
//                         //           WidgetsBinding.instance.addPostFrameCallback(
//                         //             (_) => ShowCaseWidget.of(context)
//                         //                 .startShowCase([_one]),
//                         //           );
//                         //         }),
//                         //         // _buildRichDescription(),
//                         //       ],
//                         //     ),
//                         //   );
//                         // }),
//                         4.width,
//                       ],
//                     ),
//                   ),
//                 ),
//               ).expand(),
//               SizedBox(width: 10),
//               GestureDetector(
//                 onTap: () {
//                   FocusScope.of(context).unfocus();
//                   // Future.delayed(Duration(seconds:1)).then((e){
//                   var chatPageVM =
//                   Provider.of<PlayTabooScreenVM>(context, listen: false);
//                   String messageText = chatPageVM.controller.text.trim();
//                   chatPageVM.controller.clear();
//                   Navigator.pop(context, messageText);
//                   // });
//                   // unmuteSystemSounds();
//                 },
//                 child: Container(
//                   padding: EdgeInsets.all(13),
//                   decoration: BoxDecoration(
//                     color: primaryColor,
//                     borderRadius: BorderRadius.circular(40),
//                   ),
//                   child: Icon(Icons.send, color: Colors.white),
//                 ),
//               ),
//             ],
//           ).paddingTop(10),
//         ],
//       ),
//     );
//   }
//
//   void showInstructionDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12.0),
//           ),
//           child: AnimatedContainer(
//             duration: Duration(milliseconds: 300),
//             curve: Curves.easeInOut,
//             width: MediaQuery.of(context).size.width * 0.9,
//             padding: EdgeInsets.all(12.0),
//             child: SingleChildScrollView(
//               child: Stack(
//                 clipBehavior: Clip.none,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       10.height,
//                       Text(
//                         'How should I speak?',
//                         style: secondaryTextStyle(
//                             size: 24, weight: FontWeight.bold),
//                       ),
//                       SizedBox(height: 20),
//                       Text(
//                         'Please locate the Mic icon on your keyboard.',
//                         style: secondaryTextStyle(),
//                       ),
//                       SizedBox(height: 10),
//                       Text(
//                         'Not seeing a Mic icon?',
//                         style: secondaryTextStyle(size: 18),
//                       ),
//                       SizedBox(height: 10),
//                       buildReason(
//                           'Reason 1',
//                           '(Gboard) Long press comma and open settings. Turn on ',
//                           'voice typing ',
//                           'inside settings\n'),
//                       buildReason(
//                           'Reason 2',
//                           'Check your App settings and locate your keyboard App. Make sure you have given ',
//                           'microphone permission.\n',
//                           ''),
//                       buildReason(
//                           'Reason 3',
//                           'Inside Keyboard settings, go to Text suggestions and then turn on ',
//                           'show suggestion strip\n',
//                           ''),
//                     ],
//                   ),
//                   Positioned(
//                     top: -30,
//                     right: -30,
//                     child: GestureDetector(
//                       onTap: () {
//                         Navigator.of(context).pop();
//                       },
//                       child: CircleAvatar(
//                         radius: 15,
//                         backgroundColor: Colors.black,
//                         child: Icon(
//                           Icons.close,
//                           color: Colors.white,
//                           size: 16,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget buildReason(
//       String title, String text, String highlight, String remaining) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: primaryTextStyle(),
//         ),
//         Text.rich(
//           TextSpan(
//             children: [
//               TextSpan(text: text),
//               TextSpan(
//                   text: highlight,
//                   style: primaryTextStyle(weight: FontWeight.bold)),
//               TextSpan(text: remaining),
//             ],
//           ),
//         ),
//         SizedBox(height: 10),
//       ],
//     );
//   }
// }