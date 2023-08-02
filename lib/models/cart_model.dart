
import 'package:shormeh_pos_new_28_11_2022/models/notes_model.dart';
import 'package:shormeh_pos_new_28_11_2022/models/order_method_model.dart';
import 'package:shormeh_pos_new_28_11_2022/models/owner_model.dart';
import 'package:shormeh_pos_new_28_11_2022/models/product_details_model.dart';
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
  List<int>? allAttributesValuesID;
  List<Attributes>? attributes;
  // List<AttributeValue>? values;
  List<OrderAttribute>? orderAttributes;


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
      this.allAttributesValuesID,
      this.updated = false,
      this.updatedQuantity,
      this.itemCode,
      this.itemName,
      this.attributes,
      this.orderAttributes,

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
  int? tableId;
  int? tableCount;
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
  int? departmentId;
  List<OrderPaymentMethods> payMethods = [];
  int? paymentId;
  double remaining = 0;
  double paid = 0.0;
  int? orderStatusID;
  int? paymentStatus;
  int hold = 0;
  bool payLater = false;
  String? orderQr;
  String? orderNumber;



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
    this.tableId,
    this.discountValue,
    required this.cart,
    this.tax = 0.0,
    this.total = 0.0,
    this.departmentId,
    this.paid = 0.0,
    this.paymentId,
    this.paymentStatus,
    this.orderStatusID,
    this.deliveryFee = 0.0,
    required this.payMethods,
    this.coupon,
    this.hold = 0,
    this.tableCount,
    this.finalOrder,
    this.remaining = 0,
    this.payLater = false,
    this.orderQr,
    this.orderNumber
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['phone'] = this.clientPhone;
    data['name'] = this.clientName;
    data['payment_method_id'] = this.customer != null? 2: payMethods.isNotEmpty ? payMethods[0].id : null;
    data['order_method_id'] = this.orderMethodId;
    data['paid_amount'] = this.paid;
    data['payment_status'] =  this.payMethods.isEmpty ? 0 : 1;
    data['finish'] = payMethods.isNotEmpty;
    data['table_id'] = this.tableId;
    data['coupon'] = this.coupon;
    data['hold'] = this.hold;
    data['payment_customer_id'] = this.customer != null? this.customer!.id : null;
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