enum MapGPSType {
  /// 火系坐标系
  AMap,

  /// GPS原生坐标系
  GPS,
}

class RegeocodeAddress {
  RegeocodeAddress({
      this.formattedAddress, 
      this.country, 
      this.countryCode, 
      this.province, 
      this.city, 
      this.cityCode, 
      this.district, 
      this.building, 
      this.neighborhood, 
      this.township, 
      this.towncode,
      this.adCode,});

  RegeocodeAddress.fromJson(dynamic json) {
    formattedAddress = json['formattedAddress'];
    country = json['country'];
    countryCode = json['countryCode'];
    province = json['province'];
    city = json['city'];
    cityCode = json['cityCode'];
    district = json['district'];
    building = json['building'];
    neighborhood = json['neighborhood'];
    township = json['township'];
    towncode = json['towncode'];
    adCode = json['adCode'];
  }

  /// 格式化地址
  String? formattedAddress;
  /// 国家名称
  String? country;
  /// 海外生效 国家简码
  String? countryCode;
  /// 所在省名称、直辖市的名称
  String? province;
  /// 城市名称
  String? city;
  /// 城市编码
  String? cityCode;
  /// 所在区（县）名称
  String? district;
  /// 建筑物名称
  String? building;
  /// 社区名称
  String? neighborhood;
  /// 乡镇名称
  String? township;
  /// 乡镇街道编码
  String? towncode;
  /// 所在区（县）的编码
  String? adCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['formattedAddress'] = formattedAddress;
    map['country'] = country;
    map['countryCode'] = countryCode;
    map['province'] = province;
    map['city'] = city;
    map['cityCode'] = cityCode;
    map['district'] = district;
    map['building'] = building;
    map['neighborhood'] = neighborhood;
    map['township'] = township;
    map['towncode'] = towncode;
    map['adCode'] = adCode;
    return map;
  }

}