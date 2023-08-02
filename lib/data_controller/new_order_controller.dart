import 'dart:convert';

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/printing_services/printing_service.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/styles.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/prefs_utils.dart';
import 'package:shormeh_pos_new_28_11_2022/models/cart_model.dart';
import 'package:shormeh_pos_new_28_11_2022/models/orders_model.dart';
import 'package:shormeh_pos_new_28_11_2022/models/owner_model.dart';
import 'package:shormeh_pos_new_28_11_2022/models/payment_model.dart';
import 'package:shormeh_pos_new_28_11_2022/repositories/new_order_repository.dart';
import '../models/integration_model.dart';
import '../ui/screens/reciept/widgets/products_table.dart';


final newOrderFuture = ChangeNotifierProvider.autoDispose<NewOrderController>(
        (ref) => NewOrderController());

class NewOrderController extends ChangeNotifier {
  NewOrderRepository repo = NewOrderRepository();
  List<PaymentModel> paymentMethods = [];
  List<OwnerModel> owners = [];
  bool loading = false;


  int? collapseKey;
  double? predict1;
  double? predict2;
  double? predict3;
  double? predict4;




  NewOrderController() {
    getPaymentMethods();
    getOwners();
    collapse();

    // getPrinters();
  }

  void switchLoading(bool load) {
    loading = load;
    notifyListeners();
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

  // Future getPrinters() async {
  //   List<PrinterModel> sortPrinters = [];
  //   sortPrinters = List<PrinterModel>.from(
  //       json.decode(getPrintersPrefs()).map((e) => PrinterModel.fromJson(e)));
  //
  //   sortPrinters.forEach((element) {
  //     if (element.typeName != 'CASHIER') {
  //       printers.add(element);
  //     }
  //   });
  //   sortPrinters.forEach((element) {
  //     if (element.typeName == 'CASHIER') {
  //       printers.add(element);
  //     }
  //   });
  //
  //   notifyListeners();
  // }

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





  countingIntegration(OrderDetails orderDetails, dynamic orderResponse) {

    IntegrationModel integrationModel = IntegrationModel(orderDetail: []);
    orderDetails.cart.asMap().forEach((i, element) {
      OrderDetail countingIntegrationBody = OrderDetail(
          quantity: element.count.toString(),
          description: element.itemName.toString(),
          tax: (element.total * getTax() / 100).toString(),
          discount: orderDetails.discount.toString(),
          amount: element.total.toString(),
          paymentType: '',
          itemNo: element.itemCode,
          type: 'Sale',
          unitOfMeasure: 'PCS',
          lineNo: orderResponse['id'].toString() + i.toString(),
          documentNo: '${orderResponse['id']}_${orderResponse['id']}$i',
          customerNo: orderResponse['client_id'].toString());
      integrationModel.orderDetail!.add(countingIntegrationBody);
    });

    orderDetails.payMethods.asMap().forEach((i, element) {
      integrationModel.orderDetail!.add(OrderDetail(
          quantity: '1',
          description: '',
          tax: orderDetails.tax.toString(),
          discount: orderDetails.discount.toString(),
          amount: element.value,
          paymentType: element.title,
          itemNo: '',
          type: 'Payment',
          unitOfMeasure: '',
          lineNo: '${orderResponse['id']}${i * 10}',
          documentNo: '${orderResponse['id']}_${orderResponse['id']}${i * 10}',
          customerNo: orderResponse['client_id'].toString()));
    });

    repo.payIntegration(integrationModel.toJson());
  }

  Future confirmOrder({required OrderDetails orderDetails}) async {
    String? orderNo;
    if(orderDetails.orderUpdatedId != null){
    orderNo =   await updateOrder(orderDetails);
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
            attributes: element.allAttributesValuesID));
      });
      orderDetails.finalOrder = details;
      var responseValue = await repo.confirmOrder(orderDetails.toJson());

      if (responseValue['status']) {
        if (getBranchCode().isNotEmpty) {
          countingIntegration(
            orderDetails,
            responseValue['data'],
          );
        }
        ConstantStyles.displayToastMessage(responseValue['msg'], false);

        orderNo = responseValue['data']['uuid'];
      } else {
        ConstantStyles.displayToastMessage('${responseValue['msg']}', true);
      }
      switchLoading(false);
      return orderNo;
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
            rowId: element.rowId,
            quantity: element.count,
            note: element.extraNotes,
            notes: element.extra!.map((e) => e.id!).toList(),
            attributes: element.allAttributesValuesID));
      }
    });

    orderDetails.finalOrder = details;

    var responseValue = await repo.updateFromOrder(
        orderDetails.orderUpdatedId!, orderDetails.toJson());
    if (responseValue['status']) {
      if (getBranchCode().isNotEmpty) {
          countingIntegration(
            orderDetails,
            responseValue['data'],
          );
        }
        ConstantStyles.displayToastMessage(responseValue['msg'], false);
        return responseValue['data']['uuid'];

    } else {
      ConstantStyles.displayToastMessage('${responseValue['msg']}', true);
    }

    switchLoading(false);
  }


}
