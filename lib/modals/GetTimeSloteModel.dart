// To parse this JSON data, do
//
//     final getTimeSlotModel = getTimeSlotModelFromJson(jsonString);

import 'dart:convert';

GetTimeSlotModel getTimeSlotModelFromJson(String str) => GetTimeSlotModel.fromJson(json.decode(str));

String getTimeSlotModelToJson(GetTimeSlotModel data) => json.encode(data.toJson());

class GetTimeSlotModel {
  int status;
  String message;
  List<TimeSlots> data;
  List<AvailableDay> availableDays;

  GetTimeSlotModel({
    this.status,
    this.message,
    this.data,
    this.availableDays,
  });

  factory GetTimeSlotModel.fromJson(Map<String, dynamic> json) => GetTimeSlotModel(
    status: json["status"],
    message: json["message"],
    data: List<TimeSlots>.from(json["data"].map((x) => TimeSlots.fromJson(x))),
    availableDays: List<AvailableDay>.from(json["available_days"].map((x) => AvailableDay.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "available_days": List<dynamic>.from(availableDays.map((x) => x.toJson())),
  };
}

class AvailableDay {
  int id;
  int doctorId;
  String day;
  String from;
  String to;
  DateTime createdAt;
  DateTime updatedAt;
  String status;

  AvailableDay({
    this.id,
    this.doctorId,
    this.day,
    this.from,
    this.to,
    this.createdAt,
    this.updatedAt,
    this.status,
  });

  factory AvailableDay.fromJson(Map<String, dynamic> json) => AvailableDay(
    id: json["id"],
    doctorId: json["doctor_id"],
    day: json["day"],
    from: json["from"],
    to: json["to"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "doctor_id": doctorId,
    "day": day,
    "from": from,
    "to": to,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "status": status,
  };
}

class TimeSlots {
  String startTime;
  String endTime;
  bool isEnabled;

  TimeSlots({
    this.startTime,
    this.endTime,
    this.isEnabled,
  });

  factory TimeSlots.fromJson(Map<String, dynamic> json) => TimeSlots(
    startTime: json["start_time"],
    endTime: json["end_time"],
    isEnabled: json["is_enabled"],
  );

  Map<String, dynamic> toJson() => {
    "start_time": startTime,
    "end_time": endTime,
    "is_enabled": isEnabled,
  };
}
