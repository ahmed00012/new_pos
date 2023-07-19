import 'dart:convert';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:enough_convert/enough_convert.dart';

import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shormeh_pos_new_28_11_2022/models/coupon_model.dart';
import 'package:image/image.dart' as img;
import '../constants/colors.dart';
import '../local_storage.dart';
import '../models/cart_model.dart';
import '../models/client_model.dart';
import '../models/confirm_order_model.dart';
import '../models/order_method_model.dart';
import '../models/printers_model.dart';
import '../models/tables_model.dart';
import '../repositories/new_order_repository.dart';
import '../ui/screens/home/home.dart';
import 'home_controller.dart';

final orderMethodFuture = ChangeNotifierProvider.autoDispose.family<OrderMethodController,OrderDetails>(
        (ref,order) => OrderMethodController(order));

class OrderMethodController extends ChangeNotifier {
  NewOrderRepository repo = NewOrderRepository();
  List<OrderMethodModel> orderMethods = [];
  OrderMethodModel? chosenOrderMethod;
  Tables? chosenTable ;
  bool tablesWidget = false;
  List<Department> departments = [];
  bool loading = false;
  List<CouponModel> coupons = [];
  // List<CardModel> cardItemsCopy = [];
  TextEditingController coupon = TextEditingController();
  List<PrinterModel> printers = [];
  String twitter ='';
  String instagram ='';
  String phone ='';
  OrderDetails orderDetails = OrderDetails();

  TextEditingController customerName = TextEditingController();
  TextEditingController customerPhone = TextEditingController();
  TextEditingController notes = TextEditingController();
  TextEditingController deliveryFee = TextEditingController();
  List<ClientModel> clients = [];

  Uint8List? productsImage;
  img.Image? productsScreenshot;


  OrderMethodController(OrderDetails order){

    customerName = TextEditingController(text:  order.clientName);
    customerPhone = TextEditingController(text: order.clientPhone);
    notes = TextEditingController(text:  order.notes);
    orderDetails = order;
    getOrderMethods();
     getTables();
     getPrinters();
     notifyListeners();
  }


  Future getPrinters() async {
    List<PrinterModel> printers1 = [];
    printers1 = List<PrinterModel>.from(json
        .decode(LocalStorage.getData(key: 'printers'))
        .map((e) => PrinterModel.fromJson(e)));

    printers1.forEach((element) {
      if (element.typeName != 'CASHIER') {
        printers.add(element);
      }
    });
    printers1.forEach((element) {
      if (element.typeName == 'CASHIER') {
        printers.add(element);
      }
    });

    notifyListeners();
  }

  void switchLoading(bool load) {
    loading = load;
    notifyListeners();
  }
  refreshData(){
    customerName = TextEditingController(text:  orderDetails.clientName);
    customerPhone = TextEditingController(text:  orderDetails.clientPhone);
    notes = TextEditingController(text:  orderDetails.notes);
    notifyListeners();
  }


 void setOrderMethod(OrderMethodModel orderMethod) {
    orderDetails.orderMethod  = orderMethod.title!.en;
    orderDetails.orderMethodId  = orderMethod.id;
    if (orderMethod.id == 2)
      tablesWidget = true;
    else
      tablesWidget = false;
    notifyListeners();
  }

  void reserveTable(int i, Tables table) {
    chosenTable = table;
    departments[i].tables!.forEach((element) {element.chosen=false;});
    table.chosen = true;
    orderDetails.table = table.title;
    notifyListeners();
  }

  void getTables() async {
    var data = await repo.getTables(
        LocalStorage.getData(key: 'token'),
        LocalStorage.getData(key: 'language'),
        LocalStorage.getData(key: 'branch'));
    departments = List<Department>.from(data.map((e) => Department.fromJson(e)));
    departments.forEach((element) {element.tables!.forEach((element) {element.chosen=false;});});

    // tables.forEach((element) {
    //   element.chosen = false;
    // });
    notifyListeners();
  }


  void getCoupons() async {
      coupons = List<CouponModel>.from(json
          .decode(LocalStorage.getData(key: 'coupons'))
          .map((e) => CouponModel.fromJson(e)));
    notifyListeners();
  }





  getClients() async {

      final data =
          await repo.searchClient(LocalStorage.getData(key: 'token'));
      clients = List<ClientModel>.from(
          data.map((client) => ClientModel.fromJson(client)));

    notifyListeners();

  }



  void getOrderMethods() async {
      orderMethods = List<OrderMethodModel>.from(json
          .decode(LocalStorage.getData(key: 'orderMethods'))
          .map((e) => OrderMethodModel.fromJson(e)));
    orderMethods.forEach((element) {
      element.chosen = false;
      print(element.id);
      print(element.title!.ar.toString()+'slslsll');
    });
    orderMethods[0].chosen = true;
    chosenOrderMethod = orderMethods[0];
    // int index = 0;
    // orderMethods.forEach((element) {
    //   if(element.id == 5)
    //     index = orderMethods.indexOf(element);
    // });
    //   orderMethods.removeAt(index);
      orderMethods.removeWhere((element) => element.id==5);

    notifyListeners();
  }


