


import '../constants/prefs_utils.dart';
import '../local_storage.dart';

class OrderMethodModel {
  int? id;
  OrderMethodTitle? title;
  bool? chosen = false;

  OrderMethodModel({this.id, this.title,this.chosen = false});

  OrderMethodModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'] != null ? new OrderMethodTitle.fromJson(json['title']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.title != null) {
      data['title'] = this.title!.toJson();
    }
    return data;
  }
}

class OrderMethodTitle {
  String? en;
  String? ar;

  OrderMethodTitle({this.en, this.ar});

  OrderMethodTitle.fromJson(Map<String, dynamic> json) {
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
