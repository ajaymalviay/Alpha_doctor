// To parse this JSON data, do
//
//     final upcomingAppointments = upcomingAppointmentsFromJson(jsonString);

import 'dart:convert';

UpcomingAppointments upcomingAppointmentsFromJson(String str) => UpcomingAppointments.fromJson(json.decode(str));

String upcomingAppointmentsToJson(UpcomingAppointments data) => json.encode(data.toJson());

class UpcomingAppointments {
  int status;
  String msg;
  Data data;

  UpcomingAppointments({
    this.status,
    this.msg,
    this.data,
  });

  factory UpcomingAppointments.fromJson(Map<String, dynamic> json) => UpcomingAppointments(
    status: json["status"],
    msg: json["msg"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": data.toJson(),
  };
}

class Data {
  int currentPage;
  List<InnerData> data;
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

  Data({
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

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    currentPage: json["current_page"],
    data: List<InnerData>.from(json["data"].map((x) => InnerData.fromJson(x))),
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

class InnerData {
  int age;
  DateTime createdAt;
  int userId;
  int departmentId;
  int id;
  String name;
  String date;
  String time;
  String phoneNo;
  String status;
  String messages;
  int serviceId;
  String prescription;
  String doctorName;
  String departmentName;
  String image;
  String serviceName;

  InnerData({
    this.age,
    this.createdAt,
    this.userId,
    this.departmentId,
    this.id,
    this.name,
    this.date,
    this.time,
    this.phoneNo,
    this.status,
    this.messages,
    this.serviceId,
    this.prescription,
    this.doctorName,
    this.departmentName,
    this.image,
    this.serviceName,
  });

  factory InnerData.fromJson(Map<String, dynamic> json) => InnerData(
    age: json["age"],
    createdAt: DateTime.parse(json["created_at"]),
    userId: json["user_id"],
    departmentId: json["department_id"],
    id: json["id"],
    name: json["name"],
    date: json["date"],
    time: json["time"],
    phoneNo: json["phone_no"],
    status: json["status"],
    messages: json["messages"],
    serviceId: json["service_id"],
    prescription: json["prescription"],
    doctorName: json["doctor_name"],
    departmentName: json["department_name"],
    image: json["image"],
    serviceName: json["service_name"],
  );

  Map<String, dynamic> toJson() => {
    "age": age,
    "created_at": createdAt.toIso8601String(),
    "user_id": userId,
    "department_id": departmentId,
    "id": id,
    "name": name,
    "date": date,
    "time": time,
    "phone_no": phoneNo,
    "status": status,
    "messages": messages,
    "service_id": serviceId,
    "prescription": prescription,
    "doctor_name": doctorName,
    "department_name": departmentName,
    "image": image,
    "service_name": serviceName,
  };
}
