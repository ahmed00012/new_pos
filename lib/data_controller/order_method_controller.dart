import 'dart:convert';
import 'dart:developer';
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
import 'package:shormeh_pos_new_28_11_2022/constants/prefs_utils.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/styles.dart';
import 'package:shormeh_pos_new_28_11_2022/models/coupon_model.dart';
import 'package:image/image.dart' as img;
import '../constants/colors.dart';
import '../constants/constant_keys.dart';
import '../constants/printing_services/printing_service.dart';
import '../local_storage.dart';
import '../models/cart_model.dart';
import '../models/client_model.dart';
import '../models/confirm_order_model.dart';
import '../models/order_method_model.dart';
import '../models/printers_model.dart';
import '../models/tables_model.dart';
import '../repositories/new_order_repository.dart';

import 'home_controller.dart';

final orderMethodFuture = ChangeNotifierProvider.autoDispose<OrderMethodController>(
        (ref) => OrderMethodController());

class OrderMethodController extends ChangeNotifier {
  NewOrderRepository repo = NewOrderRepository();
  List<OrderMethodModel> orderMethods = [];
  // OrderMethodModel? chosenOrderMethod;
  Tables? chosenTable ;
  bool tablesWidget = false;
  List<Department> departments = [];
  bool loading = false;
  List<CouponModel> coupons = [];
  // List<CardModel> cardItemsCopy = [];
  TextEditingController coupon = TextEditingController();
  // List<PrinterModel> printers = [];
  // String twitter ='';
  // String instagram ='';
  // String phone ='';

  TextEditingController customerName = TextEditingController();
  TextEditingController customerPhone = TextEditingController();
  TextEditingController notes = TextEditingController();
  TextEditingController deliveryFee = TextEditingController();
  List<ClientModel> clients = [];



  OrderMethodController(){

    // customerName = TextEditingController(text:  order.clientName);
    // customerPhone = TextEditingController(text: order.clientPhone);
    // notes = TextEditingController(text:  order.notes);
    // orderDetails = order;
    getOrderMethods();
     getTables();
     // getPrinters();
     // notifyListeners();
  }


  // Future getPrinters() async {
  //   List<PrinterModel> printers1 = [];
  //   printers1 = List<PrinterModel>.from(json
  //       .decode(LocalStorage.getData(key: 'printers'))
  //       .map((e) => PrinterModel.fromJson(e)));
  //
  //   printers1.forEach((element) {
  //     if (element.typeName != 'CASHIER') {
  //       printers.add(element);
  //     }
  //   });
  //   printers1.forEach((element) {
  //     if (element.typeName == 'CASHIER') {
  //       printers.add(element);
  //     }
  //   });
  //
  //   notifyListeners();
  // }

  void switchLoading(bool load) {
    loading = load;
    notifyListeners();
  }
  // refreshData(){
  //   customerName = TextEditingController(text:  orderDetails.clientName);
  //   customerPhone = TextEditingController(text:  orderDetails.clientPhone);
  //   notes = TextEditingController(text:  orderDetails.notes);
  //   notifyListeners();
  // }


 // void setOrderMethod(OrderMethodModel orderMethod) {
 //    orderDetails.orderMethod  = orderMethod.title!.en;
 //    orderDetails.orderMethodId  = orderMethod.id;
 //    if (orderMethod.id == 2)
 //      tablesWidget = true;
 //    else
 //      tablesWidget = false;
 //    notifyListeners();
 //  }

  void reserveTable(int i, Tables table) {
    chosenTable = table;
    departments[i].tables!.forEach((element) {element.chosen=false;});
    table.chosen = true;
    // orderDetails.table = table.title;
    notifyListeners();
  }

  void getTables() async {
    var data = await repo.getTables();
    departments = List<Department>.from(data['data'].map((e) => Department.fromJson(e)));
    departments.forEach((element) {element.tables!.forEach((element) {element.chosen=false;});});

    // tables.forEach((element) {
    //   element.chosen = false;
    // });
    notifyListeners();
  }


  void getCoupons() async {
    log(getCouponsPrefs().toString());
      coupons = List<CouponModel>.from(json
          .decode(getCouponsPrefs())
          .map((e) => CouponModel.fromJson(e)));
    notifyListeners();
  }





  getClients(String query) async {
      final data =
          await repo.searchClient(query);
      clients = List<ClientModel>.from(
          data['data'].map((client) => ClientModel.fromJson(client)));
      return clients;

  }



  void getOrderMethods() async {
      orderMethods = List<OrderMethodModel>.from(json
          .decode(LocalStorage.getData(key: 'orderMethods'))
          .map((e) => OrderMethodModel.fromJson(e)));
    orderMethods[0].chosen = true;
      orderMethods.removeWhere((element) => element.id==5);
    notifyListeners();
  }


  Future confirmOrder(OrderDetails order,{int ?guestsCount}) async {

    switchLoading(true);
  try  {
      List<Order> details = [];
      order.cart.forEach((element) {
        List<int> notesId = [];
        element.extra!.forEach((element) {
          notesId.add(element.id!);
        });

        Order myOrder = Order(
            productId: element.id,
            quantity: element.count,
            note: element.extraNotes,
            notes: notesId,
            attributes: element.allAttributesID);

        details.add(myOrder);
      });

      order.finalOrder = details;
      var responseValue = await repo.confirmOrder(order.toJson());
      if (responseValue['status']) {
        PrintingService.printInvoice(
            order: order,
            payLater: false,
            orderNo: responseValue['data']['uuid']);
        ConstantStyles.displayToastMessage(responseValue['msg'], false);
      } else {
        ConstantStyles.displayToastMessage(responseValue['msg'], true);
        switchLoading(false);
      }
    }
    catch(e){
      ConstantStyles.displayToastMessage(e.toString(), true);
    }
  }

}