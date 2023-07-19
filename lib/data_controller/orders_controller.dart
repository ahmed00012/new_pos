import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:easy_localization/src/public_ext.dart';
import 'package:enough_convert/enough_convert.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/styles.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/utils.dart';
import 'package:shormeh_pos_new_28_11_2022/local_storage.dart';
import 'package:shormeh_pos_new_28_11_2022/models/cart_model.dart';
import 'package:shormeh_pos_new_28_11_2022/models/customer_model.dart';

import 'package:shormeh_pos_new_28_11_2022/models/order_method_model.dart';
import 'package:shormeh_pos_new_28_11_2022/models/orders_model.dart';
import 'package:shormeh_pos_new_28_11_2022/models/payment_model.dart';
import 'package:shormeh_pos_new_28_11_2022/repositories/new_order_repository.dart';
import 'package:shormeh_pos_new_28_11_2022/repositories/orders_repository.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/screens/home/home.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/screens/payment/payment_screen.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/widgets/complain_widget.dart';

import '../constants/colors.dart';
import '../main.dart';
import '../models/complain_reasons.dart';
import '../models/order_status_model.dart';
import '../models/owner_model.dart';
import '../models/printers_model.dart';
import '../ui/screens/login.dart';
import 'home_controller.dart';
import 'package:image/image.dart' as img;


final ordersFuture = ChangeNotifierProvider.autoDispose<OrdersController>(
    (ref) => OrdersController());

class OrdersController extends ChangeNotifier {

  String token = LocalStorage.getData(key: 'token');
  int branch = LocalStorage.getData(key: 'branch');
  OrdersRepository repo = OrdersRepository();
  List<OrdersModel> orders = [];
  int? chosenOrder;
  String? chosenOrderNum;
  // int page = 1;
  int currentPage = 1;
  int lastPage = 1;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  NewOrderRepository repoFilter = NewOrderRepository();
  List<PaymentModel> paymentMethods = [];
  List<OrderMethodModel> orderMethods = [];
  List<OrderStatusModel> orderStatus = [];
  List<ComplainReasons> reasons = [];
  bool disposeFilters = true;
  int? chosenOrderMethod;
  int? chosenPaymentMethod;
  int? chosenOwner;
  int? chosenOrderStatus;
  int? chosenReason;
  // String? chosenTime;
  // int? orderNum;
  // String? client;
  TextEditingController clientSearch =TextEditingController();
  List<String> images=[
    'assets/images/grid.png',
    'assets/images/pen.png',
    'assets/images/clock.png',
    'assets/images/work-done.png',
    'assets/images/positive-vote.png',
    'assets/images/cancelled.png',
    'assets/images/stop-button.png',
    'assets/images/report.png',
    'assets/images/block-user.png',
    'assets/images/cancel.png',
    'assets/images/delivery-man(2).png'
  ];
 // List<String> items=['Complain', 'Cancel Order'];

  bool loading=false;
  TextEditingController description =TextEditingController();
  TextEditingController secretId =TextEditingController();
  TextEditingController secretCode =TextEditingController();
  TextEditingController mobile =TextEditingController();
  TextEditingController reason =TextEditingController();

  int? chosenCustomer;
  List<PaymentModel> payment = [];
  List<CustomerModel> paymentCustomer = [];
  bool isVisible = true;
  int? key;
  bool connected = true;
  bool filter = false;
  List<OwnerModel> owners = [];
  img.Image? productsScreenshot;
  Uint8List? productsImage;
  List<PrinterModel> printers = [];

  OrdersController() {
    getOrders(page: 1);
    getOrderMethods();
    getPaymentMethods();
    getOrderStatus();
    // getPayment();
    getPaymentCustomers();
    getReasons();
    getOwners();
    getPrinters();
  }

 void refresh(){
    notifyListeners();
  }

  testToken()async{
    LocalStorage.removeData(key: 'token');
    LocalStorage.removeData(key: 'branch');
    LocalStorage.removeData(key: 'coupons');
    navigatorKey.currentState!.pushAndRemoveUntil(MaterialPageRoute(builder: (_)=>Login()), (route) => false);
  }

