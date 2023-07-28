import 'dart:convert';

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:easy_localization/src/public_ext.dart';
import 'package:enough_convert/enough_convert.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/printing_services/printing_service.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/styles.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/prefs_utils.dart';
import 'package:shormeh_pos_new_28_11_2022/local_storage.dart';
import 'package:shormeh_pos_new_28_11_2022/models/cart_model.dart';
import 'package:shormeh_pos_new_28_11_2022/models/coupon_model.dart';
import 'package:shormeh_pos_new_28_11_2022/models/orders_model.dart';
import 'package:shormeh_pos_new_28_11_2022/models/owner_model.dart';
import 'package:shormeh_pos_new_28_11_2022/models/payment_model.dart';
import 'package:shormeh_pos_new_28_11_2022/repositories/new_order_repository.dart';
import '../constants/constant_keys.dart';
import '../models/integration_model.dart';
import '../models/printers_model.dart';


final newOrderFuture = ChangeNotifierProvider.autoDispose<NewOrderController>(
        (ref) => NewOrderController());

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
  int? collapseKey;
  double? predict1;
  double? predict2;
  double? predict3;
  double? predict4;
  // img.Image? productsScreenshot;
  // Uint8List? productsImage;
  double remaining = 0.0;


  NewOrderController() {
    getPaymentMethods();
    collapse();
    getOwners();
    getPrinters();
  }

  // testToken()async{
  //   LocalStorage.removeData(key: 'token');
  //   LocalStorage.removeData(key: 'branch');
  //   LocalStorage.removeData(key: 'coupons');
  //   navigatorKey.currentState!.pushAndRemoveUntil(MaterialPageRoute(builder: (_)=>Login()), (route) => false);
  // }
  collapse() {
    int? newKey;
    do {
      collapseKey = new Random().nextInt(10000);
    } while (newKey == collapseKey!);
  }

  void getPaymentMethods() async {
    paymentMethods = List<PaymentModel>.from(json
        .decode(getPaymentMethodsPrefs())
        .map((e) => PaymentModel.fromJson(e)));
    paymentMethods.forEach((element) {
      element.chosen = false;
    });

    notifyListeners();
  }

  void getOwners() async {
    owners = List<OwnerModel>.from(
        json.decode(getOwnersPrefs()).map((e) => OwnerModel.fromJson(e)));
    notifyListeners();
  }

  // void getCoupons() async {
  //     coupons = List<CouponModel>.from(json
  //         .decode(getCouponsPrefs())
  //         .map((e) => CouponModel.fromJson(e)));
  //
  //   notifyListeners();
  // }

  Future getPrinters() async {
    List<PrinterModel> sortPrinters = [];
    sortPrinters = List<PrinterModel>.from(
        json.decode(getPrintersPrefs()).map((e) => PrinterModel.fromJson(e)));

    sortPrinters.forEach((element) {
      if (element.typeName != 'CASHIER') {
        printers.add(element);
      }
    });
    sortPrinters.forEach((element) {
      if (element.typeName == 'CASHIER') {
        printers.add(element);
      }
    });

    notifyListeners();
  }

  void selectOwner(OrderDetails order ,OwnerModel owner) {
    owners.forEach((element) {
      element.chosen = false;
    });
    owner.chosen = true;
    order.owner = owner;
    collapse();
    notifyListeners();
  }

  void cancelPayment() {
    paymentMethods.forEach((element) {
      element.chosen = false;
    });
    // currentOrder!.cancelPayment();
    notifyListeners();
  }

  void selectPayment(OrderDetails order,int i, double total) {
    owners.forEach((element) {
      element.chosen = false;
    });
    order.owner = null;
    collapse();
    amountCalculator(total);

    notifyListeners();
  }

  amountCalculator(double totalWithTax) {
    // if (currentOrder!.amount1==0.0 && currentOrder!.amount2 == 0.0) {
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

    if (predict1 == predict2 && predict1! % 10 == 0)
      predict2 = predict2! + 10;
    else if (predict1 == predict2 && predict1! % 10 != 0)
      predict2 = predict2! + 5;

    if (predict3! <= predict2!) {
      for (int i = 0; i < 100; i++) {
        print(i);
        if ((predict3! + i) % 100.0 == 0.0) {
          predict3 = predict3! + i;
          break;
        }
      }
    }
    if (predict3 == predict4) predict4 = predict4! + 100;

    notifyListeners();
  }

  // double totalFromAmount() {
  //
  //   remaining =
  //       currentOrder!.getTotalAmount() -  currentOrder!.getTotal();
  //
  //   return remaining;
  // }

  void switchLoading(bool load) {
    loading = load;
    notifyListeners();
  }

  // void closeOrder() {
  //   coupon.text = '';
  //   currentOrder = OrderDetails();
  //   paymentMethods.forEach((element) {
  //     element.chosen = false;
  //   });
  //   switchLoading(false);
  //   chosenOwner = null;
  //   notifyListeners();
  // }

  countingIntegration(OrderDetails orderDetails, dynamic orderResponse) {
    IntegrationModel integrationModel = IntegrationModel(orderDetail: []);
    orderDetails.cart.asMap().forEach((i, element) {
      OrderDetail countingIntegrationBody = OrderDetail(
          postingDate: DateTime.now().toString(),
          quantity: element.count.toString(),
          description: element.itemName.toString(),
          tax: (element.total * getTax() / 100).toString(),
          discount: orderDetails.discount.toString(),
          amount: element.total.toString(),
          paymentType: '',
          itemNo: element.itemCode,
          locationCode: getBranchCode(),
          type: 'Sale',
          unitOfMeasure: 'PCS',
          lineNo: orderResponse['id'].toString() + i.toString(),
          documentNo: '${orderResponse['id']}_${orderResponse['id']}$i',
          customerNo: orderResponse['client_id'].toString());
      integrationModel.orderDetail!.add(countingIntegrationBody);
    });

    orderDetails.payMethods.asMap().forEach((i, element) {
      integrationModel.orderDetail!.add(OrderDetail(
          postingDate: DateTime.now().toString(),
          quantity: '1',
          description: '',
          tax: orderDetails.tax.toString(),
          discount: orderDetails.discount.toString(),
          amount: element.value,
          paymentType: element.title,
          itemNo: '',
          locationCode: getBranchCode(),
          type: 'Payment',
          unitOfMeasure: '',
          lineNo: '${orderResponse['id']}${i * 10}',
          documentNo: '${orderResponse['id']}_${orderResponse['id']}${i * 10}',
          customerNo: orderResponse['client_id'].toString()));
    });

    repo.payIntegration(integrationModel.toJson());
  }

  Future confirmOrder({required OrderDetails orderDetails}) async {
    if(orderDetails.orderUpdatedId != null){
      updateOrder(orderDetails);
    }
    else {
      switchLoading(true);
      List<Order> details = [];
      if (orderDetails.customer != null) {
        orderDetails.payMethods.add(OrderPaymentMethods(id: 2, value: '0'));
      }
      orderDetails.cart.forEach((element) {
        details.add(Order(
            productId: element.id,
            quantity: element.count,
            note: element.extraNotes,
            notes: element.extra!.map((e) => e.id!).toList(),
            attributes: element.allAttributesID));
      });
      orderDetails.finalOrder = details;
      var responseValue = await repo.confirmOrder(orderDetails.toJson());
      if (responseValue['status']) {
        PrintingService.printInvoice(
            order: orderDetails, orderNo: responseValue['data']['uuid']);
        if (getBranchCode().isNotEmpty) {
          countingIntegration(
            orderDetails,
            responseValue['data'],
          );
        }
        ConstantStyles.displayToastMessage(responseValue['msg'], false);
      } else {
        ConstantStyles.displayToastMessage('${responseValue['msg']}', true);
      }
      switchLoading(false);
      return responseValue['status'];
    }
  }

  Future updateOrder(OrderDetails orderDetails) async {
    switchLoading(true);
    List<Order> details = [];
    if (orderDetails.customer != null) {
      orderDetails.payMethods.add(OrderPaymentMethods(id: 2, value: '0'));
    }
    orderDetails.cart.forEach((element) {
      if(element.updated) {
        details.add(Order(
            productId: element.id,
            quantity: element.count,
            note: element.extraNotes,
            notes: element.extra!.map((e) => e.id!).toList(),
            attributes: element.allAttributesID));
      }
    });
    var responseValue = await repo.updateFromOrder(
        orderDetails.orderUpdatedId!, orderDetails.toJson());
    if (responseValue['status']) {
      PrintingService.printInvoice(order: orderDetails,orderNo: responseValue['data']['uuid']);
        if (getBranchCode().isNotEmpty) {
          countingIntegration(
            orderDetails,
            responseValue['data'],
          );
        }
        ConstantStyles.displayToastMessage(responseValue['msg'], false);

    } else {
      ConstantStyles.displayToastMessage('${responseValue['msg']}', true);
    }

    switchLoading(false);
  }


}
