/// status : 1
/// msg : "Appointment Added Successfully"
/// data : {"id":204,"price":"800"}

class BookAppoinmentModel {
  BookAppoinmentModel({
      num status, 
      String msg, 
      Data data,}){
    _status = status;
    _msg = msg;
    _data = data;
}

  BookAppoinmentModel.fromJson(dynamic json) {
    _status = json['status'];
    _msg = json['msg'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  num _status;
  String _msg;
  Data _data;
BookAppoinmentModel copyWith({  num status,
  String msg,
  Data data,
}) => BookAppoinmentModel(  status: status ?? _status,
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
      map['data'] = _data.toJson();
    }
    return map;
  }

}

/// id : 204
/// price : "800"

class Data {
  Data({
      num id, 
      String price,}){
    _id = id;
    _price = price;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _price = json['price'];
  }
  num _id;
  String _price;
Data copyWith({  num id,
  String price,
}) => Data(  id: id ?? _id,
  price: price ?? _price,
);
  num get id => _id;
  String get price => _price;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['price'] = _price;
    return map;
  }

}