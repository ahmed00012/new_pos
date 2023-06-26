import 'dart:typed_data';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shormeh_pos_new_28_11_2022/data_controller/home_controller.dart';
import 'package:shormeh_pos_new_28_11_2022/local_storage.dart';

import 'package:shormeh_pos_new_28_11_2022/ui/screens/payment_screen.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/widgets/receipt.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/widgets/delivery_order.dart';
import 'package:image/image.dart' as img;
import '../../constants.dart';
import '../../data_controller/cart_controller.dart';
import '../../data_controller/order_method_controller.dart';
import '../widgets/tables_dialog.dart';
import 'cart.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class OrderMethod extends ConsumerStatefulWidget {
  const OrderMethod({Key? key}) : super(key: key);

  @override
  OrderMethodState createState() => OrderMethodState();
}

class OrderMethodState extends ConsumerState<OrderMethod> {

ScreenshotController screenshotController = ScreenshotController();
Uint8List? productsImage;
img.Image? productsScreenshot;

imageProductsPrinter() async {
  final controller = ref.watch(orderMethodFuture);
  screenshotController.capture().then((Uint8List? image2) {
    setState((){   productsScreenshot = img.decodePng(image2!);
    productsScreenshot!.setPixelRgba(0, 0, 255,255,255);
    productsScreenshot= img.copyResize(productsScreenshot!, width: 550);
    productsImage = image2;
    controller.setImageScreenshot(image2,productsScreenshot);

    });
  });
}

  @override
  Widget build(BuildContext context) {
  final orderController = ref.watch(orderMethodFuture);
  final cartController = ref.watch(cartFuture);

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: Cart(
              navigate: false,
              page: 'orderMethod',
            ),
          ),

