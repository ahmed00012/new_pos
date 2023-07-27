import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/colors.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/styles.dart';
import 'package:shormeh_pos_new_28_11_2022/data_controller/order_method_controller.dart';


class CountOfGuests extends StatefulWidget {
  const CountOfGuests({super.key});

  @override
  _CountOfGuestsState createState() => _CountOfGuestsState();
}

class _CountOfGuestsState extends State<CountOfGuests> {
  String text = '';
  @override
  Widget build(BuildContext context) {
     Size size = MediaQuery.of(context).size;
    return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Container(
                  height: size.height*0.09,
                  width: size.width*0.285,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(text,
                        style: TextStyle(fontSize: size.height * 0.025)),
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
                    height: size.height*0.09,
                    width: size.width*0.09,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),

                    child: Center(
                      child: Text(
                        e.toString(),
                        style: TextStyle(fontSize: size.height * 0.022),
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
                    height: size.height*0.09,
                    width: size.width*0.09,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        e.toString(),
                        style: TextStyle(fontSize: size.height * 0.022),
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
                    height: size.height*0.09,
                    width: size.width*0.09,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        e.toString(),
                        style: TextStyle(fontSize: size.height * 0.022),
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
                      height: size.height*0.09,
                      width: size.width*0.09,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.backspace_outlined,
                          size: size.height * 0.03,
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
                      height: size.height*0.09,
                      width: size.width*0.09,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '0',
                          style: TextStyle(fontSize: size.height * 0.022),
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

                        ConstantStyles.displayToastMessage('numOfGuestsAlert'.tr(), true);

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
                      height: size.height*0.09,
                      width: size.width*0.09,
                      decoration: BoxDecoration(
                        color: Constants.mainColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.check,
                          size: size.height * 0.035,
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




