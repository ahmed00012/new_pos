import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/prefs_utils.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/styles.dart';
import 'package:shormeh_pos_new_28_11_2022/models/coupon_model.dart';
import '../constants/printing_services/printing_service.dart';
import '../local_storage.dart';
import '../models/cart_model.dart';
import '../models/client_model.dart';
import '../models/order_method_model.dart';
import '../models/tables_model.dart';
import '../repositories/new_order_repository.dart';
import '../ui/screens/reciept/widgets/products_table.dart';

final orderMethodFuture = ChangeNotifierProvider.autoDispose<OrderMethodController>(
        (ref) => OrderMethodController());

class OrderMethodController extends ChangeNotifier {
  NewOrderRepository repo = NewOrderRepository();
  List<OrderMethodModel> orderMethods = [];
  Tables? chosenTable ;
  bool tablesWidget = false;
  List<Department> departments = [];
  bool loading = false;
  List<CouponModel> coupons = [];
  // TextEditingController customerName = TextEditingController();
  // TextEditingController customerPhone = TextEditingController();
  // TextEditingController notes = TextEditingController();
  // TextEditingController deliveryFee = TextEditingController();
  List<ClientModel> clients = [];



  OrderMethodController(){
    getOrderMethods();
  }




  void switchLoading(bool load) {
    loading = load;
    notifyListeners();
  }

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
          .decode(getOrderMethodsPrefs())
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
            attributes: element.allAttributesValuesID);

        details.add(myOrder);
      });

      order.finalOrder = details;
      var responseValue = await repo.confirmOrder(order.toJson());
      if (responseValue['status']) {
        ConstantStyles.displayToastMessage(responseValue['msg'], false);
        return  responseValue['data']['uuid'];
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