  void getOwners() async {
    owners = List<OwnerModel>.from(json
        .decode(LocalStorage.getData(key: 'owners'))
        .map((e) => OwnerModel.fromJson(e)));
    notifyListeners();
  }
  //
  // orderStatusFilter(int i, int id) {
  //   orderStatus.forEach((element) {
  //     element.chosen = false;
  //   });
  //   orderStatus[i].chosen = true;
  //   disposeFilters = false;
  //   chosenOrderStatus = id;
  //   chosenOrder = null;
  //
  //     orderStatus.forEach((element) {
  //       element.chosen = false;
  //     });
  //     orderStatus[i].chosen = true;
  //     disposeFilters = false;
  //     orders = [];
  //     page = 1;
  //     chosenOrderStatus = id;
  //     chosenOrder = null;
  //     filterOrders(
  //         paymentMethod: chosenPaymentMethod,
  //         orderMethod: chosenOrderMethod,
  //         orderStatus: id,
  //         // date: chosenTime,
  //         orderId: orderNum);
  //
  //   notifyListeners();
  // }
  //
  // searchOrder(int order){
  //   disposeFilters = false;
  //   chosenOrder = null;
  //
  //     orderNum = order;
  //     orders = [];
  //     page = 1;
  //     chosenOrder = null;
  //     filterOrders(
  //         paymentMethod: chosenPaymentMethod,
  //         orderMethod: chosenOrderMethod,
  //         orderStatus: chosenOrderStatus,
  //         // date: chosenTime,
  //         orderId: order);
  //
  //
  //   notifyListeners();
  // }
  //
  // searchClient(){
  //   disposeFilters = false;
  //   chosenOrder = null;
  //   orderNum = null;
  //
  //     disposeFilters = false;
  //     orders = [];
  //     page = 1;
  //     chosenOrder = null;
  //     orderNum = null;
  //     filterOrders(
  //         paymentMethod: chosenPaymentMethod,
  //         orderMethod: chosenOrderMethod,
  //         orderStatus: chosenOrderStatus,
  //         // date: chosenTime,
  //         client: clientSearch.text);
  //
  //   // else{
  //   //   offlineOrdersListCopy = List.from(offlineOrdersList);
  //   //   offlineOrdersList = offlineOrdersList.where((element) => element.name!.contains(clientSearch.text)|| element.phone!.contains(clientSearch.text)).toList();
  //   // }
  //   notifyListeners();
  // }

  // void allFilter() {
  //   disposeFilters = true;
  //   orderMethods.forEach((element) {
  //     element.chosen = false;
  //   });
  //   paymentMethods.forEach((element) {
  //     element.chosen = false;
  //   });
  //   orderStatus.forEach((element) {
  //     element.chosen = false;
  //   });
  //   orderStatus[0].chosen = true;
  //   page = 1;
  //   orders = [];
  //   chosenPaymentMethod = null;
  //   chosenOrderMethod = null;
  //   chosenOrderStatus = null;
  //   // chosenTime = null;
  //   chosenOrder = null;
  //   orderNum = null;
  //   clientSearch.text='';
  //   getOrders();
  //   notifyListeners();
  // }

  void switchLoading(bool load){
    loading = load;
    notifyListeners();
  }

  Future getOrders({
    required int page, int? orderMethod, int? paymentMethod, int? orderStatus,
    int? orderId,int? customer,String? client, int? ownerId ,
    bool? paid , bool? notPaid}) async {
    if(page==1)
    switchLoading(true);

      var data = await repo.getOrders(page,paymentMethod: paymentMethod,
          orderMethod: orderMethod,
          orderStatus: orderStatus,
          orderId: orderId,
          owner: ownerId,
          customer: customer,
          client: client);
      if (!data['status']) {
        ConstantStyles.displayToastMessage(data['msg'], true);
      }

      else {
        if (page <= data['data']['meta']['last_page']) {
          List list = List<OrdersModel>.from(
              data['data']['data'].map((order) => OrdersModel.fromJson(order)));
          list.forEach((element) {
            if (element.ownerId != null) {
              owners.forEach((owner) {
                if (owner.id == element.ownerId) {
                  element.ownerName = owner.titleEn;
                }
              });
            }
            orders.add(element);
          });
          list = [];
          currentPage = ;
          refreshController.loadComplete();
        }
      }
    switchLoading(false);
    notifyListeners();
  }


