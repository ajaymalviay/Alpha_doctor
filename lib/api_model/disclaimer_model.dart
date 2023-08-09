// To parse this JSON data, do
//
//     final disclaimerDataModel = disclaimerDataModelFromJson(jsonString);

import 'dart:convert';

DisclaimerDataModel disclaimerDataModelFromJson(String str) => DisclaimerDataModel.fromJson(json.decode(str));

String disclaimerDataModelToJson(DisclaimerDataModel data) => json.encode(data.toJson());

class DisclaimerDataModel {
  int status;
  String msg;
  List<DisclaimerData> data;

  DisclaimerDataModel({
    this.status,
    this.msg,
    this.data,
  });

  factory DisclaimerDataModel.fromJson(Map<String, dynamic> json) => DisclaimerDataModel(
    status: json["status"],
    msg: json["msg"],
    data: List<DisclaimerData>.from(json["data"].map((x) => DisclaimerData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class DisclaimerData {
  int id;
  String isDemo;
  String androidServerKey;
  String logo;
  String isWeb;
  String isRtl;
  dynamic iosServerKey;
  String email;
  String address;
  String phoneNo;
  String timezone;
  String currency;
  String facebookId;
  String twitterId;
  String instagramId;
  String googleId;
  dynamic happyClient;
  dynamic surgeryComplete;
  dynamic expertDoctor;
  dynamic worldwideBranch;
  DateTime createdAt;
  DateTime updatedAt;
  String termsCondition;
  String refundPolicies;
  String cancelationPolicies;
  String privacyPolicy;
  dynamic twilioAccountSid;
  dynamic twilioApiKey;
  dynamic twilioApiSecret;
  dynamic twilioChatServiceSid;
  dynamic twilioAuthToken;
  dynamic apnCredentialSid;
  dynamic gcmOrFcmCredentialSid;
  String workingDay;
  String mainBanner;
  dynamic webKey;
  String about;
  String aboutImg;
  String disclaimer;
  String introductions;

  DisclaimerData({
    this.id,
    this.isDemo,
    this.androidServerKey,
    this.logo,
    this.isWeb,
    this.isRtl,
    this.iosServerKey,
    this.email,
    this.address,
    this.phoneNo,
    this.timezone,
    this.currency,
    this.facebookId,
    this.twitterId,
    this.instagramId,
    this.googleId,
    this.happyClient,
    this.surgeryComplete,
    this.expertDoctor,
    this.worldwideBranch,
    this.createdAt,
    this.updatedAt,
    this.termsCondition,
    this.refundPolicies,
    this.cancelationPolicies,
    this.privacyPolicy,
    this.twilioAccountSid,
    this.twilioApiKey,
    this.twilioApiSecret,
    this.twilioChatServiceSid,
    this.twilioAuthToken,
    this.apnCredentialSid,
    this.gcmOrFcmCredentialSid,
    this.workingDay,
    this.mainBanner,
    this.webKey,
    this.about,
    this.aboutImg,
    this.disclaimer,
    this.introductions,
  });

  factory DisclaimerData.fromJson(Map<String, dynamic> json) => DisclaimerData(
    id: json["id"],
    isDemo: json["is_demo"],
    androidServerKey: json["android_server_key"],
    logo: json["logo"],
    isWeb: json["is_web"],
    isRtl: json["is_rtl"],
    iosServerKey: json["ios_server_key"],
    email: json["email"],
    address: json["address"],
    phoneNo: json["phone_no"],
    timezone: json["timezone"],
    currency: json["currency"],
    facebookId: json["facebook_id"],
    twitterId: json["twitter_id"],
    instagramId: json["instagram_id"],
    googleId: json["google_id"],
    happyClient: json["happy_client"],
    surgeryComplete: json["surgery_complete"],
    expertDoctor: json["expert_doctor"],
    worldwideBranch: json["worldwide_branch"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    termsCondition: json["terms_condition"],
    refundPolicies: json["refund_policies"],
    cancelationPolicies: json["cancelation_policies"],
    privacyPolicy: json["privacy_policy"],
    twilioAccountSid: json["TWILIO_ACCOUNT_SID"],
    twilioApiKey: json["TWILIO_API_KEY"],
    twilioApiSecret: json["TWILIO_API_SECRET"],
    twilioChatServiceSid: json["TWILIO_CHAT_SERVICE_SID"],
    twilioAuthToken: json["TWILIO_AUTH_TOKEN"],
    apnCredentialSid: json["APNCredentialSid"],
    gcmOrFcmCredentialSid: json["GCM_or_FCM_Credential_Sid"],
    workingDay: json["working_day"],
    mainBanner: json["main_banner"],
    webKey: json["web_key"],
    about: json["about"],
    aboutImg: json["about_img"],
    disclaimer: json["disclaimer"],
    introductions: json["introductions"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "is_demo": isDemo,
    "android_server_key": androidServerKey,
    "logo": logo,
    "is_web": isWeb,
    "is_rtl": isRtl,
    "ios_server_key": iosServerKey,
    "email": email,
    "address": address,
    "phone_no": phoneNo,
    "timezone": timezone,
    "currency": currency,
    "facebook_id": facebookId,
    "twitter_id": twitterId,
    "instagram_id": instagramId,
    "google_id": googleId,
    "happy_client": happyClient,
    "surgery_complete": surgeryComplete,
    "expert_doctor": expertDoctor,
    "worldwide_branch": worldwideBranch,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "terms_condition": termsCondition,
    "refund_policies": refundPolicies,
    "cancelation_policies": cancelationPolicies,
    "privacy_policy": privacyPolicy,
    "TWILIO_ACCOUNT_SID": twilioAccountSid,
    "TWILIO_API_KEY": twilioApiKey,
    "TWILIO_API_SECRET": twilioApiSecret,
    "TWILIO_CHAT_SERVICE_SID": twilioChatServiceSid,
    "TWILIO_AUTH_TOKEN": twilioAuthToken,
    "APNCredentialSid": apnCredentialSid,
    "GCM_or_FCM_Credential_Sid": gcmOrFcmCredentialSid,
    "working_day": workingDay,
    "main_banner": mainBanner,
    "web_key": webKey,
    "about": about,
    "about_img": aboutImg,
    "disclaimer": disclaimer,
    "introductions": introductions,
  };
}
