import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as img;
import 'package:easy_localization/easy_localization.dart';
import 'package:enough_convert/enough_convert.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/prefs_utils.dart';
import 'dart:ui' as ui;
import '../../models/cart_model.dart';
import '../../models/printers_model.dart';
import '../constant_keys.dart';
import '../styles.dart';


class PrintingService{

 List<PrinterModel> printers = List<PrinterModel>.from(json.decode(getPrintersPrefs())
      .map((e) => PrinterModel.fromJson(e)));



  printInvoice({String ?orderNo,required OrderDetails order ,required bool payLater ,
    required Widget productsTable}) async {
    deviceReceipt(order: order ,payLater: payLater ,productsTable: productsTable ,orderNo: orderNo);
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);
    printers.forEach((element) async {
      PosPrintResult res = await printer.connect(element.ip!, port: 9100);
      if (res == PosPrintResult.success) {
        await printReceipt(printer:  printer ,order: order ,kitchen: element.typeName == 'Kitchen' ,
            payLater:payLater, productsTable: productsTable ,orderNo: orderNo );
        printer.disconnect();
      }

    });
  }

 printReceipt({required NetworkPrinter printer,
   required Widget productsTable,
   required  OrderDetails order,required bool kitchen,
   required  bool payLater, String? orderNo}) async {
   printer.setGlobalCodeTable('CP775');
   if (orderNo != null) printer.hr(ch: '_');
   if (orderNo != null) {
     printer.text('Order Number $orderNo',
         styles: const PosStyles(
             align: PosAlign.center,
             bold: true,
             height: PosTextSize.size2,
             width: PosTextSize.size2));
   }

   if (orderNo != null) printer.hr(ch: '_');

   if (order.clientName != null) {
     printer.textEncoded(
         textEncoder('${'clientName'.tr()} : ${order.clientName!}'),
         styles: ConstantStyles.centerBold);
   }

   if (!kitchen) {
     printer.textEncoded(textEncoder(' branch : ${getBranchName()}'),
         styles: ConstantStyles.centerBold);
   }

   if (!kitchen) {
     printer.text('Tax No. : ${getTaxNumber()}',
         styles: ConstantStyles.centerBold);
   }

   printer.text(DateTime.now().toString().substring(0, 16),
       styles: ConstantStyles.centerBold);

   if (order.orderMethod != null) {
     printer.textEncoded(
         textEncoder('${'orderMethod'.tr()} : ${order.orderMethod!}'),
         styles: ConstantStyles.centerBold);
   }

   order.payMethods.asMap().forEach((index, element) {
     printer.textEncoded(
         textEncoder('${'paymentMethod'.tr()} $index: ${element.title!}'),
         styles: ConstantStyles.centerBold);
   });

   if (order.customer != null && payLater) {
     printer.textEncoded(
         textEncoder("${order.customer!.title!}  -  ${'payLater'.tr()}"),
         styles: ConstantStyles.centerBold);
   }
   if (order.customer != null && !payLater) {
     printer.textEncoded(textEncoder(order.customer!.title!),
         styles: ConstantStyles.centerBold);
   }

   if (order.owner != null) {
     printer.textEncoded(
         textEncoder('${'paymentMethod'.tr()} : ${order.owner!.title!}'),
         styles: ConstantStyles.centerBold);
   }

   if (order.department != null) {
     printer.textEncoded(textEncoder(order.department!),
         styles: ConstantStyles.centerBold);
   }

   if (order.table != null) {
     printer.textEncoded(textEncoder('Table : ${order.table!}'),
         styles: ConstantStyles.centerBold);
   }
   if (!kitchen) {
     printer.textEncoded(textEncoder('Employee : ${getUserName()}'),
         styles: ConstantStyles.centerBold);
   }
   printer.emptyLines(1);
   printer.image(await createImageFromWidget(productsTable , true), align: PosAlign.center);

   if (!kitchen) printer.emptyLines(1);
   if (!kitchen) {
     printer.qrcode(
         getQrCodeContent(order.total.toString(), order.tax.toString()));
   }
   printer.emptyLines(1);
   printer.textEncoded(textEncoder('هيئة الضريبة والدخل'),
       styles: ConstantStyles.centerBold);
   printer.drawer();
   printer.feed(2);
   printer.cut();
 }



 deviceReceipt({required OrderDetails order,required Widget productsTable,required bool payLater,
   String? orderNo }) async {
   channel.invokeMethod("sdkInit");

   if (orderNo != null)
     channel.invokeMethod(iminPrintText, iminPrintTextChannel(text: 'Order Number $orderNo',fontSize: '50'));
   channel.invokeMethod(iminFeed);

   if (order.clientName != null)
     channel.invokeMethod(iminPrintText,
         iminPrintTextChannel(text: '${'clientName'.tr()} : ${order.clientName!}'));

   channel.invokeMethod(iminPrintText,
       iminPrintTextChannel(text: ' branch : ${getBranchName()}'));

   channel.invokeMethod(iminPrintText,
       iminPrintTextChannel(text: ' Tax No. : ${getTaxNumber()}'));

   channel.invokeMethod(
       iminPrintText, iminPrintTextChannel(text: DateTime.now().toString().substring(0, 16)));

   if (order.orderMethod != null)
     channel.invokeMethod(iminPrintText,
         iminPrintTextChannel(text:'${'orderMethod'.tr()} : ${order.orderMethod!}'));

   order.payMethods.asMap().forEach((index , element) {
     channel.invokeMethod(iminPrintText,
         iminPrintTextChannel(text:'${'paymentMethod'.tr()}$index : ${order.payment1!.title!.en!}'));
   });



   if (order.customer != null && payLater)
     channel.invokeMethod(iminPrintText,
         iminPrintTextChannel(text:'${order.customer!.title!}  -  ${'payLater'.tr()}'));


   if (order.customer != null && !payLater)
     channel.invokeMethod(iminPrintText,
         iminPrintTextChannel(text:'${order.customer!.title!}'));

   if (order.owner != null)
     channel.invokeMethod(iminPrintText,
         iminPrintTextChannel(text:'${'paymentMethod'.tr()} : ${order.owner!.title!}'));


   if (order.department != null)
     channel.invokeMethod(iminPrintText,
         iminPrintTextChannel(text :order.department!));

   if (order.table != null)
     channel.invokeMethod(iminPrintText, iminPrintTextChannel(text: 'Table : ${order.table!}'));


   channel.invokeMethod(iminPrintText,
       iminPrintTextChannel(text: 'Employee : ${getUserName()}'));
   channel.invokeMethod(iminFeed);
   channel.invokeMethod(iminPrintBitmap,
       {
         'image': createImageFromWidget(productsTable , true),
         'type': 'image/png',
       });

   channel.invokeMethod(iminPrintQr,
       [getQrCodeContent(order.total.toString(), order.tax.toString())]);
   channel.invokeMethod(iminPrintText, iminPrintTextChannel(text: 'هيئة الضريبة والدخل' , fontSize: '20'));
   channel.invokeMethod(iminFeed);
   channel.invokeMethod(iminFeed);
   channel.invokeMethod(iminFeed);
   channel.invokeMethod(iminPaperCutter);
   channel.invokeMethod(iminFeed);

 }



 String getQrCodeContent(String orderTotal, String orderTax) {
   final bytesBuilder = BytesBuilder();
   // 1. Seller Name
   bytesBuilder.addByte(1);
   final sellerNameBytes =
   utf8.encode(getBranchName());
   bytesBuilder.addByte(sellerNameBytes.length);
   bytesBuilder.add(sellerNameBytes);
   // 2. VAT Registration
   bytesBuilder.addByte(2);
   final vatRegistrationBytes = utf8.encode(getTaxNumber());
   bytesBuilder.addByte(vatRegistrationBytes.length);
   bytesBuilder.add(vatRegistrationBytes);
   // 3. Time
   bytesBuilder.addByte(3);
   // final time = utf8.encode('2022-04-25T15:30:00Z');
   final time = utf8.encode(DateTime.now().toString());
   bytesBuilder.addByte(time.length);
   bytesBuilder.add(time);
   // 4. total with vat
   bytesBuilder.addByte(4);
   final p1 = utf8.encode(orderTotal);
   bytesBuilder.addByte(p1.length);
   bytesBuilder.add(p1);
   // 5.  vat
   bytesBuilder.addByte(5);
   final p2 = utf8.encode(orderTax);
   bytesBuilder.addByte(p2.length);
   bytesBuilder.add(p2);

   final qrCodeAsBytes = bytesBuilder.toBytes();
   const b64Encoder = Base64Encoder();
   return b64Encoder.convert(qrCodeAsBytes);
 }



 Uint8List textEncoder(String word) {
   return Uint8List.fromList(
       const Windows1256Codec(allowInvalid: false).encode(word));
 }


 List<dynamic> iminPrintTextChannel({required String text, String? fontSize, String? alignment}){
   return [text, fontSize ?? '25',alignment ?? '1'];
 }

 iminPrintDividerChannel(){
   channel.invokeMethod(iminPrintText, ['_____________________________________', '30', '1']);
 }


 Future createImageFromWidget(Widget widget , bool iminPrint) async {
   final repaintBoundary = RenderRepaintBoundary();

   Size logicalSize = ui.window.physicalSize / ui.window.devicePixelRatio;
   Size imageSize = ui.window.physicalSize;

   assert(logicalSize.aspectRatio == imageSize.aspectRatio);

   final RenderView renderView = RenderView(
     view: ui.window,
     // window: ui.window,
     child: RenderPositionedBox(
         alignment: Alignment.center, child: repaintBoundary),
     configuration: ViewConfiguration(
       size: logicalSize,
       devicePixelRatio: 1.0,
     ),
   );

   final PipelineOwner pipelineOwner = PipelineOwner();

   final BuildOwner buildOwner = BuildOwner(focusManager: FocusManager());

   pipelineOwner.rootNode = renderView;
   renderView.prepareInitialFrame();
   final RenderObjectToWidgetElement<RenderBox> rootElement =
   RenderObjectToWidgetAdapter<RenderBox>(
     container: repaintBoundary,
     child: widget,
   ).attachToRenderTree(buildOwner);

   buildOwner.buildScope(rootElement);
   buildOwner.buildScope(rootElement);
   buildOwner.finalizeTree();
   pipelineOwner.flushLayout();
   pipelineOwner.flushCompositingBits();
   pipelineOwner.flushPaint();

   final ui.Image image = await repaintBoundary.toImage(
       pixelRatio: imageSize.width / logicalSize.width);
   final byteData = await (image.toByteData(format: ui.ImageByteFormat.png));

   if(iminPrint)
     return byteData!.buffer.asUint8List();
   else
     img.decodePng(byteData!.buffer.asUint8List());
 }

}