import 'package:shormeh_pos_new_28_11_2022/models/categories_model.dart';
import 'package:shormeh_pos_new_28_11_2022/models/products_model.dart';

class ProductDetailsModel {
  int? id;
  int? price;
  int? newPrice;
  String? image;
  int? isActive;
  int? stockAlert;
  int? categoryId;
  int? unitId;
  int? departmentId;
  String? createdAt;
  String? updatedAt;
  int? customerPrice;
  String? itemCode;
  String? itemName;
  String? titleMix;
  ProductTitle? title;
  ProductTitle? description;
  List<Attributes>? attributes;
  List<Translations>? translations;


  ProductDetailsModel(
      {this.id,
        this.price,
        this.newPrice,
        this.image,
        this.isActive,
        this.stockAlert,
        this.categoryId,
        this.unitId,
        this.departmentId,
        this.createdAt,
        this.updatedAt,
        this.customerPrice,
        this.itemCode,
        this.itemName,
        this.titleMix,
        this.title,
        this.description,
        this.attributes,
        this.translations,
      });

  ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    // id = json['id'];
    // price = json['price'];
    // newPrice = json['new_price'];
    // image = json['image'];
    // isActive = json['is_active'];
    // stockAlert = json['stock_alert'];
    // categoryId = json['category_id'];
    // unitId = json['unit_id'];
    // departmentId = json['department_id'];
    // createdAt = json['created_at'];
    // updatedAt = json['updated_at'];
    // customerPrice = json['customer_price'];
    // itemCode = json['item_code'];
    // itemName = json['item_name'];
    // titleMix = json['title_mix'];
    // title = json['title'] != null ?  ProductTitle.fromJson(json['title']) : null;
    //
    // description = json['description'] != null ?  ProductTitle.fromJson(json['description']) : null;
    if (json['attributes'] != null) {
      attributes = <Attributes>[];
      json['attributes'].forEach((v) {
        attributes!.add(new Attributes.fromJson(v));
      });
    }
    if (json['translations'] != null) {
      translations = <Translations>[];
      json['translations'].forEach((v) {
        translations!.add(new Translations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['price'] = this.price;
    data['new_price'] = this.newPrice;
    data['image'] = this.image;
    data['is_active'] = this.isActive;
    data['stock_alert'] = this.stockAlert;
    data['category_id'] = this.categoryId;
    data['unit_id'] = this.unitId;
    data['department_id'] = this.departmentId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['customer_price'] = this.customerPrice;
    data['item_code'] = this.itemCode;
    data['item_name'] = this.itemName;
    data['title_mix'] = this.titleMix;
    data['title'] = this.title;
    data['description'] = this.description;
    if (this.attributes != null) {
      data['attributes'] = this.attributes!.map((v) => v.toJson()).toList();
    }
    if (this.translations != null) {
      data['translations'] = this.translations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Attributes {
  int? id;
  int? productId;
  String? attributeAr;
  String? attributeEn;
  int? required;
  int? multiSelect;
  String? createdAt;
  String? updatedAt;
  ProductTitle? title;
  List<AttributeItem>? values;
  int? overridePrice;


  Attributes(
      {this.id,
        this.productId,
        this.attributeAr,
        this.attributeEn,
        this.required,
        this.multiSelect,
        this.createdAt,
        this.updatedAt,
        this.title,
        this.values,
        this.overridePrice

      });

  Attributes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    attributeAr = json['attribute_ar'];
    attributeEn = json['attribute_en'];
    required = json['required'];
    multiSelect = json['multi_select'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    overridePrice = json['override_price'];
    title = json['title'] != null ? new ProductTitle.fromJson(json['title']) : null;
    if (json['values'] != null) {
      values = <AttributeItem>[];
      json['values'].forEach((v) {
        values!.add(new AttributeItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['attribute_ar'] = this.attributeAr;
    data['attribute_en'] = this.attributeEn;
    data['required'] = this.required;
    data['multi_select'] = this.multiSelect;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['title'] = this.title;
    if (this.values != null) {
      data['values'] = this.values!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AttributeItem {
  int? id;
  int? productAttributeId;
  ProductTitle? attributeValue;
  double? realPrice;
  double? price;
  double? customerPrice;
  String? createdAt;
  String? updatedAt;
  String? value;
  bool? chosen;


  AttributeItem(
      {this.id,
        this.productAttributeId,
        this.attributeValue,
        this.realPrice,
        this.createdAt,
        this.updatedAt,
        this.value,
      this.chosen,
        this.price,
        this.customerPrice
      });

  AttributeItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productAttributeId = json['product_attribute_id'];
    attributeValue = json['attribute_value'] != null ? new ProductTitle.fromJson(json['attribute_value']) : null;

    price = json['price']!=null?json['price'].toDouble():null;
    customerPrice = json['customer_price']!=null?json['customer_price'].toDouble():null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_attribute_id'] = this.productAttributeId;

    data['price'] = this.realPrice;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['value'] = this.value;
    return data;
  }
}

class Translations {
  int? id;
  int? productId;
  String? locale;
  String? title;
  String? description;

  Translations(
      {this.id, this.productId, this.locale, this.title, this.description});

  Translations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    locale = json['locale'];
    title = json['title'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['locale'] = this.locale;
    data['title'] = this.title;
    data['description'] = this.description;
    return data;
  }
}

