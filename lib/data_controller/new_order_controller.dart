import 'dart:convert';

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:easy_localization/src/public_ext.dart';
import 'package:enough_convert/enough_convert.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as img;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shormeh_pos_new_28_11_2022/data_controller/home_controller.dart';
import 'package:shormeh_pos_new_28_11_2022/local_storage.dart';
import 'package:shormeh_pos_new_28_11_2022/models/cart_model.dart';
import 'package:shormeh_pos_new_28_11_2022/models/coupon_model.dart';
import 'package:shormeh_pos_new_28_11_2022/models/owner_model.dart';
import 'package:shormeh_pos_new_28_11_2022/models/payment_model.dart';
import 'package:shormeh_pos_new_28_11_2022/repositories/new_order_repository.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/widgets/amount_widget.dart';
import '../constants.dart';
import '../main.dart';
import '../models/confirm_order_model.dart';
import '../models/integration_model.dart';
import '../models/printers_model.dart';
import '../ui/screens/home.dart';
import '../ui/screens/login.dart';


final newOrderFuture = ChangeNotifierProvider.autoDispose<NewOrderController>((ref) =>
    NewOrderController());

class NewOrderController extends ChangeNotifier {
  NewOrderRepository repo = NewOrderRepository();
  List<PaymentModel> paymentMethods = [];
  List<PaymentModel> paymentCustomers = [];
  List<OwnerModel> owners = [];
  List<CouponModel> coupons = [];
  bool loading = false;
  bool selectCustomerChosen = false;

  TextEditingController coupon = TextEditingController();
  List<PrinterModel> printers = [];
  String twitter ='';
  String instagram ='';
  String phone ='';

  int? key;
  double? predict1;
  double? predict2;
  double? predict3;
  double? predict4;
  OwnerModel? chosenOwner;
  img.Image? productsScreenshot;
  Uint8List? productsImage;
  double remaining = 0.0;


  NewOrderController() {
    getPaymentMethods();
    collapse();
    getCoupons();
    getOwners();
    getSocial();
    getPrinters();



  }

  testToken()async{
    LocalStorage.removeData(key: 'token');
    LocalStorage.removeData(key: 'branch');
    LocalStorage.removeData(key: 'coupons');
    navigatorKey.currentState!.pushAndRemoveUntil(MaterialPageRoute(builder: (_)=>Login()), (route) => false);
  }
  collapse() {
    int? newKey;
    do {
      key = new Random().nextInt(10000);
    } while (newKey == key!);
  }

  void getPaymentMethods() async {
      paymentMethods = List<PaymentModel>.from(json
          .decode(LocalStorage.getData(key: 'paymentMethods'))
          .map((e) => PaymentModel.fromJson(e)));
    paymentMethods.forEach((element) {
      element.chosen = false;
    });

    notifyListeners();
  }

  void getOwners() async {
      owners = List<OwnerModel>.from(json
          .decode(LocalStorage.getData(key: 'owners'))
          .map((e) => OwnerModel.fromJson(e)));
    owners.forEach((element) {
      element.chosen = false;
    });

    notifyListeners();
  }

