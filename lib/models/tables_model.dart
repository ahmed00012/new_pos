



import 'package:shormeh_pos_new_28_11_2022/models/products_model.dart';

import '../local_storage.dart';

class Department {
  int? id;
  String? title;
  List<Tables>? tables;

  Department({this.id,  this.title, this.tables});

  Department.fromJson(Map<String, dynamic> json) {
    id = json['id'];

    title = json['title'];
    if (json['tables'] != null) {
      tables = <Tables>[];
      json['tables'].forEach((v) {
        tables!.add(new Tables.fromJson(v));
      });
    }
  }

}

class Tables {
  int? id;
  int? branchId;
  int? isActive;
  String? createdAt;
  String? updatedAt;
  String? title;
  int? tableSectionId;
  int? seatsNumber;
  CurrentOrder? currentOrder;
  bool? chosen;

  Tables(
      {this.id,
        this.branchId,
        this.isActive,
        this.createdAt,
        this.updatedAt,
        this.title,
        this.tableSectionId,
        this.seatsNumber,
        this.currentOrder,
      this.chosen=false});

  Tables.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    branchId = json['branch_id'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    title = json['title'] ;
    tableSectionId = json['table_section_id'];
    seatsNumber = json['seats_number'];
    currentOrder = json['current_order'] != null
        ? new CurrentOrder.fromJson(json['current_order'])
        : null;
  }

}

class CurrentOrder {
  int? id;
  String? uuid;
  double? subtotal;
  double? discount;
  double? tax;
  double? total;
  int? quantity;
  int? paymentStatus;
  int? finished;
  double? paidAmount;

  int? orderStatusId;
  int? branchId;
  int? employeeId;
  String? paymentMethodId;
  int? orderMethodId;
  int? tableId;
  String? createdAt;
  String? updatedAt;
  String? couponId;
  String? discountId;
  int? clientsCount;
  OrderStatusTables? orderStatus;
  List<DetailsTables>? details;
  String? itemCode;
  String? itemName;

  CurrentOrder(
      {this.id,
        this.uuid,
        this.subtotal,
        this.discount,
        this.tax,
        this.total,
        this.quantity,
        this.paymentStatus,
        this.finished,
        this.paidAmount,
        this.orderStatusId,
        this.branchId,
        this.employeeId,
        this.paymentMethodId,
        this.orderMethodId,
        this.tableId,
        this.createdAt,
        this.updatedAt,
        this.couponId,
        this.discountId,
        this.clientsCount,
        this.orderStatus,
        this.details,
     });

  CurrentOrder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    subtotal =json['subtotal']!=null? double.parse(json['subtotal'].toString()):null;
    discount = json['discount']!=null? double.parse(json['discount'].toString()):null;
    tax = double.parse(json['tax'].toString());
    total =double.parse(json['total'].toString());
    quantity = json['quantity'];
    paymentStatus = json['payment_status'];
    finished = json['finished'];
    paidAmount = json['paid_amount'].toDouble();
    orderStatusId = json['order_status_id'];
    branchId = json['branch_id'];
    employeeId = json['employee_id'];
    paymentMethodId = json['payment_method_id'].toString();
    orderMethodId = json['order_method_id'];
    tableId = json['table_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    couponId = json['coupon_id'];
    discountId = json['discount_id'];
    clientsCount = json['clients_count'];

    orderStatus = json['order_status'] != null
        ? new OrderStatusTables.fromJson(json['order_status'])
        : null;
    if (json['details'] != null) {
      details = <DetailsTables>[];
      json['details'].forEach((v) {
        details!.add(new DetailsTables.fromJson(v));
      });
    }
  }

}

class OrderStatusTables {
  int? id;
  String? createdAt;
  TableOrderTitle? title;

  OrderStatusTables({this.id, this.createdAt, this.title});

  OrderStatusTables.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    title = json['title'] != null ? new TableOrderTitle.fromJson(json['title']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['title'] = this.title;
    return data;
  }
}

class DetailsTables {
  int? id;
  double? total;
  int? quantity;
  int? completed;
  List<NotesTables>? notes;
  String? note;
  int? orderId;
  int? productId;
  String? createdAt;
  String? updatedAt;
  Product? product;
  String? itemCode;
  String? itemName;
  List<TableAttributes>? attributes;


  DetailsTables(
      {this.id,
        this.total,
        this.quantity,
        this.completed,
        this.notes,
        this.orderId,
        this.productId,
        this.createdAt,
        this.updatedAt,
        this.product,
this.note,this.itemName,this.itemCode,
        this.attributes
       });

  DetailsTables.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    total = json['total'].toDouble();
    quantity = json['quantity'];
    completed = json['completed'];
    itemCode =json['item_code'];
    itemName =json['item_name'];
    note =  json['note'];
    if (json['notes'] != null) {
      notes = <NotesTables>[];
      for(int i = 0;i<json['notes'].length;i++) {
        notes!.add(new NotesTables.fromJson(json['notes'][i]));
        notes![i].price=json['notes'][i]['pivot']['price'].toDouble();
      }
    }
    if (json['attributes'] != null) {
      attributes = <TableAttributes>[];
      json['attributes'].forEach((v) {
        attributes!.add(new TableAttributes.fromJson(v));
      });
    }
    orderId = json['order_id'];
    productId = json['product_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    product =
    json['product'] != null ? new Product.fromJson(json['product']) : null;

  }


}

