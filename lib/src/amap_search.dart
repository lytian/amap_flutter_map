part of amap_flutter_map;


class AMapSearch {

  static const MethodChannel _methodChannel = const MethodChannel('com.amap.flutter.search');

  /// 设置是否已经包含高德隐私政策并弹窗展示显示用户查看，如果未包含或者没有弹窗展示，高德定位SDK将不会工作<br>
  /// 高德SDK合规使用方案请参考官网地址：https://lbs.amap.com/news/sdkhgsy<br>
  /// <b>必须保证在调用定位功能之前调用， 建议首次启动App时弹出《隐私政策》并取得用户同意</b><br>
  /// 高德SDK合规使用方案请参考官网地址：https://lbs.amap.com/news/sdkhgsy
  /// [hasContains] 隐私声明中是否包含高德隐私政策说明<br>
  /// [hasShow] 隐私权政策是否弹窗展示告知用户<br>
  static void updatePrivacyShow(bool hasContains, bool hasShow) {
    _methodChannel
        .invokeMethod('updatePrivacyStatement', {'hasContains': hasContains, 'hasShow': hasShow});
  }

  /// 设置是否已经取得用户同意，如果未取得用户同意，高德定位SDK将不会工作<br>
  /// 高德SDK合规使用方案请参考官网地址：https://lbs.amap.com/news/sdkhgsy<br>
  /// <b>必须保证在调用定位功能之前调用, 建议首次启动App时弹出《隐私政策》并取得用户同意</b><br>
  /// [hasAgree] 隐私权政策是否已经取得用户同意<br>
  static void updatePrivacyAgree(bool hasAgree) {
    _methodChannel
        .invokeMethod('updatePrivacyStatement', {'hasAgree': hasAgree});
  }

  /// 设置Android和iOS的apikey，建议在weigdet初始化时设置<br>
  /// apiKey的申请请参考高德开放平台官网<br>
  /// Android端: https://lbs.amap.com/api/android-location-sdk/guide/create-project/get-key<br>
  /// iOS端: https://lbs.amap.com/api/ios-location-sdk/guide/create-project/get-key<br>
  /// [androidKey] Android平台的key<br>
  /// [iosKey] ios平台的key<br>
  static void setApiKey(String androidKey, String iosKey) {
    _methodChannel
        .invokeMethod('setApiKey', {'androidKey': androidKey, 'iosKey': iosKey});
  }

  /// 关键字检索<br>
  /// keyword或者types二选一必填<br>
  /// [keyword] 关键字<br>
  /// [type] 指定地点类型<br>
  /// [city] 查询城市。可填城市编码、城市名称<br>
  /// [pageNum] 第几页<br>
  /// [pageSize] 数据条数<br>
  static Future<List<PoiResult>> searchByKeyword({
    required String keyword,
    String? type,
    String? city,
    int? pageNum = 1,
    int? pageSize = 20,
  }) async {
    final r = await _methodChannel.invokeMethod('poiSearch', {
      "keyword": keyword,
      "type": type,
      "city": city,
      "pageNum": pageNum,
      "pageSize": pageSize,
    });
    if (r != null) {
      return (r as List).map((e) => PoiResult.fromJson(e)).toList();
    }
    return [];
  }

  /// 周边检索<br>
  /// [location] 中心点坐标<br>
  /// [radius] 搜索半径。取值范围:0-50000，大于50000时按默认值，单位：米<br>
  /// [keyword] 关键字<br>
  /// [type] 指定地点类型<br>
  /// [city] 查询城市。可填城市编码、城市名称<br>
  /// [pageNum] 第几页<br>
  /// [pageSize] 数据条数<br>
  static Future<List<PoiResult>> searchByAround({
    required LatLng? location,
    int? radius = 3000,
    String? keyword,
    String? type,
    String? city,
    int? pageNum = 1,
    int? pageSize = 20,
  }) async {
    final r = await _methodChannel.invokeMethod('poiSearch', {
      "keyword": keyword,
      "type": type,
      "city": city,
      "pageNum": pageNum,
      "pageSize": pageSize,
      "location": location?.toJson(),
      "radius": radius,
    });
    if (r != null) {
      return (r as List).map((e) => PoiResult.fromJson(e)).toList();
    }
    return [];
  }

  /// 多边形内检索<br>
  /// [polygon] 多边形范围，由多个[LatLng]组成<br>
  /// [keyword] 关键字<br>
  /// [type] 指定地点类型<br>
  /// [city] 查询城市。可填城市编码、城市名称<br>
  /// [pageNum] 第几页<br>
  /// [pageSize] 数据条数<br>
  static Future<List<PoiResult>> searchByPolygon({
    required List<LatLng>? polygon,
    String? keyword,
    String? type,
    String? city,
    int? pageNum = 1,
    int? pageSize = 20,
  }) async {
    final r = await _methodChannel.invokeMethod('poiSearch', {
      "keyword": keyword,
      "type": type,
      "city": city,
      "pageNum": pageNum,
      "pageSize": pageSize,
      "polygon": polygon?.map((e) => e.toJson()).toList(),
    });
    if (r != null) {
      return (r as List).map((e) => PoiResult.fromJson(e)).toList();
    }
    return [];
  }

  /// 地址编码<br>
  /// [address] 地址<br>
  /// [city] 查询城市。可填城市编码、城市名称<br>
  static Future<List<GeocodeAddress>> geocodeQuery({
    required String address,
    String? city,
  }) async {
    final r = await _methodChannel.invokeMethod('geocodeQuery', {
      "address": address,
      "city": city,
    });
    if (r != null) {
      return (r as List).map((e) => GeocodeAddress.fromJson(e)).toList();
    }
    return [];
  }
  
  /// 逆地址编码<br>
  /// [location] 经纬度<br>
  /// [radius] 搜索半径。取值范围:0-50000，大于50000时按默认值，单位：米<br>
  /// [mapType] GPS类型<br>
  static Future<RegeocodeAddress> regeocodeQuery({
    required LatLng location,
    int? radius = 1000,
    MapGPSType? gpsType,
  }) async {
    final r = await _methodChannel.invokeMethod('regeocodeQuery', {
      "location": location.toJson(),
      "radius": radius,
      "gpsType": gpsType == MapGPSType.GPS ? 'gps' : 'autonavi',
    });
    return RegeocodeAddress.fromJson(r);
  }

}