          Expanded(

            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    children: [

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Padding(
                                padding: const EdgeInsets.only(left: 10,bottom: 10),
                                child: Text(
                                  'order'.tr(),
                                  style: TextStyle(
                                      fontSize: size.height * 0.03,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              // ),
                              Container(
                                width: size.width*0.38,
                                child: GridView.builder(
                                    itemCount: orderController.orderMethods.length,
                                    physics: NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 1.1,
                                    ),
                                    shrinkWrap: true,
                                    itemBuilder: (context, i) {
                                      return Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: InkWell(
                                          onTap: () async{

                                            orderController.setOrderMethod(
                                                orderController.orderMethods[i], i);
                                            if (orderController.orderMethods[i].id ==
                                                1) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) => PaymentScreen(fromHome: false,)));
                                            }
                                            if (orderController.orderMethods[i].id ==
                                                3) {

                                              Future.delayed(Duration(milliseconds: 100),(){
                                                imageProductsPrinter();
                                                orderController.confirmOrder(context);

                                              });



                                            }   if (orderController.orderMethods[i].id == 2) {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                        titlePadding: EdgeInsets.zero,
                                                        contentPadding: EdgeInsets.zero,
                                                        title: Column(
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.fromLTRB(
                                                                  10, 10, 10, 0),
                                                              child: Align(
                                                                  alignment: Alignment.topRight,
                                                                  child: InkWell(
                                                                    onTap: () {
                                                                      Navigator.pop(context);
                                                                    },
                                                                    child: Container(
                                                                      height: size.height * 0.05,
                                                                      width: size.height * 0.05,
                                                                      decoration: BoxDecoration(
                                                                          color: Colors.red[400],
                                                                          borderRadius:
                                                                          BorderRadius.circular(
                                                                              10)),
                                                                      child: Center(
                                                                        child: Icon(
                                                                          Icons.clear,
                                                                          color: Colors.white,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )),
                                                            ),
                                                          ],
                                                        ),
                                                        content: Container(
                                                            height: size.height * 0.7,
                                                            width: size.width * 0.7,
                                                            child: TablesDialog()));
                                                  }).then((value) async{

                                                if(value!=null)
                                                  Future.delayed(Duration(milliseconds: 100),(){
                                                    imageProductsPrinter();
                                                    orderController.confirmOrder(context,guestsCount: value);

                                                  });
                                              });



                                            }

                                            if (orderController.orderMethods[i].id ==
                                                4) {
                                              orderController.getCoupons();
                                              orderController.getClients();
                                              if(cartController.orderDetails.clientPhone==null){
                                                orderController.customerPhone.text = '';
                                                orderController.customerName.text = '';
                                              }
                                              else{orderController.refreshData();}
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      contentPadding: EdgeInsets.zero,

                                                      title: Center(
                                                        child: Text(
                                                          'orderDetails'.tr(),
                                                          style: TextStyle(
                                                              fontSize:
                                                              size.height * 0.025),
                                                        ),
                                                      ),
                                                      content: DeliveryOrder(),
                                                    );
                                                  }).then((value) async{
                                                if(value==true) {
                                                  Future.delayed(
                                                      Duration(milliseconds: 100),
                                                          () {
                                                        imageProductsPrinter();
                                                        orderController
                                                            .confirmOrder(context);
                                                      });
                                                } else{
                                                  orderController.coupon.text = '';
                                                  orderController.deliveryFee.text = '';
                                                  cartController.orderDetails.deliveryFee = null;
                                                  ref.refresh(orderMethodFuture);

                                                }
                                              });
                                            }
                                          },
                                          child: Container(
                                            height: size.height * 0.2,
                                            width: size.width * 0.2,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(15),
                                                border: Border.all(
                                                    color: orderController
                                                        .orderMethods[i].chosen!
                                                        ? Constants.mainColor
                                                        : Colors.black12,
                                                    width: orderController
                                                        .orderMethods[i].chosen!
                                                        ? 2
                                                        : 1)),
                                            child: Center(
                                              child: Text(
                                                orderController.orderMethods[i].title!.en!,
                                                style: TextStyle(
                                                    fontSize: size.height * 0.025,
                                                    fontWeight: FontWeight.w500,
                                                    color: orderController
                                                        .orderMethods[i].chosen!
                                                        ? Constants.mainColor
                                                        : Colors.black45),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Container(

                                height: size.height,
                                child: Receipt(screenshotController: screenshotController,
                                    onScreenShot: (){
                                      imageProductsPrinter();
                                      Future.delayed(Duration(milliseconds: 500),(){
                                        orderController.testPrint();

                                      });
                                    }),
                              ),
                            ),
                          ),
                          Align(
                            alignment:
                            LocalStorage.getData(key: 'language')=='en'?
                            Alignment.topRight:Alignment.topLeft,
                            child: InkWell(
                              onTap: () {

                                Navigator.pop(context);

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

                        ],
                      ),

                      // Screenshot(
                      //   controller: printerController.screenshotController2,
                      //   child: Container(
                      //     child: printerController.receipt(orderController.chosenOrderMethod!),
                      //   ),
                      // ),
                      SizedBox(
                        height: 50,
                      ),
                      /////////////////////////////////////////tables////////////////////////////////
                      // if (orderController.tablesWidget)
                      // ListView.builder(
                      //     shrinkWrap: true,
                      //     physics: NeverScrollableScrollPhysics(),
                      //     itemCount: orderController.departments.length,
                      //     itemBuilder: (context, index) {
                      //       return ListView(
                      //         physics: NeverScrollableScrollPhysics(),
                      //         shrinkWrap: true,
                      //         children: [
                      //           Center(
                      //             child: Text(
                      //               orderController.departments[index].title!,
                      //               style: TextStyle(
                      //                   fontSize: size.height * 0.025,
                      //                   fontStyle: FontStyle.italic,
                      //                   fontWeight: FontWeight.bold,
                      //                   color: Colors.blue),
                      //             ),
                      //           ),
                      //           SizedBox(
                      //             height: 15,
                      //           ),
                      //           GridView.builder(
                      //             itemCount: orderController
                      //                 .departments[index].tables!.length,
                      //             physics: NeverScrollableScrollPhysics(),
                      //             shrinkWrap: true,
                      //             gridDelegate:
                      //             SliverGridDelegateWithFixedCrossAxisCount(
                      //               crossAxisCount: 6,
                      //               childAspectRatio: 1.5,
                      //             ),
                      //             itemBuilder: (context, i) {
                      //               return Card(
                      //                 shape: RoundedRectangleBorder(
                      //                   borderRadius:
                      //                   BorderRadius.circular(10.0),
                      //                 ),
                      //                 child: InkWell(
                      //                   onTap: () {
                      //                     // List<CardModel> cardItemsCopy =
                      //                     // List.from(
                      //                     //     HomeController.orderDetails.cart!);
                      //                     // print('jjjjjcccss'.length);
                      //
                      //                     if (orderController
                      //                         .departments[index]
                      //                         .tables![i]
                      //                         .currentOrder ==
                      //                         null) {
                      //                       orderController.reserveTable(
                      //                           index,
                      //                           orderController
                      //                               .departments[index]
                      //                               .tables![i]);
                      //                       showDialog(
                      //                           context: context,
                      //                           builder: (context) {
                      //                             return AlertDialog(
                      //                               backgroundColor: Constants
                      //                                   .scaffoldColor,
                      //                               scrollable: true,
                      //                               title: Center(
                      //                                 child: Text(
                      //                                     'NumOfGuests'.tr()),
                      //                               ),
                      //                               content: Container(
                      //                                 child: Numpad2(
                      //                                     size.height,
                      //                                     size.width),
                      //                               ),
                      //                             );
                      //                           }).then((value)async {
                      //                         if (value != null) {
                      //                           await orderController.confirmOrder(context, guestsCount: value);
                      //                         }
                      //                       });
                      //                     }
                      //                   },
                      //                   child: Container(
                      //                     decoration: BoxDecoration(
                      //                         color: orderController
                      //                             .departments[
                      //                         index]
                      //                             .tables![i]
                      //                             .currentOrder !=
                      //                             null ||
                      //                             orderController
                      //                                 .departments[index]
                      //                                 .tables![i]
                      //                                 .chosen!
                      //                             ? Constants.colorRed
                      //                             : Colors.white,
                      //                         borderRadius:
                      //                         BorderRadius.circular(10.0),
                      //                         border: Border.all(
                      //                             color: orderController
                      //                                 .departments[
                      //                             index]
                      //                                 .tables![i]
                      //                                 .currentOrder !=
                      //                                 null ||
                      //                                 orderController.departments[index].tables![i].chosen!
                      //                                 ? Colors.red
                      //                                 : Constants.mainColor,
                      //                             width: 1)),
                      //                     child: Center(
                      //                       child: Text(
                      //                         orderController
                      //                             .departments[index]
                      //                             .tables![i]
                      //                             .title!.toString(),
                      //                         style: TextStyle(
                      //                             color: orderController
                      //                                 .departments[
                      //                             index]
                      //                                 .tables![i]
                      //                                 .currentOrder !=
                      //                                 null ||
                      //                                 orderController
                      //                                     .departments[
                      //                                 index]
                      //                                     .tables![i]
                      //                                     .chosen!
                      //                                 ? Colors.white
                      //                                 : Constants.mainColor,
                      //                             fontSize:
                      //                             size.height * 0.03),
                      //                       ),
                      //                     ),
                      //                   ),
                      //                 ),
                      //               );
                      //             },
                      //           ),
                      //           SizedBox(
                      //             height: 40,
                      //           ),
                      //
                      //         ],
                      //       );
                      //     }),
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
      )

    );
  }
}
