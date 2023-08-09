/// status : 1
/// msg : "Register Successfully"
/// data : {"name":"name","email":"rajudcdr4aja@gmail.com","login_type":1,"phone_no":"9696969656","usertype":1,"profile_pic":"https://completewomencares.com/public/upload/profile/profile_352527.png","updated_at":"2023-06-19T08:30:51.000000Z","created_at":"2023-06-19T08:30:51.000000Z","id":71}

class SignUpModel {
  SignUpModel({
      num status,
      String msg,
      Data data,}){
    _status = status;
    _msg = msg;
    _data = data;
}

  SignUpModel.fromJson(dynamic json) {
    _status = json['status'];
    _msg = json['msg'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  num _status;
  String _msg;
  Data _data;
SignUpModel copyWith({  num status,
  String msg,
  Data data,
}) => SignUpModel(  status: status ?? _status,
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

/// name : "name"
/// email : "rajudcdr4aja@gmail.com"
/// login_type : 1
/// phone_no : "9696969656"
/// usertype : 1
/// profile_pic : "https://completewomencares.com/public/upload/profile/profile_352527.png"
/// updated_at : "2023-06-19T08:30:51.000000Z"
/// created_at : "2023-06-19T08:30:51.000000Z"
/// id : 71

class Data {
  Data({
      String name,
      String email,
      num loginType,
      String phoneNo,
      num usertype,
      String profilePic,
      String updatedAt,
      String createdAt,
      num id,}){
    _name = name;
    _email = email;
    _loginType = loginType;
    _phoneNo = phoneNo;
    _usertype = usertype;
    _profilePic = profilePic;
    _updatedAt = updatedAt;
    _createdAt = createdAt;
    _id = id;
}

  Data.fromJson(dynamic json) {
    _name = json['name'];
    _email = json['email'];
    _loginType = json['login_type'];
    _phoneNo = json['phone_no'];
    _usertype = json['usertype'];
    _profilePic = json['profile_pic'];
    _updatedAt = json['updated_at'];
    _createdAt = json['created_at'];
    _id = json['id'];
  }
  String _name;
  String _email;
  num _loginType;
  String _phoneNo;
  num _usertype;
  String _profilePic;
  String _updatedAt;
  String _createdAt;
  num _id;
Data copyWith({  String name,
  String email,
  num loginType,
  String phoneNo,
  num usertype,
  String profilePic,
  String updatedAt,
  String createdAt,
  num id,
}) => Data(  name: name ?? _name,
  email: email ?? _email,
  loginType: loginType ?? _loginType,
  phoneNo: phoneNo ?? _phoneNo,
  usertype: usertype ?? _usertype,
  profilePic: profilePic ?? _profilePic,
  updatedAt: updatedAt ?? _updatedAt,
  createdAt: createdAt ?? _createdAt,
  id: id ?? _id,
);
  String get name => _name;
  String get email => _email;
  num get loginType => _loginType;
  String get phoneNo => _phoneNo;
  num get usertype => _usertype;
  String get profilePic => _profilePic;
  String get updatedAt => _updatedAt;
  String get createdAt => _createdAt;
  num get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['email'] = _email;
    map['login_type'] = _loginType;
    map['phone_no'] = _phoneNo;
    map['usertype'] = _usertype;
    map['profile_pic'] = _profilePic;
    map['updated_at'] = _updatedAt;
    map['created_at'] = _createdAt;
    map['id'] = _id;
    return map;
  }

}