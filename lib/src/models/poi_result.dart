import 'package:amap_flutter_base/amap_flutter_base.dart';

class PoiResult {
  PoiResult({
      this.poiId, 
      this.title, 
      this.snippet, 
      this.postcode, 
      this.provinceCode, 
      this.provinceName, 
      this.cityCode, 
      this.cityName, 
      this.adCode, 
      this.adName, 
      this.typeCode, 
      this.typeDes, 
      this.parkingType, 
      this.businessArea, 
      this.direction, 
      this.distance, 
      this.email, 
      this.tel, 
      this.website, 
      this.isIndoorMap, 
      this.latLonPoint, 
      this.enter, 
      this.exit, 
      this.photos, 
      this.subPois,});

  PoiResult.fromJson(dynamic json) {
    poiId = json['poiId'];
    title = json['title'];
    snippet = json['snippet'];
    postcode = json['postcode'];
    provinceCode = json['provinceCode'];
    provinceName = json['provinceName'];
    cityCode = json['cityCode'];
    cityName = json['cityName'];
    adCode = json['adCode'];
    adName = json['adName'];
    typeCode = json['typeCode'];
    typeDes = json['typeDes'];
    parkingType = json['parkingType'];
    businessArea = json['businessArea'];
    direction = json['direction'];
    distance = json['distance'];
    email = json['email'];
    tel = json['tel'];
    website = json['website'];
    isIndoorMap = json['isIndoorMap'];
    latLonPoint = json['latLonPoint'] != null ? LatLng.fromJson(json['latLonPoint']) : null;
    enter = json['enter'] != null ? LatLng.fromJson(json['enter']) : null;
    exit = json['exit'] != null ? LatLng.fromJson(json['exit']) : null;
    photos = json['photos'] != null ? AMapPhoto.fromJson(json['photos']) : null;
    if (json['subPois'] != null) {
      subPois = [];
      json['subPois'].forEach((v) {
        subPois?.add(AMapSubPoi.fromJson(v));
      });
    }
  }

  /// id, 唯一标识
  String? poiId;
  /// 名称
  String? title;
  /// 地址
  String? snippet;
  /// 邮编
  String? postcode;
  /// 省/自治区/直辖市/特别行政区编码
  String? provinceCode;
  /// 省/自治区/直辖市/特别行政区名称
  String? provinceName;
  /// 城市编码
  String? cityCode;
  /// 城市名称
  String? cityName;
  /// 行政区域代码
  String? adCode;
  /// 行政区域名称
  String? adName;
  /// 兴趣点类型编码
  String? typeCode;
  /// 兴趣点类型描述
  String? typeDes;
  /// 停车场类型
  String? parkingType;
  /// 所在商圈
  String? businessArea;
  /// POI坐标点相对于地理坐标点的方
  String? direction;
  /// 距离中心点的距离
  int? distance;
  /// 电子邮件地址
  String? email;
  /// 电话号码
  String? tel;
  /// POI的网址
  String? website;
  /// 返回是否支持室内地图
  bool? isIndoorMap;
  /// 经纬度坐标
  /// 如果使用该POI进行导航时，可以检查POI是否有exit 和 enter，如果有建议使用它们作为导航的起终点
  LatLng? latLonPoint;
  /// 入口经纬度
  LatLng? enter;
  /// 出口经纬度
  LatLng? exit;
  /// 图片信息
  AMapPhoto? photos;
  /// 子POI信息
  List<AMapSubPoi>? subPois;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['poiId'] = poiId;
    map['title'] = title;
    map['snippet'] = snippet;
    map['postcode'] = postcode;
    map['provinceCode'] = provinceCode;
    map['provinceName'] = provinceName;
    map['cityCode'] = cityCode;
    map['cityName'] = cityName;
    map['adCode'] = adCode;
    map['adName'] = adName;
    map['typeCode'] = typeCode;
    map['typeDes'] = typeDes;
    map['parkingType'] = parkingType;
    map['businessArea'] = businessArea;
    map['direction'] = direction;
    map['distance'] = distance;
    map['email'] = email;
    map['tel'] = tel;
    map['website'] = website;
    map['isIndoorMap'] = isIndoorMap;
    if (latLonPoint != null) {
      map['latLonPoint'] = latLonPoint?.toJson();
    }
    if (enter != null) {
      map['enter'] = enter?.toJson();
    }
    if (exit != null) {
      map['exit'] = exit?.toJson();
    }
    if (photos != null) {
      map['photos'] = photos?.toJson();
    }
    if (subPois != null) {
      map['subPois'] = subPois?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class AMapSubPoi {
  AMapSubPoi({
      this.poiId, 
      this.title, 
      this.subTypeDes, 
      this.subName, 
      this.snippet, 
      this.distance, 
      this.latLon, });

  AMapSubPoi.fromJson(dynamic json) {
    poiId = json['poiId'];
    title = json['title'];
    subTypeDes = json['subTypeDes'];
    subName = json['subName'];
    snippet = json['snippet'];
    distance = json['distance'];
    latLon = json['latLon'] != null ? LatLng.fromJson(json['latLon']) : null;
  }
  String? poiId;
  String? title;
  String? subTypeDes;
  String? subName;
  String? snippet;
  int? distance;
  LatLng? latLon;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['poiId'] = poiId;
    map['title'] = title;
    map['subTypeDes'] = subTypeDes;
    map['subName'] = subName;
    map['snippet'] = snippet;
    map['distance'] = distance;
    map['latLon'] = latLon?.toJson();
    return map;
  }

}

class AMapPhoto {
  AMapPhoto({
      this.title, 
      this.url,});

  AMapPhoto.fromJson(dynamic json) {
    title = json['title'];
    url = json['url'];
  }
  String? title;
  String? url;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['url'] = url;
    return map;
  }

}