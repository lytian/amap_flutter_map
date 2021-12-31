import 'dart:math';

import 'package:amap_flutter_map_example/base_page.dart';
import 'package:amap_flutter_map_example/widgets/amap_switch_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';

class CircleDemoPage extends BasePage {
  CircleDemoPage(String title, String subTitle) : super(title, subTitle);
  @override
  Widget build(BuildContext context) {
    return _Body();
  }
}

class _Body extends StatefulWidget {
  const _Body();

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<_Body> {
  _State();
  static final LatLng mapCenter = const LatLng(39.909187, 116.397451);

// Values when toggling Circle color
  int colorsIndex = 0;
  double zIndex = 1;
  List<Color> colors = <Color>[
    Colors.purple,
    Colors.red,
    Colors.green,
    Colors.pink,
  ];

  Map<String, Circle> _circles = <String, Circle>{};
  String? selectedCircleId;

  void _onMapCreated(AMapController controller) {}

  LatLng _createCenter() {
    final int circleCount = _circles.length;
    LatLng circleCenter = LatLng(
        mapCenter.latitude + sin(circleCount * pi / 12.0) / 20.0,
        mapCenter.longitude + cos(circleCount * pi / 12.0) / 20.0);
    return circleCenter;
  }

  void _add() {
    final Circle circle = Circle(
      center: _createCenter(),
      radius: 1500,
      strokeColor: colors[++colorsIndex % colors.length],
      fillColor: colors[(colorsIndex + 1) % colors.length].withOpacity(0.2),
      strokeWidth: 3,
    );
    setState(() {
      selectedCircleId = circle.id;
      _circles[circle.id] = circle;
    });
  }

  void _remove() {
    if(selectedCircleId != null) {
      //有选中的Marker
      setState(() {
        _circles.remove(selectedCircleId);
      });
    }

  }

  void _changeStrokeWidth() {
    final Circle? selectedCircle = _circles[selectedCircleId];
    if(selectedCircle != null) {
      double currentWidth = selectedCircle.strokeWidth;
      if (currentWidth < 12) {
        currentWidth += 3;
      } else {
        currentWidth = 3;
      }
      //有选中的Circle
      setState(() {
        _circles[selectedCircleId!] =
            selectedCircle.copyWith(strokeWidthParam: currentWidth);
      });
    } else {
      print('无选中的Circle，无法修改宽度');
    }
  }

  void _changeStrokeType() {
    final Circle? selectedCircle = _circles[selectedCircleId];
    if(selectedCircle != null) {
      DashLineType dashType = selectedCircle.strokeDottedLineType;
      if (dashType == DashLineType.none) {
        dashType = DashLineType.circle;
      } else if (dashType == DashLineType.circle) {
        dashType = DashLineType.square;
      } else if (dashType == DashLineType.square) {
        dashType = DashLineType.none;
      }
      //有选中的Circle
      setState(() {
        _circles[selectedCircleId!] =
            selectedCircle.copyWith(strokeDottedLineTypeParam: dashType);
      });
    } else {
      print('无选中的Circle，无法修改宽度');
    }
  }

  void _changeRadius() {
    final Circle? selectedCircle = _circles[selectedCircleId];
    if(selectedCircle != null) {
      double currentRadius = selectedCircle.radius;
      if (currentRadius < 2000) {
        currentRadius += 500;
      } else {
        currentRadius = 1000;
      }
      //有选中的Circle
      setState(() {
        _circles[selectedCircleId!] =
            selectedCircle.copyWith(radiusParam: currentRadius);
      });
    } else {
      print('无选中的Circle，无法修改宽度');
    }
  }

  void _changeZIndex() {
    final Circle? selectedCircle = _circles[selectedCircleId];
    if(selectedCircle != null) {
      double currentZIndex = selectedCircle.zIndex;
      if (currentZIndex <= 0) {
        currentZIndex = ++zIndex;
      } else {
        currentZIndex = 0;
      }
      //有选中的Circle
      setState(() {
        _circles[selectedCircleId!] =
            selectedCircle.copyWith(zIndexParam: currentZIndex);
      });
    } else {
      print('无选中的Circle，无法修改宽度');
    }
  }

  void _changeColors() {
    final Circle circle = _circles[selectedCircleId]!;
    setState(() {
      _circles[selectedCircleId!] = circle.copyWith(
        strokeColorParam: colors[++colorsIndex % colors.length],
        fillColorParam: colors[(colorsIndex + 1) % colors.length].withOpacity(0.3),
      );
    });
  }

  Future<void> _toggleVisible(value) async {
    final Circle circle = _circles[selectedCircleId]!;
    setState(() {
      _circles[selectedCircleId!] = circle.copyWith(
        visibleParam: value,
      );
    });
  }

  void _changeCenter() {
    final Circle circle = _circles[selectedCircleId]!;
    final LatLng current = circle.center;
    final Offset offset = Offset(
      mapCenter.latitude - current.latitude,
      mapCenter.longitude - current.longitude,
    );
    setState(() {
      _circles[selectedCircleId!] = circle.copyWith(
        centerParam: LatLng(
          mapCenter.latitude + offset.dy,
          mapCenter.longitude + offset.dx,
        ),
      );
    });
  }

  void _removeAll() {
    if (_circles.length > 0) {
      setState(() {
        _circles.clear();
        selectedCircleId = null.toString();
      });
    }
  }

  void _onMapTap(LatLng location) {
    _circles..forEach((id, circle) {
      double radius = circle.radius;
      if (AMapTools.distanceBetween(location, circle.center) < radius) {
        if (selectedCircleId != id) {
          ++zIndex;
        }
        selectedCircleId = id;
        //有选中的Circle
        final Circle? selectedCircle = _circles[selectedCircleId];
        setState(() {
          _circles[selectedCircleId!] =
              selectedCircle!.copyWith(zIndexParam: zIndex);
        });
        print(zIndex);
        return;
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AMapWidget map = AMapWidget(
      initialCameraPosition:
          CameraPosition(target: mapCenter, zoom: 13),
      onMapCreated: _onMapCreated,
      onTap: _onMapTap,
      circles: Set<Circle>.of(_circles.values),
    );
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width,
            child: map,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          TextButton(
                            child: const Text('添加'),
                            onPressed: _add,
                          ),
                          TextButton(
                            child: const Text('删除'),
                            onPressed:
                                (selectedCircleId == null) ? null : _remove,
                          ),
                          TextButton(
                            child: const Text('修改边框宽度'),
                            onPressed: (selectedCircleId == null)
                                ? null
                                : _changeStrokeWidth,
                          ),
                          TextButton(
                            child: const Text('修改边框类型'),
                            onPressed: (selectedCircleId == null)
                                ? null
                                : _changeStrokeType,
                          ),
                          TextButton(
                            child: const Text('修改半径'),
                            onPressed: (selectedCircleId == null)
                                ? null
                                : _changeRadius,
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          TextButton(
                            child: const Text('全部移除'),
                            onPressed: _circles.length > 0 ? _removeAll : null,
                          ),
                          TextButton(
                            child: const Text('修改边框和填充色'),
                            onPressed: (selectedCircleId == null)
                                ? null
                                : _changeColors,
                          ),
                          AMapSwitchButton(
                            label: Text('显示'),
                            onSwitchChanged: (selectedCircleId == null)
                                ? null
                                : _toggleVisible,
                            defaultValue: true,
                          ),
                          TextButton(
                            child: const Text('修改坐标'),
                            onPressed: (selectedCircleId == null)
                                ? null
                                : _changeCenter,
                          ),
                          TextButton(
                            child: const Text('修改层级'),
                            onPressed: (selectedCircleId == null)
                                ? null
                                : _changeZIndex,
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
