// class ConfirmOrderModel{
//   int? id;
//   String? uuid;
//   double? total;
//   String? phone;
//   int? paymentMethod;
//   int? orderMethod;
//   String? paidAmount;
//   int? paymentStatus;
//   int? table;
//   String? coupon;
//   List<Details>? details;
//   String? createdAt;
//   String? orderStatus;
//   ConfirmOrderModel({this.paymentStatus,this.paidAmount,this.details,this.table,this.coupon,this.phone,this.orderMethod,this.paymentMethod});
//
//   ConfirmOrderModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     uuid = json['uuid'];
//     total = json['total'];
//     createdAt = json['created_at'];
//     paymentMethod = json['payment_method'];
//     orderMethod = json['order_method'];
//     orderStatus = json['order_status'];
//     if (json['details'] != null) {
//       details = <Details>[];
//       json['details'].forEach((v) {
//         details!.add(Details.fromJson(v));
//       });
//     }
//   }
//
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['phone'] = this.phone;
//     data['payment_method_id'] = this.paymentMethod;
//     data['order_method_id'] = this.orderMethod;
//     if (this.details != null) {
//       data['details'] = this.details!.map((v) => v.toJson()).toList();
//     }
//     data['paid_amount'] = this.paidAmount;
//     data['payment_status'] = this.paymentStatus;
//     data['table_id'] = this.table;
//     data['coupon'] = this.coupon;
//     return data;
//   }
//
// }
//
//
// class Details{
//
//   int? id;
//   int? productId;
//   int? quantity;
//   List<String>? notes;
//   List<int>? notesId;
//   String? title;
//   String? extraNote;
//
//   Details({this.quantity,this.notes,this.id,this.notesId,this.productId,this.extraNote});
//
//   Details.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     productId = json['product_id'];
//     title = json['title'];
//     quantity = json['quantity'];
//     extraNote =json['note'];
//     if (json['notes'] != null) {
//       notes = <String>[];
//       json['notes'].forEach((v) {
//         notes!.add(v.toString());
//       });
//     }
//   }
//
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['product_id'] = this.id;
//     data['quantity'] = this.quantity;
//     data['notes'] = this.notes;
//     data['note'] = this.extraNote;
//     return data;
//   }
// }