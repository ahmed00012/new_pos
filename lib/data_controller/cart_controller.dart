import 'dart:convert';


import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/styles.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/prefs_utils.dart';
import '../models/cart_model.dart';
import '../models/client_model.dart';
import '../models/coupon_model.dart';
import '../models/customer_model.dart';
import '../models/notes_model.dart';
import '../models/order_method_model.dart';
import '../models/orders_model.dart';
import '../models/owner_model.dart';
import '../models/payment_model.dart';
import '../models/product_details_model.dart';
import '../models/products_model.dart';
import '../models/tables_model.dart';
import '../repositories/products_repository.dart';

final cartFuture = ChangeNotifierProvider.autoDispose<CartController>(
    (ref) => CartController());

class CartController extends ChangeNotifier {
  ProductsRepo productsRepo = ProductsRepo();
  OrderDetails orderDetails = OrderDetails(cart: [], payMethods: []);
  bool clientsLoading = false;
  List<ClientModel> clients = [];
  List<ClientModel> clientsFiltered = [];
  List<CouponModel> coupons = [];

  double getTotal() {
    orderDetails.total = 0;

    orderDetails.cart.forEach((element) {
      orderDetails.total = orderDetails.total + element.total;
    });
    orderDetails.tax = orderDetails.total * getTax() / 100;
    orderDetails.total = orderDetails.total + orderDetails.deliveryFee;

    if (orderDetails.orderUpdatedId != null) {
      orderDetails.discountValue = orderDetails.discount;
    }

    if (orderDetails.discount < orderDetails.total) {
      orderDetails.total = orderDetails.total - orderDetails.discount;
    } else {
      orderDetails.total = 0;
    }

    orderDetails.remaining = orderDetails.paid - orderDetails.total;

    // total = total + tax!;
    return orderDetails.total;
  }

  // void insertIntoCart(ProductModel product){
  //
  //
  //   orderDetails.departmentId= product.departmentId;
  //
  //   orderDetails.cart.add(CartModel(
  //       id: product.id!,
  //       price: orderDetails.customer==null? product.price!: product.customerPrice!,
  //       title: product.titleMix,
  //       mainName: product.title!.en,
  //       extra: [],
  //       count: 1,
  //       total: orderDetails.customer==null? product.price!: product.customerPrice!,
  //       updated: orderDetails.orderUpdatedId!=null,
  //       itemName: product.itemName,
  //       itemCode: product.itemCode,
  //       allAttributesValuesID: [],
  //       attributes: [],
  //       newInCart: true,
  //   ));
  //
  //   getTotal();
  //
  // }

  void minusController(int i) {
    if (orderDetails.cart[i].count! > 1) {
      double itemPrice =
          orderDetails.cart[i].total / orderDetails.cart[i].count!;

      orderDetails.cart[i].count = orderDetails.cart[i].count! - 1;
      orderDetails.cart[i].total = orderDetails.cart[i].total - itemPrice;

      if (orderDetails.orderUpdatedId != null) {
        orderDetails.cart[i].updated = true;
        orderDetails.cart[i].updatedQuantity =
            orderDetails.cart[i].updatedQuantity! - 1;
      }
      getTotal();
    }
    notifyListeners();
  }

  void plusController(int index, List<Attributes> attributes) {
    //  double totalOptions = 0.0;
    //  double totalAttributes = 0.0;
    //  List<AttributeItem> productAttributes = [];
    //  List<AttributeItem> cartProductAttributes = [];
    // orderDetails.cart[index].extra!.forEach((element) {
    //    totalOptions = totalOptions + element.price!;
    //  });
    //
    // for(int i = 0 ; i< attributes.length ; i++){
    //   productAttributes= attributes[i].values!.map((e) => e).toList();
    // }
    // if(orderDetails.cart[index].attributes!=null) {
    //    for (int i = 0; i < orderDetails.cart[index].attributes!.length; i++) {
    //      cartProductAttributes = orderDetails.cart[index].attributes![i].values!.map((e) => e).toList();
    //    }
    //  }

    // productAttributes.forEach((element) {
    //   cartProductAttributes.forEach((element2) {
    //     if(element.id == element2.id) {
    //       element2.price = element.realPrice;
    //       totalAttributes = totalAttributes + element.realPrice!;
    //     }
    //   });
    //
    // });

    //
    // orderDetails.cart[index].attributes!.forEach((element) {
    //   element.values!.forEach((value2) {
    //     if(orderDetails.cart[index].allAttributesID!.contains(value2.id)) {
    //       totalAttributes = totalAttributes + value2.price!;
    //       if(element.overridePrice==1) {
    //        orderDetails.cart[index].price = 0;
    //       }
    //
    //     }
    //   });
    // });

    orderDetails.cart[index].count = orderDetails.cart[index].count! + 1;
    orderDetails.cart[index].total =
        orderDetails.cart[index].total * orderDetails.cart[index].count!;

    if (orderDetails.orderUpdatedId != null) {
      orderDetails.cart[index].updated = true;
      orderDetails.cart[index].updatedQuantity =
          orderDetails.cart[index].updatedQuantity! + 1;
    }
    getTotal();
    notifyListeners();
  }

