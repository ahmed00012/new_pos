
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:enough_convert/enough_convert.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shormeh_pos_new_28_11_2022/models/details_model.dart';
import 'package:shormeh_pos_new_28_11_2022/models/notes_model.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/screens/home.dart';
import 'package:image/image.dart' as img;
import '../constants.dart';
import '../local_storage.dart';
import '../main.dart';
import '../models/cart_model.dart';
import '../models/confirm_order_model.dart';
import '../models/offlineOrder.dart';
import '../models/order_method_model.dart';

import '../models/orders_model.dart';
import '../models/printers_model.dart';
import '../models/tables_model.dart';
import '../repositories/new_order_repository.dart';
import '../ui/screens/login.dart';
import 'home_controller.dart';

final tablesFuture = ChangeNotifierProvider.autoDispose<TablesController>(
        (ref) => TablesController());

class TablesController extends ChangeNotifier {

  NewOrderRepository repo = NewOrderRepository();
  List<OrderMethodModel> orderMethods = [];
  OrderMethodModel? chosenOrderMethod;
  Tables? chosenTable ;
  List<Department> departments = [];
  bool loading = false;
  // List<PrinterModel> printers = [];
  List<CardModel> cardItemsCopy = [];
  int? chosenOrder;
  int? chosenDepartment;
  String? chosenDepartmentTitle;
  String? chosenOrderNum;
  Tables? currentOrder;
  List<PrinterModel> printers = [];
  String twitter ='';
  String instagram ='';
  String phone ='';
  img.Image? productsScreenshot;
  Uint8List? productsImage;


  TablesController(){
    getTables();

  }

  void switchLoading(bool load) {
    loading = load;
    notifyListeners();
  }


  getCurrentOrder(int index,int i){
    chosenDepartment=index;
    chosenOrder = i;
    chosenOrderNum = departments[index].tables![i].currentOrder!.uuid;
     currentOrder= departments[chosenDepartment!].tables![chosenOrder!];
     print(currentOrder!.currentOrder!.orderStatus);
     print(chosenDepartment);
     print(chosenOrder);


    notifyListeners();
  }



 Future<void>  reserveTable(int i, Tables table, int count,BuildContext context,
     bool homeDialog) async{

    chosenTable = table;
    departments[i].tables!.forEach((element) {element.chosen=false;});
    table.chosen = true;

    HomeController.orderDetails.table = table.id.toString();
    HomeController.orderDetails.tableTitle = table.title;
    HomeController.orderDetails.department = departments[i].title;
    HomeController.orderDetails.orderMethod = 'restaurant';
    HomeController.orderDetails.orderMethodId = 2;
    HomeController.orderDetails.customer = null;
    HomeController.orderDetails.paymentId = null;
    HomeController.orderDetails.cancelPayment();


    if(!homeDialog)
    await confirmOrder(count,context);
    else
      Navigator.pop(context,count);

    notifyListeners();
  }


  // editOrder(var homeController){
  //   homeController.chosenCustomer =null;
  //   homeController.updateOrder = true;
  //   HomeController.orderDetails.orderUpdatedId = currentOrder!.currentOrder!.id;
  //   HomeController.total = currentOrder!.currentOrder!.total!;
  //   currentOrder!.currentOrder!.details!.forEach((element) {
  //     List<NotesModel> notes = [];
  //
  //     for (int i = 0; i < element.notes!.length; i++) {
  //
  //       notes.add(NotesModel(
  //         id: element.notes![i].id,
  //         title: element.notes![i].title,
  //         price: element.notes![i].price,
  //       ));
  //
  //     }
  //
  //     HomeController.cartItems.add(CardModel(
  //         id: element.productId,
  //         rowId: element.id,
  //         mainName: element.product!.title,
  //         title: element.product!.title,
  //         extra: notes,
  //         count: element.quantity,
  //         total: double.parse(element.total.toString()),
  //         price:element.product!.newPrice!=0.0? element.product!.newPrice!:
  //         element.product!.price!,
  //         orderMethod: 'restaurant'.tr(),
  //         time:currentOrder!.createdAt,
  //         orderMethodId: currentOrder!.currentOrder!.orderMethodId,
  //         orderStatus:currentOrder!.currentOrder!.orderStatusId,
  //         tableTitle: chosenTable!.title,
  //         department: departments[chosenDepartment!].title
  //       // department:,
  //     ));
  //   });
  //   homeController.orderMethodModel= OrderMethodModel(
  //       id: currentOrder!.currentOrder!.orderMethodId,
  //       title: 'restaurant'.tr()
  //   );
  //
  //   homeController.selectedTab = SelectedTab.home;
  //   homeController.notifyListeners();
  // }


  testToken()async{
    LocalStorage.removeData(key: 'token');
    LocalStorage.removeData(key: 'branch');
    LocalStorage.removeData(key: 'coupons');
    navigatorKey.currentState!.pushAndRemoveUntil(MaterialPageRoute(builder: (_)=>Login()), (route) => false);
  }

