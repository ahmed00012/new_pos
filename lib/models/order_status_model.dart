import '../local_storage.dart';

class OrderStatusModel {
  int? id;
  StatusTitle? title;
  String? createdAt;
  bool chosen = false;

  OrderStatusModel({this.id, this.title, this.createdAt,this.chosen = false});

  OrderStatusModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'] != null ? new StatusTitle.fromJson(json['title']) : null;
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.title != null) {
      data['title'] = this.title!.toJson();
    }
    data['created_at'] = this.createdAt;
    return data;
  }
}

class StatusTitle {
  String? ar;
  String? en;

  StatusTitle({this.ar, this.en});

  StatusTitle.fromJson(Map<String, dynamic> json) {
    ar = json['ar'];
    en = LocalStorage.getData(key: 'language')=='en'? json['en']:json['ar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ar'] = this.ar;
    data['en'] = this.en;
    return data;
  }
}
