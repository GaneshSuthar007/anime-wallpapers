class WallpaperResponse {
  WallpaperResponse({
    num? status,
    List<WallpaperResponseData>? data,
    String? message,
  }) {
    _status = status;
    _data = data;
    _message = message;
  }

  WallpaperResponse.fromJson(dynamic json) {
    _status = json['status'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(WallpaperResponseData.fromJson(v));
      });
    }
    _message = json['message'];
  }

  num? _status;
  List<WallpaperResponseData>? _data;
  String? _message;

  WallpaperResponse copyWith({
    num? status,
    List<WallpaperResponseData>? data,
    String? message,
  }) =>
      WallpaperResponse(
        status: status ?? _status,
        data: data ?? _data,
        message: message ?? _message,
      );

  num? get status => _status;

  List<WallpaperResponseData>? get data => _data;

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

class WallpaperResponseData {
  WallpaperResponseData({
    num? id,
    String? url,
    bool? isPremium,
  }) {
    _id = id;
    _url = url;
    _isPremium = isPremium;
  }

  WallpaperResponseData.fromJson(dynamic json) {
    _id = json['id'];
    _url = json['url'];
    _isPremium = json['is_premium'];
  }

  num? _id;
  String? _url;
  bool? _isPremium;

  WallpaperResponseData copyWith({
    num? id,
    String? url,
    bool? isPremium,
  }) =>
      WallpaperResponseData(
        id: id ?? _id,
        url: url ?? _url,
        isPremium: isPremium ?? _isPremium,
      );

  num? get id => _id;

  String? get url => _url;

  bool? get isPremium => _isPremium;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['url'] = _url;
    map['is_premium'] = _isPremium;
    return map;
  }
}
