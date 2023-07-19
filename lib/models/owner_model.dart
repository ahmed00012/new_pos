class OwnerModel{
  int ?id;
  String? title;
  String? titleAr;
  String? titleEn;
  bool chosen = false;
  OwnerModel({this.id,this.title,this.chosen = false});
  OwnerModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    title = json['title'];
    titleEn = json['title_en'];
    titleAr = json['title_ar'];

  }
}