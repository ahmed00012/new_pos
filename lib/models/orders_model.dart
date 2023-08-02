




import 'package:easy_localization/easy_localization.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/prefs_utils.dart';
import 'package:shormeh_pos_new_28_11_2022/local_storage.dart';

class OrdersModel {
  int? id;
  String? uuid;
  double? total;
  int? quantity;
  String? createdAt;
  String? time;
  String? paymentMethod;
  int? paymentMethodId;
  List<OrderPaymentMethods>? paymentMethods;
  String? orderMethod;
  int? orderMethodId;
  String? orderStatus;
  int? paymentStatus;
  List<OrdersDetails>? details;
  int? orderStatusId;
  String? clientPhone;
  String? clientName;
  String? paymentCustomer;
  int? paymentCustomerId;
  String? paymentCustomerImage;
  String? table;
  String? subTotal;
  String? tax;
  double discount = 0.0;
  String? notes;
  String? department;
  int? ownerId;
  String? ownerName;
  String? coupon;
  String? amount;
  int? finished;
  double? paidAmount;
  int? tableId;
  String? updatedAt;
  String? couponId;
  String? discountId;
  int? clientsCount;
  double deliveryFee = 0.0;
  Car? car;


  OrdersModel(
      {this.id,
        this.uuid,
        this.total,
        this.quantity,
        this.createdAt,
        this.time,
        this.paymentStatus,
        this.paymentMethod,
        this.paymentMethods,
        this.orderMethod,
        this.orderStatus,
        this.orderMethodId,
        this.details,this.orderStatusId,this.table,
      this.clientPhone,
      this.clientName,this.paymentCustomer,
        this.paymentCustomerId,
      this.subTotal,this.tax,
        this.discount = 0.0,
      this.notes,this.paymentCustomerImage,this.ownerId,this.department,this.coupon,
      this.amount,this.paymentMethodId,this.paidAmount,
      this.tableId,this.clientsCount,this.couponId,
      this.discountId,this.finished,this.updatedAt,this.ownerName,
        this.deliveryFee = 0.0,
        this.car
     });

 String checkCurrentTimeZone(String time){
   print(time);
   String year = time.substring(0,2);
   String month = time.substring(3,5);
   String day = time.substring(6,8);
   String minute = time.substring(12,14);
   String second = time.substring(15,17);

   // String year = time.substring(1,2);
   // String year = time.substring(1,2);
    int utc = DateTime.now().toUtc().hour;
    int current = DateTime.now().hour;
   int actualTime = current - utc ;

    return '${day}-${month}-${year}  ${utc + actualTime }:${minute}:${second}' ;
  }

  OrdersModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    total = double.parse(json['total'].toString());
    quantity = json['quantity'];
    createdAt = json['created_at']!=null ? checkCurrentTimeZone(json['created_at']) : null;
    time = json['time'];
    paymentMethod = getLanguage() =='en'?
    json['payment_method_en']:json['payment_method_ar'];
    deliveryFee = json['delivery_fee']!=null? double.parse(json['delivery_fee'].toString()) : 0.0;
    orderMethod = getLanguage()  =='en'?
    json['order_method_en']:json['order_method_ar'];
    orderStatus = getLanguage()  =='en'?
    json['order_status_en']:json['order_status_ar'];
    paymentStatus = json['payment_status'];
    orderStatusId = json['order_status_id'];
    clientPhone=  json['client_phone'];
    clientName=  json['client_name'];
    paymentCustomer=  json['payment_customer'];
    paymentCustomerId=  json['payment_customer_id'];
    paymentCustomerImage=  json['payment_customer_image'];
    discount = json['discount']!=null? double.parse(json['discount'].toString()) : 0.0;
    subTotal =json['subtotal'].toString();
    tax =  json['tax'].toString();
    table = json['table'];
    notes = json['notes'];
    ownerId = json['owner_id'];
    department = json['table_department'];
    finished = json['finished'];
    paidAmount = json['paid_amount']!=null?json['paid_amount'].toDouble():null;
    paymentMethodId = json['payment_method_id'];
    orderMethodId = json['order_method_id'];
    tableId = json['table_id'];
    updatedAt = json['updated_at'];
    couponId = json['coupon_id'];
    discountId = json['discount_id'];
    clientsCount = json['clients_count'];
    car =json['car']!=null? Car.fromJson(json['car']):null;

    if (json['payment_methods']!=null) {
      paymentMethods = <OrderPaymentMethods>[];
      json['payment_methods'].forEach((v) {
        paymentMethods!.add(new OrderPaymentMethods.fromJson(v));
      });
    }