  Future confirmOrder(BuildContext context,{int ?guestsCount}) async {

    List<Order> details = [];

    switchLoading(true);

    orderDetails.cart!.forEach((element) {
      List<int> notesId = [];
      element.extra!.forEach((element) {
        notesId.add(element.id!);
      });

      Order myOrder = Order(
          productId: element.id,
          quantity: element.count,
          note: element.extraNotes,
          notes: notesId,
          attributes: element.allAttributesID
      );

      details.add(myOrder);
    });

    orderDetails.deliveryFee = double.tryParse(deliveryFee.text);



    ConfirmOrderModel order = ConfirmOrderModel(
        name: orderDetails.clientName,
        phone: orderDetails.clientPhone,
         tableId: orderDetails.table,
        notes: orderDetails.notes,
        paymentMethodId: null,
        clientsCount: guestsCount,
        paymentCustomerId:  null,
        paymentStatus:  0,
        coupon: coupon.text,
        orderMethodId: orderDetails.orderMethodId,
        paidAmount: orderDetails.getTotalAmount(),
        order: details,
      deliveryFee: deliveryFee.text.isNotEmpty? double.parse(deliveryFee.text) : 0
    );


    var responseValue = await repo.confirmOrder(LocalStorage.getData(key: 'token'),
        LocalStorage.getData(key: 'language'), order.toJson());

    if(responseValue['data']!=null) {

       testPrint(orderNo: responseValue['data']['uuid'],).then((value) {

        displayToastMessage(
            ' ${'order'.tr()} ${responseValue['data']['uuid']}  ${'createdSuccessfully'.tr()}',
            false);
        // Future.delayed(Duration(seconds: 2),(){
          closeOrder();
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (_)=>Home()), (route) => false);
        // });



      });

    }

    else {
      displayToastMessage('Order Failed ${responseValue['msg']}', true);
      switchLoading(false);
    }

  }

  void closeOrder() {
    // cartItems = [];
    tablesWidget = false;
    orderDetails = OrderDetails();
    coupon.text='';
    deliveryFee.text='';
    orderMethods.forEach((element) {
      element.chosen = false;
    });
    orderMethods[0].chosen = true;
    chosenOrderMethod = orderMethods[0];
    chosenTable = null;
    // productsScreenshot = null;
    // productsImage = null;
    switchLoading(false);
    notifyListeners();
  }


  //
  // imageDevicePrinter(ScreenshotController screenshotController)  {
  //   screenshotController.capture().then((Uint8List? image2) {
  //     productsImage = image2;
  //   });
  //   notifyListeners();
  // }

  getSocial(){
    twitter = LocalStorage.getData(key: 'twitter').toString();
    instagram = LocalStorage.getData(key: 'instagram').toString();
    phone = LocalStorage.getData(key: 'phone').toString();
  }

  String _getQrCodeContent(String orderTotal,String orderTax) {


    final bytesBuilder = BytesBuilder();
    // 1. Seller Name
    bytesBuilder.addByte(1);
    final sellerNameBytes = utf8.encode(LocalStorage.getData(key: 'branchName').toString());
    bytesBuilder.addByte(sellerNameBytes.length);
    bytesBuilder.add(sellerNameBytes);
    // 2. VAT Registration
    bytesBuilder.addByte(2);
    final vatRegistrationBytes = utf8.encode(LocalStorage.getData(key: 'taxNumber').toString());
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
        Windows1256Codec(allowInvalid: false).encode(word));
  }
   testReceipt(img.Image productsScreenshot, NetworkPrinter printer, OrderDetails order , bool kitchen,{String? orderNo}) async {
    printer.setGlobalCodeTable('CP775');
    if(orderNo!=null)
    printer.hr(ch: '_');

    if(orderNo!=null)
    printer.text('Order Number $orderNo' ,
        styles: PosStyles(
            align: PosAlign.center,
            bold: true,
            height: PosTextSize.size2,
            width: PosTextSize.size2));

    if(orderNo!=null)
    printer.hr(ch: '_');

    if(order.clientName!=null)
      printer.textEncoded(textEncoder(
          'clientName'.tr()+ ' : '+
          order.clientName!),
          styles: PosStyles(
            align: PosAlign.center,
            bold: true,
          ));

    if(!kitchen)

    printer.textEncoded(textEncoder(
        ' branch :' +  LocalStorage.getData(key: 'branchName')),
        styles: PosStyles(
          align: PosAlign.center,
          bold: true,
        ));
    if(!kitchen)
    if(LocalStorage.getData(key: 'taxNumber')!=null) {
      printer.text(
          'Tax No. : ${LocalStorage.getData(key: 'taxNumber')}',
          styles: PosStyles(
            align: PosAlign.center,
            bold: true,
          ));
    }
    printer.text(DateTime.now().toString().substring(0, 16),
        styles: PosStyles(
          align: PosAlign.center,
          bold: true,
        ));

    if(order.orderMethod!=null)
      printer.textEncoded(textEncoder(
          'orderMethod'.tr()+ ' : '+
          order.orderMethod!),
          styles: PosStyles(
            align: PosAlign.center,
            bold: true,
          ));



    if (order.department != null)
      printer.textEncoded(textEncoder(order.department!),
          styles: PosStyles(
            align: PosAlign.center,
            bold: true,
          ));

    if (order.table != null)
      printer.textEncoded(textEncoder('Table : ' +order.table!.toString()),
          styles: PosStyles(
            align: PosAlign.center,
            bold: true,
          ));
    if(!kitchen)

    printer.textEncoded(textEncoder('Employee : ' + LocalStorage.getData(key: 'username')),
        styles: PosStyles(
          align: PosAlign.center,
          bold: true,
        ));

    printer.emptyLines(1);


    printer.image(productsScreenshot , align: PosAlign.center);

    if(!kitchen)

      printer.emptyLines(1);
    if(!kitchen)

      printer.qrcode(_getQrCodeContent(order.getTotal().toString(),order.tax.toString())  );
    printer.emptyLines(1);
    printer.textEncoded(textEncoder('هيئة الضريبة والدخل'),
        styles: PosStyles(
          align: PosAlign.center,
          bold: true,
        ));

    printer.drawer();
    printer.feed(2);
    printer.cut();

  }

  deviceReceipt(OrderDetails order , {String ?orderNo}) async{
    channel.invokeMethod("sdkInit");

    if(orderNo!=null)
    channel.invokeMethod("printText", ['Order Number $orderNo','50','1']);
    channel.invokeMethod("feed");

    if(order.clientName!=null )
      channel.invokeMethod("printText", [ 'clientName'.tr()+ ' : '+ order.clientName!,'25','1']);
    channel.invokeMethod("printText", [ ' branch :' +  LocalStorage.getData(key: 'branchName'),'25','1']);

    if(LocalStorage.getData(key: 'taxNumber')!=null)
      channel.invokeMethod("printText", ['Tax No. : ${LocalStorage.getData(key: 'taxNumber')}','25','1']);
    channel.invokeMethod("printText", [DateTime.now().toString().substring(0, 16),'25','1']);

    if(order.orderMethod!=null)
      channel.invokeMethod("printText", ['orderMethod'.tr()+ ' : '+ order.orderMethod!,'25','1']);


    if (order.payment1!= null)
      channel.invokeMethod("printText", ['paymentMethod'.tr()+ ' : '+order.payment1!.title!.en!,'25','1']);
    if (order.payment2!= null)
      channel.invokeMethod("printText", ['paymentMethod'.tr()+ ' : '+order.payment2!.title!.en!,'25','1']);
    if (order.owner!= null )
      channel.invokeMethod("printText", [ order.owner!.title!,'25','1']);


    if (order.customer!=null)
      channel.invokeMethod("printText", [order.customer!.title!,'25','1']);

    if (order.department != null)
      channel.invokeMethod("printText", [order.department!,'25','1']);
    if (order.table != null)
      channel.invokeMethod("printText", ['Table : ' +order.table!.toString(),'25','1']);

    channel.invokeMethod("printText", ['Employee : ' + LocalStorage.getData(key: 'username'),'25','1']);
    channel.invokeMethod("feed");

    channel.invokeMethod("printBitmap", {
      'image': productsImage,
      'type': 'image/png',
    });


    channel.invokeMethod("printQr", [_getQrCodeContent(order.getTotal().toString(),order.tax.toString())]);
    channel.invokeMethod("printText", ['هيئة الضريبة والدخل','20','1']);
    channel.invokeMethod("feed");
    channel.invokeMethod("feed");
    channel.invokeMethod("feed");
    channel.invokeMethod("paperCutter");
    channel.invokeMethod("feed");

  }

  setImageScreenshot(Uint8List? productsImageScreenShot, img.Image? productsTableScreenshot){

    productsImage = productsImageScreenShot ;
    productsScreenshot = productsTableScreenshot;
    notifyListeners();
  }

  Future testPrint({String ?orderNo}) async {

    OrderDetails order= orderDetails.copyWith();
    deviceReceipt(order,orderNo:orderNo);
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);
    printers.forEach((element) async {
      PosPrintResult res = await printer.connect(element.ip!, port: 9100);
      if (res == PosPrintResult.success) {
         testReceipt(productsScreenshot!,printer,order,element.typeName == 'Kitchen',orderNo: orderNo);
        printer.disconnect();
      }

    });


    notifyListeners();
  }




  void displayToastMessage(var toastMessage, bool alert) {
    showSimpleNotification(
        Container(
          height: 60,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Center(
              child: Text(
                toastMessage,
                style: TextStyle(
                    color: alert ? Colors.white : Constants.mainColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
        duration: Duration(seconds: 3),
        elevation: 2,
        background: alert ? Colors.red[500] : Constants.secondryColor);
  }
}