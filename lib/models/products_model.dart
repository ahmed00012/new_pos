

import 'package:shormeh_pos_new_28_11_2022/models/product_details_model.dart';

import '../local_storage.dart';

class ProductModel {
  int? id;
  String? departmentId;
  double? price;
  // String? newPrice;
  ProductTitle? title;
  String? titleMix;
  String? description;
  double? customerPrice;
  String? itemCode;
  String? itemName;
  bool? onHover;
  List<Attributes>? attributes ;
  LastImage? image;

  ProductModel(
      {  this.id,
        this.departmentId,
        this.price,
         // this.newPrice,
         this.title,
         this.description,
        this.customerPrice,
        this.itemCode,
        this.itemName,
        this.onHover = false,
        this.attributes,
        this.image
});

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    departmentId = json['department_id'].toString() ;
    price = json['new_price'] == 0 ?double.parse(json['price'].toString())
        : double.parse(json['new_price'].toString());
    // newPrice = json['new_price'].toString() ;
    title = json['title'] != null ? new ProductTitle.fromJson(json['title']) : null;
    titleMix = json['title_mix'].toString() ;
    description = json['description'].toString()  ;
    customerPrice = double.parse(json['customer_price'].toString()) ;
    itemCode = json['item_code'].toString()  ;
    itemName = json['item_name'].toString()  ;
    image = json['last_image'] != null ? new LastImage.fromJson(json['last_image']) : null;
  }
}
class ProductTitle {
  String? en;
  String? ar;

  ProductTitle({this.en, this.ar});

  ProductTitle.fromJson(Map<String, dynamic> json) {
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

class LastImage {
  String? id;
  String? image;

  LastImage({this.id, this.image});

  LastImage.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    image = json['image'];
  }
}
