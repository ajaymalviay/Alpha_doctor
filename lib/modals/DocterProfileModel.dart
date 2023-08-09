/// status : 1
/// msg : "Sliders lists"
/// data : {"id":1,"user_id":4,"department_id":1,"name":"Dr. Mohammed Umar Mansoori","email":"cwchealthquery@gmail.com","password":"cwchealth*****","phone_no":"8529653753","working_hour":[{"id":1,"doctor_id":1,"day":"Monday","from":"11:00 AM","to":"08:00 PM","created_at":"2023-02-09 11:56:44","updated_at":"2023-06-27 16:46:39","status":"0"},{"id":2,"doctor_id":1,"day":"Tuesday","from":"12:00 PM","to":"06:00 PM","created_at":"2023-02-09 11:56:44","updated_at":"2023-06-01 17:41:01","status":"0"},{"id":3,"doctor_id":1,"day":"Wednesday","from":"01:00 PM","to":"06:00 PM","created_at":"2023-02-09 11:56:44","updated_at":"2023-06-02 09:59:25","status":"0"},{"id":4,"doctor_id":1,"day":"Thursday","from":"02:00 PM","to":"07:00 PM","created_at":"2023-02-09 11:56:44","updated_at":"2023-06-02 09:59:26","status":"0"},{"id":5,"doctor_id":1,"day":"Friday","from":"03:00 PM","to":"08:00 PM","created_at":"2023-02-09 11:56:44","updated_at":"2023-06-26 18:06:23","status":"0"},{"id":6,"doctor_id":1,"day":"Saturday","from":"04:00 PM","to":"09:00 PM","created_at":"2023-02-09 11:56:44","updated_at":"2023-06-26 13:49:00","status":"0"},{"id":7,"doctor_id":1,"day":"Sunday","from":"10:00 AM","to":"04:00 PM","created_at":"2023-02-09 11:56:44","updated_at":"2023-06-27 16:46:42","status":"1"}],"about_us":"Dr. Mohammed Umar Mansoori is a renowned and experienced Gynaecologist and Fertility Expert in Chittaurgarh. He brings with him an experience of 10+ years and has been associated with some of the best hospitals in Chittaurgarh. A dedicated compassionate doctor who handles many challenging cases with the latest cutting edge technology. He offers patient- friendly scientific advice to your problems while maintaining the highest professional and ethical values.","service":"1. Pregnancy and Childbirth\r\n2. Fertility treatment\r\n3. Treatment for Menopause and related problems\r\n4. Fibroid treatment\r\n5. PCOS Management \r\n6. Hysteroscopy and laparoscopy","image":"https://completewomencares.com/public/upload/doctor/doctor_291101.jpg","facebook_id":"https://facebook.com","twitter_id":"https://twitter.com","google_id":"https://google.com","instagram_id":"https://instagram.com","consultation_charges":"100.00","created_at":"2023-02-09 11:55:22","updated_at":"2023-06-24 14:13:56"}

class DocterProfileModel {
  DocterProfileModel({
      num status,
      String msg,
      Data data,}){
    _status = status;
    _msg = msg;
    _data = data;
}

