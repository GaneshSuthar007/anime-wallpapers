
class CategoriesResponse {
  CategoriesResponse({
      num? status, 
      List<CategoriesResponseData>? data,
      String? message,}){
    _status = status;
    _data = data;
    _message = message;
}

  CategoriesResponse.fromJson(dynamic json) {
    _status = json['status'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(CategoriesResponseData.fromJson(v));
      });
    }
    _message = json['message'];
  }
  num? _status;
  List<CategoriesResponseData>? _data;
  String? _message;
  CategoriesResponse copyWith({  num? status,
  List<CategoriesResponseData>? data,
  String? message,
}) => CategoriesResponse(  status: status ?? _status,
  data: data ?? _data,
  message: message ?? _message,
);
  num? get status => _status;
  List<CategoriesResponseData>? get data => _data;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    map['message'] = _message;
    return map;
  }
}

class CategoriesResponseData {
  CategoriesResponseData({
      num? id, 
      String? name, 
      String? url,
    CategoriesResponseApp? app,}){
    _id = id;
    _name = name;
    _url = url;
    _app = app;
}

  CategoriesResponseData.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _url = json['url'];
    _app = json['app'] != null ? CategoriesResponseApp.fromJson(json['app']) : null;
  }
  num? _id;
  String? _name;
  String? _url;
  CategoriesResponseApp? _app;
  CategoriesResponseData copyWith({  num? id,
  String? name,
  String? url,
    CategoriesResponseApp? app,
}) => CategoriesResponseData(  id: id ?? _id,
  name: name ?? _name,
  url: url ?? _url,
  app: app ?? _app,
);
  num? get id => _id;
  String? get name => _name;
  String? get url => _url;
  CategoriesResponseApp? get app => _app;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['url'] = _url;
    if (_app != null) {
      map['app'] = _app?.toJson();
    }
    return map;
  }

}

class CategoriesResponseApp {
  CategoriesResponseApp({
      num? id, 
      String? name,}){
    _id = id;
    _name = name;
}

  CategoriesResponseApp.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
  }
  num? _id;
  String? _name;
  CategoriesResponseApp copyWith({  num? id,
  String? name,
}) => CategoriesResponseApp(  id: id ?? _id,
  name: name ?? _name,
);
  num? get id => _id;
  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    return map;
  }

}