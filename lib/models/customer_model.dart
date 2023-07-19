class CustomerModel{
  int? id;
  String ?title;
  String ?image;
  bool chosen = false;

  CustomerModel({this.title,this.chosen = false,this.id,this.image});

  CustomerModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    title = json['title_en'];
    image = json['image'];

  }



}