  // filterOrders({int? orderMethod, int? paymentMethod, int? orderStatus,String? date,
  //   int? orderId,int? customer,String? client, int? ownerId ,
  //   bool? paid , bool? notPaid}) async {
  //  page = 1;
  //  orders.clear();
  //  chosenOrder = null;
  //   switchLoading(true);
  //   var data = await repo.getOrders(token, LocalStorage.getData(key: 'language'), page,
  //       paymentMethod: paymentMethod,
  //       orderMethod: orderMethod,
  //       orderStatus: orderStatus,
  //   date: LocalStorage.getData(key: 'loginDate'),
  //   orderId: orderId,
  //   owner: ownerId,
  //   customer: customer,
  //   client: client);
  //   if(data == 'unauthorized'){
  //     testToken();
  //   }
  //   else if(data ==false){
  //     displayToastMessage('Connection Error', true);
  //   }
  //
  //   else {
  //     if (page <= data['meta']['last_page']) {
  //       List list = List<OrdersModel>.from(
  //           data['data'].map((order) => OrdersModel.fromJson(order)));
  //       list.forEach((element) {
  //         if (element.ownerId != null) {
  //           owners.forEach((owner) {
  //             if (owner.id == element.ownerId) {
  //               element.ownerName = owner.titleEn;
  //             }
  //           });
  //         }
  //         orders.add(element);
  //       });
  //       print(list.length.toString()+'dkdkkdk');
  //
  //       if(paid!= null && paid)
  //       orders = orders.where((element) => element.paymentStatus!= 0).toList();
  //
  //       if(notPaid!= null && notPaid)
  //         orders = orders.where((element) => element.paymentStatus!= 1).toList();
  //
  //       list = [];
  //       page++;
  //       refreshController.loadComplete();
  //     } else {
  //       refreshController.loadComplete();
  //     }
  //   }
  //   switchLoading(false);
  //   notifyListeners();
  // }

  void getOrderMethods() async {

      orderMethods = List<OrderMethodModel>.from(json
          .decode(LocalStorage.getData(key: 'orderMethods'))
          .map((e) => OrderMethodModel.fromJson(e)));

    orderMethods.forEach((element) {
      element.chosen = false;
    });
    notifyListeners();
  }

  void getPaymentMethods() async {
    print(LocalStorage.getData(key: 'paymentMethods').toString()+'sllqqq');
      paymentMethods = List<PaymentModel>.from(json
          .decode(LocalStorage.getData(key: 'paymentMethods'))
          .map((e) => PaymentModel.fromJson(e)));
    paymentMethods.forEach((element) {
      element.chosen = false;
    });

    notifyListeners();
  }

  void getOrderStatus() async {
    print(LocalStorage.getData(key: 'orderStatus').toString()+'slsklslaa');
    // if(LocalStorage.getData(key: 'orderStatus')==null) {
    //   var data = await repo.getOrderStatus(token, LocalStorage.getData(key: 'language'));
    //   LocalStorage.saveData(key: 'orderStatus', value: json.encode(data));
    //   orderStatus = List<OrderMethodModel>.from(
    //       data.map((e) => OrderMethodModel.fromJson(e)));
    // }
    // else{
      orderStatus = List<OrderStatusModel>.from(json
          .decode( LocalStorage.getData(key: 'orderStatus')).map((e) => OrderStatusModel.fromJson(e)));
    // }
    orderStatus.forEach((element) {
      element.chosen = false;
    });

    orderStatus.insert(
      0,
      OrderStatusModel(
        id: 0,
        chosen: true,
        title: StatusTitle(
          en :'All',
          ar:'الكل'
        )
      )
    );

    notifyListeners();
  }

