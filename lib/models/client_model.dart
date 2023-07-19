class ClientModel{
  String? name;
  String ?phone;
  String? points;
  String? balance;
  bool allowCreateOrder = true;


  ClientModel({this.name,this.phone,this.points,this.allowCreateOrder = true,this.balance});

  ClientModel.fromJson(Map<String, dynamic> json){
    name = json['name'];
    phone = json['phone'];
    balance = json['balance'];
    points = json['points'];
    allowCreateOrder = json['allow_create_order'] ?? true;
  }

}