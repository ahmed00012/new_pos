class ClientModel{
  String? name;
  String ?phone;
  String? points;
  String? balance;
  String? allowCreateOrder;


  ClientModel({this.name,this.phone,this.points,this.allowCreateOrder,this.balance});

  ClientModel.fromJson(Map<String, dynamic> json){
    name = json['name'];
    phone = json['phone'].toString();
    balance = json['balance'].toString();
    points = json['points'].toString();
    allowCreateOrder = json['allow_create_order'].toString();
  }

}