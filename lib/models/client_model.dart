class ClientModel{
  String? name;
  String ?phone;
  int points = 0;
  double balance = 0;
  bool allowCreateOrder = true;


  ClientModel({this.name,this.phone,this.points = 0,this.allowCreateOrder = true,this.balance = 0});

  ClientModel.fromJson(Map<String, dynamic> json){
    name = json['name'];
    phone = json['phone'];
    balance =json['balance']!=null? json['balance'].toDouble() : 0;
    points = json['points']!=null? int.parse(json['points'].toString()) : 0;
    allowCreateOrder = json['allow_create_order'] ?? true;
  }

}