  void textCountController(int i, int qty) {
    if (orderDetails.orderUpdatedId != null) {
      orderDetails.cart[i].updated = true;
      orderDetails.cart[i].updatedQuantity = qty - orderDetails.cart[i].count!;
    }

    orderDetails.cart[i].count = qty;
    // (cart[i].price! + totalOptions)
    orderDetails.cart[i].total = orderDetails.cart[i].total * qty;
    getTotal();
  }

  void addOption(NotesModel note, int index) {
    if (orderDetails.orderUpdatedId != null) {
      orderDetails.cart[index].updated = true;
    }

    List notesID = [];

    orderDetails.cart[index].extra!.forEach((element) {
      notesID.add(element.id);
    });

    if (!notesID.contains(note.id!)) {
      orderDetails.cart[index].extra!.add(note);
      orderDetails.cart[index].total = orderDetails.cart[index].total +
          note.price! * orderDetails.cart[index].count!;
    } else {
      orderDetails.cart[index].extra!.remove(note);
      orderDetails.cart[index].total = orderDetails.cart[index].total -
          (note.price! * orderDetails.cart[index].count!);
    }

    getTotal();
  }

  void addAttributes(
    Attributes attribute,
    int productIndex,
    AttributeItem value,
  ) {
    if (orderDetails.orderUpdatedId != null) {
      orderDetails.cart[productIndex].updated = true;
    }

    orderDetails.cart[productIndex].total =
        orderDetails.cart[productIndex].total /
            orderDetails.cart[productIndex].count!;
    orderDetails.cart[productIndex].count = 1;

    if (orderDetails.customer != null) {
      value.price = value.customerPrice;
    }
    bool inList = false;

    orderDetails.cart[productIndex].attributes!.forEach((element) {
      if (element.id == attribute.id) {
        inList = true;
      }
    });

    if (!orderDetails.cart[productIndex].allAttributesValuesID!
        .contains(value.id!)) {
      if (attribute.overridePrice == 1) {
        if (inList) {
          attribute.values!.forEach((element2) {
            orderDetails.cart[productIndex].allAttributesValuesID!
                .forEach((element3) {
              if (element2.id == element3)
                orderDetails.cart[productIndex].total =
                    orderDetails.cart[productIndex].total - element2.price!;
            });
          });
        } else
          orderDetails.cart[productIndex].total =
              orderDetails.cart[productIndex].total -
                  orderDetails.cart[productIndex].price!;
      }
      orderDetails.cart[productIndex].total =
          orderDetails.cart[productIndex].total + value.price!;

      if (attribute.multiSelect == 1) {
        if (!inList) {
          orderDetails.cart[productIndex].attributes!.add(attribute);
          orderDetails.cart[productIndex].allAttributesValuesID!.add(value.id!);
        } else {
          orderDetails.cart[productIndex].allAttributesValuesID!.add(value.id!);
        }
      } else {
        if (!inList) {
          orderDetails.cart[productIndex].attributes!.add(attribute);
          orderDetails.cart[productIndex].allAttributesValuesID!.add(value.id!);
        } else {
          attribute.values!.forEach((element) {
            orderDetails.cart[productIndex].allAttributesValuesID!
                .remove(element.id!);
          });
          orderDetails.cart[productIndex].allAttributesValuesID!.add(value.id!);
        }
      }

      getTotal();
    }
  }

