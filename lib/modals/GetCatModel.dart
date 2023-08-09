// To parse this JSON data, do
//
//     final getCatModel = getCatModelFromJson(jsonString);

import 'dart:convert';

GetCatModel getCatModelFromJson(String str) => GetCatModel.fromJson(json.decode(str));

String getCatModelToJson(GetCatModel data) => json.encode(data.toJson());

class GetCatModel {
  int status;
  String msg;
  List<Data> data;

  GetCatModel({
    this.status,
    this.msg,
    this.data,
  });

  factory GetCatModel.fromJson(Map<String, dynamic> json) => GetCatModel(
    status: json["status"],
    msg: json["msg"],
    data: List<Data>.from(json["data"].map((x) => Data.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Data {
  int id;
  String name;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  Data({
    this.id,
    this.name,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
