

class UserModel {
  String? accessToken;
  String? tokenType;
  int? expiresIn;
  Employee? employee;
  List<Department>? department;
  String? branch;
  String? branchCode;
  String? taxNumber;
  WebLinks? webLinks;
  String? phone;
  int? tax;

  UserModel(
      {this.accessToken,
        this.tokenType,
        this.expiresIn,
        this.employee,
        this.department,
        this.branch,
        this.branchCode,
        this.taxNumber,
        this.webLinks,
        this.phone,
        this.tax});

  UserModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    expiresIn = json['expires_in'];
    employee = json['employee'] != null
        ? new Employee.fromJson(json['employee'])
        : null;
    if (json['department'] != null) {
      department = <Department>[];
      json['department'].forEach((v) {
        department!.add(new Department.fromJson(v));
      });
    }
    branch = json['branch'];
    branchCode = json['branch_code']!=null ? json['branch_code'].toString() : null;
    taxNumber = json['tax_number'];
    webLinks = json['web_links'] != null
        ? new WebLinks.fromJson(json['web_links'])
        : null;
    phone = json['phone'];
    tax = int.tryParse(json['tax'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_token'] = this.accessToken;
    data['token_type'] = this.tokenType;
    data['expires_in'] = this.expiresIn;
    if (this.employee != null) {
      data['employee'] = this.employee!.toJson();
    }
    if (this.department != null) {
      data['department'] = this.department!.map((v) => v.toJson()).toList();
    }
    data['branch'] = this.branch;
    data['branch_code'] = this.branchCode;
    data['tax_number'] = this.taxNumber;
    if (this.webLinks != null) {
      data['web_links'] = this.webLinks!.toJson();
    }
    data['phone'] = this.phone;
    data['tax'] = this.tax;
    return data;
  }
}

class Employee {
  int? id;
  String? name;
  String? email;
  int? type;
  int? isActive;
  String? image;
  int? departmentId;
  int? branchId;
  String? loginTime;
  String? createdAt;
  String? updatedAt;
  int? showMobileOrders;
  int? isPreparingUser;
  int? isUpdateStatus;

  Employee(
      {this.id,
        this.name,
        this.email,
        this.type,
        this.isActive,
        this.image,
        this.departmentId,
        this.branchId,
        this.loginTime,
        this.createdAt,
        this.updatedAt,
        this.showMobileOrders,
        this.isPreparingUser,
      this.isUpdateStatus});

  Employee.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    type = json['type'];
    isActive = json['is_active'];
    image = json['image'];
    departmentId = json['department_id'];
    branchId = json['branch_id'];
    loginTime = json['login_time'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    showMobileOrders = json['show_mobile_orders'];
    isPreparingUser = json['is_preparing_user'];
    isUpdateStatus = json['is_update_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['type'] = this.type;
    data['is_active'] = this.isActive;
    data['image'] = this.image;
    data['department_id'] = this.departmentId;
    data['branch_id'] = this.branchId;
    data['login_time'] = this.loginTime;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['show_mobile_orders'] = this.showMobileOrders;
    data['is_preparing_user'] = this.isPreparingUser;
    return data;
  }
}

class Department {
  int? id;
  Title? title;

  Department({this.id, this.title});

  Department.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'] != null ? new Title.fromJson(json['title']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.title != null) {
      data['title'] = this.title!.toJson();
    }
    return data;
  }
}

class Title {
  String? en;
  String? ar;

  Title({this.en, this.ar});

  Title.fromJson(Map<String, dynamic> json) {
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

class WebLinks {
  String? instagram;
  String? twitter;

  WebLinks({this.instagram, this.twitter});

  WebLinks.fromJson(Map<String, dynamic> json) {
    instagram = json['instagram'];
    twitter = json['twitter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['instagram'] = this.instagram;
    data['twitter'] = this.twitter;
    return data;
  }
}
