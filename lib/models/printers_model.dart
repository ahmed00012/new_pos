class PrinterModel{
  String? departmentId;
  String ?ip;
  String? typeName;


  PrinterModel({this.ip,this.departmentId,this.typeName});

  PrinterModel.fromJson(Map<String, dynamic> json){
    ip = json['ip'];
    departmentId = json['department_id'].toString();
    typeName = json['type_name'].toString();
  }
}