    if (json['details'] != null) {
      details = <OrdersDetails>[];
      json['details'].forEach((v) {
        details!.add(new OrdersDetails.fromJson(v));
      });
    }
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uuid'] = this.uuid;
    data['total'] = this.total;
    data['quantity'] = this.quantity;
    data['discount'] = this.discount;
    data['tax'] = this.tax;
    data['notes'] = this.notes;
    data['created_at'] = this.createdAt;
    data['time'] = this.time;
    data['payment_status'] = this.paymentStatus;
    data['payment_method'] = this.paymentMethod;
    if (this.paymentMethods != null) {
      data['payment_methods'] =
          this.paymentMethods!.map((v) => v.toJson()).toList();
    }
    data['order_method'] = this.orderMethod;
    data['order_method_id'] = this.orderMethodId;
    data['order_status'] = this.orderStatus;
    data['order_status_id'] = this.orderStatusId;
    data['table'] = this.table;
    if (this.details != null) {
      data['details'] = this.details!.map((v) => v.toJson()).toList();
    }
    data['phone'] = this.clientPhone;
    data['name'] = this.clientName;
    data['payment_customer_id'] = this.paymentCustomerId;
    data['payment_customer'] = this.paymentCustomer;
    data['owner_id'] = this.ownerId;
    data['coupon'] =this.coupon;
    data['paid_amount'] =this.amount;
    data['payment_method_id'] =this.paymentMethodId;

    return data;
  }
}


class OrdersDetails {
  int? id;
  int? productId;
  String? title;
  String? titleMix;
  int? quantity;
  List<String>? notes;
  List<String>? notesMix;
  String? note;
  List<NotesIds>? notesID;
  int? complete;
  String? total;
  List<double>? notePrice;
  double? price;
  String? itemCode;
  String? itemName;
  List<OrderAttribute>? attributes;
  List<OrderAddon>? addons;


  OrdersDetails(
      {this.id,
        this.title,
        this.quantity,
        this.notes,
        this.complete,
        this.total,
        this.notesID,
        this.notePrice,
        this.productId,
        this.price,
        this.note,
        this.titleMix,
        this.notesMix,
        this.itemName,this.itemCode,
        this.attributes,
        this.addons
        });

  OrdersDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    title = json['title'];
    titleMix = json['title_mix'];
    quantity = json['quantity'];
    notes = json['notes'].cast<String>();
    if(json['notes_mix']!=null)
    notesMix = json['notes_mix'].cast<String>();
    complete = json['complete'];
    total = json['total'].toString();
    note = json['note'];
    notesID = json['notes_ids']!=null ?
    List<NotesIds>.from(json['notes_ids'].map((e)=>NotesIds.fromJson(e))):[];
    price = json['price']!=null? double.parse(json['price'].toString()):null;
    itemCode =json['item_code'];
    itemName =json['item_name'];
    if (json['attribute'] != null) {
      attributes = <OrderAttribute>[];
      json['attribute'].forEach((v) {
        attributes!.add(new OrderAttribute.fromJson(v));
      });
    }
    if (json['addon'] != null) {
      addons = <OrderAddon>[];
      json['addon'].forEach((v) {
        addons!.add( OrderAddon.fromJson(v));
      });
    }
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['title_mix'] = this.titleMix;
    data['product_id'] = this.productId;
    data['quantity'] = this.quantity;
    data['notes'] = this.notes;
    if (this.notesID != null) {
      data['notes_ids'] = this.notesID!.map((v) => v.toJson()).toList();
    }
    data['notes_mix'] = this.notesMix;
    data['note'] = this.note;
    data['complete'] = this.complete;
    data['total'] = this.total;
    data['price'] = this.price;
    return data;
  }
}



class OrderPaymentMethods{
  int? id;
  String? title;
  String? value;
  OrderPaymentMethods({this.id,this.title,this.value});

  OrderPaymentMethods.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    value = json['value'].toString();
    id = json['id'];

  }


  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //  data['title'] = this.title;
  //  data['value'] = this.value;
  //  data['id']=this.id;
  //   return data;
  // }
  //

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['payment_method_id'] = this.id;
    data['value'] = this.value;

    return data;
  }
}

class NotesIds{
  int? id;
  double? price;
  NotesIds({this.id,this.price});
  NotesIds.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = double.parse(json['price'].toString());

  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['price'] = this.price;
    return data;
  }

}


class OrderAttribute{

  String? attribute;
  String? value;
  int? id;

  OrderAttribute({this.attribute,this.value,this.id});

  OrderAttribute.fromJson(Map<String, dynamic> json) {
    attribute = json['attribute'];
    value = json['value'].toString();
    id = json['attribute_value_id'];

  }
}

class OrderAddon{

  String? addon;
  String? value;
  int? id;
  double? price;

  OrderAddon({this.price,this.value,this.id ,this.addon});

  OrderAddon.fromJson(Map<String, dynamic> json) {
    addon = json['addon'];
    value = json['value'].toString();
    id = json['addon_value_id'];
    price = json['price']!= null ?json['price'].toDouble():null;

  }
}

class Car {
  int? id;
  String? model;
  String? number;
  String? color;

  Car({this.id,this.color,this.number,this.model});

  Car.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    model = json['car_model'].toString();
    number = json['plate_number'].toString();
    color = json['car_color'].toString();

  }

}