  DocterProfileModel.fromJson(dynamic json) {
    _status = json['status'];
    _msg = json['msg'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  num _status;
  String _msg;
  Data _data;
DocterProfileModel copyWith({  num status,
  String msg,
  Data data,
}) => DocterProfileModel(  status: status ?? _status,
  msg: msg ?? _msg,
  data: data ?? _data,
);
  num get status => _status;
  String get msg => _msg;
  Data get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['msg'] = _msg;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }

}

/// id : 1
/// user_id : 4
/// department_id : 1
/// name : "Dr. Mohammed Umar Mansoori"
/// email : "cwchealthquery@gmail.com"
/// password : "cwchealth*****"
/// phone_no : "8529653753"
/// working_hour : [{"id":1,"doctor_id":1,"day":"Monday","from":"11:00 AM","to":"08:00 PM","created_at":"2023-02-09 11:56:44","updated_at":"2023-06-27 16:46:39","status":"0"},{"id":2,"doctor_id":1,"day":"Tuesday","from":"12:00 PM","to":"06:00 PM","created_at":"2023-02-09 11:56:44","updated_at":"2023-06-01 17:41:01","status":"0"},{"id":3,"doctor_id":1,"day":"Wednesday","from":"01:00 PM","to":"06:00 PM","created_at":"2023-02-09 11:56:44","updated_at":"2023-06-02 09:59:25","status":"0"},{"id":4,"doctor_id":1,"day":"Thursday","from":"02:00 PM","to":"07:00 PM","created_at":"2023-02-09 11:56:44","updated_at":"2023-06-02 09:59:26","status":"0"},{"id":5,"doctor_id":1,"day":"Friday","from":"03:00 PM","to":"08:00 PM","created_at":"2023-02-09 11:56:44","updated_at":"2023-06-26 18:06:23","status":"0"},{"id":6,"doctor_id":1,"day":"Saturday","from":"04:00 PM","to":"09:00 PM","created_at":"2023-02-09 11:56:44","updated_at":"2023-06-26 13:49:00","status":"0"},{"id":7,"doctor_id":1,"day":"Sunday","from":"10:00 AM","to":"04:00 PM","created_at":"2023-02-09 11:56:44","updated_at":"2023-06-27 16:46:42","status":"1"}]
/// about_us : "Dr. Mohammed Umar Mansoori is a renowned and experienced Gynaecologist and Fertility Expert in Chittaurgarh. He brings with him an experience of 10+ years and has been associated with some of the best hospitals in Chittaurgarh. A dedicated compassionate doctor who handles many challenging cases with the latest cutting edge technology. He offers patient- friendly scientific advice to your problems while maintaining the highest professional and ethical values."
/// service : "1. Pregnancy and Childbirth\r\n2. Fertility treatment\r\n3. Treatment for Menopause and related problems\r\n4. Fibroid treatment\r\n5. PCOS Management \r\n6. Hysteroscopy and laparoscopy"
/// image : "https://completewomencares.com/public/upload/doctor/doctor_291101.jpg"
/// facebook_id : "https://facebook.com"
/// twitter_id : "https://twitter.com"
/// google_id : "https://google.com"
/// instagram_id : "https://instagram.com"
/// consultation_charges : "100.00"
/// created_at : "2023-02-09 11:55:22"
/// updated_at : "2023-06-24 14:13:56"

class Data {
  Data({
      num id,
      num userId,
      num departmentId,
      String name,
      String email,
      String password,
      String phoneNo,
      List<WorkingHour> workingHour,
      String aboutUs,
      String service,
      String image,
      String facebookId,
      String twitterId,
      String googleId,
      String instagramId,
      String consultationCharges,
      String createdAt,
      String updatedAt,}){
    _id = id;
    _userId = userId;
    _departmentId = departmentId;
    _name = name;
    _email = email;
    _password = password;
    _phoneNo = phoneNo;
    _workingHour = workingHour;
    _aboutUs = aboutUs;
    _service = service;
    _image = image;
    _facebookId = facebookId;
    _twitterId = twitterId;
    _googleId = googleId;
    _instagramId = instagramId;
    _consultationCharges = consultationCharges;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['user_id'];
    _departmentId = json['department_id'];
    _name = json['name'];
    _email = json['email'];
    _password = json['password'];
    _phoneNo = json['phone_no'];
    if (json['working_hour'] != null) {
      _workingHour = [];
      json['working_hour'].forEach((v) {
        _workingHour?.add(WorkingHour.fromJson(v));
      });
    }
    _aboutUs = json['about_us'];
    _service = json['service'];
    _image = json['image'];
    _facebookId = json['facebook_id'];
    _twitterId = json['twitter_id'];
    _googleId = json['google_id'];
    _instagramId = json['instagram_id'];
    _consultationCharges = json['consultation_charges'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  num _id;
  num _userId;
  num _departmentId;
  String _name;
  String _email;
  String _password;
  String _phoneNo;
  List<WorkingHour> _workingHour;
  String _aboutUs;
  String _service;
  String _image;
  String _facebookId;
  String _twitterId;
  String _googleId;
  String _instagramId;
  String _consultationCharges;
  String _createdAt;
  String _updatedAt;
Data copyWith({  num id,
  num userId,
  num departmentId,
  String name,
  String email,
  String password,
  String phoneNo,
  List<WorkingHour> workingHour,
  String aboutUs,
  String service,
  String image,
  String facebookId,
  String twitterId,
  String googleId,
  String instagramId,
  String consultationCharges,
  String createdAt,
  String updatedAt,
}) => Data(  id: id ?? _id,
  userId: userId ?? _userId,
  departmentId: departmentId ?? _departmentId,
  name: name ?? _name,
  email: email ?? _email,
  password: password ?? _password,
  phoneNo: phoneNo ?? _phoneNo,
  workingHour: workingHour ?? _workingHour,
  aboutUs: aboutUs ?? _aboutUs,
  service: service ?? _service,
  image: image ?? _image,
  facebookId: facebookId ?? _facebookId,
  twitterId: twitterId ?? _twitterId,
  googleId: googleId ?? _googleId,
  instagramId: instagramId ?? _instagramId,
  consultationCharges: consultationCharges ?? _consultationCharges,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  num get id => _id;
  num get userId => _userId;
  num get departmentId => _departmentId;
  String get name => _name;
  String get email => _email;
  String get password => _password;
  String get phoneNo => _phoneNo;
  List<WorkingHour> get workingHour => _workingHour;
  String get aboutUs => _aboutUs;
  String get service => _service;
  String get image => _image;
  String get facebookId => _facebookId;
  String get twitterId => _twitterId;
  String get googleId => _googleId;
  String get instagramId => _instagramId;
  String get consultationCharges => _consultationCharges;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['user_id'] = _userId;
    map['department_id'] = _departmentId;
    map['name'] = _name;
    map['email'] = _email;
    map['password'] = _password;
    map['phone_no'] = _phoneNo;
    if (_workingHour != null) {
      map['working_hour'] = _workingHour?.map((v) => v.toJson()).toList();
    }
    map['about_us'] = _aboutUs;
    map['service'] = _service;
    map['image'] = _image;
    map['facebook_id'] = _facebookId;
    map['twitter_id'] = _twitterId;
    map['google_id'] = _googleId;
    map['instagram_id'] = _instagramId;
    map['consultation_charges'] = _consultationCharges;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }

}

/// id : 1
/// doctor_id : 1
/// day : "Monday"
/// from : "11:00 AM"
/// to : "08:00 PM"
/// created_at : "2023-02-09 11:56:44"
/// updated_at : "2023-06-27 16:46:39"
/// status : "0"

class WorkingHour {
  WorkingHour({
      num id,
      num doctorId,
      String day,
      String from,
      String to,
      String createdAt,
      String updatedAt,
      String status,}){
    _id = id;
    _doctorId = doctorId;
    _day = day;
    _from = from;
    _to = to;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _status = status;
}

  WorkingHour.fromJson(dynamic json) {
    _id = json['id'];
    _doctorId = json['doctor_id'];
    _day = json['day'];
    _from = json['from'];
    _to = json['to'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _status = json['status'];
  }
  num _id;
  num _doctorId;
  String _day;
  String _from;
  String _to;
  String _createdAt;
  String _updatedAt;
  String _status;
WorkingHour copyWith({  num id,
  num doctorId,
  String day,
  String from,
  String to,
  String createdAt,
  String updatedAt,
  String status,
}) => WorkingHour(  id: id ?? _id,
  doctorId: doctorId ?? _doctorId,
  day: day ?? _day,
  from: from ?? _from,
  to: to ?? _to,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  status: status ?? _status,
);
  num get id => _id;
  num get doctorId => _doctorId;
  String get day => _day;
  String get from => _from;
  String get to => _to;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  String get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['doctor_id'] = _doctorId;
    map['day'] = _day;
    map['from'] = _from;
    map['to'] = _to;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['status'] = _status;
    return map;
  }

}