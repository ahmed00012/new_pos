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
// class Receipt2 extends ConsumerWidget {
//   OrderMethodModel? orderMethod;
//   // GlobalKey globalKey2 = GlobalKey();
//   Receipt2({this.orderMethod});
//   var scr2 =  GlobalKey();
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final viewModel = ref.watch(dataFuture);
//     final printerController = ref.watch(printerFuture);
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
//                   // if (orderController.chosenPayment.isNotEmpty)
//                   //   Text(
//                   //     orderController.chosenPayment[0].title!,
//                   //     style: TextStyle(
//                   //       fontSize: 16,
//                   //     ),
//                   //   ),
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
//                     key: scr2,
//                     child: Screenshot(
//                       controller: printerController.screenshotController2,
//                       child: Column(
//                         children: [
//                           Table(
//                             border: TableBorder.all(),
//                             columnWidths: const <int, TableColumnWidth>{
//                               0: FixedColumnWidth(45),
//                               1: FlexColumnWidth(),
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
//                               ])
//                             ],
//                           ),
//                           if(HomeController.orderDetails.cart!=null)
//                           Table(
//                             border: TableBorder.all(),
//                             columnWidths: const <int, TableColumnWidth>{
//                               0: FixedColumnWidth(45),
//                               1: FlexColumnWidth(),
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
//                                             e.title!,
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
//                               ]);
//                             }).toList(),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//
//                   SizedBox(
//                     height: 40,
//                   ),
//
//                   // Table(
//                   //   border: TableBorder.all(),
//                   //   children: [
//                   //     if (orderController.amount.isNotEmpty)
//                   //       TableRow(children: [
//                   //         Padding(
//                   //           padding: const EdgeInsets.all(5.0),
//                   //           child: Center(
//                   //             child: Text(
//                   //               'paid'.tr(),
//                   //               style: TextStyle(
//                   //                   fontSize: 17, fontWeight: FontWeight.bold),
//                   //             ),
//                   //           ),
//                   //         ),
//                   //         Padding(
//                   //           padding: const EdgeInsets.all(5.0),
//                   //           child: Center(
//                   //             child: Text(
//                   //               orderController.amount.length == 1
//                   //                   ? orderController.amount[0]
//                   //                   .toStringAsFixed(2) +
//                   //                   ' SAR '
//                   //                   : (orderController.amount[0] +
//                   //                   orderController.amount[1])
//                   //                   .toStringAsFixed(2) +
//                   //                   ' SAR ',
//                   //               style: TextStyle(
//                   //                   fontSize: 17, fontWeight: FontWeight.bold),
//                   //             ),
//                   //           ),
//                   //         ),
//                   //       ]),
//                   //     if (orderController.amount.isNotEmpty)
//                   //       TableRow(children: [
//                   //         Padding(
//                   //           padding: const EdgeInsets.all(5.0),
//                   //           child: Center(
//                   //             child: Text(
//                   //               'remaining'.tr(),
//                   //               style: TextStyle(
//                   //                   fontSize: 17, fontWeight: FontWeight.bold),
//                   //             ),
//                   //           ),
//                   //         ),
//                   //         Padding(
//                   //           padding: const EdgeInsets.all(5.0),
//                   //           child: Center(
//                   //             child: Text(
//                   //               orderController
//                   //                   .totalFromAmount()
//                   //                   .toStringAsFixed(2) +
//                   //                   ' SAR ',
//                   //               style: TextStyle(
//                   //                   fontSize: 17, fontWeight: FontWeight.bold),
//                   //             ),
//                   //           ),
//                   //         ),
//                   //       ]),
//                   //     TableRow(children: [
//                   //       Padding(
//                   //         padding: const EdgeInsets.all(5.0),
//                   //         child: Center(
//                   //           child: Text(
//                   //             'tax'.tr(),
//                   //             style: TextStyle(
//                   //                 fontSize: 17, fontWeight: FontWeight.bold),
//                   //           ),
//                   //         ),
//                   //       ),
//                   //       Padding(
//                   //         padding: const EdgeInsets.all(5.0),
//                   //         child: Center(
//                   //           child: Text(
//                   //             HomeController.orderDetails.tax!.toStringAsFixed(2)+
//                   //                 ' SAR ',
//                   //             style: TextStyle(
//                   //                 fontSize: 17, fontWeight: FontWeight.bold),
//                   //           ),
//                   //         ),
//                   //       ),
//                   //     ]),
//                   //     if (HomeController.orderDetails.discount!=null)
//                   //       TableRow(children: [
//                   //         Padding(
//                   //           padding: const EdgeInsets.all(5.0),
//                   //           child: Center(
//                   //             child: Text(
//                   //               'discount'.tr(),
//                   //               style: TextStyle(
//                   //                   fontSize: 17, fontWeight: FontWeight.bold),
//                   //             ),
//                   //           ),
//                   //         ),
//                   //         Padding(
//                   //           padding: const EdgeInsets.all(5.0),
//                   //           child: Center(
//                   //             child: Text(
//                   //               HomeController.orderDetails.discount!,
//                   //               style: TextStyle(
//                   //                   fontSize: 17, fontWeight: FontWeight.bold),
//                   //             ),
//                   //           ),
//                   //         ),
//                   //       ]),
//                   //     TableRow(children: [
//                   //       Padding(
//                   //         padding: const EdgeInsets.all(15.0),
//                   //         child: Center(
//                   //           child: Text(
//                   //             'total'.tr(),
//                   //             style: TextStyle(
//                   //                 fontSize: 20, fontWeight: FontWeight.bold),
//                   //           ),
//                   //         ),
//                   //       ),
//                   //       Padding(
//                   //         padding: const EdgeInsets.all(15.0),
//                   //         child: Center(
//                   //           child: Text(
//                   //             HomeController.orderDetails.getTotal().toStringAsFixed(2) +
//                   //                 ' SAR ',
//                   //             style: TextStyle(
//                   //                 fontSize: 20, fontWeight: FontWeight.bold),
//                   //           ),
//                   //         ),
//                   //       ),
//                   //     ]),
//                   //   ],
//                   // ),
//
//                   SizedBox(
//                     height: 40,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