  void removeAttributes(Attributes attribute, int productIndex,
      AttributeItem value, int attributeIndex) {
    if (orderDetails.orderUpdatedId != null)
      orderDetails.cart[productIndex].updated = true;

    orderDetails.cart[productIndex].total =
        orderDetails.cart[productIndex].total /
            orderDetails.cart[productIndex].count!;
    orderDetails.cart[productIndex].count = 1;

    if (orderDetails.customer != null)
      value.realPrice = value.customerPrice;
    else
      value.realPrice = value.price;

    if (attribute.multiSelect == 1) {
      if (orderDetails
              .cart[productIndex].attributes![attributeIndex].values!.length ==
          1) orderDetails.cart[productIndex].attributes!.remove(attribute);
      orderDetails.cart[productIndex].allAttributesValuesID!.remove(value.id!);
      if (attribute.overridePrice == 1) {
        orderDetails.cart[productIndex].total =
            orderDetails.cart[productIndex].total +
                orderDetails.cart[productIndex].price!;
      }
      orderDetails.cart[productIndex].total =
          orderDetails.cart[productIndex].total - value.realPrice!;
    } else {
      if (attribute.required == 0) {
        orderDetails.cart[productIndex].allAttributesValuesID!
            .remove(value.id!);
        if (attribute.overridePrice == 1) {
          orderDetails.cart[productIndex].total =
              orderDetails.cart[productIndex].total +
                  orderDetails.cart[productIndex].price!;
        }
        orderDetails.cart[productIndex].total =
            orderDetails.cart[productIndex].total - value.realPrice!;
      }
    }

    getTotal();
  }

  // void removeOption(int i,int chosenCartItem){
  //
  //  orderDetails.cart[chosenCartItem].total =orderDetails.cart[chosenCartItem].total -
  //       (orderDetails.cart[chosenCartItem].extra![i].price! *orderDetails.cart[chosenCartItem].count!) ;
  //  orderDetails.cart[chosenCartItem].extra!.removeAt(i);
  //   getTotal();
  //   if (orderDetails.orderUpdatedId!=null) {
  //    orderDetails.cart[chosenCartItem].updated = true;
  //   }
  //
  // }

  OrderDetails editOrder(OrdersModel order) {
    print(order.toJson());
    OrderDetails editedOrder = OrderDetails(cart: [], payMethods: []);
    editedOrder.orderUpdatedId = order.id;
    editedOrder.total = order.total!;
    editedOrder.tax = double.parse(order.tax!);
    editedOrder.paid = order.paidAmount ?? 0.0;
    editedOrder.paymentStatus = order.paymentStatus;
    editedOrder.orderStatusID = order.orderStatusId;
    print(order.toJson());
    order.details!.forEach((element) {
      List<NotesModel> notes = [];
      for (int i = 0; i < element.notes!.length; i++) {
        notes.add(NotesModel(
            id: element.notesID![i].id,
            price: element.notesID![i].price,
            title: element.notes![i],
            titleEn: element.notes![i],
            titleMix: element.notesMix![i]));
      }

      editedOrder.cart.add(
        CartModel(
          id: element.productId,
          rowId: element.id,
          mainName: element.title,
          title: element.titleMix,
          extra: notes,
          count: element.quantity,
          total: double.parse(element.total!),
          price: element.price,
          extraNotes: element.note,
          updatedQuantity: 0,
          itemName: element.itemName,
          itemCode: element.itemCode,
          orderAttributes: element.attributes,
          attributes: [],
          allAttributesValuesID: [],
        ),
      );

      element.attributes!.forEach((element2) {
        editedOrder.cart.last.allAttributesValuesID!.add(element2.id!);
        editedOrder.cart.last.attributes!.add(
            Attributes(title: ProductTitle(en: element2.attribute!), values: [
          AttributeItem(
            attributeValue: ProductTitle(en: element2.value),
            id: element2.id,
          )
        ]));
      });
    });

    editedOrder.clientName = order.clientName;
    editedOrder.clientPhone = order.clientPhone;
    editedOrder.deliveryFee = order.deliveryFee;
    editedOrder.orderMethod = order.orderMethod;
    editedOrder.orderMethodId = order.orderMethodId;
    editedOrder.orderStatus = order.orderStatusId;
    editedOrder.discount = order.discount;
    if (order.paymentCustomerId != null) {
      editedOrder.customer = CustomerModel(
          title: order.paymentCustomer,
          id: order.paymentCustomerId,
          image: order.paymentCustomerImage,
          chosen: true);
    }
    editedOrder.department = order.department;
    editedOrder.orderMethodModel = OrderMethodModel(
        id: order.orderMethodId,
        title: OrderMethodTitle(en: editedOrder.orderMethod));
    editedOrder.updateWithCoupon = order.discount != 0;
    editedOrder.owner = order.ownerId!=null?
        OwnerModel(id: order.ownerId, chosen: true,title: order.ownerName ??''):null;
    editedOrder.tableTitle = order.table;
    editedOrder.payMethods = order.paymentMethods!;
    if (editedOrder.payMethods.isNotEmpty)
      editedOrder.paymentId = editedOrder.payMethods[0].id;
    editedOrder.orderNumber = order.uuid;
    editedOrder.orderTime = order.createdAt;


    // if(order.paymentMethods!=null) {
    //   orderDetails.payment1 =
    //       PaymentModel(id: order.paymentMethods![0].id!, title: PaymentTitle(
    //         en: order.paymentMethods![0].title!,
    //       ));
    //   orderDetails.amount1 = double.parse(order.paymentMethods![0].value!);
    // }
    // if(order.paymentMethods!=null&& order.paymentMethods!.length>1){
    //   orderDetails.payment2 =
    //       PaymentModel(id: order.paymentMethods![1].id!, title: PaymentTitle(
    //         en: order.paymentMethods![1].title!,
    //       ));
    //   orderDetails.amount2 = double.parse(order.paymentMethods![1].value!);
    //
    // }

    return editedOrder;
  }

