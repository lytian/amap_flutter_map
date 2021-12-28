import 'package:amap_flutter_base/amap_flutter_base.dart';

class GeocodeAddress {
  GeocodeAddress({
      this.formattedAddress, 
      this.country, 
      this.province, 
      this.city, 
      this.district, 
      this.building, 
      this.neighborhood, 
      this.township, 
      this.adcode, 
      this.postcode, 
      this.location, 
      this.level,});

  GeocodeAddress.fromJson(dynamic json) {
    formattedAddress = json['formattedAddress'];
    country = json['country'];
    province = json['province'];
    city = json['city'];
    district = json['district'];
    building = json['building'];
    neighborhood = json['neighborhood'];
    township = json['township'];
    adcode = json['adcode'];
    postcode = json['postcode'];
    location = json['location'] != null ? LatLng.fromJson(json['location']) : null;
    level = json['level'];
  }
  /// 格式化地址
  String? formattedAddress;
  /// 海外生效 国家名称
  String? country;
  /// 所在省名称、直辖市的名称
  String? province;
  /// 所在城市名称
  String? city;
  /// 所在区（县）名称
  String? district;
  /// 建筑物名称
  String? building;
  /// 社区名称
  String? neighborhood;
  /// 乡镇名称
  String? township;
  /// 区域编码
  String? adcode;
  /// 海外生效 邮政编码
  String? postcode;
  /// 经纬度坐标
  LatLng? location;
  /// 匹配级别
  String? level;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['formattedAddress'] = formattedAddress;
    map['country'] = country;
    map['province'] = province;
    map['city'] = city;
    map['district'] = district;
    map['building'] = building;
    map['neighborhood'] = neighborhood;
    map['township'] = township;
    map['adcode'] = adcode;
    map['postcode'] = postcode;
    if (location != null) {
      map['location'] = location?.toJson();
    }
    map['level'] = level;
    return map;
  }

}