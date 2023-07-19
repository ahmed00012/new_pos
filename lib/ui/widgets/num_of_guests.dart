import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/colors.dart';
import 'package:shormeh_pos_new_28_11_2022/data_controller/order_method_controller.dart';


class Numpad2 extends StatefulWidget {
double height;
double width;
 Numpad2(this.height,this.width);
  @override
  _Numpad2State createState() => _Numpad2State();
}

class _Numpad2State extends State<Numpad2> {
  String text = '';
  @override
  Widget build(BuildContext context) {
     // Size size = MediaQuery.of(context).size;
    return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Container(
                  height: widget.height*0.09,
                  width: widget.width*0.285,
                  color: Colors.white,
                  child: Center(
                    child: Text(text,
                        style: TextStyle(fontSize: widget.height * 0.025)),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [1, 2, 3]
                  .map((e) => InkWell(
                onTap: () {
                  setState(() {
                   text=text+e.toString();
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    height: widget.height*0.09,
                    width: widget.width*0.09,
                    color: Colors.white,
                    child: Center(
                      child: Text(
                        e.toString(),
                        style: TextStyle(fontSize: widget.height * 0.022),
                      ),
                    ),
                  ),
                ),
              ))
                  .toList(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [4, 5, 6]
                  .map((e) => InkWell(
                onTap: () {
                  setState(() {
                    text=text+e.toString();
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    height: widget.height*0.09,
                    width: widget.width*0.09,
                    color: Colors.white,
                    child: Center(
                      child: Text(
                        e.toString(),
                        style: TextStyle(fontSize: widget.height * 0.022),
                      ),
                    ),
                  ),
                ),
              ))
                  .toList(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [7, 8, 9]
                  .map((e) => InkWell(
                onTap: () {
                  setState(() {
                   text=text+e.toString();
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    height: widget.height*0.09,
                    width: widget.width*0.09,
                    color: Colors.white,
                    child: Center(
                      child: Text(
                        e.toString(),
                        style: TextStyle(fontSize: widget.height * 0.022),
                      ),
                    ),
                  ),
                ),
              ))
                  .toList(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {

                    if (text.isNotEmpty)
                     setState(() {
                       text = text.substring(0,text.length-1);
                     });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      height: widget.height*0.09,
                      width: widget.width*0.09,
                      color: Colors.green,
                      child: Center(
                        child: Icon(
                          Icons.backspace_outlined,
                          size: widget.height * 0.03,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (text.isNotEmpty)
                     setState(() {
                       text=text+'0';
                     });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      height: widget.height*0.09,
                      width: widget.width*0.09,
                      color: Colors.white,
                      child: Center(
                        child: Text(
                          '0',
                          style: TextStyle(fontSize: widget.height * 0.022),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: InkWell(
                    onTap: () {

                      if(text!='') {

                    Navigator.pop(context,int.parse(text));
                  }
                      else{
                        showSimpleNotification(
                           Container(
                              height: 60,
                              child:  Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: Center(
                                  child: Text(
                                    'numOfGuestsAlert'.tr(),
                                    style: TextStyle(
                                        color: Colors.white ,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                            duration: Duration(seconds: 3),
                            elevation: 2,
                            background: Colors.red[500] );
                      }

                  // if (ordersScreen == null) {
                      //   HomeController.cardItems[viewModel.chosenItem!].count =
                      //       int.parse(viewModel.countText.join());
                      //   viewModel.textCountController(viewModel.chosenItem!);
                      // } else {
                      //   ordersController.searchOrder(int.parse(viewModel.countText.join())) ;
                      // }
                      //
                      // viewModel.countText = [];
                      //
                    },
                    child: Container(
                      height: widget.height*0.08,
                      width: widget.width*0.09,
                      color: Constants.mainColor,
                      child: Center(
                        child: Icon(
                          Icons.check,
                          size: widget.height * 0.035,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ));
  }
}