  // void getPayment()async{
  //   // if (LocalStorage.getData(key: 'paymentCustomers') == null) {
  //   //   var data = await repo.getCustomers(token, LocalStorage.getData(key: 'language'));
  //   //   LocalStorage.saveData(key: 'paymentCustomers', value: json.encode(data));
  //   //   paymentCustomers =
  //   //   List<PaymentModel>.from(data.map((e) => PaymentModel.fromJson(e)));
  //   // } else {
  //     payment = List<PaymentModel>.from(json
  //         .decode(LocalStorage.getData(key: 'paymentCustomers'))
  //         .map((e) => PaymentModel.fromJson(e)));
  //   // }
  //   payment.forEach((element) {
  //     element.chosen = false;
  //   });
  //   // paymentCustomers[0].chosen = true;
  //   // chosenCustomer = paymentCustomers[0];
  //   notifyListeners();
  // }

  void getPaymentCustomers() async {
    paymentCustomer = List<CustomerModel>.from(json
        .decode(LocalStorage.getData(key: 'paymentCustomers'))
        .map((e) => CustomerModel.fromJson(e)));
    paymentCustomer.forEach((element) {
      element.chosen = false;
    });
    loading = false;
    notifyListeners();
  }

  void getReasons()async{
    // if (LocalStorage.getData(key: 'reasons') == null) {
    //   var data = await repo.getReasons(token, LocalStorage.getData(key: 'language'));
    //   print(data.toString()+'fdldfflk');
    //   LocalStorage.saveData(key: 'reasons', value: json.encode(data));
    //   reasons =
    //   List<PaymentModel>.from(data.map((e) => PaymentModel.fromJson(e)));
    // } else {

      reasons = List<ComplainReasons>.from(json
          .decode(LocalStorage.getData(key: 'reasons'))
          .map((e) => ComplainReasons.fromJson(e)));
    //   print(reasons[0].title);
    // }
    reasons.forEach((element) {
      element.chosen = false;
    });
    notifyListeners();
  }

  void selectReason(int i){
   reasons.forEach((element) {element.chosen=false;});
    reasons[i].chosen=true;
    chosenReason=reasons[i].id;
    notifyListeners();
  }

  void cancelOrder(int id,BuildContext context)async{
    if(id!=0) {
      switchLoading(true);
      var data = await repo.cancelOrder(
          token, LocalStorage.getData(key: 'language'), id, reason.text,
          secretId.text,secretCode.text,LocalStorage.getData(key: 'branch').toString()).then((
          value) {
        if(value == 'unauthorized'){
          testToken();
        }
        else if(value ==false){
          displayToastMessage('Connection Error', true);
        }

        else {

          displayToastMessage(
              'order'.tr() + ' $chosenOrderNum ' + 'cancelled'.tr(), false);
          orders[chosenOrder!].orderStatusId = 5;
          orders[chosenOrder!].orderStatus = 'Order Cancelled';
          reason.text = '';
          secretId.text='';
          secretCode.text='';
          chosenReason=null;
          Navigator.pop(context);
        }

      });
      switchLoading(false);
    }
    // else{
    //   displayToastMessage(
    //      ' ${'order'.tr()}  ${offlineOrdersList[chosenOrder!].uuid!} ${'cancelled'.tr()}', false);
    //   offlineOrdersList.removeAt(chosenOrder!);
    //   List<String> updatedList = [];
    //   offlineOrdersList.forEach((element) {
    //     updatedList.add(json.encode(element.toJson()));
    //   });
    //   LocalStorage.saveList(key: 'orderList', value: updatedList);
    //
    //   reason.text = '';
    // }

    notifyListeners();
  }

  void complainOrder(int id,BuildContext context)async {
    if (chosenReason == null)
      displayToastMessage('pleaseSelectReason'.tr(), true);
    else {
      var data = await repo.complainOrder(
          token, LocalStorage.getData(key: 'language'), id, {
        'notes': description.text,
        'secret_id': secretId.text,
        'secret_code': secretCode.text,
        'complain_reason_id': chosenReason,
        'phone': mobile.text
      });
      if (data['status'] == false) {
        displayToastMessage(data['msg'], true);
      }

      else {
        orders[chosenOrder!].orderStatusId = 7;
        orders[chosenOrder!].orderStatus = 'order Complained';
        chosenReason = null;
        reasons.forEach((element) {
          element.chosen = false;
        });
        displayToastMessage(
            'complainCreatedOnOrder'.tr() + ' $chosenOrderNum', false);
        Navigator.pop(context);
      }

      notifyListeners();
    }
  }

