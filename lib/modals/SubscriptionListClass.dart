// To parse this JSON data, do
//
//     final subscriptionListClass = subscriptionListClassFromJson(jsonString);

import 'dart:convert';

SubscriptionListClass subscriptionListClassFromJson(String str) => SubscriptionListClass.fromJson(json.decode(str));

String subscriptionListClassToJson(SubscriptionListClass data) => json.encode(data.toJson());

class SubscriptionListClass {
  int status;
  String msg;
  Results results;

  SubscriptionListClass({
    this.status,
    this.msg,
    this.results,
  });

  factory SubscriptionListClass.fromJson(Map<String, dynamic> json) => SubscriptionListClass(
    status: json["status"],
    msg: json["msg"],
    results: Results.fromJson(json["results"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "results": results.toJson(),
  };
}

class Results {
  int currentPage;
  List<Data> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  dynamic nextPageUrl;
  String path;
  int perPage;
  dynamic prevPageUrl;
  int to;
  int total;

  Results({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory Results.fromJson(Map<String, dynamic> json) => Results(
    currentPage: json["current_page"],
    data: List<Data>.from(json["data"].map((x) => Data.fromJson(x))),
    firstPageUrl: json["first_page_url"],
    from: json["from"],
    lastPage: json["last_page"],
    lastPageUrl: json["last_page_url"],
    nextPageUrl: json["next_page_url"],
    path: json["path"],
    perPage: json["per_page"],
    prevPageUrl: json["prev_page_url"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "first_page_url": firstPageUrl,
    "from": from,
    "last_page": lastPage,
    "last_page_url": lastPageUrl,
    "next_page_url": nextPageUrl,
    "path": path,
    "per_page": perPage,
    "prev_page_url": prevPageUrl,
    "to": to,
    "total": total,
  };
}

class Data {
  int id;
  int userId;
  int packageId;
  String transactionId;
  String name;
  int paymentType;
  DateTime createdAt;
  DateTime updatedAt;
  String amount;
  DateTime date;
  String time;
  int status;
  DateTime expire;
  Packagedata packagedata;

  Data({
    this.id,
    this.userId,
    this.packageId,
    this.transactionId,
    this.name,
    this.paymentType,
    this.createdAt,
    this.updatedAt,
    this.amount,
    this.date,
    this.time,
    this.status,
    this.expire,
    this.packagedata,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    userId: json["user_id"],
    packageId: json["package_id"],
    transactionId: json["transaction_id"],
    name: json["name"],
    paymentType: json["payment_type"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    amount: json["amount"],
    date: DateTime.parse(json["date"]),
    time: json["time"],
    status: json["status"],
    expire: DateTime.parse(json["expire"]),
    packagedata: Packagedata.fromJson(json["packagedata"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "package_id": packageId,
    "transaction_id": transactionId,
    "name": name,
    "payment_type": paymentType,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "amount": amount,
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "time": time,
    "status": status,
    "expire": "${expire.year.toString().padLeft(4, '0')}-${expire.month.toString().padLeft(2, '0')}-${expire.day.toString().padLeft(2, '0')}",
    "packagedata": packagedata.toJson(),
  };
}

class Packagedata {
  int id;
  String title;
  String description;
  String image;
  int time;
  String type;
  int amount;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  Packagedata({
    this.id,
    this.title,
    this.description,
    this.image,
    this.time,
    this.type,
    this.amount,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Packagedata.fromJson(Map<String, dynamic> json) => Packagedata(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    image: json["image"],
    time: json["time"],
    type: json["type"],
    amount: json["amount"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "image": image,
    "time": time,
    "type": type,
    "amount": amount,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
