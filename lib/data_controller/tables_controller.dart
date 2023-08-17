
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/styles.dart';

import '../models/cart_model.dart';
import '../models/order_method_model.dart';

import '../models/tables_model.dart';
import '../repositories/new_order_repository.dart';



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
  List<CartModel> cardItemsCopy = [];
  int? chosenOrder;
  int? chosenDepartment;
  String? chosenDepartmentTitle;
  String? chosenOrderNum;
  Tables? currentOrder;



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



 reserveTable({required int i,required Tables table,required int count,required OrderDetails order}) {

    departments[i].tables!.forEach((element) {element.chosen=false;});
    table.chosen = true;
    order.tableId = table.id;
    order.tableTitle = table.title;
    order.department = departments[i].title;
    order.orderMethod = 'restaurant';
    order.orderMethodId = 2;
    order.tableCount = count;
     confirmOrder(order);
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


  // testToken()async{
  //   LocalStorage.removeData(key: 'token');
  //   LocalStorage.removeData(key: 'branch');
  //   LocalStorage.removeData(key: 'coupons');
  //   navigatorKey.currentState!.pushAndRemoveUntil(MaterialPageRoute(builder: (_)=>Login()), (route) => false);
  // }

  void getTables() async {
    switchLoading(true);
    try{
      var data = await repo.getTables();
      if (data['status']) {
        departments = List<Department>.from(
            data['data'].map((e) => Department.fromJson(e)));
        departments.forEach((element) {
          element.tables!.forEach((element) {
            element.chosen = false;
          });
        });
      }
    }
    catch(e){
      ConstantStyles.displayToastMessage(e.toString(), true);
    }
    switchLoading(false);
    // print(departments[0].tables![0].title);
    // tables.forEach((element) {
    //   element.chosen = false;
    // });
    notifyListeners();
  }

  Future confirmOrder(OrderDetails order) async {
    loading = true;
    try{
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
            notes: notesId);

        details.add(myOrder);
      });
      order.finalOrder = details;
      var responseValue = await repo.confirmOrder(order.toJson());
      ConstantStyles.displayToastMessage(
          responseValue['msg'], !responseValue['status']);
      if (responseValue['status']) {
        // PrintingService.printInvoice(order: order,  table: ProductsTable(cart: order.cart));
      }
    }catch(e){
      ConstantStyles.displayToastMessage(e.toString(), true);
    }

    loading = false;
    notifyListeners();
  }


}