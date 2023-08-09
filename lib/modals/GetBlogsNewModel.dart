class GetBlogsNewModel {
  int status;
  String msg;
  List<Data> data;

  GetBlogsNewModel({this.status, this.msg, this.data});

  GetBlogsNewModel.fromJson(Map<String, dynamic> json) {
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
  int categoryId;
  String title;
  String description;
  String image;
  String video;
  int isPaid;
  int status;
  String createdAt;
  String updatedAt;
  bool isActive;

  Data(
      {this.id,
        this.categoryId,
        this.title,
        this.description,
        this.image,
        this.video,
        this.isPaid,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.isActive});

  Data.fromJson(Map<String, dynamic> json) {
    print(json);
    id = json['id'];
    categoryId = json['category_id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    video = json['video'];
    isPaid = json['is_paid'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['image'] = this.image;
    data['video'] = this.video;
    data['is_paid'] = this.isPaid;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['is_active'] = this.isActive;
    return data;
  }
}