class NotesTables {
  int? id;
  String? title;
  double? price;


  NotesTables({this.id, this.title,this.price});

  NotesTables.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }
}

class TableAttributes {
  int? id;
  int? price;
  int? orderDetailsId;
  int? productId;
  int? productAttributeId;
  int? productAttributeValueId;
  String? createdAt;
  String? updatedAt;
  TableAttribute? attribute;
  AttributeValue? attributeValue;

  TableAttributes(
      {this.id,
        this.price,
        this.orderDetailsId,
        this.productId,
        this.productAttributeId,
        this.productAttributeValueId,
        this.createdAt,
        this.updatedAt,
        this.attribute,
        this.attributeValue});

  TableAttributes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    orderDetailsId = json['order_details_id'];
    productId = json['product_id'];
    productAttributeId = json['product_attribute_id'];
    productAttributeValueId = json['product_attribute_value_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    attribute = json['attribute'] != null
        ? new TableAttribute.fromJson(json['attribute'])
        : null;
    attributeValue = json['attribute_value'] != null
        ? new AttributeValue.fromJson(json['attribute_value'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['price'] = this.price;
    data['order_details_id'] = this.orderDetailsId;
    data['product_id'] = this.productId;
    data['product_attribute_id'] = this.productAttributeId;
    data['product_attribute_value_id'] = this.productAttributeValueId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.attribute != null) {
      data['attribute'] = this.attribute!.toJson();
    }
    if (this.attributeValue != null) {
      data['attribute_value'] = this.attributeValue!.toJson();
    }
    return data;
  }
}

class TableAttribute {
  int? id;
  int? productId;
  ProductTitle? title;
  int? required;
  int? multiSelect;
  int? overridePrice;
  String? createdAt;
  String? updatedAt;
  int? isActive;

  TableAttribute(
      {this.id,
        this.productId,
        this.title,
        this.required,
        this.multiSelect,
        this.overridePrice,
        this.createdAt,
        this.updatedAt,
        this.isActive});

  TableAttribute.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    title = json['title'] != null ? new ProductTitle.fromJson(json['title']) : null;
    required = json['required'];
    multiSelect = json['multi_select'];
    overridePrice = json['override_price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    if (this.title != null) {
      data['title'] = this.title!.toJson();
    }
    data['required'] = this.required;
    data['multi_select'] = this.multiSelect;
    data['override_price'] = this.overridePrice;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['is_active'] = this.isActive;
    return data;
  }
}

class AttributeValue {
  int? id;
  int? productAttributeId;
  ProductTitle? attributeValueTitle;
  int? price;
  String? createdAt;
  String? updatedAt;

  AttributeValue(
      {this.id,
        this.productAttributeId,
        this.attributeValueTitle,
        this.price,
        this.createdAt,
        this.updatedAt});

  AttributeValue.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productAttributeId = json['product_attribute_id'];
    attributeValueTitle = json['attribute_value'] != null
        ?  ProductTitle.fromJson(json['attribute_value'])
        : null;
    price = json['price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_attribute_id'] = this.productAttributeId;
    if (this.attributeValueTitle != null) {
      data['attribute_value'] = this.attributeValueTitle!.toJson();
    }
    data['price'] = this.price;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}





class Product {
  int? id;
  double? price;
  double? newPrice;
  int? isActive;
  int? stockAlert;
  int? categoryId;
  int? unitId;
  int? departmentId;
  String? createdAt;
  String? updatedAt;
  ProductTitle? title;
  ProductTitle? description;


  Product(
      {this.id,
        this.price,
        this.newPrice,
        this.isActive,
        this.stockAlert,
        this.categoryId,
        this.unitId,
        this.departmentId,
        this.createdAt,
        this.updatedAt,
        this.title,
        this.description,
      });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'].toDouble();
    newPrice = json['new_price'].toDouble();
    isActive = json['is_active'];
    stockAlert = json['stock_alert'];
    categoryId = json['category_id'];
    unitId = json['unit_id'];
    departmentId = json['department_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    title = json['title'] != null ?  ProductTitle.fromJson(json['title']) : null;
    description = json['description'] != null ?  ProductTitle.fromJson(json['title']) : null;
  }

}



class TableOrderTitle {
  String? en;
  String? ar;

  TableOrderTitle({this.en, this.ar});

  TableOrderTitle.fromJson(Map<String, dynamic> json) {
    en = LocalStorage.getData(key: 'language')=='en'? json['en']:json['ar'];
    ar = json['ar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['en'] = this.en;
    data['ar'] = this.ar;
    return data;
  }
}
