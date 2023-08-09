/// status : 1
/// msg : "Get Gallery"
/// data : [{"id":1,"name":"Infertility","description":"i treat infertility patient,","gallery":[{"id":1,"image":"https://completewomencares.com/public/upload/gallery/63e4f743dcf41.png"},{"id":8,"image":"https://completewomencares.com/public/upload/gallery/6447b9aa072e4.jpg"},{"id":9,"image":"https://completewomencares.com/public/upload/gallery/6447c39881e83.jpg"},{"id":10,"image":"https://completewomencares.com/public/upload/gallery/6447c42b312a4.jpg"}]},{"id":3,"name":"Mohammed umar Mansoori","description":"Mohammed umar Mansoori Description","gallery":[{"id":3,"image":"https://completewomencares.com/public/upload/gallery/6447b8f7122c7.jpg"},{"id":5,"image":"https://completewomencares.com/public/upload/gallery/6447b93defeb2.jpg"},{"id":6,"image":"https://completewomencares.com/public/upload/gallery/6447b950edb95.jpg"}]},{"id":4,"name":"Women's day","description":"we celebrate womens day","gallery":[{"id":11,"image":"https://completewomencares.com/public/upload/gallery/6447c4bc53e8e.jpg"}]},{"id":5,"name":"life care hospital","description":"gynac hospital","gallery":[{"id":15,"image":"https://completewomencares.com/public/upload/gallery/644d0e41ebc47.jpg"}]},{"id":6,"name":"stripe","description":"we celebrate womens day","gallery":[{"id":12,"image":"https://completewomencares.com/public/upload/gallery/644c8ec7cd336.jpg"},{"id":13,"image":"https://completewomencares.com/public/upload/gallery/644c8f52be5b7.jpg"},{"id":14,"image":"https://completewomencares.com/public/upload/gallery/644c8f7000e4e.jpg"}]},{"id":7,"name":"LIFE CARE HOSPITAL","description":",,,,,,,,,","gallery":[{"id":17,"image":"https://completewomencares.com/public/upload/gallery/6450e18bb0335. 2"}]}]

class GalleryModel {
  GalleryModel({
      num status,
      String msg,
      List<Data> data,}){
    _status = status;
    _msg = msg;
    _data = data;
}

  GalleryModel.fromJson(dynamic json) {
    _status = json['status'];
    _msg = json['msg'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  num _status;
  String _msg;
  List<Data> _data;
GalleryModel copyWith({ num status,
  String msg,
  List<Data> data,
}) => GalleryModel(  status: status ?? _status,
  msg: msg ?? _msg,
  data: data ?? _data,
);
  num get status => _status;
  String get msg => _msg;
  List<Data> get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['msg'] = _msg;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 1
/// name : "Infertility"
/// description : "i treat infertility patient,"
/// gallery : [{"id":1,"image":"https://completewomencares.com/public/upload/gallery/63e4f743dcf41.png"},{"id":8,"image":"https://completewomencares.com/public/upload/gallery/6447b9aa072e4.jpg"},{"id":9,"image":"https://completewomencares.com/public/upload/gallery/6447c39881e83.jpg"},{"id":10,"image":"https://completewomencares.com/public/upload/gallery/6447c42b312a4.jpg"}]

class Data {
  Data({
      num id,
      String name,
      String description,
      List<Gallery> gallery,}){
    _id = id;
    _name = name;
    _description = description;
    _gallery = gallery;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _description = json['description'];
    if (json['gallery'] != null) {
      _gallery = [];
      json['gallery'].forEach((v) {
        _gallery?.add(Gallery.fromJson(v));
      });
    }
  }
  num _id;
  String _name;
  String _description;
  List<Gallery> _gallery;
Data copyWith({  num id,
  String name,
  String description,
  List<Gallery> gallery,
}) => Data(  id: id ?? _id,
  name: name ?? _name,
  description: description ?? _description,
  gallery: gallery ?? _gallery,
);
  num get id => _id;
  String get name => _name;
  String get description => _description;
  List<Gallery> get gallery => _gallery;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['description'] = _description;
    if (_gallery != null) {
      map['gallery'] = _gallery?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 1
/// image : "https://completewomencares.com/public/upload/gallery/63e4f743dcf41.png"

class Gallery {
  Gallery({
      num id,
      String image,}){
    _id = id;
    _image = image;
}

  Gallery.fromJson(dynamic json) {
    _id = json['id'];
    _image = json['image'];
  }
  num _id;
  String _image;
Gallery copyWith({  num id,
  String image,
}) => Gallery(  id: id ?? _id,
  image: image ?? _image,
);
  num get id => _id;
  String get image => _image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['image'] = _image;
    return map;
  }

}