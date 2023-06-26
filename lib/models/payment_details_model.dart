

class PaymentDetailsModel{
  String ?title;
  List<KeyValue> ?keys;

  PaymentDetailsModel({this.title  , this.keys});
}

class KeyValue{
  String? key;
  var value;

  KeyValue({this.key,this.value});

  factory KeyValue.fromJson(Map<String, dynamic> json) => KeyValue(
      key: json['title'],
      value: json['quantity']
  );
}