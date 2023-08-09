class getSubsrctionNewModel {
  int status;
  String msg;
  List<Data> data;

  getSubsrctionNewModel({this.status, this.msg, this.data});

  getSubsrctionNewModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int id;
  String title;
  String description;
  String image;
  int time;
  String type;
  String Enddate;
  String amount;
  bool isactive;
  int status;
  String createdAt;
  String updatedAt;

  Data(
      {this.id,
        this.title,
        this.description,
        this.image,
        this.time,
        this.type,
        this.Enddate,
        this.isactive,
        this.amount,
        this.status,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    time = json['time'];
    type = json['type'];
    Enddate = json["end_date"];
    isactive = json["is_active"];
    amount = json['amount'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['image'] = this.image;
    data['time'] = this.time;
    data['end_date'] = this.Enddate;
    data['is_active'] = this.isactive;
    data['type'] = this.type;
    data['amount'] = this.amount;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}