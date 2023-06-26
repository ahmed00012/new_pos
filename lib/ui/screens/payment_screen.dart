
import 'dart:typed_data';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:screenshot/screenshot.dart';

import 'package:shormeh_pos_new_28_11_2022/data_controller/home_controller.dart';
import 'package:shormeh_pos_new_28_11_2022/data_controller/new_order_controller.dart';

import 'package:shormeh_pos_new_28_11_2022/ui/widgets/receipt.dart';


import '../../constants.dart';
import '../../data_controller/cart_controller.dart';
import '../../local_storage.dart';
import '../../models/cart_model.dart';
import 'cart.dart';
import 'home.dart';


class PaymentScreen extends ConsumerStatefulWidget {

  bool? selectCustomer;
  bool? fromHome;

  PaymentScreen({this.selectCustomer,this.fromHome});

  @override
  PaymentScreenState createState() => PaymentScreenState();
}

class PaymentScreenState extends ConsumerState {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {

    final orderController = ref.watch(newOrderFuture);
    final cartController = ref.watch(cartFuture);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: scaffoldKey,
      body: Row(
        children: [

          Cart(
            navigate: false,
            page: 'orderMethod',
            closeEdit: true,
          ),

          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                        child: Container(
                          width: size.width * 0.35,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //////////////payment////////////////////////////////////////

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Text(
                                        'payment'.tr() + ' : ',
                                        style: TextStyle(
                                            fontSize: size.height * 0.03,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(
                                height: 10,
                              ),



                              Container(
                                width: size.width * 0.35,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount:
                                        orderController.paymentMethods.length,
                                    itemBuilder: (context, i) {
                                      return orderController.paymentMethods[i].id == 2 ||
                                          orderController.paymentMethods[i].id == 7
                                          ? Container()
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                              child: InkWell(
                                                onTap: () {
                                                    orderController.selectPayment(i,context);

                                                  },
                                                child: Container(
                                                  width: size.width * 0.3,
                                                  height: size.height * 0.06,
                                                  decoration: BoxDecoration(
                                                      color: orderController
                                                              .paymentMethods[i]
                                                              .chosen!
                                                          ? Constants.mainColor
                                                          : Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                          color:
                                                              Colors.black12)),
                                                  child: Center(
                                                    child: Text(
                                                      orderController
                                                          .paymentMethods[i]
                                                          .title!.en!,
                                                      style: TextStyle(
                                                          fontSize:
                                                              size.height *
                                                                  0.02,
                                                          color: orderController
                                                                  .selectCustomerChosen
                                                              ? Colors.black38
                                                              : orderController
                                                                      .paymentMethods[
                                                                          i]
                                                                      .chosen!
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                    }),
                              ),

                              if(cartController.orderDetails.customer==null &&
                                  cartController.orderDetails.orderStatusID !=4 &&
                                  cartController.orderDetails.paymentStatus !=0)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: orderController.chosenOwner == null
                                          ? Colors.white
                                          : Constants.mainColor,
                                      borderRadius: BorderRadius.circular(10),
                                      border:
                                          Border.all(color: Colors.black12)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: ExpansionTile(
                                      key: Key(orderController.key.toString()),
                                      collapsedIconColor: Colors.lightGreen,
                                      iconColor: Colors.lightGreen,
                                      title: Center(
                                        child: Text(
                                          orderController.chosenOwner == null
                                              ? 'others'.tr()
                                              : orderController
                                                  .chosenOwner!.title!,
                                          style: TextStyle(
                                              fontSize: size.height * 0.02,
                                              color:
                                                  orderController.chosenOwner ==
                                                          null
                                                      ? Colors.black
                                                      : Colors.white,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      children:
                                          orderController.owners.map((element) {
                                        return InkWell(
                                          onTap: () {
                                            orderController.selectOwner(
                                                orderController.owners
                                                    .indexOf(element));
                                          },
                                          child: Container(
                                            width: size.width * 0.35,
                                            height: size.height * 0.06,
                                            color: element.chosen!
                                                ? Colors.lightGreen
                                                : Colors.white,
                                            child: Center(
                                              child: Text(
                                                element.title!,
                                                style: TextStyle(
                                                    fontSize:
                                                        size.height * 0.02,
                                                    color: element.chosen!
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),

                              // InkWell(
                              //   onTap: (){
                              //    print(cartController.orderDetails.updateWithCoupon);
                              //    print(cartController.orderDetails.customer);
                              //    print(cartController.orderDetails.discount);
                              //    print( cartController.orderDetails.paymentStatus);
                              //    print(cartController.orderDetails.orderStatusID);
                              //   },
                              //   child:
                                SizedBox(
                                  height: 30,
                                  width: size.width,
                                ),
                              // ),

                              ////////////////////////////coupon/////////////////////////////////////////////////////


                              if (
                             ( cartController.orderDetails.updateWithCoupon == false ||
                                 cartController.orderDetails.updateWithCoupon == null)
                                  && cartController.orderDetails.customer == null&&
                                  (cartController.orderDetails.discount== null
                                      || cartController.orderDetails.discount == '0')&&
                                 cartController.orderDetails.orderStatusID !=4
                              )
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical:  10),
                                  child: Container(
                                    width: size.width * 0.35,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 7,
                                          child: Container(
                                            height: size.height * 0.07,

                                            // width: size.width*0.4,

                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Colors.black12,
                                                    width: 1.2),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: TextField(

                                                controller:
                                                    orderController.coupon,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.all(10),
                                                  label: Text(
                                                    'coupon'.tr(),
                                                    style: TextStyle(
                                                      fontSize:
                                                          size.height * 0.02,
                                                      color: Colors.black45,
                                                    ),
                                                  ),
                                                  border: InputBorder.none,
                                                  icon: Image.asset(
                                                    'assets/images/discount.png',
                                                    color: Colors.black45,
                                                    height: 30,
                                                    width: 30,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: InkWell(
                                              onTap: () {
                                                // FocusManager
                                                //     .instance.primaryFocus
                                                //     ?.unfocus();
                                                orderController.checkCoupon();
                                              },
                                              child: Container(
                                                height: size.height * 0.07,
                                                // width: size.width*0.2,
                                                decoration: BoxDecoration(
                                                    color: Constants.mainColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Center(
                                                  child: Text(
                                                    'add'.tr(),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            size.height * 0.02),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              if(cartController.orderDetails.discount!=null&& cartController.orderDetails.discount!='0')
                                Container(
                                  height: size.height*0.1,
                                  width: size.width*0.4,

                                  decoration: BoxDecoration(
                                     color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: Constants.mainColor)
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,

                                    children: [

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/images/discount.png',
                                            color: Constants.mainColor,
                                            height: 30,
                                            width: 30,
                                          ),
                                          SizedBox(width: 20,),
                                          Text('couponDiscount'.tr(),style: TextStyle(
                                              color: Constants.mainColor,
                                              fontSize: size.height*0.02
                                          ),)
                                        ],
                                      ),
                                      cartController.orderDetails.discount!.contains('%')?
                                      Text(
                                        cartController.orderDetails.discount!,
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ):
                                      Text(
                                        cartController.orderDetails.discount!+  ' SAR',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                        color: Constants.mainColor),
                                      ),
                                    ],
                                  ),
                                ),

                              SizedBox(
                                height: size.height * 0.06,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if(cartController.orderDetails.cart!=null)
                          Padding(
                            padding:
                          LocalStorage.getData(key: 'language')=='en'?
                              EdgeInsets.fromLTRB(0, 0, 60, 0):
                          EdgeInsets.fromLTRB(60, 0, 0, 0)  ,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                width: size.width * 0.3,
                                height: size.height*0.9,

                                child: Receipt(screenshotController: screenshotController,onScreenShot: (){
                                  orderController.imageProductsPrinter(screenshotController);
                                  Future.delayed(Duration(milliseconds: 500),(){

                                    orderController.testPrint();

                                  });
                                }),
                              ),
                            ),
                          ),
                        ],
                      ),

                ),

                ////////////////////////////// x button ///////////////////////////////
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment:LocalStorage.getData(key: 'language')=='en'?
                    Alignment.topRight:Alignment.topLeft,
                    child: InkWell(
                      onTap: () {
                        if(cartController.orderDetails.orderUpdatedId != null &&
                        cartController.orderDetails.paymentStatus == 0){

                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Center(
                                    child: Text(
                                        'cancelEditing'.tr(),
                                        style: TextStyle(
                                          fontSize: 24,
                                        )),
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          height: MediaQuery.of(context).size.height*0.07,
                                          width: MediaQuery.of(context).size.width*0.1,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  10),
                                              color: Constants.mainColor),
                                          child: InkWell(
                                            onTap: () {
                                              // viewModel.emptyCardList();
                                              orderController.cancelPayment();
                                              Navigator.pushAndRemoveUntil(context,
                                                  MaterialPageRoute(builder: (_)=>Home()), (route) => false);

                                            },
                                            child: Center(
                                              child: Text(
                                                'yes'.tr(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:24),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 40,),
                                        Container(
                                          height: MediaQuery.of(context).size.height*0.07,
                                          width: MediaQuery.of(context).size.width*0.1,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  10),
                                              color: Constants.mainColor),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pop(context);

                                            },
                                            child: Center(
                                              child: Text(
                                                'no'.tr(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:24),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                    ],
                                  ),
                                );
                              });
                        }


                       else{
                          orderController.cancelPayment();
                          Navigator.pop(context);
                        }




                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            color: Colors.red[400],
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Icon(
                            Icons.clear,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                ///////////////////////////////////////////////////////////////////done button//////////////////////



                Align(
                  alignment: Alignment.bottomCenter,
                   child: Row(
                     children: [
                       Expanded(
                         child: Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: InkWell(
                             onTap: () {
                               orderController.checkOrderDetails(0, context,screenshotController);
                               },
                             child: Container(
                               height: size.height * 0.07,

                               decoration: BoxDecoration(
                                 color: Constants.mainColor,
                                 borderRadius: BorderRadius.circular(10)
                               ),

                               child: Center(
                                 child: Text(
                                   'pay'.tr() + '/' + 'send'.tr(),
                                   style: TextStyle(
                                     fontSize: size.height * 0.035,
                                     color: Colors.white
                                   ),
                                 ),
                               ),
                             ),
                           ),
                         ),
                       ),
                       if (cartController.orderDetails.orderUpdatedId==null &&
                           cartController.orderDetails.customer==null)
                         Expanded(
                           child: Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: InkWell(
                               onTap: () {
                                 orderController.checkOrderDetails(1, context,screenshotController);
                               },
                               child: Container(
                                 height: size.height * 0.07,

                                 decoration: BoxDecoration(
                                     color: Constants.secondryColor,
                                     borderRadius: BorderRadius.circular(10)
                                 ),
                                 child: Center(
                                   child: Text(
                                     'hold'.tr(),
                                     style: TextStyle(
                                       color: Colors.white,
                                       fontSize: size.height * 0.035,
                                     ),
                                   ),
                                 ),
                               ),
                             ),
                           ),
                         ),

                         if( cartController.orderDetails.customer!=null)
                         Expanded(
                           child: Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: InkWell(
                               onTap: () {


                                 orderController.switchLoading(true);
                                 orderController.cancelPayment();
                                orderController.checkOrderDetails(0, context,screenshotController);
                               },
                               child: Container(
                                 height: size.height * 0.07,

                                 decoration: BoxDecoration(
                                     color: Constants.secondryColor,
                                     borderRadius: BorderRadius.circular(10)
                                 ),
                                 child: Center(
                                   child: Text(
                                     'payLater'.tr(),
                                     style: TextStyle(
                                       color: Colors.white,
                                       fontSize: size.height * 0.035,
                                     ),
                                   ),
                                 ),
                               ),
                             ),
                           ),
                         ),
                     ],
                   ),
                ),

                if (orderController.loading)
                  Container(
                    height: size.height,
                    width: size.width,
                    color: Colors.white.withOpacity(0.8),
                    child: Center(
                      child:
                      LoadingAnimationWidget.inkDrop(
                        color: Constants.mainColor,
                        size: size.height*0.2,
                      ),
                    ),
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}
