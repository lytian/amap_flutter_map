import 'dart:convert';

import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_map_example/base_page.dart';
import 'package:flutter/material.dart';

class SearchDemoPage extends BasePage {
  SearchDemoPage(String title, String subTitle) : super(title, subTitle);

  @override
  Widget build(BuildContext context) {
    return _SearchDemo();
  }
}

class _SearchDemo extends StatefulWidget {
  const _SearchDemo({Key? key}) : super(key: key);

  @override
  _SearchDemoState createState() => _SearchDemoState();
}

class _SearchDemoState extends State<_SearchDemo> {
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
              final List<AMapPoiResult> r = await AMapSearch.searchByKeyword(
                  keyword: '肯德基',
                  city: '贵阳市',
              );
              setState(() {
                _result = json.encode(r.map((e) => e.toJson()).toList());
              });
            },
            child: Text('关键字搜索'),
          ),
          ElevatedButton(
            onPressed: () async {
              final List<AMapPoiResult> r = await AMapSearch.searchByAround(
                location: LatLng(26.647699, 106.650116),
                radius: 1000,
              );
              setState(() {
                _result = json.encode(r.map((e) => e.toJson()).toList());
              });
            },
            child: Text('周边搜索'),
          ),
          ElevatedButton(
            onPressed: () async {
              final r = await AMapSearch.searchByPolygon(
                polygon: [
                  LatLng(26.654182, 106.657047),
                  LatLng(26.652878, 106.624303),
                  LatLng(26.6271, 106.629624),
                  LatLng(26.628404, 106.676917),
                ],
                keyword: '停车场',
              );
              setState(() {
                _result = json.encode(r.map((e) => e.toJson()).toList());
              });
            },
            child: Text('多边形搜索'),
          ),
        ],
      ),
    );
  }
}
