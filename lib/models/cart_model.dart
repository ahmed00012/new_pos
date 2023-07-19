
import 'package:shormeh_pos_new_28_11_2022/local_storage.dart';
import 'package:shormeh_pos_new_28_11_2022/models/confirm_order_model.dart';
import 'package:shormeh_pos_new_28_11_2022/models/notes_model.dart';
import 'package:shormeh_pos_new_28_11_2022/models/order_method_model.dart';
import 'package:shormeh_pos_new_28_11_2022/models/owner_model.dart';
import 'package:shormeh_pos_new_28_11_2022/models/payment_model.dart';
import 'package:shormeh_pos_new_28_11_2022/models/product_details_model.dart';
import 'package:shormeh_pos_new_28_11_2022/models/products_model.dart';
import 'package:shormeh_pos_new_28_11_2022/models/tables_model.dart';

import 'customer_model.dart';
import 'orders_model.dart';

class CartModel {
  int? id;
  int? rowId;

  String? title;
 String? mainName;
  double? price;
  int? count;
  List<NotesModel>? extra;
  String? extraNotes;
  double total  = 0.0;
  bool updated;
  int? updatedQuantity;
  String? itemCode;
  String? itemName;
  List<int>? allAttributesID;
  List<Attributes>? attributes;
  List<AttributeValue>? values;
  List<OrderAttribute>? orderAttributes;
  bool? newInCart;

  CartModel(
      {this.id,
      this.rowId,
      // this.departmentId,
      this.mainName,
      this.title,
      this.price,
      this.count,
      this.extra,
      this.extraNotes,
      this.total = 0.0,
      this.allAttributesID,
      this.updated = false,
      this.updatedQuantity,
      this.itemCode,
      this.itemName,
      this.attributes,
      this.orderAttributes,
      this.newInCart
      });
}

class OrderDetails {
  int? orderUpdatedId;
  String? clientName;
  String? clientPhone;
  OrderMethodModel? orderMethodModel;
  String? notes;
  double discount = 0;
  String? coupon;
  // bool? discountPercentage;
  double? discountValue;
  bool? updateWithCoupon;
  OwnerModel? owner;
  String? orderMethod;
  int? orderMethodId;
  String? table;
  int? tableCount;
  String? time;
  int? orderStatus;
  String? payment;
  // String? selectCustomer ;
  // int? customer ;
  CustomerModel? customer;
  String? tableTitle;
  String? department;
  double total = 0.0;
  double tax = 0.0;
  // double delivery = 0.0;
  double deliveryFee = 0.0;
  List<CartModel> cart = [];
  List<Order> ?finalOrder;
  String? departmentId;
  List<OrderPaymentMethods> payMethods = [];
  int? paymentId;

  PaymentModel? payment1;
  PaymentModel? payment2;
  double amount1 = 0.0;
  double amount2 = 0.0;
  double paid = 0.0;
  int? orderStatusID;
  int? paymentStatus;
  int hold = 0;

