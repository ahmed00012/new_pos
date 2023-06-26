
class CouponModel {
  int? id;
  String? code;
  int? isActive;
  int? numOfUses;
  int? counter;
  int? type;
  double? value;
  String? dateFrom;
  String? dateTo;
  String? timeFrom;
  String? timeTo;
  String? createdAt;
  String? updatedAt;
  List<Branches>? branches;

  CouponModel(
      {this.id,
        this.code,
        this.isActive,
        this.numOfUses,
        this.counter,
        this.type,
        this.value,
        this.dateFrom,
        this.dateTo,
        this.timeFrom,
        this.timeTo,
        this.createdAt,
        this.updatedAt,
        this.branches});

  CouponModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    isActive = json['is_active'];
    numOfUses = json['num_of_uses'];
    counter = json['counter'];
    type = json['type'];
    value = json['value'].toDouble();
    dateFrom = json['date_from'];
    dateTo = json['date_to'];
    timeFrom = json['time_from'];
    timeTo = json['time_to'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['branches'] != null) {
      branches = <Branches>[];
      json['branches'].forEach((v) {
        branches!.add(new Branches.fromJson(v));
      });
    }
  }
}

class Branches {
  int? id;
  int? isActive;
  BranchesTitle? title;


  Branches(
      {this.id,
        this.isActive,
        this.title,});

  Branches.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isActive = json['is_active'];
    title = json['title'] != null ? new BranchesTitle.fromJson(json['title']) : null;
  }


}
class BranchesTitle {
  String? en;
  String? ar;

  BranchesTitle({this.en, this.ar});

  BranchesTitle.fromJson(Map<String, dynamic> json) {
    en = json['en'];
    ar = json['ar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['en'] = this.en;
    data['ar'] = this.ar;
    return data;
  }
}