  OrderDetails editOrderTable(
      {required CurrentOrder order,
      required Tables table,
      required Department department}) {
    OrderDetails editedOrder =OrderDetails(cart: [], payMethods: []);
    editedOrder.orderUpdatedId = order.id;
    editedOrder.total = order.total!;
    editedOrder.tax = order.tax ?? 0;
    editedOrder.paid = order.paidAmount ?? 0.0;
    editedOrder.paymentStatus = order.paymentStatus;
    editedOrder.orderStatusID = order.orderStatusId;

    // orderDetails.amount1 = 0.0;
    // orderDetails.amount2 = 0.0;

    order.details!.forEach((element) {
      List<NotesModel> notes = [];
      for (int i = 0; i < element.notes!.length; i++) {
        notes.add(NotesModel(
            id: element.notes![i].id,
            price: element.notes![i].price,
            title: element.notes![i].title,
            titleMix: element.notes![i].title));
      }

      editedOrder.cart.add(
        CartModel(
            id: element.productId,
            rowId: element.id,
            mainName: element.product!.title!.en,
            title: element.product!.title!.en,
            extra: notes,
            count: element.quantity,
            total: element.product!.price ?? 0.0,
            price: element.product!.price,
            extraNotes: element.note,
            updatedQuantity: 0,
            itemName: element.itemName,
            itemCode: element.itemCode,
            attributes: [],
            allAttributesValuesID: [],
            ),
      );

      element.attributes!.forEach((element2) {
        editedOrder.cart.last.allAttributesValuesID!
            .add(element2.attributeValue!.id!);
        editedOrder.cart.last.attributes!.add(Attributes(
            title: ProductTitle(en: element2.attribute!.title!.en!),
            values: [
              AttributeItem(
                  attributeValue: ProductTitle(
                      en: element2.attributeValue!.attributeValueTitle!.en!),
                  id: element2.attributeValue!.id)
            ]));
      });
    });
    editedOrder.orderMethod = 'restaurant';
    editedOrder.orderMethodId = 2;
    editedOrder.tableTitle = table.title;
    editedOrder.tableId = table.id;
    editedOrder.department = department.title;
    editedOrder.departmentId = department.id;
    editedOrder.orderMethodModel =
        OrderMethodModel(id: 2, title: OrderMethodTitle(en: 'restaurant'.tr()));
    editedOrder.updateWithCoupon = false;
    editedOrder.orderNumber = order.uuid;
    editedOrder.orderTime = order.createdAt;

    return editedOrder;
  }

  emptyCardList() {
    orderDetails = OrderDetails(cart: [], payMethods: []);
    notifyListeners();
  }

  void removeCartItem({required int index}) {
    if (orderDetails.cart.length > 1) {
      if (orderDetails.orderUpdatedId != null &&
          orderDetails.cart[index].rowId != null) {
        deleteFromOrder(orderDetails.cart[index].rowId!);
      }
      orderDetails.cart.removeAt(index);
      if (orderDetails.cart.isEmpty) orderDetails.orderUpdatedId = null;

      getTotal();
    }
    notifyListeners();
  }

  Future deleteFromOrder(int itemId) async {
    try {
      var data = await productsRepo.deleteFromOrder(itemId);
    } catch (e) {
      ConstantStyles.displayToastMessage(e.toString(), true);
    }
    notifyListeners();
  }