  OrderDetails({
    this.clientName,
    this.clientPhone,
    this.discount = 0,
    this.owner,
    this.orderUpdatedId,
    this.notes,
    this.orderMethodModel,
    this.updateWithCoupon,
    this.orderMethodId,
    this.orderStatus,
    this.payment,
    this.customer,
    this.tableTitle,
    this.department,
    this.orderMethod,
    this.time,
    this.table,
    this.discountValue,
    this.cart = const [],
    this.tax = 0.0,
    this.total = 0.0,
    this.departmentId,
    this.payment1,
    this.payment2,
    this.amount1 = 0.0,
    this.amount2 = 0.0,
    this.paid = 0.0,
    this.paymentId,
    this.paymentStatus,
    this.orderStatusID,
    this.deliveryFee = 0.0,
    this.payMethods = const [],
    this.coupon,
    this.hold = 0,
    this.tableCount,
    this.finalOrder
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['phone'] = this.clientPhone;
    data['name'] = this.clientName;
    data['payment_method_id'] = this.paymentId;
    data['order_method_id'] = this.orderMethodId;
    data['paid_amount'] = this.paid;
    data['payment_status'] = this.paymentStatus;
    data['finish'] = payMethods.isNotEmpty;
    data['table_id'] = this.table;
    data['coupon'] = this.coupon;
    data['hold'] = this.hold;
    data['payment_customer_id'] =this.customer != null? this.customer!.id : null;
    data['clients_count'] = this.tableCount;
    data['notes'] = this.notes;
    data['owner_id'] = this.owner != null? this.owner!.id : null;
    data['delivery_fee'] = this.deliveryFee;
      data['pay_methods'] = this.payMethods.map((v) => {
        'payment_method_id': v.id,
        'value':v.value
      }).toList();
    if (this.finalOrder != null) {
      data['details'] = this.finalOrder!.map((v) => v.toJson()).toList();
    }


    return data;
  }

  // OrderDetails copyWith() {
  //   return OrderDetails(
  //       clientName: this.clientName,
  //       clientPhone: this.clientPhone,
  //       discount: this.discount,
  //       owner: this.owner,
  //       orderUpdatedId: this.orderUpdatedId,
  //       notes: this.notes,
  //       orderMethodModel: this.orderMethodModel,
  //       updateWithCoupon: this.updateWithCoupon,
  //       orderMethodId: this.orderMethodId,
  //       orderStatus: this.orderStatus,
  //       payment: this.payment,
  //       customer: this.customer,
  //       tableTitle: this.tableTitle,
  //       department: this.department,
  //       orderMethod: this.orderMethod,
  //       time: this.time,
  //       table: this.table,
  //       cart: List.from(this.cart!),
  //       tax: this.tax,
  //       total: this.total,
  //       departmentId: this.departmentId,
  //       payment1: this.payment1,
  //       payment2: this.payment2,
  //       amount1: this.amount1,
  //       amount2: this.amount2,
  //       paid: this.paid,
  //       paymentId: this.paymentId,
  //       paymentStatus: this.paymentStatus,
  //       orderStatusID: this.orderStatusID,
  //       deliveryFee: this.deliveryFee);
  // }
  //
  // double getTotal() {
  //   total = 0;
  //
  //   cart!.forEach((element) {
  //     total = total! + element.total!;
  //   });
  //   tax = total! *
  //       double.parse(LocalStorage.getData(key: 'tax').toString()) /
  //       100;
  //
  //   if (deliveryFee != null) total = total! + deliveryFee!;
  //
  //   if (delivery != null) total = total! + delivery!;
  //
  //   if (discount != null && discount != '0') {
  //     if (orderUpdatedId != null) {
  //       discountPercentage = false;
  //       discountValue = double.parse(discount!);
  //     }
  //
  //     // if( discountPercentage! ){
  //     //    discount = (discountValue! *0.01 * total!).toStringAsFixed(2);
  //     // }
  //     // else{
  //     //   discount = discountValue!.toStringAsFixed(2);
  //     // }
  //
  //     if (double.parse(discount!) < total!) {
  //       total = total! - double.parse(discount!);
  //     } else {
  //       total = 0;
  //     }
  //   }
  //   // total = total! + tax!;
  //   return total!;
  // }

  // void setDiscount(bool percentage, double currentDiscountValue) {
  //   discountValue = currentDiscountValue;
  //   discountPercentage = percentage;
  //   if (percentage) {
  //     // print(currentDiscountValue *0.01 * HomeController.orderDetails.getTotal());
  //     if (deliveryFee != null)
  //       discount = (currentDiscountValue * 0.01 * (getTotal() - deliveryFee!))
  //           .toStringAsFixed(2);
  //     else if (delivery != null)
  //       discount = (currentDiscountValue * 0.01 * (getTotal() - delivery!))
  //           .toStringAsFixed(2);
  //     else
  //       discount =
  //           (currentDiscountValue * 0.01 * getTotal()).toStringAsFixed(2);
  //     // discount = currentDiscountValue.toString();
  //   } else {
  //     discount = currentDiscountValue.toString();
  //   }
  //   getTotal();
  // }

  // void insertIntoCart(ProductModel product) {
  //   departmentId = product.departmentId;
  //   if (cart == null) {
  //     cart = [];
  //
  //     amount1 = 0.0;
  //     amount2 = 0.0;
  //     paid = 0;
  //   }
  //   cart!.add(CartModel(
  //       id: product.id!,
  //       price: customer == null
  //           ? double.parse(product.price!)
  //           : double.parse(product.customerPrice!),
  //       title: product.titleMix,
  //       mainName: product.title!.en,
  //       extra: [],
  //       count: 1,
  //       total: customer == null
  //           ? double.parse(product.price!)
  //           : double.parse(product.customerPrice!),
  //       updated: orderUpdatedId != null,
  //       itemName: product.itemName,
  //       itemCode: product.itemCode,
  //       allAttributesID: [],
  //       attributes: [],
  //       newInCart: true));
  //
  //   getTotal();
  //
  //   if (discount != null && discount != '0') {
  //     total = total! - double.parse(discount!);
  //   }
  // }

  // void addOption( NotesModel note , int index){
  //
  //
  //   if(orderUpdatedId!=null){
  //   cart![index].updated = true;
  //   }
  //
  //   List notesID= [];
  //
  //   cart![index].extra!.forEach((element) {
  //   notesID.add(element.id);
  //   });
  //
  //   if (!notesID.contains(note.id!)) {
  //   cart![index].extra!.add(note);
  //   cart![index].total =
  //   cart![index].total! + note.price! * cart![index].count!;
  //
  //   }
  //   else
  //   {
  //     cart![index].extra!.remove(note);
  //     cart![index].total =
  //         cart![index].total! -(note.price! * cart![index].count!);
  //
  //   }
  //
  //
  //   getTotal();
  //
  // }

  // void addAttributes(Attributes attribute , int productIndex , AttributeValue value ) {
  //
  //  cart![productIndex].total = cart![productIndex].total! / cart![productIndex].count!;
  //  cart![productIndex].count = 1;
  //
  //  if(customer!= null)
  //    value.realPrice = value.customerPrice;
  //  else
  //    value.realPrice = value.price;
  //  bool inList = false;
  //  cart![productIndex].attributes!.forEach((element) {
  //    if(element.id == attribute.id) {
  //       inList = true;
  //
  //     }
  //   });
  //
  //
  //   if (!cart![productIndex].allAttributesID!.contains(value.id!)) {
  //     if (attribute.overridePrice == 1) {
  //       if(inList) {
  //      attribute.values!.forEach((element2) {
  //        cart![productIndex].allAttributesID!.forEach((element3) {
  //          if(element2.id == element3)
  //            cart![productIndex].total =
  //                cart![productIndex].total! - element2.realPrice!;
  //        });
  //
  //      });
  //    }
  //       else
  //       cart![productIndex].total =
  //           cart![productIndex].total! - cart![productIndex].price!;
  //
  //     }
  //     cart![productIndex].total = cart![productIndex].total! + value.realPrice!;
  //
  //     if (attribute.multiSelect == 1) {
  //       if (!inList) {
  //         cart![productIndex].attributes!.add(attribute);
  //         cart![productIndex].allAttributesID!.add(value.id!);
  //       } else {
  //         cart![productIndex].allAttributesID!.add(value.id!);
  //       }
  //     }
  //
  //     else {
  //
  //       if (!inList) {
  //
  //         cart![productIndex].attributes!.add(attribute);
  //         cart![productIndex].allAttributesID!.add(value.id!);
  //       } else {
  //
  //         attribute.values!.forEach((element) {
  //           cart![productIndex].allAttributesID!.remove(element.id!);
  //         });
  //         cart![productIndex].allAttributesID!.add(value.id!);
  //
  //       }
  //     }
  //
  //     getTotal();
  //   }
  // }
  //
  //   void removeAttributes(Attributes attribute, int productIndex, AttributeValue value,
  //       int attributeIndex) {
  //     cart![productIndex].total = cart![productIndex].total! / cart![productIndex].count!;
  //     cart![productIndex].count = 1;
  //
  //     if(customer!= null)
  //       value.realPrice = value.customerPrice;
  //     else
  //       value.realPrice = value.price;
  //
  //     if (attribute.multiSelect == 1) {
  //       if (cart![productIndex].attributes![attributeIndex].values!.length == 1)
  //         cart![productIndex].attributes!.remove(attribute);
  //       cart![productIndex].allAttributesID!.remove(value.id!);
  //       if (attribute.overridePrice == 1) {
  //         cart![productIndex].total =
  //             cart![productIndex].total! + cart![productIndex].price!;
  //       }
  //       cart![productIndex].total = cart![productIndex].total! - value.realPrice!;
  //     } else {
  //       if (attribute.required == 0) {
  //         cart![productIndex].allAttributesID!.remove(value.id!);
  //         if (attribute.overridePrice == 1) {
  //           cart![productIndex].total =
  //               cart![productIndex].total! + cart![productIndex].price!;
  //         }
  //         cart![productIndex].total = cart![productIndex].total! - value.realPrice!;
  //       }
  //     }
  //     // cart![productIndex]
  //     //     .allAttributesID!.remove(attribute.values![valueIndex].id!);
  //     //
  //     // if(attribute.required== 1 && attribute.multiSelect == 1){
  //     //   if(cart![productIndex].multiChooseRequiredAttribute!.length>1)
  //     //     cart![productIndex].multiChooseRequiredAttribute!.remove(attribute.values![valueIndex]);
  //     // }
  //     //
  //     // else if(attribute.required==0 && attribute.multiSelect == 1){
  //     //   cart![productIndex].multiChooseNotRequiredAttribute!.remove(attribute.values![valueIndex]);
  //     // }
  //     //
  //     // else if(attribute.required==0 && attribute.multiSelect == 0){
  //     //   cart![productIndex].oneChooseNotRequiredAttribute = null;
  //     // }
  //     // cart![productIndex].total = cart![productIndex].total! - attribute.values![valueIndex].price!;
  //
  //     getTotal();
  //   }

  // void minusController(int i) {
  //   // double totalOptions = 0.0;
  //   // cart![i].extra!.forEach((element) {
  //   //   totalOptions = totalOptions + element.price!;
  //   // });
  //   if (cart![i].count! > 1) {
  //     // (cart![i].price!+totalOptions)
  //
  //     double itemPrice = cart![i].total! / cart![i].count!;
  //
  //     cart![i].count = cart![i].count! - 1;
  //     cart![i].total = cart![i].total! - itemPrice;
  //
  //     if (orderUpdatedId != null) {
  //       cart![i].updated = true;
  //       cart![i].updatedQuantity = cart![i].updatedQuantity! - 1;
  //     }
  //     getTotal();
  //   }
  // }

  // void plusController(int i) {
  //   double totalOptions = 0.0;
  //   double totalAttributes = 0.0;
  //   cart![i].extra!.forEach((element) {
  //     totalOptions = totalOptions + element.price!;
  //   });
  //   cart![i].attributes!.forEach((element) {
  //     element.values!.forEach((value2) {
  //       if (cart![i].allAttributesID!.contains(value2.id)) {
  //         totalAttributes = totalAttributes + value2.realPrice!;
  //         if (element.overridePrice == 1) {
  //           cart![i].price = 0;
  //         }
  //
  //         // print(value2.realPrice.toString() + 'dvmkd');
  //         // print(cart![i].price!.toString() + 'dvmkd');
  //       }
  //     });
  //   });
  //
  //   cart![i].count = cart![i].count! + 1;
  //   cart![i].total =
  //       (cart![i].price! + totalOptions + totalAttributes) * cart![i].count!;
  //   // ( cart![i].price!+totalOptions)
  //   // cart![i].total = cart![i].total! *  cart![i].count! ;
  //
  //   if (orderUpdatedId != null) {
  //     cart![i].updated = true;
  //     cart![i].updatedQuantity = cart![i].updatedQuantity! + 1;
  //   }
  //   getTotal();
  // }
  //
  // void textCountController(int i, int qty) {
  //   //
  //   //  double totalOptions = 0.0;
  //   // cart![i].extra!.forEach((element) {
  //   //    totalOptions = totalOptions + element.price!;
  //   //  });
  //
  //   if (orderUpdatedId != null) {
  //     cart![i].updated = true;
  //     cart![i].updatedQuantity = qty - cart![i].count!;
  //   }
  //
  //   cart![i].count = qty;
  //   // (cart![i].price! + totalOptions)
  //   cart![i].total = cart![i].total! * qty;
  //   getTotal();
  // }
  //
  // void removeOption(int i, int chosenCartItem) {
  //   cart![chosenCartItem].total = cart![chosenCartItem].total! -
  //       (cart![chosenCartItem].extra![i].price! * cart![chosenCartItem].count!);
  //   cart![chosenCartItem].extra!.removeAt(i);
  //   getTotal();
  //   if (orderUpdatedId != null) {
  //     cart![chosenCartItem].updated = true;
  //   }
  // }
  // void editOrder(OrdersModel order) {
  //   orderUpdatedId = order.id;
  //   total = order.total!;
  //   tax = total! * double.parse(LocalStorage.getData(key: 'tax').toString()) / 100;
  //   amount1 = 0.0;
  //   amount2 = 0.0;
  //
  //   cart = [];
  //   paid = order.paidAmount??0.0;
  //   paymentStatus = order.paymentStatus;
  //   orderStatusID = order.orderStatusId;
  //
  //     order.details!.forEach((element) {
  //       List<NotesModel> notes = [];
  //       for (int i = 0; i < element.notes!.length; i++) {
  //         notes.add(NotesModel(
  //             id: element.notesID![i].id,
  //             price: element.notesID![i].price,
  //             title: element.notes![i],
  //             titleEn: element.notes![i],
  //             titleMix: element.notesMix![i]));
  //       }
  //
  //
  //       cart!.add(
  //         CardModel(
  //           id: element.productId,
  //           rowId: element.id,
  //           mainName: element.title,
  //           title: element.titleMix,
  //           extra: notes,
  //           count: element.quantity,
  //           total: double.parse(element.total!),
  //           price: element.price,
  //           extraNotes: element.note,
  //           updatedQuantity: 0,
  //           itemName: element.itemName,
  //           itemCode: element.itemCode,
  //           orderAttributes: element.attributes,
  //           attributes: [],
  //           allAttributesID: [],
  //           newInCart: false,
  //
  //         ),
  //       );
  //
  //       element.attributes!.forEach((element2) {
  //         cart!.last.allAttributesID!.add(element2.id!);
  //         cart!.last.attributes!.add(
  //           Attributes(
  //             title: ProductTitle(
  //               en: element2.attribute!
  //             ),
  //             values: [AttributeValue(attributeValue: ProductTitle(en: element2.value),id: element2.id)]
  //           )
  //         );
  //       });
  //     });
  //
  //
  //     clientName = order.clientName;
  //     clientPhone = order.clientPhone;
  //     delivery = order.deliveryFee;
  //     orderMethod = order.orderMethod;
  //     orderMethodId = order.orderMethodId;
  //     orderStatus = order.orderStatusId;
  //     discount = order.discount;
  //     if(order.paymentCustomerId!=null)
  //     customer = CustomerModel(
  //       title: order.paymentCustomer,
  //       id: order.paymentCustomerId,
  //       image: order.paymentCustomerImage,
  //       chosen: true
  //   );
  //     department = order.department;
  //     orderMethodModel = OrderMethodModel(id: order.orderMethodId,
  //         title: OrderMethodTitle(
  //           en: orderMethod
  //         ));
  //     updateWithCoupon = order.discount != '0';
  //     owner = OwnerModel(
  //       id: order.ownerId,
  //       chosen: true
  //     );
  //     tableTitle = order.table;
  //     branchName = LocalStorage.getData(key: 'branchName');
  //   // if(order.paymentCustomerId!=null ) {
  //   //   order.paymentMethods!.removeAt(0);
  //   // }
  //     if(order.paymentMethods!=null) {
  //       print(order.paymentMethods);
  //       payment1 =
  //           PaymentModel(id: order.paymentMethods![0].id!, title: PaymentTitle(
  //             en: order.paymentMethods![0].title!,
  //           ));
  //       amount1 = double.parse(order.paymentMethods![0].value!);
  //   }
  //     if(order.paymentMethods!=null&& order.paymentMethods!.length>1){
  //       payment2 =
  //           PaymentModel(id: order.paymentMethods![1].id!, title: PaymentTitle(
  //             en: order.paymentMethods![1].title!,
  //           ));
  //       amount2 = double.parse(order.paymentMethods![1].value!);
  //
  //     }
  // }

  // void editOrderTable(Department department , int tableIndex) {
  //   orderUpdatedId = department.tables![tableIndex].currentOrder!.id;
  //   total = department.tables![tableIndex].currentOrder!.total!;
  //   tax = total! * double.parse(LocalStorage.getData(key: 'tax').toString()) / 100;
  //   amount1 = 0.0;
  //   amount2 = 0.0;
  //   cart = [];
  //   paid = 0.0;
  //   department.tables![tableIndex].currentOrder!.details!.forEach((element) {
  //     List<NotesModel> notes = [];
  //     for (int i = 0; i < element.notes!.length; i++) {
  //       notes.add(NotesModel(
  //           id: element.notes![i].id,
  //           price: element.notes![i].price,
  //           title: element.notes![i].title,
  //           titleMix: element.notes![i].title));
  //     }
  //
  //
  //     cart!.add(
  //       CardModel(
  //           id: element.productId,
  //           rowId: element.id,
  //           mainName: element.product!.title!.en,
  //           title: element.product!.title!.en,
  //           extra: notes,
  //           count: element.quantity,
  //           total: element.product!.price,
  //           price: element.product!.price,
  //           extraNotes: element.note,
  //           updatedQuantity: 0,
  //         itemName: element.itemName,
  //         itemCode: element.itemCode,
  //           attributes: [],
  //           allAttributesID: [],
  //           newInCart: false
  //       ),
  //     );
  //
  //     element.attributes!.forEach((element2) {
  //       cart!.last.allAttributesID!.add(element2.attributeValue!.id!);
  //       cart!.last.attributes!.add(
  //           Attributes(
  //               title: ProductTitle(
  //                   en: element2.attribute!.title!.en!
  //               ),
  //               values: [AttributeValue(attributeValue: ProductTitle(en: element2.attributeValue!
  //                   .attributeValueTitle!.en!),
  //                   id: element2.attributeValue!.id)]
  //           )
  //       );
  //     });
  //   });
  //
  //   orderMethod = 'restaurant';
  //   orderMethodId = 2;
  //   orderStatus = department.tables![tableIndex].currentOrder!.orderStatusId;
  //
  //   tableTitle = department.tables![tableIndex].title!.toString();
  //   department = department;
  //   orderMethodModel = OrderMethodModel(id: 2,
  //       title: OrderMethodTitle(
  //         en: 'restaurant'.tr()
  //       ));
  //   updateWithCoupon = false;
  //   department = department;
  //   branchName = LocalStorage.getData(key: 'branchName');
  // }

  // void cancelPayment() {
  //   payment1 = null;
  //   payment2 = null;
  //   amount1 = 0.0;
  //   amount2 = 0.0;
  //   paid = 0.0;
  // }
  //
  // double getTotalAmount() {
  //   amount1 ??= 0;
  //   amount2 ??= 0;
  //   return amount1! + amount2!;
  // }
  //
  // List<Map<String, dynamic>> getPaymentMethods() {
  //   final Map<String, dynamic> payment1Data = new Map<String, dynamic>();
  //   final Map<String, dynamic> payment2Data = new Map<String, dynamic>();
  //   List<Map<String, dynamic>> payments = [];
  //   if (payment1 != null) {
  //     payment1Data['payment_method_id'] = this.payment1!.id;
  //     payment1Data['value'] = this.payment1!.title;
  //     payments.add(payment1Data);
  //   }
  //
  //   if (payment2 != null) {
  //     payment2Data['payment_method_id'] = this.payment2!.id;
  //     payment2Data['value'] = this.payment2!.title;
  //     payments.add(payment2Data);
  //   }
  //
  //   return payments;
  // }
}


class Order{
  int? productId;
  int? rowId;
  int? quantity;
  List<int> ?notes;
  String? note;
  List<int> ?attributes;

  Order({this.notes,this.note,this.quantity,this.productId,this.rowId,this.attributes});
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['id'] = this.rowId;
    data['product_id'] = this.productId;
    data['quantity'] = this.quantity;
    data['notes'] = this.notes;
    data['note'] = this.note;
    data['attribute_value_id'] = this.attributes;



    return data;
  }

}