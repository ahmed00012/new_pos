

class ConfirmOrderModel2{
  String? phone;
  String? name;
  int? paymentMethodId;
  int? orderMethodId;
  double? paidAmount;
  int? paymentStatus;
  int? finish;
  String? tableId;
  String? coupon;
  int? hold;
  int? paymentCustomerId;
  int? clientsCount;
  int? ownerId;
  String? notes;
  List<PayMethods>? paymethods;
  List<Order>? order ;
  double? deliveryFee;

  ConfirmOrderModel2({this.notes,this.order,this.phone,this.clientsCount,this.tableId,
  this.paidAmount,this.name,this.coupon,this.paymentMethodId,this.paymentCustomerId,this.ownerId,
  this.hold,this.paymentStatus,this.orderMethodId,this.paymethods,this.finish,
  this.deliveryFee});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['phone'] = this.phone;
    data['name'] = this.name;
    data['payment_method_id'] = this.paymentMethodId;
    data['order_method_id'] = this.orderMethodId;
    data['paid_amount'] = this.paidAmount;
    data['payment_status'] = this.paymentStatus;
    data['finish'] = this.finish;
    data['table_id'] = this.tableId;
    data['coupon'] = this.coupon;
    data['hold'] = this.hold;
    data['payment_customer_id'] = this.paymentCustomerId;
    data['clients_count'] = this.clientsCount;
    data['notes'] = this.notes;
    data['owner_id'] = this.ownerId;
    data['delivery_fee'] = this.deliveryFee == null ? 0 :this.deliveryFee;
    if (this.paymethods != null) {
      data['pay_methods'] = this.paymethods!.map((v) => v.toJson()).toList();
    }
    if (this.order != null) {
      data['details'] = this.order!.map((v) => v.toJson()).toList();
    }


    return data;
  }




}

class PayMethods{
  int? payMethodId;
  double? value;

  PayMethods({this.payMethodId,this.value});


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

      data['payment_method_id'] = this.payMethodId;
      data['value'] = this.value;

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