  void insertCart(ProductModel product) {
    // orderDetails.insertIntoCart(product);
    orderDetails.departmentId = product.departmentId;
    orderDetails.cart.add(CartModel(
        id: product.id!,
        price: orderDetails.customer == null
            ? product.price!
            : product.customerPrice!,
        title: product.titleMix,
        mainName: product.title!.en,
        extra: [],
        count: 1,
        total: orderDetails.customer == null
            ? product.price!
            : product.customerPrice!,
        updated: orderDetails.orderUpdatedId != null,
        itemName: product.itemName,
        itemCode: product.itemCode,
        allAttributesValuesID: [],
        attributes: [],));

    getTotal();
    // getProductDetails(int.parse(products[i].id!));
    notifyListeners();
  }

  void insertOption({required int indexOfProduct, required NotesModel note}) {
    List notesID = [];
    if (orderDetails.orderUpdatedId != null) {
      orderDetails.cart[indexOfProduct].updated = true;
    }
    orderDetails.cart[indexOfProduct].extra!.forEach((element) {
      notesID.add(element.id);
    });

    if (!notesID.contains(note.id!)) {
      orderDetails.cart[indexOfProduct].extra!.add(note);
      orderDetails.cart[indexOfProduct].total =
          orderDetails.cart[indexOfProduct].total +
              note.price! * orderDetails.cart[indexOfProduct].count!;
    }
    getTotal();
    notifyListeners();
  }

  addAnotherOption(
      {int? index, required String anotherOption, required bool itemWidget}) {
    if (itemWidget) {
      orderDetails.cart[index!].extraNotes = anotherOption;
      orderDetails.cart[index].updated = true;
    } else {
      orderDetails.cart.last.extraNotes = anotherOption;
      orderDetails.cart.last.updated = true;
    }
    notifyListeners();
  }

  void itemCount({
    required int index,
    required int value,
  }) {
    if (orderDetails.orderUpdatedId != null) {
      orderDetails.cart[index].updated = true;
      orderDetails.cart[index].updatedQuantity =
          value - orderDetails.cart[index].count!;
    }
    orderDetails.cart[index].count = value;
    orderDetails.cart[index].total = orderDetails.cart[index].total * value;
    getTotal();

    notifyListeners();
  }

  bool inList({required Attributes attribute, required int productIndex}) {
    bool x = false;
    attribute.values!.forEach((element) {
      if (orderDetails.cart[productIndex].allAttributesValuesID!
          .contains(element.id)) x = true;
    });
    return x;
  }

  void editAttributes(
      {required Attributes attribute,
      required AttributeItem attributeValue,
      required int attributeIndex,
      required int productIndex}) {
    if (!attributeValue.chosen!) {
      addAttributes(attribute, productIndex, attributeValue);
    } else if (attributeValue.chosen!) {
      removeAttributes(attribute, productIndex, attributeValue, attributeIndex);
    }
    notifyListeners();
  }

  Future onSearchClientTextChanged(String text) async {
    if(text.isNotEmpty)
    {
      try {
        clientsLoading = true;
        notifyListeners();
        final data = await productsRepo.searchClient(text);
        clients = List<ClientModel>.from(
            data['data'].map((client) => ClientModel.fromJson(client)));

      } catch (e) {
        ConstantStyles.displayToastMessage(e.toString(), true);
      }
      print(clients.length);
      clientsLoading = false;
      notifyListeners();
      return clients;
    }
  }

  Future onSearchClientLocally(String text) async {
    clientsFiltered = [];
    if (text.isNotEmpty) {
      clientsFiltered.addAll(clients
          .where((element) => element.name!.toLowerCase().contains(text))
          .toList());
      clientsFiltered.addAll(clients
          .where((element) => element.phone!.toLowerCase().contains(text))
          .toList());
    } else
      clientsFiltered = clients;

    notifyListeners();
  }

  Future getAllClients() async {
    if (clients.isEmpty) {
      try {
        clientsLoading = true;
        final data = await productsRepo.searchClient('');
        clients = List<ClientModel>.from(
            data['data'].map((client) => ClientModel.fromJson(client)));

        clientsLoading = false;
      } catch (e) {
        ConstantStyles.displayToastMessage(e.toString(), true);
      }
    }
    clientsFiltered = clients;
    notifyListeners();
  }

  chooseClient({required String name, required String phone}) {
    orderDetails.clientPhone = phone;
    orderDetails.clientName = name;
    notifyListeners();
  }

  // void getCoupons() async {
  //   coupons = List<CouponModel>.from(json
  //       .decode(LocalStorage.getData(key: 'coupons'))
  //       .map((e) => CouponModel.fromJson(e)));
  //   notifyListeners();
  // }

