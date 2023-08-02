import 'package:shormeh_pos_new_28_11_2022/constants/prefs_utils.dart';

import '../local_storage.dart';

class CategoriesModel {
  int? id;
  Title? title;
  int? isActive;
  String? image;
  int? order;
  String? createdAt;
  String? updatedAt;
  bool chosen = false;

  CategoriesModel(
      {this.id,
        this.title,
        this.isActive,
        this.image,
        this.order,
        this.createdAt,
        this.updatedAt,
      this.chosen = false});

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'] != null ? new Title.fromJson(json['title']) : null;
    isActive = json['is_active'];
    image = json['image'];
    order = json['order'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.title != null) {
      data['title'] = this.title!.toJson();
    }
    data['is_active'] = this.isActive;
    data['image'] = this.image;
    data['order'] = this.order;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Title {
  String? en;
  String? ar;

  Title({this.en, this.ar});

  Title.fromJson(Map<String, dynamic> json) {
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
