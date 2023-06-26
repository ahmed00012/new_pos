// import 'package:easy_localization/src/public_ext.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/painting.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:screenshot/screenshot.dart';
// import 'package:shormeh_pos_new_28_11_2022/data_controller/home_controller.dart';
// import 'package:shormeh_pos_new_28_11_2022/data_controller/new_order_controller.dart';
// import 'package:shormeh_pos_new_28_11_2022/data_controller/printer_controller.dart';
//
// import '../../models/order_method_model.dart';
//
// class HomeDeliveryReceipt extends ConsumerWidget {
//   OrderMethodModel? orderMethod;
//   HomeDeliveryReceipt({this.orderMethod});
//   var scr4 =  GlobalKey();
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final viewModel = ref.watch(dataFuture);
//     final printerController = ref.watch(printerFuture);
//
//     final orderController = ref.watch(newOrderFuture(orderMethod!));
//     // Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Center(
//           child: Container(
//             color: Colors.white,
//             child: Padding(
//               padding: const EdgeInsets.all(5),
//               child: Column(
//                 children: [
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Image.asset(
//                     'assets/images/logo.png',
//                     height: 120,
//                   ),
//                   Text(
//                     HomeController.orderDetails.branchName!,
//                     style: TextStyle(
//                       fontSize: 16,
//                     ),
//                   ),
//                   if (HomeController.orderDetails.cart!=null)
//                     Text(
//                           DateTime.now().toString().substring(0, 16),
//                       style: TextStyle(
//                         fontSize: 16,
//                       ),
//                     ),
//                   if (HomeController.orderDetails.payment1!=null)
//                     Text(
//                       HomeController.orderDetails.payment1!.title!,
//                       style: TextStyle(
//                         fontSize: 16,
//                       ),
//                     ),
//                   if (HomeController.orderDetails.cart!=null &&
//                       HomeController.orderDetails.selectCustomer != null)
//                     Text(
//                       HomeController.orderDetails.selectCustomer!,
//                       style: TextStyle(
//                         fontSize: 16,
//                       ),
//                     ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   // orderController.chosenOrderMethod != null||
//                   //     HomeController.cardItems[0].orderMethod != null
//                   if (HomeController.orderDetails.cart!=null)
//                     Container(
//                       height: 30,
//                       width: 150,
//                       decoration: BoxDecoration(border: Border.all(width: 2)),
//                       child: Center(
//                         child: Text(
//                           HomeController.orderDetails.orderMethod ??
//                               orderMethod!.title ??
//                               '',
//                           style: TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   RepaintBoundary(
//                     key: scr4,
//                     child: Screenshot(
//                       controller: printerController.screenshotController4,
//                       child: Column(
//                         children: [
//                           Table(
//                             border: TableBorder.all(),
//                             columnWidths: const <int, TableColumnWidth>{
//                               0: FixedColumnWidth(45),
//                               1: FlexColumnWidth(),
//                               2: FixedColumnWidth(90),
//                               3: FixedColumnWidth(70),
//                             },
//                             children: [
//                               TableRow(children: [
//                                 TableCell(
//                                     verticalAlignment:
//                                     TableCellVerticalAlignment.middle,
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(2.0),
//                                       child: Center(
//                                         child: Text(
//                                           'qty'.tr(),
//                                           style: TextStyle(
//                                               fontSize: 15,
//                                               fontWeight: FontWeight.bold,
//                                               fontStyle: FontStyle.italic),
//                                         ),
//                                       ),
//                                     )),
//                                 TableCell(
//                                     verticalAlignment:
//                                     TableCellVerticalAlignment.middle,
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(5.0),
//                                       child: Center(
//                                         child: Text(
//                                           'item'.tr(),
//                                           style: TextStyle(
//                                               fontSize: 17,
//                                               fontWeight: FontWeight.bold,
//                                               fontStyle: FontStyle.italic),
//                                         ),
//                                       ),
//                                     )),
//                                 TableCell(
//                                     verticalAlignment:
//                                     TableCellVerticalAlignment.middle,
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(5.0),
//                                       child: Center(
//                                         child: Text(
//                                           'price'.tr(),
//                                           style: TextStyle(
//                                               fontSize: 17,
//                                               fontWeight: FontWeight.bold,
//                                               fontStyle: FontStyle.italic),
//                                         ),
//                                       ),
//                                     )),
//                                 TableCell(
//                                     verticalAlignment:
//                                     TableCellVerticalAlignment.middle,
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(5.0),
//                                       child: Center(
//                                         child: Text(
//                                           'total'.tr(),
//                                           style: TextStyle(
//                                               fontSize: 17,
//                                               fontWeight: FontWeight.bold,
//                                               fontStyle: FontStyle.italic),
//                                         ),
//                                       ),
//                                     )),
//                               ])
//                             ],
//                           ),
//                           if(HomeController.orderDetails.cart!=null)
//                           Table(
//                             border: TableBorder.all(),
//                             columnWidths: const <int, TableColumnWidth>{
//                               0: FixedColumnWidth(45),
//                               1: FlexColumnWidth(),
//                               2: FixedColumnWidth(90),
//                               3: FixedColumnWidth(70),
//                             },
//                             children: HomeController.orderDetails.cart!.map((e) {
//                               return TableRow(children: [
//                                 TableCell(
//                                   verticalAlignment: TableCellVerticalAlignment.middle,
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(2.0),
//                                     child: Center(
//                                       child: Text(
//                                         e.count.toString(),
//                                         style: TextStyle(
//                                             fontSize: 17, fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 TableCell(
//                                   child: Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             e.title??e.mainName!,
//                                             style: TextStyle(
//                                                 fontSize: 17,
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                           if (e.extra != null)
//                                             Column(
//                                               crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                               children: e.extra!.map((extra) {
//                                                 return Padding(
//                                                   padding: const EdgeInsets.all(2.0),
//                                                   child: Text(
//                                                     extra.title!,
//                                                     style: TextStyle(
//                                                         fontSize: 14,
//                                                         fontWeight: FontWeight.w500),
//                                                   ),
//                                                 );
//                                               }).toList(),
//                                             ),
//                                           if (e.extraNotes != null)
//                                             Padding(
//                                               padding: const EdgeInsets.all(2.0),
//                                               child: Text(
//                                                 e.extraNotes!,
//                                                 style: TextStyle(
//                                                     fontSize: 14,
//                                                     fontWeight: FontWeight.w500),
//                                               ),
//                                             )
//                                         ],
//                                       )),
//                                 ),
//                                 TableCell(
//                                   child: Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Column(
//                                         children: [
//
//                                           Text(
//                                             e.price.toString() + ' SAR',
//                                             style: TextStyle(
//                                                 fontSize: 15,
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                           if (e.title!.length > 15)
//                                             SizedBox(
//                                               height: 35,
//                                             ),
//                                           if (e.title!.length <= 15)
//                                             SizedBox(height: 15,),
//                                           if (e.extra != null)
//                                             Column(
//                                               children: e.extra!.map((extra) {
//                                                 return Padding(
//                                                   padding: const EdgeInsets.all(2.0),
//                                                   child: Text(
//                                                     extra.price.toString() + ' SAR',
//                                                     textAlign: TextAlign.center,
//                                                     style: TextStyle(
//                                                         fontSize: 14,
//                                                         fontWeight: FontWeight.w500),
//                                                   ),
//                                                 );
//                                               }).toList(),
//                                             ),
//                                           if (e.extraNotes != null)
//                                             Padding(
//                                               padding: const EdgeInsets.all(2.0),
//                                               child: Text(
//                                                 '0.0 SAR',
//                                                 style: TextStyle(
//                                                     fontSize: 14,
//                                                     fontWeight: FontWeight.w500),
//                                               ),
//                                             )
//                                         ],
//                                       )),
//                                 ),
//                                 TableCell(
//                                   child: Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         vertical: 8, horizontal: 5),
//                                     child: Center(
//                                       child: Text(
//                                         e.total.toString() + ' SAR',
//                                         style: TextStyle(
//                                             fontSize: 17, fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ]);
//                             }).toList(),
//                           ),
//                           SizedBox(
//                             height: 40,
//                           ),
//
//                           Table(
//                             border: TableBorder.all(),
//                             children: [
//                               if (HomeController.orderDetails.amount1!=null)
//                                 TableRow(children: [
//                                   Padding(
//                                     padding: const EdgeInsets.all(5.0),
//                                     child: Center(
//                                       child: Text(
//                                         'paid'.tr(),
//                                         style: TextStyle(
//                                             fontSize: 17, fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.all(5.0),
//                                     child: Center(
//                                       child: Text(
//                                         HomeController.orderDetails.getTotalAmount().toStringAsFixed(2),
//                                         style: TextStyle(
//                                             fontSize: 17, fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                   ),
//                                 ]),
//                               if (HomeController.orderDetails.amount1!=null)
//                                 TableRow(children: [
//                                   Padding(
//                                     padding: const EdgeInsets.all(5.0),
//                                     child: Center(
//                                       child: Text(
//                                         'remaining'.tr(),
//                                         style: TextStyle(
//                                             fontSize: 17, fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.all(5.0),
//                                     child: Center(
//                                       child: Text(
//                                       (HomeController.orderDetails.getTotalAmount() - HomeController.orderDetails.getTotal())
//                                             .toStringAsFixed(2) +
//                                             ' SAR ',
//                                         style: TextStyle(
//                                             fontSize: 17, fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                   ),
//                                 ]),
//                               TableRow(children: [
//                                 Padding(
//                                   padding: const EdgeInsets.all(5.0),
//                                   child: Center(
//                                     child: Text(
//                                       'tax'.tr(),
//                                       style: TextStyle(
//                                           fontSize: 17, fontWeight: FontWeight.bold),
//                                     ),
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.all(5.0),
//                                   child: Center(
//                                     child: Text(
//                                       HomeController.orderDetails.tax!.toStringAsFixed(2)+
//                                           ' SAR ',
//                                       style: TextStyle(
//                                           fontSize: 17, fontWeight: FontWeight.bold),
//                                     ),
//                                   ),
//                                 ),
//                               ]),
//                               if (HomeController.orderDetails.discount!=null)
//                                 TableRow(children: [
//                                   Padding(
//                                     padding: const EdgeInsets.all(5.0),
//                                     child: Center(
//                                       child: Text(
//                                         'discount'.tr(),
//                                         style: TextStyle(
//                                             fontSize: 17, fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.all(5.0),
//                                     child: Center(
//                                       child: Text(
//                                         HomeController.orderDetails.discount!,
//                                         style: TextStyle(
//                                             fontSize: 17, fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                   ),
//                                 ]),
//                               TableRow(children: [
//                                 Padding(
//                                   padding: const EdgeInsets.all(15.0),
//                                   child: Center(
//                                     child: Text(
//                                       'total'.tr(),
//                                       style: TextStyle(
//                                           fontSize: 20, fontWeight: FontWeight.bold),
//                                     ),
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.all(15.0),
//                                   child: Center(
//                                     child: Text(
//                                       HomeController.orderDetails.getTotal().toStringAsFixed(2) +
//                                           ' SAR ',
//                                       style: TextStyle(
//                                           fontSize: 20, fontWeight: FontWeight.bold),
//                                     ),
//                                   ),
//                                 ),
//                               ]),
//                             ],
//                           ),
//
//                           SizedBox(
//                             height: 40,
//                           ),
//                           Text('contactUs'.tr(),style: TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold
//                           ),),
//                           SizedBox(
//                             height: 20,
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 20),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Image.asset('assets/images/twitter.png',width: 40,),
//                                 SizedBox(width: 5,),
//                                 Text(printerController.twitter,style: TextStyle(
//                                     fontSize: 22
//                                 ),),
//                                 Spacer(),
//                                 Image.asset('assets/images/instagram.png',width: 40,),
//                                 SizedBox(width: 5,),
//                                 Text(printerController.instagram,style: TextStyle(
//                                     fontSize: 22
//                                 ),),
//                               ],
//                             ),
//                           ),
//                           SizedBox(height: 30,),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Image.asset('assets/images/call.png',width: 40,),
//                               SizedBox(width: 10,),
//                               Text(printerController.phone,style: TextStyle(
//                                   fontSize: 22
//                               ),),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//
//
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