  void checkCoupon(String code) {
    coupons = List<CouponModel>.from(
        json.decode(getCouponsPrefs()).map((e) => CouponModel.fromJson(e)));
    print(getCouponsPrefs());

    CouponModel? couponUse;
    bool inBranch = false;
    bool valid = true;
    coupons.forEach((element) {
      if (element.code == code) {
        couponUse = element;
      }
    });

    print(couponUse!.branches!.map((e) => e.title).toList().toString());
    print(couponUse!.code.toString());
    print(couponUse!.counter.toString());
    print(couponUse!.numOfUses.toString());
    print(couponUse!.isActive.toString());
    print(couponUse!.timeTo.toString());
    print(couponUse!.dateTo.toString());

    if (couponUse == null) {
      ConstantStyles.displayToastMessage('couponNotFound'.tr(), true);
      valid = false;
    }
     if (couponUse!.branches != null) {
      couponUse!.branches!.forEach((element) {
        if (element.id == getBranch()) inBranch = true;
      });
    }
     if (couponUse!.isActive == 0) {
      ConstantStyles.displayToastMessage('couponNotValid'.tr(), true);
      valid = false;
    }  if (couponUse!.counter! >= couponUse!.numOfUses!) {
      ConstantStyles.displayToastMessage('couponHasEnded'.tr(), true);
      valid = false;
    }  if (!inBranch) {
      ConstantStyles.displayToastMessage(
          'couponNotAvailableForThisBranch'.tr(), true);
      valid = false;
    }
    if (couponUse != null && couponUse!.dateFrom != null) {
      if (DateTime.parse(
              '${couponUse!.dateFrom} ${couponUse!.timeFrom ?? '00:00'}')
          .isAfter(DateTime.now())) {
        ConstantStyles.displayToastMessage(
            'couponStillNotAvailable'.tr(), true);
        valid = false;
      }
    }  if (couponUse != null && couponUse!.dateTo != null) {
      if (DateTime.parse('${couponUse!.dateTo} ${couponUse!.timeTo ?? '23:59'}')
          .isBefore(DateTime.now())) {
        ConstantStyles.displayToastMessage('couponHasEnded'.tr(), true);
        valid = false;
      }
    }
    if (valid) {
      ConstantStyles.displayToastMessage('couponAdded'.tr(), false);
      orderDetails.coupon = code;
      orderDetails.couponType = couponUse!.type;
      if (couponUse!.type == 1) {
        orderDetails.discountValue = couponUse!.value!;

         orderDetails.discount = couponUse!.value!;

        // orderDetails.setDiscount(false, couponUse.value!);
      } else {
        orderDetails.discountValue = couponUse!.value!;
        String discount =
            (couponUse!.value! * 0.01 * (getTotal() - orderDetails.deliveryFee))
                .toStringAsFixed(2);
        orderDetails.discount = double.parse(discount);
      }
      getTotal();
    }
    notifyListeners();
  }

  void setPayment(PaymentModel paymentMethod, String total) {
    print(total);
    orderDetails.payMethods.add(OrderPaymentMethods(
        id: paymentMethod.id, value: total, title: paymentMethod.title!.en));
    orderDetails.paid = orderDetails.paid + double.parse(total);
    orderDetails.remaining = orderDetails.paid - orderDetails.total;
    print(orderDetails.paid);
    // notifyListeners();
    // orderDetails.payMethods.last.value = paymentAmount.toString();
    // orderDetails.paid = double.parse(paymentAmount);
  }

  void removePayment({PaymentModel? paymentModel, required bool clear}) {
    if (!clear) {
      int? index;
      orderDetails.payMethods.asMap().forEach((i, element) {
        if (element.id == paymentModel!.id) index = i;
      });
      orderDetails.paid = orderDetails.paid -
          double.parse(orderDetails.payMethods[index!].value!);
      orderDetails.remaining = orderDetails.paid - orderDetails.total;
      orderDetails.payMethods.removeAt(index!);
    } else {
      orderDetails.payMethods.clear();
      orderDetails.paid = 0;
      orderDetails.remaining = -orderDetails.total;
    }
  }

  closeOrder() {
    orderDetails = OrderDetails(cart: [], payMethods: []);
  }

  setOrderMethod(OrderMethodModel orderMethod) {
    orderDetails.orderMethod = orderMethod.title!.en;
    orderDetails.orderMethodId = orderMethod.id;
    notifyListeners();
  }
}