  void complain(Size size,BuildContext context,bool complainOrder,{int? orderId}){
    showDialog(
        context: context,
        builder: (context) {
          return ComplainWidget(complain: complainOrder,orderId: orderId!,);
        }).then((value)  {
      description.text='';
      secretId.text='';
      secretCode.text='';
      mobile.text='';
      chosenReason=null;
      reasons.forEach((element) {element.chosen=false;});
    });
  }


  void editOrder(BuildContext context, bool navigate){
    // HomeController.orderDetails = OrderDetails();
    //
    // HomeController.orderDetails.editOrder(orders[chosenOrder!],);




    // selectedTab = SelectedTab.home;

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

  imageProductsPrinter(ScreenshotController screenshotController) async {

    screenshotController.capture().then((Uint8List? image2) {
      productsScreenshot = img.decodePng(image2!);
      productsScreenshot!.setPixelRgba(0, 0, 255,255,255);
      productsScreenshot= img.copyResize(productsScreenshot!, width: 550);
      productsImage = image2;
      // setImageScreenshot(image2,productsScreenshot);
      notifyListeners();
    });
  }

  String getQrCodeContent(String orderTotal,String orderTax) {


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

  testReceipt(img.Image productsScreenshot, NetworkPrinter printer,
      OrderDetails order , bool kitchen,{String? orderNo}) async {

    print('zzzzdswfd');
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

    if(order.clientName!=null )
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

    if( !kitchen)

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
    if (order.payment1!= null && !kitchen)
      printer.textEncoded(textEncoder(
          'paymentMethod'.tr()+ ' : '+
              order.payment1!.title!.en!),
          styles: PosStyles(
            align: PosAlign.center,
            bold: true,
          ));

    if (order.payment2!= null && !kitchen)
      printer.textEncoded(textEncoder(
          'paymentMethod'.tr()+ ' : '+
              order.payment2!.title!.en!),
          styles: PosStyles(
            align: PosAlign.center,
            bold: true,
          ));

    //
    // if (order.owner!= null )
    //   printer.textEncoded(textEncoder(order.owner!.title!),
    //       styles: PosStyles(
    //         align: PosAlign.center,
    //         bold: true,
    //       ));



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


    printer.image(productsScreenshot, align: PosAlign.center);

    if(!kitchen)
      printer.emptyLines(1);
    if(!kitchen)
      printer.qrcode(getQrCodeContent(order.getTotal().toString(),order.tax.toString()));
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
    // if (order.owner!= null )
    //   channel.invokeMethod("printText", [ order.owner!.title!,'25','1']);


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


    channel.invokeMethod("printQr", [getQrCodeContent(order.getTotal().toString(),order.tax.toString())]);
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

  testPrint({String ?orderNo,required OrderDetails order}) async {
    // OrderDetails order = HomeController.orderDetails.copyWith();
    // HomeController.orderDetails = OrderDetails();
    deviceReceipt(order , orderNo:orderNo);
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);
    printers.forEach((element) async {
      PosPrintResult res = await printer.connect(element.ip!, port: 9100);
      if (res == PosPrintResult.success) {
        await testReceipt(productsScreenshot!,printer,order,element.typeName == 'Kitchen',orderNo: orderNo);
        printer.disconnect();
      }

    });
    //
    //  testReceipt(printer,order,orderNo,false);

    notifyListeners();
  }

  void displayToastMessage(var toastMessage,bool alert) {
    showSimpleNotification(
        Container(
          height: 50,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Center(
              child: Text(
                toastMessage,
                style: TextStyle(
                    color:alert? Colors.white:Constants.mainColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
        duration: Duration(seconds: 3),
        elevation: 2,
        background: alert?Colors.red[500]:Constants.secondryColor);
  }
}
