




import '../constants/prefs_utils.dart';

class IntegrationModel {
  List<OrderDetail>? orderDetail;

  IntegrationModel({this.orderDetail});

  IntegrationModel.fromJson(Map<String, dynamic> json) {
    if (json['OrderDetail'] != null) {
      orderDetail = <OrderDetail>[];
      json['OrderDetail'].forEach((v) {
        orderDetail!.add(new OrderDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orderDetail != null) {
      data['OrderDetail'] = this.orderDetail!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderDetail {
  String? documentNo;
  String? lineNo;
  String? type;
  String? postingDate;
  String? itemNo;
  String? description;
  String? unitOfMeasure;
  String? quantity;
  String? amount;
  String? paymentType;
  String? customerNo;
  String? locationCode;
  String? tax;
  String? discount;
  String? tIPAmount;

  OrderDetail(
      {this.documentNo,
        this.lineNo,
        this.type,
        this.postingDate,
        this.itemNo,
        this.description,
        this.unitOfMeasure,
        this.quantity,
        this.amount,
        this.paymentType,
        this.customerNo,
        this.locationCode,
        this.tax,
        this.discount,
        this.tIPAmount});

  OrderDetail.fromJson(Map<String, dynamic> json) {
    documentNo = json['Document No.'];
    lineNo = json['LineNo'];
    type = json['Type'];
    postingDate = json['PostingDate'];
    itemNo = json['ItemNo'];
    description = json['Description'];
    unitOfMeasure = json['Unit_of_Measure'];
    quantity = json['Quantity'];
    amount = json['Amount'];
    paymentType = json['Payment_Type'];
    customerNo = json['Customer_No'];
    locationCode = json['Location_Code'];
    tax = json['Tax'];
    discount = json['Discount'];
    tIPAmount = json['TIP_Amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Document No.'] = this.documentNo;
    data['LineNo'] = this.lineNo;
    data['Type'] =  this.type;
    data['PostingDate'] = DateTime.now.toString().substring(0,10);
    data['ItemNo'] = this.itemNo;
    data['Description'] = this.description;
    data['Unit_of_Measure'] = this.unitOfMeasure;
    data['Quantity'] = this.quantity;
    data['Amount'] = this.amount;
    data['Payment_Type'] = this.paymentType;
    data['Customer_No'] = this.customerNo;
    data['Location_Code'] = '12';
    data['Tax'] = this.tax;
    data['Discount'] = this.discount;
    data['TIP_Amount'] = '0';
    return data;
  }
}
