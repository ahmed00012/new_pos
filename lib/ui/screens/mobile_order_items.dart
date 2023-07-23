// import 'dart:typed_data';
//
// import 'package:easy_localization/src/public_ext.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:screenshot/screenshot.dart';
// import 'package:shormeh_pos_new_28_11_2022/data_controller/home_controller.dart';
// import '../../constants/colors.dart';
// import '../../data_controller/cart_controller.dart';
// import '../../data_controller/mobile_order_controller.dart';
// import '../../local_storage.dart';
// import '../../models/orders_model.dart';
// import 'reciept/receipt_screen.dart';
//
//
// class MobileOrderItems extends ConsumerStatefulWidget {
//
//   @override
//   MobileOrderItemsState createState() => MobileOrderItemsState();
// }
//
// class MobileOrderItemsState extends ConsumerState {
//   ScreenshotController screenshotController = ScreenshotController();
//
//   // Uint8List? productsImage;
//   //
//   // img.Image? productsScreenshot;
//   //
//   // imageProductsPrinter() async {
//   //   final controller = ref.watch(newOrderFuture);
//   //   screenshotController.capture().then((Uint8List? image2) {
//   //     setState((){   productsScreenshot = img.decodePng(image2!);
//   //     productsScreenshot!.setPixelRgba(0, 0, 255,255,255);
//   //     productsScreenshot= img.copyResize(productsScreenshot!, width: 550);
//   //     productsImage = image2;
//   //     controller.setImageScreenshot(image2,productsScreenshot);
//   //
//   //     });
//   //   });
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     final viewModel = ref.watch(mobileOrdersFuture(false));
//     final homeController = ref.watch(dataFuture);
//     final cartController = ref.watch(cartFuture);
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       backgroundColor: Colors.white,
//       body: Container(
//         child: viewModel.chosenOrder != null
//             ? Stack(
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(20),
//               child: Receipt(screenshotController: screenshotController,
//                   onScreenShot: (){},
//                 order: cartController.orderDetails,
//
//               ),
//             ),
//             Container(
//               color: Colors.white,
//               alignment: Alignment.topLeft,
//               child:  Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: InkWell(
//               onTap: (){
//               cartController.editOrder(viewModel.orders[viewModel.chosenOrder!]);
//               viewModel.imageProductsPrinter(screenshotController);
//               Future.delayed(Duration(milliseconds: 500),(){
//               viewModel.testPrint(order: cartController.orderDetails);
//
//               });
//               },
//                     child: Icon(Icons.print,color: Constants.mainColor,size: 30,)),
//               ),
//             ),
//             Column(
//               children: [
//                 if (viewModel
//                     .orders[viewModel.chosenOrder!].orderStatusId == 4 )
//                   InkWell(
//                     onTap: () {
//                       viewModel.complain(size, context, true,
//                           orderId:
//                           viewModel.orders[viewModel.chosenOrder!].id!);
//                     },
//                     child: Container(
//                         height: 35,
//
//                         decoration: BoxDecoration(
//                             color: Colors.red[500],
//                             borderRadius: BorderRadius.only(
//                               topRight: Radius.circular(10),
//                               topLeft: Radius.circular(10),
//                             )
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.warning_amber_outlined,
//                               color: Colors.white,
//                             ),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             Text(
//                               'complainOrder'.tr(),
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: size.height * 0.02,
//                               ),
//                             ),
//                           ],
//                         )),
//                   ),
//                 SizedBox(
//                   height: 5,
//                 ),
//                 Expanded(
//                   child: Padding(
//                     padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
//                     child: Column(
//
//                       children: [
//                         Text(
//                           'orderNumber'.tr() +
//                               ':  ${viewModel.chosenOrderNum!}',
//                           style: TextStyle(
//                               fontSize: size.height * 0.028,
//                               fontWeight: FontWeight.bold,
//                               color: Constants.mainColor,
//                               fontStyle: FontStyle.italic),
//                         ),
//                         SizedBox(
//                           height: 5,
//                         ),
//                         Text(
//                           viewModel
//                               .orders[viewModel.chosenOrder!].createdAt!,
//                           style: TextStyle(
//                               fontSize: size.height * 0.02,
//                               fontWeight: FontWeight.bold,
//                               color: Constants.mainColor),
//                         ),
//                         if (viewModel.orders[viewModel.chosenOrder!]
//                             .clientName !=
//                             null &&
//                             viewModel.orders[viewModel.chosenOrder!]
//                                 .clientName !=
//                                 '')
//                           SizedBox(
//                             height: 5,
//                           ),
//                         if (viewModel.orders[viewModel.chosenOrder!]
//                             .clientName !=
//                             null &&
//                             viewModel.orders[viewModel.chosenOrder!]
//                                 .clientName !=
//                                 '')
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 'client'.tr() + ' : ',
//                                 style: TextStyle(
//                                     fontSize: size.height * 0.02,
//                                     fontWeight: FontWeight.bold,
//                                     color: Constants.mainColor),
//                               ),
//                               Text(
//                                 viewModel.orders[viewModel.chosenOrder!]
//                                     .clientName!,
//                                 style: TextStyle(
//                                     fontSize: size.height * 0.02,
//                                     fontWeight: FontWeight.bold,
//                                     color: Constants.mainColor),
//                               ),
//                             ],
//                           ),
//                         SizedBox(
//                           height: 5,
//                         ),
//
//                         if (viewModel.orders[viewModel.chosenOrder!].car !=
//                             null)
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//
//                             children: [
//                               Text(
//                                 'car'.tr() + ' : ',
//                                 style: TextStyle(
//                                     fontSize: size.height * 0.02,
//                                     fontWeight: FontWeight.bold,
//                                     color: Constants.mainColor),
//                               ),
//                               // Icon(Icons.directions_car,  color: Constants.mainColor,),
//                               // Image.asset('assets/images/car-wash.png',
//                               //   color: Constants.lightBlue,
//                               // height: 25,),
//
//                               Text(
//                                 viewModel.orders[viewModel.chosenOrder!].car!.model! + ' ' +
//                                     viewModel.orders[viewModel.chosenOrder!].car!.color! + ' '+
//                                     viewModel.orders[viewModel.chosenOrder!].car!.number! ,
//                                 style: TextStyle(
//                                     fontSize: size.height * 0.02,
//                                     color: Constants.mainColor,
//                                     fontWeight: FontWeight.bold
//                                 ),
//                               ),
//
//
//                             ],
//                           ),
//                         SizedBox(
//                           height: 5,
//                         ),
//                         Text(
//                           viewModel
//                               .orders[viewModel.chosenOrder!].orderStatus!,
//                           style: TextStyle(
//                               fontSize: size.height * 0.02,
//                               fontWeight: FontWeight.bold,
//                               color: Constants.mainColor),
//                         ),
//                         SizedBox(
//                           height: 30,
//                         ),
//                         Divider(color:Colors.grey,),
//                         Expanded(
//                             child: ListView.builder(
//                                 itemCount: viewModel
//                                     .orders[viewModel.chosenOrder!]
//                                     .details!
//                                     .length,
//                                 itemBuilder: (context, i) {
//                                   List<OrdersDetails> details = viewModel
//                                       .orders[viewModel.chosenOrder!]
//                                       .details!;
//
//                                   return Padding(
//                                     padding: const EdgeInsets.all(5.0),
//                                     child: Container(
//                                       decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(10),
//                                           border: Border.all(color: Colors.grey,width: 0.5)
//                                       ),
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           Padding(
//                                             padding: const EdgeInsets.all(10.0),
//                                             child: Text(
//                                               details[i].quantity.toString() +
//                                                   'X  ' +
//                                                   details[i].title!,
//                                               style: TextStyle(
//                                                   fontSize: size.height * 0.022,
//                                                   color: Constants.mainColor,
//                                                   fontWeight: FontWeight.bold),
//                                             ),
//                                           ),
//                                           ListView.separated(
//                                             itemCount: details[i].addons!.length,
//                                             physics: NeverScrollableScrollPhysics(),
//                                             shrinkWrap: true,
//                                             itemBuilder: (context,j){
//                                               return Padding(
//                                                 padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 2),
//                                                 child: Row(
//                                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                   children: [
//                                                     Text(details[i].addons![j].addon!,style: TextStyle(
//                                                         fontSize: size.height*0.02,
//                                                         color: Constants.lightBlue
//                                                     ),),
//
//                                                     Text(details[i].addons![j].value!,style: TextStyle(
//                                                         fontSize: size.height*0.02,
//                                                         color: Constants.lightBlue
//                                                     ),),
//                                                   ],
//                                                 ),
//                                               );
//
//                                             }, separatorBuilder: (BuildContext context, int index) { return Divider(); },),
//
//
//                                           if(details[i].notes!.isNotEmpty && details[i].attributes!.isNotEmpty)
//                                             Divider(),
//                                           ListView.separated(
//                                             itemCount: details[i].attributes!.length,
//                                             physics: NeverScrollableScrollPhysics(),
//                                             shrinkWrap: true,
//                                             itemBuilder: (context,j){
//                                               return Padding(
//                                                 padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 2),
//                                                 child: Row(
//                                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                   children: [
//                                                     Flexible(
//                                                       child: Text(details[i].attributes![j].attribute!,style: TextStyle(
//                                                           fontSize: size.height*0.018,
//                                                           letterSpacing: 0.1,
//                                                           color: Constants.lightBlue,
//                                                         fontWeight: FontWeight.bold
//                                                       ),),
//                                                     ),
//
//                                                     Container(
//                                                       width: size.width*0.12,
//                                                       alignment: Alignment.centerRight,
//
//                                                        child: Text(details[i].attributes![j].value!,style: TextStyle(
//                                                           fontSize: size.height*0.018,
//                                                           letterSpacing: 0.1,
//                                                           color: Constants.lightBlue
//                                                     ),),
//                                                      ),
//                                                   ],
//                                                 ),
//                                               );
//
//                                             }, separatorBuilder: (BuildContext context, int index) { return Divider(); },),
//                                           if((details[i].notes!.isNotEmpty || details[i].attributes!.isNotEmpty)
//                                           && details[i].addons!.isNotEmpty)
//                                             Divider(),
//
//                                           ListView.separated(
//                                             itemCount: details[i].notes!.length,
//                                             physics: NeverScrollableScrollPhysics(),
//                                             shrinkWrap: true,
//                                             itemBuilder: (context,j){
//                                               return Padding(
//                                                 padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 2),
//                                                 child: Row(
//                                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                   textDirection:
//                                                   LocalStorage.getData(key: 'language')=='en'?
//                                                   TextDirection.ltr:TextDirection.rtl,
//                                                   children: [
//                                                     Text(details[i].notes![j],style: TextStyle(
//                                                         fontSize: size.height*0.018,
//                                                         overflow: TextOverflow.ellipsis,
//                                                         letterSpacing: 0.1,
//                                                         color: Constants.lightBlue,
//                                                         fontWeight: FontWeight.bold
//                                                     ),),
//
//                                                     Text(details[i].notesID![j].price.toString()+' SAR',style: TextStyle(
//                                                         fontSize: size.height*0.018,
//                                                         overflow: TextOverflow.ellipsis,
//                                                         letterSpacing: 0.1,
//                                                         color: Constants.lightBlue,
//
//                                                     ),),
//                                                   ],
//                                                 ),
//                                               );
//
//                                             }, separatorBuilder: (BuildContext context, int index) { return Divider(); },),
//                                           if((details[i].notes!.isNotEmpty || details[i].attributes!.isNotEmpty ||
//                                               details[i].addons!.isNotEmpty) && details[i].note!=null)
//                                             Divider(),
//                                           if(details[i].note!=null)
//                                             Padding(
//                                               padding: const EdgeInsets.symmetric(horizontal: 10),
//                                               child: Row(
//                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                 children: [
//                                                   Text('notes'.tr(),style: TextStyle(
//                                                       fontSize: size.height*0.02,
//                                                       color: Colors.red
//                                                   ),),
//                                                   Text(details[i].note!,style: TextStyle(
//                                                       fontSize: size.height*0.02,
//                                                       color: Colors.red
//                                                   ),),
//
//
//                                                 ],
//                                               ),
//                                             ),
//                                           SizedBox(height: 5,)
//                                         ],
//                                       ),
//                                     ),
//                                   );
//                                 })),
//
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             if(viewModel.orders[viewModel.chosenOrder!]
//                                 .notes != null)
//                               Divider(color: Colors.grey,),
//                             if(viewModel.orders[viewModel.chosenOrder!]
//                                 .notes != null)
//                               Text('notes'.tr()+' \n'+viewModel.orders[viewModel.chosenOrder!]
//                                   .notes!,
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                     color: Constants.secondryColor,
//                                     fontSize: size.height*0.02
//                                 ),),
//                             Divider(color:Colors.grey,),
//                             SizedBox(height: 5,),
//                             Row(
//                               mainAxisAlignment:
//                               MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   'orderMethod'.tr(),
//                                   style: TextStyle(
//                                       fontSize: size.height * 0.02,
//                                       fontWeight: FontWeight.bold,
//                                       color: Constants.mainColor),
//                                 ),
//                                 Text(
//                                   viewModel.orders[viewModel.chosenOrder!]
//                                       .orderMethod!,
//                                   style: TextStyle(
//                                       fontSize: size.height * 0.02,
//                                       fontWeight: FontWeight.bold,
//                                       color: Constants.mainColor),
//                                 ),
//                               ],
//                             ),
//                             if (viewModel
//                                 .orders[viewModel.chosenOrder!].table !=
//                                 'null')
//                               Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     'table'.tr(),
//                                     style: TextStyle(
//                                         fontSize: size.height * 0.02,
//                                         fontWeight: FontWeight.bold,
//                                         color: Constants.mainColor),
//                                   ),
//                                   Text(
//                                     viewModel.orders[viewModel.chosenOrder!]
//                                         .table!,
//                                     style: TextStyle(
//                                         fontSize: size.height * 0.02,
//                                         fontWeight: FontWeight.bold,
//                                         color: Constants.mainColor),
//                                   ),
//                                 ],
//                               ),
//                             if (viewModel.orders[viewModel.chosenOrder!]
//                                 .paymentMethods !=
//                                 null &&
//                                 viewModel.orders[viewModel.chosenOrder!]
//                                     .paymentMethods!.length >
//                                     1)
//                               Column(children: [
//                                 Row(
//                                   mainAxisAlignment:
//                                   MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       viewModel
//                                           .orders[viewModel.chosenOrder!]
//                                           .paymentMethods![0]
//                                           .title!,
//                                       style: TextStyle(
//                                           fontSize: size.height * 0.02,
//                                           fontWeight: FontWeight.bold,
//                                           color: Constants.mainColor),
//                                     ),
//                                     Text(
//                                       viewModel
//                                           .orders[viewModel.chosenOrder!]
//                                           .paymentMethods![0]
//                                           .value!,
//                                       style: TextStyle(
//                                           fontSize: size.height * 0.02,
//                                           fontWeight: FontWeight.bold,
//                                           color: Constants.mainColor),
//                                     ),
//                                   ],
//                                 ),
//                                 Row(
//                                   mainAxisAlignment:
//                                   MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       viewModel
//                                           .orders[viewModel.chosenOrder!]
//                                           .paymentMethods![1]
//                                           .title!,
//                                       style: TextStyle(
//                                           fontSize: size.height * 0.02,
//                                           fontWeight: FontWeight.bold,
//                                           color: Constants.mainColor),
//                                     ),
//                                     Text(
//                                       viewModel
//                                           .orders[viewModel.chosenOrder!]
//                                           .paymentMethods![1]
//                                           .value!,
//                                       style: TextStyle(
//                                           fontSize: size.height * 0.02,
//                                           fontWeight: FontWeight.bold,
//                                           color: Constants.mainColor),
//                                     ),
//                                   ],
//                                 ),
//                               ]),
//                             if (viewModel.orders[viewModel.chosenOrder!]
//                                 .paymentMethods ==
//                                 null ||
//                                 (viewModel.orders[viewModel.chosenOrder!]
//                                     .paymentMethods !=
//                                     null &&
//                                     viewModel.orders[viewModel.chosenOrder!]
//                                         .paymentMethods!.length <=
//                                         1))
//                               Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     'payment'.tr(),
//                                     style: TextStyle(
//                                         fontSize: size.height * 0.02,
//                                         fontWeight: FontWeight.bold,
//                                         color: Constants.mainColor),
//                                   ),
//                                   if (viewModel
//                                       .orders[viewModel.chosenOrder!]
//                                       .paymentCustomer ==
//                                       null)
//                                     Text(
//                                       viewModel
//                                           .orders[viewModel
//                                           .chosenOrder!]
//                                           .ownerId !=
//                                           null
//                                           ? 'paid'.tr()
//                                           : viewModel
//                                           .orders[viewModel
//                                           .chosenOrder!]
//                                           .paymentMethod ??
//                                           'notPaid'.tr(),
//                                       style: TextStyle(
//                                           fontSize: size.height * 0.02,
//                                           fontWeight: FontWeight.bold,
//                                           color: Constants.mainColor),
//                                     ),
//                                   if (viewModel
//                                       .orders[viewModel.chosenOrder!]
//                                       .paymentCustomer !=
//                                       null)
//                                     Text(
//                                       viewModel
//                                           .orders[viewModel
//                                           .chosenOrder!]
//                                           .paymentMethods !=
//                                           null
//                                           ? viewModel
//                                           .orders[
//                                       viewModel.chosenOrder!]
//                                           .paymentMethods![0]
//                                           .title!
//                                           : viewModel
//                                           .orders[viewModel
//                                           .chosenOrder!]
//                                           .paymentCustomer !=
//                                           null
//                                           ? viewModel
//                                           .orders[viewModel
//                                           .chosenOrder!]
//                                           .paymentCustomer!
//                                           : 'notPaid'.tr(),
//                                       style: TextStyle(
//                                           fontSize: size.height * 0.02,
//                                           fontWeight: FontWeight.bold,
//                                           color: Constants.mainColor),
//                                     ),
//                                 ],
//                               ),
//                             if (viewModel.orders[viewModel.chosenOrder!]
//                                 .discount !=
//                                 '0' &&
//                                 viewModel.orders[viewModel.chosenOrder!]
//                                     .discount!.isNotEmpty)
//                               Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     'discount'.tr(),
//                                     style: TextStyle(
//                                         fontSize: size.height * 0.02,
//                                         fontWeight: FontWeight.bold,
//                                         color: Constants.mainColor),
//                                   ),
//                                   Text(
//                                    '- '+ viewModel.orders[viewModel.chosenOrder!]
//                                         .discount! +
//                                         ' SAR',
//                                     style: TextStyle(
//                                         fontSize: size.height * 0.02,
//                                         fontWeight: FontWeight.bold,
//                                         color: Constants.mainColor),
//                                   ),
//                                 ],
//                               ),
//
//                             if (viewModel.orders[viewModel.chosenOrder!]
//                                 .deliveryFee != 0)
//                               Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     'delivery'.tr(),
//                                     style: TextStyle(
//                                         fontSize: size.height * 0.02,
//                                         fontWeight: FontWeight.bold,
//                                         color: Constants.mainColor),
//                                   ),
//                                   Text(
//                                     viewModel.orders[viewModel.chosenOrder!]
//                                         .deliveryFee.toString() +
//                                         ' SAR',
//                                     style: TextStyle(
//                                         fontSize: size.height * 0.02,
//                                         fontWeight: FontWeight.bold,
//                                         color: Constants.mainColor),
//                                   ),
//                                 ],
//                               ),
//                             Row(
//                               mainAxisAlignment:
//                               MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   'total'.tr(),
//                                   style: TextStyle(
//                                       fontSize: size.height * 0.02,
//                                       fontWeight: FontWeight.bold,
//                                       color: Constants.mainColor),
//                                 ),
//                                 Text(
//                                   viewModel.orders[viewModel.chosenOrder!]
//                                       .total
//                                       .toString() +
//                                       ' SAR ',
//                                   style: TextStyle(
//                                       fontSize: size.height * 0.02,
//                                       fontWeight: FontWeight.bold,
//                                       color: Constants.mainColor),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(
//                               height: 10,
//                             )
//                           ],
//                         ),
//
//                       ],
//                     ),
//                   ),
//                 ),
//                 if (viewModel
//                     .orders[viewModel.chosenOrder!].orderStatusId == 1)
//                   Container(
//                     height: 50,
//                     child: Row(
//                       children: [
//                         Flexible(
//                           child: InkWell(
//                             onTap: () {
//                               viewModel.complain( size, context,false, orderId: viewModel
//                                   .orders[viewModel.chosenOrder!].id!);
//                             },
//                             child: Container(
//                               color: Constants.secondryColor,
//                               child: Center(
//                                 child: Text(
//                                   'cancelOrder'.tr(),
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: size.height * 0.025,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Flexible(
//                           child: InkWell(
//                             onTap: () {
//                               viewModel.acceptOrder();
//                             },
//                             child: Container(
//                               color: Constants.mainColor,
//                               child: Center(
//                                 child: Text(
//                                   'acceptOrder'.tr(),
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: size.height * 0.025,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                 if (viewModel
//                     .orders[viewModel.chosenOrder!].orderStatusId !=1 &&
//                     viewModel.orders[viewModel.chosenOrder!].orderStatusId != 8 &&
//                     viewModel.orders[viewModel.chosenOrder!].orderStatusId != 9 &&
//                     viewModel.orders[viewModel.chosenOrder!].orderStatusId != 5 &&
//                     viewModel.orders[viewModel.chosenOrder!].paymentStatus == 0 &&
//                     viewModel.orders[viewModel.chosenOrder!].orderStatusId != 10)
//                   Container(
//                     height: 50,
//                     child: InkWell(
//                       onTap: () {
//                         cartController.editOrder(viewModel.orders[viewModel.chosenOrder!]);
//                         homeController.selectedTab = SelectedTab.home;
//                         homeController.notifyListeners();
//                       },
//                       child: Container(
//                         color: Constants.mainColor,
//                         child: Center(
//                           child: Text(
//                             'editOrder'.tr(),
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: size.height * 0.025,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//             if (viewModel.loading)
//               Container(
//                 height: size.height,
//                 width: size.width,
//                 color: Colors.white.withOpacity(0.5),
//               )
//           ],
//         )
//             : Container(),
//       ),
//     );
//   }
// }
