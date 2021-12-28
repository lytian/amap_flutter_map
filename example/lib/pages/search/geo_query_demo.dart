import 'dart:convert';

import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_map_example/base_page.dart';
import 'package:flutter/material.dart';

class GeoQueryPage extends BasePage {
  GeoQueryPage(String title, String subTitle) : super(title, subTitle);

  @override
  Widget build(BuildContext context) {
    return _GeoQuery();
  }
}

class _GeoQuery extends StatefulWidget {
  const _GeoQuery({Key? key}) : super(key: key);

  @override
  _GeoQueryState createState() => _GeoQueryState();
}

class _GeoQueryState extends State<_GeoQuery> {
  String? _result;

  @override
  void initState() {
    super.initState();

    AMapSearch.updatePrivacyShow(true, true);
    AMapSearch.updatePrivacyAgree(true);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 250,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.grey,
                width: 1
              ),
              borderRadius: BorderRadius.circular(5.0)
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(5),
              child: Text(_result ?? ''),
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () async {
              final List<GeocodeAddress> r = await AMapSearch.geocodeQuery(
                  address: '长岭北路贵阳农商银行大厦',
                  city: '贵阳市',
              );
              setState(() {
                _result = json.encode(r.map((e) => e.toJson()).toList());
              });
            },
            child: Text('地址编码'),
          ),
          ElevatedButton(
            onPressed: () async {
              final RegeocodeAddress r = await AMapSearch.regeocodeQuery(
                location: LatLng(26.647699, 106.650116),
              );
              setState(() {
                _result = r.formattedAddress;
              });
            },
            child: Text('逆地址编码'),
          ),
        ],
      ),
    );
  }
}
