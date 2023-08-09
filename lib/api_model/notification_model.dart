// To parse this JSON data, do
//
//     final getNotificationModel = getNotificationModelFromJson(jsonString);

import 'dart:convert';

GetNotificationModel getNotificationModelFromJson(String str) => GetNotificationModel.fromJson(json.decode(str));

String getNotificationModelToJson(GetNotificationModel data) => json.encode(data.toJson());

class GetNotificationModel {
  int status;
  String msg;
  List<Result> results;

  GetNotificationModel({
    this.status,
    this.msg,
    this.results,
  });

  factory GetNotificationModel.fromJson(Map<String, dynamic> json) => GetNotificationModel(
    status: json["status"],
    msg: json["msg"],
    results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
  };
}

class Result {
  int id;
  int userId;
  String message;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  Result({
    this.id,
    this.userId,
    this.message,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    userId: json["user_id"],
    message: json["message"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "message": message,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