  void getTables() async {
    switchLoading(true);
    var data = await repo.getTables(
        LocalStorage.getData(key: 'token'),
        LocalStorage.getData(key: 'language'),
        LocalStorage.getData(key: 'branch'));

    if(data == 'unauthorized'){
      testToken();
    }
    else if(data ==false){
      displayToastMessage('Connection Error', true);
    }

    else {
      departments =
      List<Department>.from(data.map((e) => Department.fromJson(e)));
      departments.forEach((element) {
        element.tables!.forEach((element) {
          element.chosen = false;
        });
      });
    }
    switchLoading(false);
    // print(departments[0].tables![0].title);
    // tables.forEach((element) {
    //   element.chosen = false;
    // });
    notifyListeners();
  }



  Future confirmOrder(int guestsCount, BuildContext context) async {
    List<Order> details = [];
    HomeController.orderDetails.cart!.forEach((element) {
      List<int> notesId = [];
      element.extra!.forEach((element) {
        notesId.add(element.id!);
      });

      Order myOrder = Order(
          productId: element.id,
          quantity: element.count,
          note: element.extraNotes,
          notes: notesId
      );

      details.add(myOrder);
    });


    ConfirmOrderModel2 order = ConfirmOrderModel2(
        name: HomeController.orderDetails.clientName,
        phone: HomeController.orderDetails.clientPhone,
        hold: 0,
        tableId: HomeController.orderDetails.table,
        notes: HomeController.orderDetails.notes,
        // clientsCount:  HomeController.orderDetails.co,
        paymentStatus:  0,
        orderMethodId: 2,
        order: details
    );


    var responseValue = await repo.confirmOrder(LocalStorage.getData(key: 'token'),
        LocalStorage.getData(key: 'language'), order.toJson());

    if(responseValue == 'unauthorized'){
      testToken();
    }
    else if(responseValue ==false){
      displayToastMessage('Order Failed', true);
    }

    else {

      OrderDetails newOrder = HomeController.orderDetails.copyWith();
      testPrint(newOrder, responseValue['uuid']).then((value) {
        deviceReceipt(newOrder, responseValue['uuid']);
        displayToastMessage(
            ' ${'order'.tr()} ${responseValue['uuid']}  ${'createdSuccessfully'.tr()}',
            false);
        closeOrder();
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_)=>Home()), (route) => false);
      });


    }
    loading = false;
    notifyListeners();
  }
  void editOrder(){
    HomeController.orderDetails = OrderDetails();
    HomeController.orderDetails.editOrderTable(departments[chosenDepartment!] , chosenOrder!);
    // selectedTab = SelectedTab.home;

    notifyListeners();
  }

  void closeOrder() {
    HomeController.orderDetails = OrderDetails();
    departments.forEach((element) {element.tables!.forEach((element) {element.chosen=false;});});
    chosenTable = null;
    switchLoading(false);
    notifyListeners();
  }


  imageProductsPrinter(ScreenshotController screenshotController)  {
    // productsScreenshot = null;
    screenshotController.capture().then((Uint8List? image2) {
      productsScreenshot = img.decodePng(image2!);
      productsScreenshot!.setPixelRgba(0, 0, 255,255,255);
      productsScreenshot= img.copyResize(productsScreenshot!, width: 550);
    });



    notifyListeners();
  }
  imageDevicePrinter(ScreenshotController screenshotController)  {
    screenshotController.capture().then((Uint8List? image2) {
      productsImage = image2;
    });
    notifyListeners();
  }

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
   testReceipt(NetworkPrinter printer, OrderDetails order ,String orderNo , bool kitchen) async {
     printer.setGlobalCodeTable('CP775');
    printer.hr(ch: '_');
    printer.text('Order Number $orderNo' ,
        styles: PosStyles(
            align: PosAlign.center,
            bold: true,
            height: PosTextSize.size2,
            width: PosTextSize.size2));
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

    if(LocalStorage.getData(key: 'taxNumber')!=null && !kitchen) {
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



    if (order.owner!= null)
      printer.textEncoded(textEncoder(order.owner!.title!),
          styles: PosStyles(
            align: PosAlign.center,
            bold: true,
          ));



    if (order.customer!=null)
      printer.textEncoded(textEncoder(order.customer!.title!),
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


    printer.image(productsScreenshot!, align: PosAlign.center);

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

  deviceReceipt(OrderDetails order , String orderNo) async{
    channel.invokeMethod("sdkInit");

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

    // channel.invokeMethod("printText", [  'orderMethod'.tr()+ ' : '+order.orderMethod!]);
    // channel.invokeMethod("printText", [  'orderMethod'.tr()+ ' : '+order.orderMethod!]);
    // channel.invokeMethod("printText", [  'orderMethod'.tr()+ ' : '+order.orderMethod!]);

  }

  Future testPrint(OrderDetails order,String orderNo) async {
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);
    printers.forEach((element) async {
      PosPrintResult res = await printer.connect(element.ip!, port: 9100);
      if (res == PosPrintResult.success) {
       await testReceipt(printer,order,orderNo,element.typeName == 'Kitchen');
        printer.disconnect();
      }

    });


    notifyListeners();
  }

  // confirmOfflineOrder(BuildContext context, var printerController, ){
  //
  //   int orderCount = LocalStorage.getData(key: 'offlineOrdersCount')??0;
  //   double totalAmount = 0.0;
  //   List <OfflineProduct> ordersDetails = [];
  //   List<String> offlineOrders = LocalStorage.getList(key: 'orderList')  ??[];
  //   String uuid =  '#off_${1000+orderCount}';
  //   List<String>? notes = [];
  //   List<NotesIds> notesIds= [];
  //   List<String> notesTitle = [];
  //   List<String> notesTitleMix = [];
  //
  //   HomeController.cartItems.forEach((element) {
  //
  //     notes = [];
  //     notesIds= [];
  //     notesTitle = [];
  //     notesTitleMix = [];
  //
  //     if (element.extra != null) {
  //       element.extra!.forEach((e) {
  //         notes!.add(e.id.toString());
  //         notesIds.add(
  //             NotesIds(id:e.id, price: e.price )
  //         );
  //         notesTitle.add(e.title!);
  //         notesTitleMix.add(e.titleMix!);
  //       });
  //
  //     }
  //
  //     ordersDetails.add(OfflineProduct(
  //       productId: element.id,
  //       title: element.mainName ,
  //       price: element.price,
  //       total: element.total.toString(),
  //       notesID: notesIds,
  //       quantity: element.count,
  //       note: element.extraNotes,
  //       titleMix: element.title,
  //       notesMix: notesTitleMix,
  //       notes: notes,
  //
  //     )
  //     );
  //   });
  //
  //
  //
  //
  //
  //
  //
  //   ///////////////////////// order to json ////////////////
  //   OfflineOrderDetails ordersModel = OfflineOrderDetails(
  //     notes: HomeController.orderDetails.no,
  //     total: HomeController.total,
  //     time: DateTime.now().toString(),
  //     payMethods: [],
  //     orderMethod: chosenOrderMethod!.title,
  //     orderMethodId: chosenOrderMethod!.id,
  //     discount: HomeController.discount,
  //     name: HomeController.customerName.text,
  //     phone: HomeController.customerPhone.text,
  //     tax: LocalStorage.getData(key: 'tax').toString(),
  //     paymentMethod: 'Not Paid',
  //     ownerId:  null,
  //     paymentCustomer: HomeController.cartItems[0].selectCustomer,
  //     paymentCustomerId: HomeController.cartItems[0].customer,
  //     paymentStatus: 0,
  //     uuid: uuid,
  //     details: ordersDetails,
  //     createdAt: DateTime.now().toUtc().toString(),
  //     orderStatus:"order sent to kitchen",
  //     orderStatusId: 2,
  //     paymentMethodId: null,
  //     owner: null,
  //     paidAmount: totalAmount.toString(),
  //   );
  //
  //   print(ordersModel.paymentMethodId.toString()+'dkdoiopwpw');
  //   offlineOrders.add(json.encode(ordersModel.toJson()));
  //   LocalStorage.saveList(key: 'orderList', value: offlineOrders);
  //   print(LocalStorage.getList(key: 'orderList').last);
  //
  //
  //
  //   // closeOrder();
  //   // error is SecondError
  //   switchLoading(false);
  //   LocalStorage.saveData(key: 'offlineOrdersCount',value: orderCount+1) ;
  //   displayToastMessage(
  //       ' ${'order'.tr() } $uuid  ${'createdSuccessfully'.tr()}',
  //       false);
  //
  //
  //
  //   printerController.testPrint(
  //       time: DateTime.now().toString().substring(0, 16),
  //       orderNo: uuid.toString(),
  //       discount: HomeController.discount,
  //       tax: LocalStorage.getData(key: 'tax').toString(),
  //       total: HomeController.total.toString(),
  //       amount: totalAmount.toString(),
  //       notes: HomeController.notes.text,
  //       customerName: HomeController.customerName.text,
  //       customerNumber: HomeController.customerPhone.text,
  //       cashier: true,
  //       deliver: cardItemsCopy[0].selectCustomer == null ? true : false,
  //       kitchen: true,
  //       home: cardItemsCopy[0].selectCustomer == null ? false : true,
  //       cart: cardItemsCopy);
  //
  //
  //   Navigator.pop(context);
  //   HomeController.closeOrders = true;
  //
  //   notifyListeners();
  //   // LocalStorage.removeData(key: 'orderList');
  // }

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