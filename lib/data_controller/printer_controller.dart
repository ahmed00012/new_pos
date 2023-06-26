// import 'dart:convert';
// import 'dart:developer';
// import 'dart:typed_data';
// import 'dart:ui';
// import 'package:easy_localization/src/public_ext.dart';
// import 'package:enough_convert/enough_convert.dart';
//
// import 'package:esc_pos_printer/esc_pos_printer.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:image/image.dart' as img;
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:screenshot/screenshot.dart';
// import 'package:shormeh_pos_new_28_11_2022/local_storage.dart';
// import 'package:shormeh_pos_new_28_11_2022/models/cart_model.dart';
// import 'package:shormeh_pos_new_28_11_2022/models/key_value_model.dart';
// import 'package:shormeh_pos_new_28_11_2022/models/printers_model.dart';
// import 'package:shormeh_pos_new_28_11_2022/repositories/new_order_repository.dart';
// import 'package:esc_pos_utils/esc_pos_utils.dart';
//
// import 'home_controller.dart';
//
// final printerFuture = ChangeNotifierProvider.autoDispose<PrinterController>(
//         (ref) => PrinterController());
//
// class PrinterController extends ChangeNotifier {
//   NewOrderRepository repo = NewOrderRepository();
//   List<PrinterModel> printers = [];
//   img.Image? image;
//   // List<img.Image> images =[];
//   img.Image? productsScreenshot;
//   img.Image? productsScreenshotKitchen;
//   img.Image? productsScreenshotHomeDelivery;
//
//   Uint8List? imgBytes;
//   ScreenshotController screenshotController = ScreenshotController();
//    ScreenshotController screenshotController2 = ScreenshotController();
//     ScreenshotController screenshotController3 = ScreenshotController();
//   ScreenshotController screenshotController4 = ScreenshotController();
//   // // List<ScreenshotController>screenshotControllers =[];
//   // var scr =  GlobalKey();
//   // var scr2 =  GlobalKey();
//   // var scr3 =  GlobalKey();
//   // var scr4 =  GlobalKey();
//   String twitter ='';
//   String instagram ='';
//   String phone ='';
//
//   PrinterController() {
//     // imageLogo();
//     getPrinters();
//     getSocial();
//
//   }
//   Future getPrinters() async {
//     List<PrinterModel> printers1 = [];
//     //
//     // if (LocalStorage.getData(key: 'printers') == null) {
//     //   var data = await repo.getPrinters(LocalStorage.getData(key: 'token'),
//     //       LocalStorage.getData(key: 'branch').toString());
//     //   LocalStorage.saveData(key: 'printers', value: json.encode(data));
//     //   printers1 =
//     //   List<PrinterModel>.from(data.map((e) => PrinterModel.fromJson(e)));
//     // } else {
//       printers1 = List<PrinterModel>.from(json
//           .decode(LocalStorage.getData(key: 'printers'))
//           .map((e) => PrinterModel.fromJson(e)));
//     // }
//
//
//     ////////////////sort cashier first //////////////////
//     printers1.forEach((element) {
//       if (element.typeName != 'CASHIER') {
//         printers.add(element);
//       }
//     });
//     printers1.forEach((element) {
//       if (element.typeName == 'CASHIER') {
//         printers.add(element);
//       }
//     });
//
//     notifyListeners();
//   }
//
//   imageLogo()async{
//     final ByteData data = await rootBundle.load('assets/images/sss.jpg');
//     imgBytes = data.buffer.asUint8List();
//     image = img.decodeImage(imgBytes!);
//     image = img.copyResize(image!,width: 180);
//   }
//
//   imageLogo1()  {
//
//     productsScreenshot = null;
//     productsScreenshotKitchen = null;
//
//     screenshotController.capture().then((Uint8List? image2) {
//       productsScreenshot = img.decodePng(image2!);
//       productsScreenshot!.setPixelRgba(0, 0, 255,255,255);
//      productsScreenshot= img.copyResize(productsScreenshot!, width: 550);
//       notifyListeners();
//     });
//
//     screenshotController2.capture().then((Uint8List? image4) {
//       productsScreenshotKitchen = img.decodePng(image4!);
//       productsScreenshotKitchen!.setPixelRgba(0, 0, 255,255,255);
//       productsScreenshotKitchen= img.copyResize(productsScreenshotKitchen!, width: 520);
//       notifyListeners();
//     });
//
//     notifyListeners();
//   }
//
//   imageLogoOrderMethod(){
//     screenshotController3.capture().then((Uint8List? image2) {
//       productsScreenshotKitchen = img.decodePng(image2!);
//       productsScreenshotKitchen!.setPixelRgba(0, 0, 255,255,255);
//       productsScreenshotKitchen= img.copyResize(productsScreenshotKitchen!, width: 520);
//
//       notifyListeners();
//     });
//     screenshotController4.capture().then((Uint8List? image2) {
//       productsScreenshotHomeDelivery = img.decodePng(image2!);
//       productsScreenshotHomeDelivery!.setPixelRgba(0, 0, 255,255,255);
//       productsScreenshotHomeDelivery= img.copyResize(productsScreenshotHomeDelivery!, width: 520);
//
//       notifyListeners();
//     });
//
//     notifyListeners();
//   }
//
//   Uint8List textEncoder(String word) {
//     return Uint8List.fromList(
//         Windows1256Codec(allowInvalid: false).encode(word));
//   }
//
// //   mainNameItem(List<CardModel> cart) {
// //       for (int i = 0; i < cart.length; i++) {
// //       int nameLength =  cart[i].title!.length;
// //
// //         print(cart[i].title.toString()+'dddd');
// //         if(nameLength>23) {
// //         if (nameLength % 23 > 0) {
// //           for (int j = 15; j <= 22; j++) {
// //             if (cart[i].title![j] == ' ') {
// //               cart[i].mainNameNewLine = cart[i].title!.substring(j);
// //               cart[i].titleNew = cart[i].title!.substring(0, j);
// //             }
// //           }
// //         }
// //
// //         if (nameLength % 23 > 1) {
// //
// // if(cart[i].mainNameNewLine!.length>20) {
// //             for (int j = 17; j <= cart[i].mainNameNewLine!.length; j++) {
// //               if (cart[i].mainNameNewLine![j] == ' ') {
// //                 cart[i].mainNameNewLine1 =
// //                     cart[i].mainNameNewLine!.substring(j);
// //                 cart[i].mainNameNewLine =
// //                     cart[i].mainNameNewLine!.substring(0, j);
// //               }
// //             }
// //           }
// //         }
// //       }
// //
// //         else {
// //           cart[i].titleNew = cart[i].title!;
// //         }
// //
// //       // if (cart[i].title!.length >= 22) {
// //       //
// //       //
// //       //   for (int j = 0; j <= 25; j++) {
// //       //     if (j >= 18 && cart[i].title![j] == ' ') {
// //       //
// //       //       cart[i].mainNameNewLine = cart[i].title!.substring(j);
// //       //       cart[i].titleNew = cart[i].title!.substring(0, j);
// //       //     }
// //       //     else
// //       //       {
// //       //         cart[i].titleNew = cart[i].title!.substring(0, j);
// //       //       }
// //       //
// //       //   }
// //       // }
// //       // else {
// //       //   cart[i].titleNew = cart[i].title!;
// //       // }
// //       //
// //       // if (cart[i].mainNameNewLine != null &&
// //       //     cart[i].mainNameNewLine!.length >= 22) {
// //       //
// //       //   for (int j = 0 ; j <= cart[i].mainNameNewLine!.length; j++) {
// //       //     if (j >= 18 && cart[i].mainNameNewLine![j] == ' ') {
// //       //       cart[i].mainNameNewLine1 = cart[i].mainNameNewLine!.substring(j);
// //       //       cart[i].mainNameNewLine = cart[i].mainNameNewLine!.substring(0, j);
// //       //     }
// //       //   }
// //       // }
// //       // else if (cart[i].mainNameNewLine != null &&
// //       //     cart[i].mainNameNewLine!.length <= 22)
// //       //   cart[i].mainNameNewLine = cart[i].mainNameNewLine!;
// //
// //       print(cart[i].titleNew);
// //     }
// //
// //     notifyListeners();
// //   }
//
//   getSocial(){
//     twitter = LocalStorage.getData(key: 'twitter').toString();
//     instagram = LocalStorage.getData(key: 'instagram').toString();
//     phone = LocalStorage.getData(key: 'phone').toString();
//   }
//
//   String _getQrCodeContent(String orderTotal,String orderTax) {
//
//
//     final bytesBuilder = BytesBuilder();
//     // 1. Seller Name
//     bytesBuilder.addByte(1);
//     final sellerNameBytes = utf8.encode(LocalStorage.getData(key: 'branchName').toString());
//     bytesBuilder.addByte(sellerNameBytes.length);
//     bytesBuilder.add(sellerNameBytes);
//     // 2. VAT Registration
//     bytesBuilder.addByte(2);
//     final vatRegistrationBytes = utf8.encode(LocalStorage.getData(key: 'taxNumber').toString());
//     bytesBuilder.addByte(vatRegistrationBytes.length);
//     bytesBuilder.add(vatRegistrationBytes);
//     // 3. Time
//     bytesBuilder.addByte(3);
//     // final time = utf8.encode('2022-04-25T15:30:00Z');
//     final time = utf8.encode(DateTime.now().toString());
//     bytesBuilder.addByte(time.length);
//     bytesBuilder.add(time);
//     // 4. total with vat
//     bytesBuilder.addByte(4);
//     final p1 = utf8.encode(orderTotal);
//     bytesBuilder.addByte(p1.length);
//     bytesBuilder.add(p1);
//     // 5.  vat
//     bytesBuilder.addByte(5);
//     final p2 = utf8.encode(orderTax);
//     bytesBuilder.addByte(p2.length);
//     bytesBuilder.add(p2);
//
//     final qrCodeAsBytes = bytesBuilder.toBytes();
//     const b64Encoder = Base64Encoder();
//     log(b64Encoder.convert(qrCodeAsBytes));
//     return b64Encoder.convert(qrCodeAsBytes);
//   }
//
//   void testReceipt(
//       NetworkPrinter printer,
//       // String time,
//       String orderNo,
//       String orderDiscount,
//       String orderTax,
//       String orderTotal,
//       String orderAmount,
//       List<CardModel> products,
//       String customerName,
//       String customerNumber,
//       bool noImg,
//       String payment,
//       String owner,
//       List<KeyValue> paymentSplit,
//       String table,
//       String department,
//   String notes,
//       OrderDetails order) async {
//     // printer.setGlobalCodeTable('CP775');
//
//     if (!noImg) printer.image(image!, align: PosAlign.center);
//
//     printer.hr(ch: '_');
//     printer.textEncoded(textEncoder('Order Number '  + orderNo),
//         styles: PosStyles(
//             align: PosAlign.center,
//             bold: true,
//             height: PosTextSize.size2,
//             width: PosTextSize.size2));
//     printer.hr(ch: '_');
//
//     if(customerName.isNotEmpty)
//     printer.textEncoded(textEncoder(customerName),
//         styles: PosStyles(
//           align: PosAlign.center,
//           bold: true,
//         ));
//
//     if(customerNumber.isNotEmpty)
//     printer.text(customerNumber,
//         styles: PosStyles(
//           align: PosAlign.center,
//           bold: true,
//         ));
//
//     printer.textEncoded(
//         textEncoder(
//           ' branch :' +  LocalStorage.getData(key: 'branchName'),
//         ),
//         styles: PosStyles(
//           align: PosAlign.center,
//           bold: true,
//         ));
//     if(LocalStorage.getData(key: 'taxNumber')!=null) {
//       printer.textEncoded(
//           textEncoder(
//             'Tax No. : ${LocalStorage.getData(key: 'taxNumber')}',
//           ),
//           styles: PosStyles(
//             align: PosAlign.center,
//             bold: true,
//           ));
//     }
//
//     printer.text(DateTime.now().toString().substring(0, 16),
//         styles: PosStyles(
//           align: PosAlign.center,
//           bold: true,
//         ));
//
//     if(order.orderMethod!=null)
//       printer.textEncoded(
//           textEncoder(
//             order.orderMethod!,
//           ),
//           styles: PosStyles(
//             align: PosAlign.center,
//             bold: true,
//           ));
//     if (payment != 'null' && payment != '')
//       printer.textEncoded(textEncoder(payment),
//           styles: PosStyles(
//             align: PosAlign.center,
//             bold: true,
//           ));
//
//
//     if (owner != 'null' && owner != '')
//       printer.textEncoded(textEncoder(owner),
//           styles: PosStyles(
//             align: PosAlign.center,
//             bold: true,
//           ));
//     if (order.selectCustomer.toString()!='null')
//       printer.textEncoded(textEncoder(order.selectCustomer!),
//           styles: PosStyles(
//             align: PosAlign.center,
//             bold: true,
//           ));
//
//     if (department != '')
//       printer.textEncoded(textEncoder(department),
//           styles: PosStyles(
//             align: PosAlign.center,
//             bold: true,
//           ));
//     if (table != '')
//       printer.textEncoded(textEncoder(table),
//           styles: PosStyles(
//             align: PosAlign.center,
//             bold: true,
//           ));
//
//     printer.textEncoded(textEncoder('Employee : ' + LocalStorage.getData(key: 'username')),
//         styles: PosStyles(
//           align: PosAlign.center,
//           bold: true,
//         ));
//
//     // printer.hr(ch: '_');
//     //
//     // printer.row([
//     //   PosColumn(
//     //       textEncoded: textEncoder('qty'),
//     //       width: 1,
//     //       styles: PosStyles(
//     //         bold: true,
//     //         align: PosAlign.right
//     //       )),
//     //   PosColumn(
//     //       textEncoded: textEncoder('item'),
//     //       width: 7,
//     //       styles: PosStyles(bold: true, align: PosAlign.center)),
//     //   PosColumn(
//     //       textEncoded: textEncoder('price'),
//     //       width: 2,
//     //       styles: PosStyles(
//     //         bold: true,
//     //       )),
//     //   PosColumn(
//     //       textEncoded: textEncoder('total'),
//     //       width: 2,
//     //       styles: PosStyles(
//     //         bold: true,
//     //       ))
//     // ]);
//     printer.emptyLines(1);
// // if(productsScreenshot!=null && !noImg)
//     if(productsScreenshotHomeDelivery==null) {
//
//       printer.image(productsScreenshot!, align: PosAlign.center);
//     } else {
//
//       printer.image(productsScreenshotHomeDelivery!, align: PosAlign.center);
//     }
//
//     printer.emptyLines(1);
//     printer.qrcode(_getQrCodeContent(orderTotal,orderTax)  );
// if(!noImg)
//     printer.drawer();
//
//     printer.feed(2);
//     printer.cut();
//   }
//
//   void testReceiptKitchen(
//       NetworkPrinter printer,
//       String orderNo,
//       List<CardModel> products,
//           String notes,
//       OrderDetails order
//       ) async {
//
//
//     printer.hr(ch: '_');
//     printer.textEncoded(textEncoder('Order Number ' + orderNo),
//         styles: PosStyles(
//             align: PosAlign.center,
//             bold: true,
//             height: PosTextSize.size2,
//             width: PosTextSize.size2));
//     printer.hr(ch: '_', linesAfter: 1);
//
//     printer.textEncoded(
//         textEncoder(
//           LocalStorage.getData(key: 'branchName'),
//         ),
//         styles: PosStyles(
//           align: PosAlign.center,
//           bold: true,
//         ));
//     printer.text(DateTime.now().toString().substring(0, 16),
//         styles: PosStyles(
//           align: PosAlign.center,
//           bold: true,
//         ));
//     if(order.orderMethod!=null)
//       printer.textEncoded(
//           textEncoder(
//             order.orderMethod!,
//           ),
//           styles: PosStyles(
//             align: PosAlign.center,
//             bold: true,
//           ));
//     if(order.tableTitle!=null)
//       printer.textEncoded(
//           textEncoder(
//             order.tableTitle!,
//           ),
//           styles: PosStyles(
//             align: PosAlign.center,
//             bold: true,
//           ));
//     if(order.department!=null)
//       printer.textEncoded(
//           textEncoder(
//             order.department!,
//           ),
//           styles: PosStyles(
//             align: PosAlign.center,
//             bold: true,
//           ));
//
//
//     printer.emptyLines(1);
//
//     printer.image(productsScreenshotKitchen!, align: PosAlign.center);
//     printer.emptyLines(1);
//     if (notes.isNotEmpty) {
//       print(notes.toString()+'dldkkd');
//       printer.hr();
//
//       printer.textEncoded(textEncoder('Notes'),
//           styles: PosStyles(
//             align: PosAlign.center,
//             bold: true,
//           ));
//       printer.textEncoded(textEncoder(notes),
//           styles: PosStyles(
//             align: PosAlign.center,
//           ));
//       printer.hr(ch: '_');
//     }
//
//
//     printer.feed(2);
//     printer.cut();
//   }
//
//   Future testPrint(
//       {
//         // String? time,
//         String? orderNo,
//         String? discount,
//         String? tax,
//         String? total,
//         String? amount,
//         bool? cashier,
//         bool? deliver,
//         bool? kitchen,
//         bool? home,
//         List<CardModel>? cart,
//         String? notes,
//         String? customerName,
//         String? customerNumber,
//         String? payment,
//         String? owner,
//         List<KeyValue> ?paymentSplit,
//         String? table,
//         String? department,
//       OrderDetails? order}) async {
//     // mainNameItem( cart!);
//     const PaperSize paper = PaperSize.mm80;
//     final profile = await CapabilityProfile.load();
//     final printer = NetworkPrinter(paper, profile);
//     // printer.profile.codePages.forEach((element) {print(element.name);});
//     printers.forEach((element) async {
//
//       PosPrintResult res = await printer.connect(element.ip!, port: 9100);
//       if (element.typeName == 'CASHIER') {
//         print('from cashier ' + element.ip.toString() + element.typeName!);
//         if (res == PosPrintResult.success) {
//           if (payment.toString() != 'null' && payment!.isNotEmpty)
//             testReceipt(
//                 printer,
//                 // time!,
//                 orderNo!,
//                 discount ?? '0',
//                 tax ?? '0',
//                 total!,
//                 amount ?? '0',
//                 cart!,
//                 customerName??'',
//                 customerNumber??'',
//                 false,
//                 payment.toString(),
//                 owner.toString(),
//                 paymentSplit!,
//                 table??'',
//                 department??'',
//                 notes??'',
//             order!);
//           printer.disconnect();
//         }
//
//       }
//       else if (element.typeName == 'Deliver') {
//         print('from Deliver ' + element.ip.toString() + element.typeName!);
//
//         if (res == PosPrintResult.success) {
//           print('from Deliver ' + element.ip.toString() + element.typeName!);
//
//           if (deliver!) {
//              testReceiptKitchen(printer, orderNo!, cart!,  notes??'',order!);
//           }
//           if (home!) {
//             testReceipt(
//                 printer,
//                 orderNo??'',
//                 discount??'',
//                 tax??'',
//                 total??'',
//                 amount??'',
//                 cart!,
//                 customerName??'',
//                 customerNumber??'',
//                 true,
//                 '',
//                 owner.toString(),
//                 paymentSplit??[],
//                 table??'',
//                 department??'',
//                 notes??'',order!);
//           }
//           printer.disconnect();
//         }
//         print('Print result: ${res.msg}');
//       } else {
//         if (res == PosPrintResult.success) {
//           print('from kitchen ' + element.ip.toString());
//           List<CardModel> newList = [];
//           cart!.forEach((product) {
//             if (element.departmentId == order!.departmentId) {
//               newList.add(product);
//               print(product.mainName);
//             }
//           });
//           if (newList.isNotEmpty && kitchen!) {
//             // testReceiptKitchen(
//             //     printer, time!, orderNo!, newList, total!, notes!,table??'',department??'');
//           }
//           printer.disconnect();
//         }
//         print('Print result: ${res.msg}');
//       }
//     });
//
//
//     notifyListeners();
//   }
//
//
// }
