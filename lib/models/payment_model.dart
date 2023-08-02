

import '../constants/prefs_utils.dart';
import '../local_storage.dart';

class PaymentModel {
  int? id;
  PaymentTitle? title;
  int? isActive;
  String? image;
  String? createdAt;
  bool chosen = false;


  PaymentModel(
      {this.id, this.title, this.isActive, this.image, this.createdAt,this.chosen=false});

  PaymentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'] != null ? new PaymentTitle.fromJson(json['title']) : null;
    isActive = json['is_active'];
    image = json['image'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.title != null) {
      data['title'] = this.title!.toJson();
    }
    data['is_active'] = this.isActive;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class PaymentTitle {
  String? en;
  String? ar;

  PaymentTitle({this.en, this.ar});

  PaymentTitle.fromJson(Map<String, dynamic> json) {
    en = getLanguage()=='en'? json['en']:json['ar'];
    ar = json['ar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['en'] = this.en;
    data['ar'] = this.ar;
    return data;
  }
}