  void getCoupons() async {
    print(LocalStorage.getData(key: 'coupons').toString()+'a;alal');
      coupons = List<CouponModel>.from(json
          .decode(LocalStorage.getData(key: 'coupons'))
          .map((e) => CouponModel.fromJson(e)));

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

  void checkCoupon() {
    CouponModel couponUse = CouponModel();
    bool inBranch = false;
    bool valid = true;
    coupons.forEach((element) {
      if (element.code == coupon.text) {
        couponUse = element;
      }
    });

    if (couponUse.id == null) {
      displayToastMessage('couponNotFound'.tr(), true);
      valid = false;
    } else {
      couponUse.branches!.forEach((element) {
        if (element.id == LocalStorage.getData(key: 'branch')) inBranch = true;
      });
    }
    if (couponUse.isActive == 0) {
      displayToastMessage('couponNotValid'.tr(), true);
      valid = false;
    }
    if (couponUse.counter! >= couponUse.numOfUses!) {
      displayToastMessage('couponHasEnded'.tr(), true);
      valid = false;
    }
    if (!inBranch) {
      displayToastMessage('couponNotAvailableForThisBranch'.tr(), true);
      valid = false;
    }
    if (couponUse.dateFrom != null) {

      if (DateTime.parse('${couponUse.dateFrom} ${couponUse.timeFrom??'00:00'}')
          .isAfter(DateTime.now())) {
        displayToastMessage('couponStillNotAvailable'.tr(), true);
        valid = false;
      }
    }
    if (couponUse.dateTo != null ) {
      if (DateTime.parse('${couponUse.dateTo} ${couponUse.timeTo??'23:59'}')
          .isBefore(DateTime.now())) {
        displayToastMessage('couponHasEnded'.tr(), true);
        valid = false;
      }
    }
    if (valid) {
      displayToastMessage('couponAdded'.tr(), false);
      if (couponUse.type == 1) {
        HomeController.orderDetails.setDiscount(false, couponUse.value!);
        // HomeController.orderDetails.discount= couponUse.value.toString() + ' SAR ';
        // if (HomeController.orderDetails.getTotal() >= couponUse.value!)
        //   // HomeController.total = HomeController.total - couponUse.value!;
        //   HomeController.orderDetails.discountValue = couponUse.value!.toDouble();
        //
        // else
        //   HomeController.total = 0.0;
      } else {
        HomeController.orderDetails.setDiscount(true, couponUse.value!);
        // HomeController.orderDetails.discount = couponUse.value.toString() + '% ';
        // HomeController.total =
        //     HomeController.total * (1 - (couponUse.value! / 100));
      }
    }
    else{
      coupon.text='';
    }
    notifyListeners();
  }

  void selectOwner(int i) {
    cancelPayment();
    owners.forEach((element) {
      element.chosen = false;
    });
    owners[i].chosen = true;
    chosenOwner = owners[i];
    HomeController.orderDetails.owner =OwnerModel(
      id: owners[i].id,
      title: owners[i].title,
      chosen: true
    );
    collapse();
    notifyListeners();
  }

  void cancelPayment(){
    paymentMethods.forEach((element) {
      element.chosen = false;
    });
    HomeController.orderDetails.cancelPayment();
    notifyListeners();
  }

  void selectPayment(int i, BuildContext context) {
    // HomeController.orderDetails.amount1 = 0;
    // HomeController.orderDetails.amount2 = 0;
    owners.forEach((element) {
      element.chosen = false;
    });
    chosenOwner = null;
    HomeController.orderDetails.owner = null;
    collapse();


    if(HomeController.orderDetails.payment1==null){
      HomeController.orderDetails.payment1 = paymentMethods[i];
      paymentMethods[i].chosen = true;
      amountCalculator(context);

    }
    else if(HomeController.orderDetails.payment1!=null&&
        HomeController.orderDetails.payment2 == null &&
    HomeController.orderDetails.getTotal()>HomeController.orderDetails.getTotalAmount()){
      HomeController.orderDetails.payment2 = paymentMethods[i];
      paymentMethods[i].chosen = true;
      amountCalculator(context);
    }

   else if(HomeController.orderDetails.payment1==paymentMethods[i]){
      paymentMethods[i].chosen = false;
      HomeController.orderDetails.payment1 = null;
      HomeController.orderDetails.amount1 = 0.0;
      print(HomeController.orderDetails.getTotalAmount());
      print(HomeController.orderDetails.getTotal());
      HomeController.orderDetails.getTotalAmount();
      HomeController.orderDetails.getTotal();
    }
    else if(HomeController.orderDetails.payment2==paymentMethods[i]){
      paymentMethods[i].chosen = false;
      HomeController.orderDetails.payment2 = null;
      HomeController.orderDetails.amount2 = 0.0;
    }

    else if(HomeController.orderDetails.payment2!=null&&HomeController.orderDetails.payment1!=null){

      paymentMethods.forEach((element) {
        if(element.id ==HomeController.orderDetails.payment2!.id){
         element.chosen = false;
        }
      });
      HomeController.orderDetails.amount2 = 0.0;
      paymentMethods[i].chosen = true;
      HomeController.orderDetails.payment2 = paymentMethods[i];
      amountCalculator(context);

    }

    HomeController.orderDetails.payment =paymentMethods[i].title!.en;

    notifyListeners();
  }

  double totalFromAmount() {

    remaining =
        HomeController.orderDetails.getTotalAmount() -  HomeController.orderDetails.getTotal();

    return remaining;
  }

  void switchLoading(bool load) {
    loading = load;
    notifyListeners();
  }

  void closeOrder() {
    coupon.text = '';
    HomeController.orderDetails = OrderDetails();
    paymentMethods.forEach((element) {
      element.chosen = false;
    });
    switchLoading(false);
    chosenOwner = null;
    notifyListeners();
  }



  Future confirmOrder(int hold,BuildContext context) async {
    switchLoading(true);
    List<Order> details = [];
    List<PayMethods> payment = [];
    IntegrationModel integrationModel = IntegrationModel(orderDetail: []);
    int ? payMethodID ;
    int? paymentStatus ;
    totalFromAmount();



    if(HomeController.orderDetails.payment1!=null&& hold ==0) {
      PayMethods orderPayment1 = PayMethods(
          payMethodId: HomeController.orderDetails.payment1!.id,
          value: HomeController.orderDetails.amount1);
      payment.add(orderPayment1);

    }
    if(HomeController.orderDetails.customer !=null) {
      PayMethods orderPayment = PayMethods(
          payMethodId: 2,
          value: 0);
      payment.add(orderPayment);

    }

    if(HomeController.orderDetails.payment2!=null&& hold ==0 && HomeController.orderDetails.amount2 != 0) {
      PayMethods orderPayment2 = PayMethods(
          payMethodId: HomeController.orderDetails.payment2!.id,
          value: HomeController.orderDetails.amount2);
      payment.add(orderPayment2);
    }

    if(HomeController.orderDetails.paymentId!=null) {
      payMethodID = HomeController.orderDetails.paymentId;
    }
    else if(HomeController.orderDetails.payment1!=null&& hold ==0) {
      payMethodID = HomeController.orderDetails.payment1!.id;
    }
     if(HomeController.orderDetails.customer !=null ) {
      payMethodID = 2;
    }


    HomeController.orderDetails.cart!.forEach((element) {
      List<int> notesId = [];
      // description.add(element.itemName! + ' ');

      OrderDetail countingIntegrationBody = OrderDetail(
   
          postingDate: DateTime.now().toString(),
          quantity: element.count.toString(),
           description: element.itemName.toString(),
          tax: (element.total! * double.parse(LocalStorage.getData(key: 'tax').toString()) / 100).toString(),
          discount: HomeController.orderDetails.discount??'0',
        // amount: (element.total!/element.count!.toDouble()).toString(),
        amount: element.total!.toString(),
          paymentType:'',
          itemNo: element.itemCode,
          locationCode:LocalStorage.getData(key: 'branchCode').toString(),
        type: 'Sale',
        unitOfMeasure: 'PCS'

      );
      integrationModel.orderDetail!.add(countingIntegrationBody);
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




    if(HomeController.orderDetails.payment1!=null){
      integrationModel.orderDetail!.add( OrderDetail(
        postingDate: DateTime.now().toString(),
        quantity:'1',
        description: '',
        tax: HomeController.orderDetails.tax.toString(),
        discount: HomeController.orderDetails.discount??'0',
        amount: HomeController.orderDetails.payment2==null?
        HomeController.orderDetails.getTotal().toString():
        HomeController.orderDetails.amount1.toString(),
        paymentType: HomeController.orderDetails.payment1!.id.toString(),
        itemNo: '',
        locationCode: LocalStorage.getData(key: 'branchCode').toString(),
        type: 'Payment',
        unitOfMeasure: ''
      ));
    }
    if(HomeController.orderDetails.payment2!=null && HomeController.orderDetails.amount2 != 0){
      integrationModel.orderDetail!.add( OrderDetail(
          postingDate: DateTime.now().toString(),
          quantity:'1',
          description: '',
          tax: HomeController.orderDetails.tax.toString(),
          discount: HomeController.orderDetails.discount??'0',
          amount: HomeController.orderDetails.amount2.toString(),
          paymentType:HomeController.orderDetails.payment2!.id.toString(),
          itemNo: '',
          locationCode: LocalStorage.getData(key: 'branchCode').toString(),
          type: 'Payment',
          unitOfMeasure: ''
      ));
    }




    if(hold ==1)
      paymentStatus = 0;
    else if(HomeController.orderDetails.payment1==null)
      paymentStatus = 0;
    else
      paymentStatus = 1;

    ConfirmOrderModel2 order = ConfirmOrderModel2(
      name: HomeController.orderDetails.clientName,
      phone: HomeController.orderDetails.clientPhone,
      hold: hold,
      tableId: HomeController.orderDetails.table,
      ownerId:HomeController.orderDetails.owner!=null?
      HomeController.orderDetails.owner!.id:null,
      notes: HomeController.orderDetails.notes,
      paymentMethodId: payMethodID,
      // clientsCount:  HomeController.orderDetails.co,
      paymentCustomerId: HomeController.orderDetails.customer!=null?
      HomeController.orderDetails.customer!.id:null,
      paymentStatus:  paymentStatus,
      coupon: coupon.text,
      orderMethodId: HomeController.orderDetails.orderMethodId,
      paidAmount: HomeController.orderDetails.getTotalAmount(),
      paymethods:   payment.length>1 ? payment : null ,
      order: details
    );

    var responseValue = await repo.confirmOrder(LocalStorage.getData(key: 'token'),
          LocalStorage.getData(key: 'language'), order.toJson());


    // if(responseValue == 'unauthorized'){
    //   testToken();
    // }
    // else if(responseValue ==false){
    //   displayToastMessage('Order Failed', true);
    // }

    if(responseValue['data']!=null) {

      // OrderDetails newOrder = HomeController.orderDetails.copyWith();
      //
      testPrint(orderNo: responseValue['data']['uuid'],).then((value) {

          //
         integrationModel.orderDetail!.asMap().forEach((index,element) {

           element.lineNo = responseValue['data']['id'].toString() + index.toString();
           element.documentNo = responseValue['data']['id'].toString()+'_'+responseValue['data']['id'].toString()+index.toString();
           element.customerNo = responseValue['data']['client_id'].toString();
         });


          if(LocalStorage.getData(key: 'branchCode').toString()!='null')
         repo.payIntegration(integrationModel.toJson());

          print('Order Confirmed :' + order.toJson().toString());

         displayToastMessage(
             ' ${'order'.tr()} ${responseValue['data']['uuid']}  ${'createdSuccessfully'.tr()}',
             false);
         closeOrder();
         Navigator.pushAndRemoveUntil(context,
             MaterialPageRoute(builder: (_)=>Home()), (route) => false);
       });


      }
    else {
      displayToastMessage('Order Failed ${responseValue['msg']}', true);
    }

    switchLoading(false);
    notifyListeners();
  }

  Future updateOrder(int itemId,BuildContext context) async {


    // mainNameItem();
    switchLoading(true);
    List<Order> details = [];
    List<PayMethods> payment = [];
    List <String> description = [];
    IntegrationModel integrationModel = IntegrationModel(orderDetail: []);
    int? paymentStatus ;
    int ? payMethodID ;
    totalFromAmount();


    if(HomeController.orderDetails.payment1!=null) {
      PayMethods orderPayment1 = PayMethods(
          payMethodId: HomeController.orderDetails.payment1!.id,
          value: HomeController.orderDetails.amount1);
      payment.add(orderPayment1);
    }
    if(HomeController.orderDetails.customer !=null) {
      PayMethods orderPayment = PayMethods(
          payMethodId: 2,
          value: 0);
      payment.add(orderPayment);

    }
    if(HomeController.orderDetails.payment2!=null && HomeController.orderDetails.amount2 != 0) {
      PayMethods orderPayment2 = PayMethods(
          payMethodId: HomeController.orderDetails.payment2!.id,
          value: HomeController.orderDetails.amount2);
      payment.add(orderPayment2);
    }

    if(HomeController.orderDetails.paymentId!=null) {
      payMethodID = HomeController.orderDetails.paymentId;
    } else if(HomeController.orderDetails.payment1!=null) {
      payMethodID = HomeController.orderDetails.payment1!.id;
    }
     if(HomeController.orderDetails.customer !=null) {
      payMethodID = 2;
    }

    HomeController.orderDetails.cart!.forEach((element) {
     List<int> notesId = [];
     description.add(element.itemName.toString());

     if(element.updated)
     {

        element.extra!.forEach((element) {

          notesId.add(element.id!);
        });

        Order myOrder = Order();
          myOrder = Order(
              rowId: element.rowId,
              productId: element.id,
              quantity: element.count ,
              note: element.extraNotes,
              notes: notesId,
              attributes: element.allAttributesID);

        details.add(myOrder);
      }
     OrderDetail countingIntegrationBody = OrderDetail(
         postingDate: DateTime.now().toString(),
         quantity: element.count.toString(),
         description: element.itemName.toString(),
         tax: (element.total! * double.parse(LocalStorage.getData(key: 'tax').toString()) / 100).toString(),
         discount: HomeController.orderDetails.discount.toString(),
         // amount: (element.total!/element.count!.toDouble()).toString(),
         amount: element.total!.toString(),
         paymentType: '',
         itemNo: element.itemCode,
         locationCode: LocalStorage.getData(key: 'branch_code').toString(),
       type: 'Sale'
     );
     integrationModel.orderDetail!.add(countingIntegrationBody);

    });


    if(HomeController.orderDetails.payment1!=null){
      paymentStatus = 1;
      integrationModel.orderDetail!.add( OrderDetail(
          postingDate: DateTime.now().toString(),
          quantity:'1',
          description: '',
          tax: HomeController.orderDetails.tax.toString(),
          discount: HomeController.orderDetails.discount??'0',
          amount: HomeController.orderDetails.payment2==null?
          HomeController.orderDetails.getTotal().toString():
          HomeController.orderDetails.amount1.toString(),
          paymentType:HomeController.orderDetails.payment1!.id.toString(),
          itemNo: '',
          locationCode: LocalStorage.getData(key: 'branchCode').toString(),
          type: 'Payment',
          unitOfMeasure: ''
      ));
    }
    else {
      paymentStatus = 0;
    }
    if(HomeController.orderDetails.payment2!=null && HomeController.orderDetails.amount2 != 0){
      integrationModel.orderDetail!.add( OrderDetail(
          postingDate: DateTime.now().toString(),
          quantity:'1',
          description: '',
          tax: HomeController.orderDetails.tax.toString(),
          discount: HomeController.orderDetails.discount??'0',
          amount: HomeController.orderDetails.amount2.toString(),
          paymentType:HomeController.orderDetails.payment2!.id.toString(),
          itemNo: '',
          locationCode: LocalStorage.getData(key: 'branchCode').toString(),
          type: 'Payment',
          unitOfMeasure: ''
      ));
    }

    ConfirmOrderModel2 updatedOrder = ConfirmOrderModel2(
        name: HomeController.orderDetails.clientName,
        phone: HomeController.orderDetails.clientPhone,
        hold: 0,
        tableId: HomeController.orderDetails.table,
        ownerId:HomeController.orderDetails.owner!=null?
        HomeController.orderDetails.owner!.id:null,
        notes: HomeController.orderDetails.notes,
        paymentMethodId:payMethodID,
        paymentCustomerId:  HomeController.orderDetails.customer!=null?
        HomeController.orderDetails.customer!.id:null,
        paymentStatus:  paymentStatus,
        finish: paymentStatus,
        coupon: coupon.text,
        orderMethodId: HomeController.orderDetails.orderMethodId,
        paidAmount: HomeController.orderDetails.getTotalAmount(),
        paymethods: payment.length>1 ? payment : null,
        order: details,

    );

    var   data = await repo.updateFromOrder(LocalStorage.getData(key: 'token'),
          LocalStorage.getData(key: 'language'), itemId, updatedOrder.toJson()
          );

    if(data == 'unauthorized'){
      testToken();
    }
    else if(data ==false){
      displayToastMessage('Order Failed', true);
    }

    else {
      // OrderDetails newOrder = HomeController.orderDetails.copyWith();
      //
   testPrint(orderNo: data['uuid'],).then((value) {


     if(payMethodID!=null && LocalStorage.getData(key: 'branchCode').toString()!='null')
     {
       integrationModel.orderDetail!.asMap().forEach((index ,element) {
         element.lineNo = data['uuid'].toString() + index.toString();
         element.documentNo = data['id'].toString();
         element.customerNo = data['client_id'].toString();
       });

         repo.payIntegration(integrationModel.toJson());

     }
     print('Order Updated :' + updatedOrder.toJson().toString());
     displayToastMessage(
         'order'.tr() +
             ' ${data['uuid']} ' +
             'updatedSuccessfully'.tr(),
         false);
     closeOrder();
     Navigator.pushAndRemoveUntil(context,
         MaterialPageRoute(builder: (_)=>Home()), (route) => false);
   });



    }
    switchLoading(false);
    notifyListeners();

  }



  amountCalculator(BuildContext context,) {
    double totalWithTax = HomeController.orderDetails.getTotal();
   
    if (HomeController.orderDetails.amount1==0.0 && HomeController.orderDetails.amount2 == 0.0) {
      for (int i = 0; i < 5; i++) {
        if ((totalWithTax + i).ceil() % 5 == 0) {
          predict1 = (totalWithTax + i).ceil().toDouble();
          break;
        }
      }
      for (int i = 0; i < 10; i++) {
        if ((totalWithTax + i).ceil() % 10 == 0) {
          predict2 = (totalWithTax + i).ceil().toDouble();
          break;
        }
      }

      for (int i = 0; i < 50; i++) {
        if ((totalWithTax + i).ceil() % 50 == 0) {
          predict3 = (totalWithTax + i).ceil().toDouble();
          break;
        }
      }

      for (int i = 0; i < 100; i++) {
        if ((totalWithTax + i).ceil() % 100 == 0) {
          predict4 = (totalWithTax + i).ceil().toDouble();
          break;
        }
      }


      if(predict1 == predict2 && predict1! % 10 == 0) predict2 = predict2! + 10;
      else if(predict1 == predict2 && predict1! % 10 != 0)predict2 = predict2! + 5;

      if(predict3!<= predict2!) {
        for (int i = 0; i < 100; i++) {
          print(i);
          if ((predict3! + i )% 100.0 == 0.0) {
            predict3 = predict3! + i;
            break;
          }
        }
      }
      if (predict3 == predict4) predict4 = predict4! + 100;

      // HomeController.orderDetails.amount1 = double.parse(value);
      if(HomeController.orderDetails.payment1!.id==1) {
        showDialog(
            context: context,
            builder: (context) {
              return AmountWidget(
                predict1: predict1 != predict2 ? predict1.toString() : null,
                predict2: predict2.toString(),
                predict3: predict3.toString(),
                predict4: predict4.toString(),
                showTextField: true,
              );
            }).then((value) {
          if (value != null) {
            // amount.insert(0, double.parse(value));
            HomeController.orderDetails.amount1 = double.parse(value);
            HomeController.orderDetails.paid = double.parse(value);
            notifyListeners();
          }
        });
      }
      else {
        showDialog(
            context: context,
            builder: (context) {
              return AmountWidget(
                predict1: HomeController.orderDetails.getTotal().toString(),
                showTextField: true,
              );
            }).then((value) {

          if (value != null) {

            // amount.insert(0, double.parse(value));
            HomeController.orderDetails.amount1 = double.parse(value);
            HomeController.orderDetails.paid = double.parse(value);
            notifyListeners();
          }
          else{
            HomeController.orderDetails.payment1!.chosen = false;
            HomeController.orderDetails.payment1 = null;
            notifyListeners();

          }
        });
        // HomeController.orderDetails.amount1 =
        //     HomeController.orderDetails.getTotal();
        // HomeController.orderDetails.paid = HomeController.orderDetails.getTotal();
        notifyListeners();
      }
    }
    else {
      predict1 = null;
      predict2 = null;
      predict3 = null;
      predict4 = null;
      if(HomeController.orderDetails.amount1!=0) {
        HomeController.orderDetails.amount2 =
            HomeController.orderDetails.getTotal() -
                HomeController.orderDetails.getTotalAmount();
        HomeController.orderDetails.paid=    HomeController.orderDetails.amount2! +
            HomeController.orderDetails.amount1!;
        notifyListeners();

      } else {
        HomeController.orderDetails.amount1 =
            HomeController.orderDetails.getTotal() -
                HomeController.orderDetails.getTotalAmount();
        HomeController.orderDetails.paid=HomeController.orderDetails.amount1!;
        notifyListeners();
        print(HomeController.orderDetails.amount2.toString() + 'slslls');
      }
    }

    notifyListeners();
  }

  // setImageScreenshot(Uint8List? productsImageScreenShot, img.Image? productsTableScreenshot){
  //
  //   productsImage = productsImageScreenShot ;
  //   productsScreenshot = productsTableScreenshot;
  //   notifyListeners();
  // }

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

  checkOrderDetails(int hold,BuildContext context,ScreenshotController screenshotController){
    Future.delayed(Duration(milliseconds: 100),(){
      imageProductsPrinter(screenshotController);
    });
    ////if order not updating///////////
    if(HomeController.orderDetails.orderUpdatedId==null){
      if(HomeController.orderDetails.customer!=null){
      if (HomeController.orderDetails.payment1!=null&& totalFromAmount()!=0.0) {
        showDialog(
            context: context,
            builder: (dialogContext) {
              return AlertDialog(
                title: Center(
                  child: Text(
                      'remaining'.tr() + ' ${totalFromAmount().toStringAsFixed(2)} SAR',
                      style: TextStyle(
                        fontSize: 24,
                      )),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        height: MediaQuery.of(context).size.height*0.07,
                        width: MediaQuery.of(context).size.width*0.2,
                        decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(
                                10),
                            color: Constants.mainColor),
                        child: InkWell(
                          onTap: () {

                            Navigator.pop(dialogContext);
                            confirmOrder(hold,context).then((value) {
                              Navigator.pushAndRemoveUntil(context,
                                  MaterialPageRoute(builder: (_)=>Home()), (route) => false);
                            });
                          },
                          child: Center(
                            child: Text(
                              'ok'.tr(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize:24),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            });
      }
        else {

          confirmOrder(hold, context);
        }
      }

     else if(HomeController.orderDetails.owner!=null){
        confirmOrder(hold,context);
      }

     else if(hold==1) {
        confirmOrder(hold,context);
      }
     else{

       if(HomeController.orderDetails.payment1==null){
         displayToastMessage('Please Choose Payment', true);
       }
      else if(HomeController.orderDetails.getTotalAmount()<HomeController.orderDetails.getTotal() ){
         displayToastMessage('Please Choose Payment', true);
       }
       else if (totalFromAmount()!=0.0) {
         showDialog(
             context: context,
             builder: (dialogContext) {
               return AlertDialog(
                 title: Center(
                   child: Text(
                       'remaining'.tr() + ' ${totalFromAmount().toStringAsFixed(2)} SAR',
                       style: TextStyle(
                         fontSize: 24,
                       )),
                 ),
                 content: Column(
                   mainAxisSize: MainAxisSize.min,
                   children: [

                     Center(
                       child: Container(
                         height: MediaQuery.of(context).size.height*0.07,
                         width: MediaQuery.of(context).size.width*0.2,
                         decoration: BoxDecoration(
                             borderRadius:
                             BorderRadius.circular(
                                 10),
                             color: Constants.mainColor),
                         child: InkWell(
                           onTap: () {

                              Navigator.pop(dialogContext);
                             confirmOrder(hold,context);
                           },
                           child: Center(
                             child: Text(
                               'ok'.tr(),
                               style: TextStyle(
                                   color: Colors.white,
                                   fontSize:24),
                             ),
                           ),
                         ),
                       ),
                     ),
                   ],
                 ),
               );
             });
       }
      else{
         confirmOrder(hold,context);
       }
      }
    }

    else{
      if(HomeController.orderDetails.customer!=null){
        updateOrder(HomeController.orderDetails.orderUpdatedId!, context);
      }

      else{

       if(
       HomeController.orderDetails.payment1!=null&&
       HomeController.orderDetails.getTotalAmount()<HomeController.orderDetails.getTotal() ){
             displayToastMessage('wrongAmount'.tr(), true);
        }
       else if (HomeController.orderDetails.payment1!=null&& totalFromAmount()!=0.0) {
         showDialog(
             context: context,
             builder: (dialogContext) {
               return AlertDialog(
                 title: Center(
                   child: Text(
                       'remaining'.tr() + ' ${totalFromAmount().toStringAsFixed(2)} SAR',
                       style: TextStyle(
                         fontSize: 24,
                       )),
                 ),
                 content: Column(
                   mainAxisSize: MainAxisSize.min,
                   children: [
                     Center(
                       child: Container(
                         height: MediaQuery.of(context).size.height*0.07,
                         width: MediaQuery.of(context).size.width*0.2,
                         decoration: BoxDecoration(
                             borderRadius:
                             BorderRadius.circular(
                                 10),
                             color: Constants.mainColor),
                         child: InkWell(
                           onTap: () {
                             Navigator.pop(dialogContext);
                             updateOrder(HomeController.orderDetails.orderUpdatedId!, context);
                           },
                           child: Center(
                             child: Text(
                               'ok'.tr(),
                               style: TextStyle(
                                   color: Colors.white,
                                   fontSize:24),
                             ),
                           ),
                         ),
                       ),
                     ),
                   ],
                 ),
               );
             });
       }
        else{

         updateOrder(HomeController.orderDetails.orderUpdatedId!, context);
        }
      }
    }
  }


  // imageProductsPrinter(ScreenshotController screenshotController)  {
  //   // productsScreenshot = null;
  //
  //   screenshotController.capture().then((Uint8List? image2) {
  //     productsImage = image2;
  //     productsScreenshot = img.decodePng(image2!);
  //     productsScreenshot!.setPixelRgba(0, 0, 255,255,255);
  //     productsScreenshot= img.copyResize(productsScreenshot!, width: 550);
  //   });
  //
  //   notifyListeners();
  // }

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


    // if (order.owner!= null )
    //   printer.textEncoded(textEncoder(order.owner!.title!),
    //       styles: PosStyles(
    //         align: PosAlign.center,
    //         bold: true,
    //       ));



    if (order.customer!=null && remaining < 0 )
      printer.textEncoded(textEncoder(order.customer!.title! + "  -  " + 'payLater'.tr()) ,
          styles: PosStyles(
            align: PosAlign.center,
            bold: true,
          ));
     if (order.customer!=null && remaining >= 0)
       printer.textEncoded(textEncoder(order.customer!.title!) ,
           styles: PosStyles(
             align: PosAlign.center,
             bold: true,
           ));

     if (order.owner!=null)
       printer.textEncoded(textEncoder('paymentMethod'.tr()+ ' : '+order.owner!.title!),
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

    // channel.invokeMethod("printText", [ order.owner!.title!,'25','1']);


    if (order.customer!=null && remaining < 0)
    channel.invokeMethod("printText", [order.customer!.title! + '  -  ' + 'payLater'.tr(),'25','1']);


    if (order.customer!=null && remaining >= 0 )
      channel.invokeMethod("printText", [order.customer!.title!,'25','1']);

    if (order.owner!=null)
      channel.invokeMethod("printText", ['paymentMethod'.tr()+ ' : '+order.owner!.title!,'25','1']);


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

  //

   testPrint({String ?orderNo}) async {
     OrderDetails order= HomeController.orderDetails.copyWith();
     deviceReceipt(order,orderNo:orderNo);
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
