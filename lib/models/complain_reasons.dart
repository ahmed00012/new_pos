class ComplainReasons {
  int? id;
  String? title;
  bool chosen = false;

  ComplainReasons({this.id, this.title,this.chosen = false});

  ComplainReasons.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    return data;
  }
}