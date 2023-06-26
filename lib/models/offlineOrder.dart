//
//
// import 'orders_model.dart';
//
// class OfflineOrder {
//   List<OfflineOrderDetails>? order;
//
//   OfflineOrder({this.order});
//
//   OfflineOrder.fromJson(Map<String, dynamic> json) {
//     if (json['order'] != null) {
//       order = <OfflineOrderDetails>[];
//       json['order'].forEach((v) {
//         order!.add(new OfflineOrderDetails.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.order != null) {
//       data['order'] = this.order!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class OfflineOrderDetails {
//   String? phone;
//   int? paymentMethodId;
//   int? orderMethodId;
//   String? orderMethod;
//   List<OfflineProduct>? details;
//   String? paidAmount;
//   String? coupon;
//   String? clientsCount;
//   String? notes;
//   List<OfflinePayMethods>? payMethods;
//   String? discount;
//   double? total;
//   String? time;
//   String? name;
//   String? tax;
//   String? paymentMethod;
//   int? ownerId;
//   String? owner;
//   String? paymentCustomer;
//   int? paymentCustomerId;
//   int?paymentStatus;
//   String? uuid;
//   String? createdAt;
//   String? orderStatus;
//   int? orderStatusId;
//   int? tableId;
//   int? hold;
//
//
//
//
//   OfflineOrderDetails(
//       {this.phone,
//         this.paymentMethodId,
//         this.orderMethodId,
//         this.orderMethod,
//         this.details,
//         this.paidAmount,
//         this.coupon,
//         this.clientsCount,
//         this.notes,
//         this.payMethods,this.paymentStatus,
//       this.uuid,this.total,this.discount,
//       this.tax,this.orderStatus,this.createdAt,
//       this.paymentCustomer,this.owner,this.time,
//       this.name,this.ownerId,this.paymentCustomerId,
//       this.orderStatusId,this.paymentMethod,this.hold,
//       this.tableId});
//
//   OfflineOrderDetails.fromJson(Map<String, dynamic> json) {
//     phone = json['phone'];
//     paymentMethodId = json['payment_method_id'];
//     orderMethodId = json['order_method_id'];
//     uuid = json['uuid'];
//     name = json['name'];
//     if (json['details'] != null) {
//       details = <OfflineProduct>[];
//       json['details'].forEach((v) {
//         details!.add(new OfflineProduct.fromJson(v));
//       });
//     }
//     if (json['pay_methods'] != null) {
//       payMethods = [];
//       json['pay_methods'].forEach((v) {
//         payMethods!.add(new OfflinePayMethods.fromJson(v));
//       });
//     }
//     paidAmount = json['paid_amount'];
//     coupon = json['coupon'];
//     clientsCount = json['clients_count'];
//     notes = json['notes'];
//
//
//     paymentStatus = json['payment_status'] ;
//     uuid =json['uuid'] ;
//     total= json['total'] ;
//     discount= json['discount'] ;
//     tax= json['tax'] ;
//     orderStatus= json['order_status'] ;
//     createdAt = json['created_at'] ;
//     paymentCustomer= json['payment_customer'] ;
//     paymentCustomerId =json['payment_customer_id'] ;
//     ownerId =json['owner_id'] ;
//     owner =json['owner'] ;
//     time =json['time'] ;
//     orderStatusId= json['order_status_id'];
//     paymentMethod =json['payment_method'] ;
//     hold =json['hold'] = this.hold;
//     tableId =json['table_id'] ;
//     orderMethod =json['order_method'] ;
//
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['phone'] = this.phone;
//     data['name'] = this.name;
//     data['payment_method_id'] = this.paymentMethodId;
//     data['order_method_id'] = this.orderMethodId;
//     if (this.details != null) {
//       data['details'] = this.details!.map((v) => v.toJson()).toList();
//     }
//     data['paid_amount'] = this.paidAmount;
//     data['coupon'] = this.coupon;
//     data['clients_count'] = this.clientsCount;
//     data['notes'] = this.notes;
//     if (this.payMethods != null) {
//       data['pay_methods'] = this.payMethods!.map((v) => v.toJson()).toList();
//     }
//     data['payment_status'] = this.paymentStatus;
//     data['uuid'] =this.uuid;
//     data['total'] =this.total;
//     data['discount'] =this.discount;
//     data['tax'] =this.tax;
//     data['order_status'] =this.orderStatus;
//     data['created_at'] = this.createdAt;
//     data['payment_customer'] = this.paymentCustomer;
//     data['payment_customer_id'] = this.paymentCustomerId;
//     data['owner_id'] = this.ownerId;
//     data['owner'] = this.owner;
//     data['time'] = this.time;
//     data['order_status_id'] = this.orderStatusId;
//     data['payment_method'] = this.paymentMethod;
//     data['hold'] = this.hold;
//     data['table_id'] = this.tableId;
//     data['order_method'] = this.orderMethod;
//
//
//     return data;
//   }
// }
//
// class OfflineProduct {
//
//   int? productId;
//   String? title;
//   String? titleMix;
//   int? quantity;
//   List<String>? notes;
//   List<String>? notesMix;
//   String? note;
//   List<NotesIds>? notesID;
//   String? total;
//   List<double>? notePrice;
//   double? price;
//
//   OfflineProduct({
//     this.title,
//     this.quantity,
//     this.notes,
//     this.total,
//     this.notesID,
//     this.notePrice,
//     this.productId,
//     this.price,
//     this.note,
//     this.titleMix,
//     this.notesMix});
//
//   OfflineProduct.fromJson(Map<String, dynamic> json) {
//     productId = json['product_id'];
//     title = json['title'] ;
//     titleMix = json['title_mix'] ;
//     productId =json['product_id'] ;
//     quantity  =json['quantity'] ;
//     if(json['notes']!=null){
//       notes=[];
//         json['notes'].forEach((e){
//           notes!.add(e.toString());
//         }) ;
//     }
//     if (json['notes_ids'] != null) {
//       notesID =[];
//       json['notes_ids'].forEach((v) {
//         notesID!.add(new NotesIds.fromJson(v));
//       });
//     }
//     if (json['notes_mix'] != null) {
//       notesMix =[];
//       json['notes_mix'].forEach((v) {
//         notesMix!.add(v.toString());
//       });
//     }
//
//     note =json['note'] ;
//     total= json['total'] ;
//     price =json['price'] ;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['title'] = this.title;
//     data['title_mix'] = this.titleMix;
//     data['product_id'] = this.productId;
//     data['quantity'] = this.quantity;
//     data['notes'] = this.notes;
//     if (this.notesID != null) {
//       data['notes_ids'] = this.notesID!.map((v) => v.toJson()).toList();
//     }
//     data['notes_mix'] = this.notesMix;
//     data['note'] = this.note;
//     data['total'] = this.total;
//     data['price'] = this.price;
//     return data;
//   }
// }
//
// class OfflinePayMethods {
//   int? paymentMethodId;
//   String? title;
//   String? value;
//
//   OfflinePayMethods({this.paymentMethodId, this.value,this.title});
//
//   OfflinePayMethods.fromJson(Map<String, dynamic> json) {
//     paymentMethodId = json['payment_method_id'];
//     value = json['value'];
//     title = json['title'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['payment_method_id'] = this.paymentMethodId;
//     data['value'] = this.value;
//     data['title'] = this.title;
//     return data;
//   }
// }
