import '../constants/prefs_utils.dart';
import '../local_storage.dart';

class NotesModel{
  int? id;
  double? price;
  String? title;
  String? titleEn;
  String? titleMix;
  bool? onHover;

  NotesModel({this.title,this.titleEn,this.price,this.id,this.titleMix,this.onHover = false});
  factory NotesModel.fromJson(Map<String, dynamic> json) => NotesModel(
    id: json["id"],
    title: json["title"],
    titleEn: getLanguage()=='en'? json["title_en"]:json["title_ar"],
    titleMix: '${json["title_en"]} - ${json["title_ar"]}',
    price: double.parse(json["price"].toString()),
  );

}