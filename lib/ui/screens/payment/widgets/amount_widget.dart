import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';

import '../../../../constants/colors.dart';

class AmountWidget extends StatefulWidget {
 String? predict1;
 String? predict2;
 String? predict3;
 String? predict4;
 String? remainingAmount;
 bool? showTextField;
 AmountWidget({this.predict1,this.predict2,this.predict3,this.predict4,this.remainingAmount,this.showTextField});

  @override
  _AmountWidgetState createState() => _AmountWidgetState();
}

class _AmountWidgetState extends State<AmountWidget> {
TextEditingController amount =TextEditingController();
bool predict1Chosen= true;
bool predict2Chosen=false;
bool predict3Chosen=false;
bool predict4Chosen=false;



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if(widget.predict1.toString()!='null')
            InkWell(
              onTap: (){
                setState(() {
                  predict1Chosen=true;
                  predict2Chosen=false;
                  predict3Chosen=false;
                  predict4Chosen=false;
                  amount.text='';
                });
                // Navigator.pop(context,widget.predict1);
              },
              child: Container(
                height: size.height*0.08,
                width: 250,
                decoration: BoxDecoration(
                    color: predict1Chosen?Constants.mainColor:Colors
                        .white,
                    borderRadius:
                    BorderRadius.circular(10),
                    border: Border.all(color:  predict1Chosen?Constants.mainColor:Colors
                        .black12,)
                ),
                child:
                Center(
                  child:
                  Text(
                    widget.predict1!,
                    style: TextStyle(
                      fontSize:
                      size.height * 0.02,
                      color: predict1Chosen?Colors
                          .white:Colors
                          .black,),
                  ),
                ),
              ),
            ),
          if(widget.predict1.toString()!='null')
            SizedBox(
              height: 20,
            ),
          if(widget.predict2.toString()!='null')
            InkWell(
              onTap: (){
                setState(() {
                  predict1Chosen=false;
                  predict2Chosen=true;
                  predict3Chosen=false;
                  predict4Chosen=false;
                  amount.text='';
                });
              },
              child: Container(
                height: size.height*0.08,
                width: 250,
                decoration: BoxDecoration(
                    color: predict2Chosen?Constants.mainColor:Colors
                        .white,
                    borderRadius:
                    BorderRadius.circular(10),
                    border: Border.all(color:  predict2Chosen?Constants.mainColor:Colors
                        .black12,)),
                child:
                Center(
                  child:
                  Text(
                    widget.predict2!,
                    style: TextStyle(
                      fontSize:
                      size.height * 0.02,
                      color: predict2Chosen?Colors
                          .white:Colors
                          .black,),
                  ),
                ),
              ),
            ),
          if(widget.predict2.toString()!='null')
            SizedBox(
              height: 20,
            ),
          if(widget.predict3.toString()!='null')
            InkWell(
              onTap: (){
                setState(() {
                  predict1Chosen=false;
                  predict2Chosen=false;
                  predict3Chosen=true;
                  predict4Chosen=false;
                  amount.text='';
                });
              },
              child: Container(
                height: size.height*0.08,
                width: 250,
                decoration: BoxDecoration(
                    color: predict3Chosen?Constants.mainColor:Colors
                        .white,
                    borderRadius:
                    BorderRadius.circular(10),
                    border: Border.all(color:  predict3Chosen?Constants.mainColor:Colors
                        .black12,)),
                child:
                Center(
                  child:
                  Text(
                    widget.predict3!,
                    style: TextStyle(
                      fontSize:
                      size.height * 0.02,
                      color: predict3Chosen?Colors
                          .white:Colors
                          .black,),
                  ),
                ),
              ),
            ),

          if(widget.predict3.toString()!='null')
            SizedBox(
              height: 20,
            ),
          if(widget.predict4.toString()!='null')
            InkWell(
              onTap: (){
                setState(() {
                  predict1Chosen=false;
                  predict2Chosen=false;
                  predict3Chosen=false;
                  predict4Chosen=true;
                  amount.text='';
                });
              },
              child: Container(
                height:size.height*0.08,
                width: 250,
                decoration: BoxDecoration(
                    color: predict4Chosen?Constants.mainColor:Colors
                        .white,
                    borderRadius:
                    BorderRadius.circular(10),
                    border: Border.all(color:  predict4Chosen?Constants.mainColor:Colors
                        .black12,)),
                child:
                Center(
                  child:
                  Text(
                    widget.predict4!,
                    style: TextStyle(
                      fontSize:
                      size.height * 0.02,
                      color: predict4Chosen?Colors
                          .white:Colors
                          .black,),
                  ),
                ),
              ),
            ),
          if(widget.predict4.toString()!='null')
            SizedBox(
              height: 20,
            ),
          if(widget.showTextField!)
            Container(
              height: size.height*0.08,
              width: 250,
              decoration: BoxDecoration(
                color: Colors
                    .white,
                borderRadius:
                BorderRadius.circular(10),
              ),
              child:
              Center(
                child: TextField(
                  controller:amount ,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border:OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.black12)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Constants.mainColor)
                    ),
                    hintText: 'anotherAmount'.tr(),
                  ),
                  onTap: (){
                    setState(() {
                      predict1Chosen=false;
                      predict2Chosen=false;
                      predict3Chosen=false;
                      predict4Chosen=false;
                    });
                  },

                ),
              ),
            ),
          if(widget.remainingAmount!=null)
            Container(
              height: 70,
              width: 250,
              decoration: BoxDecoration(
                  color: Constants.mainColor,
                  borderRadius:
                  BorderRadius.circular(10)),
              child:
              Center(
                child:
                Text(
                  widget.remainingAmount!,
                  style: TextStyle(
                      fontSize:
                      size.height * 0.02,
                      color: Colors.white),
                ),
              ),
            ),
          SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: (){

              if(predict1Chosen && widget.remainingAmount==null) {

                Navigator.pop(context, widget.predict1);
              }
              if(predict2Chosen) {
                Navigator.pop(context, widget.predict2);
              }
              if(predict3Chosen) {

                Navigator.pop(context, widget.predict3);
              }
              if(predict4Chosen) {

                Navigator.pop(context, widget.predict4);
              }
              if(amount.text.isNotEmpty) {
                Navigator.pop(context, amount.text);
              }
              if(widget.remainingAmount!=null) {

                Navigator.pop(context, widget.remainingAmount);
                amount.text ='';
              }
            },
            child: Container(
              height: size.height*0.08,
              width: 150,

              decoration: BoxDecoration(
                  color: Constants.mainColor,
                  borderRadius:
                  BorderRadius.circular(10)),
              child:
              Center(
                child: Text(
                  'ok'.tr(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: size.height*0.025
                  ),

                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
