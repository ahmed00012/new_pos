import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/colors.dart';

class ConstantStyles {


  static const PosStyles centerBold = PosStyles(align: PosAlign.center, bold: true);
  static const PosStyles center = PosStyles(align: PosAlign.center);
  static const PosStyles left = PosStyles(align: PosAlign.left);
  static const PosStyles leftBold = PosStyles(align: PosAlign.left, bold: true);
  static const PosStyles right = PosStyles(align: PosAlign.left);
  static const PosStyles rightBold = PosStyles(align: PosAlign.left, bold: true);


  static contextSize(BuildContext context){
    return MediaQuery.of(context).size;
  }
  static contextHeight(BuildContext context){
    return MediaQuery.of(context).size.height;
  }
  static contextWidth(BuildContext context){
    return MediaQuery.of(context).size.width;
  }

  // static showDialog({required BuildContext context,
  //   required String title,
  //   required Widget content,}){
  // AlertDialog(
  //         titlePadding: EdgeInsets.zero,
  //         title: Column(
  //           children: [
  //             Padding(
  //               padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
  //               child: Align(
  //                   alignment: Alignment.topRight,
  //                   child: InkWell(
  //                     onTap: (){
  //                       Navigator.pop(context);
  //                     },
  //                     child: Container(
  //                       height: contextHeight(context)*0.05,
  //                       width: contextHeight(context)*0.05,
  //                       decoration: BoxDecoration(
  //                           color: Colors.red[400],
  //                           borderRadius: BorderRadius.circular(10)),
  //                       child: const Center(
  //                         child: Icon(
  //                           Icons.clear,
  //                           color: Colors.white,
  //                         ),
  //                       ),
  //                     ),
  //                   )),
  //             ),
  //             Text(
  //               title, style: TextStyle(fontSize: contextHeight(context) * 0.025),
  //             ),
  //           ],
  //         ),
  //         content: content,
  //       );
  // }


  static Future showPopup({
    required BuildContext context,
    required Widget content,
    required String title,
  }) async {
    return showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.symmetric(horizontal: 20),
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: Align(
                            alignment: Alignment.topRight,
                            child: InkWell(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: contextHeight(context)*0.05,
                                width: contextHeight(context)*0.05,
                                decoration: BoxDecoration(
                                    color: Colors.red[400],
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Center(
                                  child: Icon(
                                    Icons.clear,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )),
                      ),
                      Text(
                        title, style: TextStyle(fontSize: contextHeight(context) * 0.025),
                      ),
                      SizedBox(height: 20,),
                      content
                    ],
                  ),
        ),
      ),
    );
  }



  static displayToastMessage(String toastMessage, bool alert) {
    showSimpleNotification(
        Container(
          height: 50,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Center(
              child: Text(
                toastMessage,
                style:const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
        duration: const Duration(seconds: 3),
        elevation: 2,
        background: alert? Colors.red[500] : Constants.secondryColor);
  }

}