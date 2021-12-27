package com.amap.flutter.map;

import android.content.Context;

import androidx.annotation.NonNull;

import com.amap.api.maps.MapsInitializer;
import com.amap.api.services.core.AMapException;
import com.amap.api.services.core.LatLonPoint;
import com.amap.api.services.core.PoiItem;
import com.amap.api.services.poisearch.Photo;
import com.amap.api.services.poisearch.PoiResult;
import com.amap.api.services.poisearch.PoiSearch;
import com.amap.api.services.poisearch.SubPoiItem;
import com.amap.flutter.map.utils.LogUtil;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

/**
 * @Author: Vincent
 * @CreateAt: 2021/12/23 23:06
 * @Desc:
 */
public class AMapFlutterSearch implements FlutterPlugin, MethodChannel.MethodCallHandler {

    private static final String CLASS_NAME = "AMapFlutterSearch";

    private static final String CHANNEL_NAME = "com.amap.flutter.search";
    private MethodChannel channel;
    private Context context;
    private MethodChannel.Result result;

    public AMapFlutterSearch() {
    }
    
    @SuppressWarnings("deprecation")
    public static void registerWith(io.flutter.plugin.common.PluginRegistry.Registrar registrar) {
        LogUtil.i(CLASS_NAME, "registerWith==>");
        AMapFlutterSearch instance = new AMapFlutterSearch();
        instance.setup(registrar.messenger(), registrar.context());
    }


    public void setup(BinaryMessenger messenger, Context context) {
        if (channel != null) {
            return;
        }
        this.context = context;
        channel = new MethodChannel(messenger, CHANNEL_NAME);
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        LogUtil.i(CLASS_NAME, "onAttachedToEngine==>");
        setup(binding.getBinaryMessenger(), binding.getApplicationContext());
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        LogUtil.i(CLASS_NAME, "onDetachedFromEngine==>");
        channel.setMethodCallHandler(null);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        LogUtil.i(CLASS_NAME, "onMethodCall==>" + call.method + ", arguments==> " + call.arguments);
        String method = call.method;
        this.result = result;
        switch (method) {
            case "updatePrivacyStatement":
                updatePrivacyStatement((Map) call.arguments);
                break;
            case "poiSearch":
                try {
                    poiSearch((Map) call.arguments);
                } catch (AMapException e) {
                    e.printStackTrace();
                    result.error(e.getErrorType(), e.getMessage(), "");
                }
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private void updatePrivacyStatement(Map<String, Boolean> privacyShowMap) {
        if (null != privacyShowMap) {
            if (privacyShowMap.containsKey("hasContains") && privacyShowMap.containsKey("hasShow")) {
                boolean hasContains = privacyShowMap.get("hasContains");
                boolean hasShow = privacyShowMap.get("hasShow");
                MapsInitializer.updatePrivacyShow(context, hasContains, hasShow);
            }

            if (privacyShowMap.containsKey("hasAgree")) {
                boolean hasAgree = privacyShowMap.get("hasAgree");
                MapsInitializer.updatePrivacyAgree(context, hasAgree);
            }
        }
    }

    private void poiSearch(Map<String, Object> params) throws AMapException {
        PoiSearch.Query query = new PoiSearch.Query(
            (String) params.get("keyword"),
            (String) params.get("type"),
            (String) params.get("city")
        );
        query.setPageNum((int) params.get("pageNum"));
        query.setPageSize((int) params.get("pageSize"));
        PoiSearch poiSearch = new PoiSearch(context, query);
        if (params.containsKey("location") && params.get("location") != null) {
            // 周边搜索
            List<Double> location = (List<Double>) params.get("location");
            poiSearch.setBound(new PoiSearch.SearchBound(
                new LatLonPoint(location.get(0), location.get(1)),
                params.get("radius") == null ? 3000 : (int) params.get("radius")
            ));
        } else if (params.containsKey("polygon") && params.get("polygon") != null) {
            // 多边形搜索
            List<List<Double>> polygon = (List<List<Double>>) params.get("polygon");
            List<LatLonPoint> pointList = new ArrayList<>();
            for (List<Double> p: polygon) {
                pointList.add(new LatLonPoint(p.get(0), p.get(1)));
            }
            poiSearch.setBound(new PoiSearch.SearchBound(pointList));
        }
        poiSearch.setOnPoiSearchListener(onPoiSearchListener);
        poiSearch.searchPOIAsyn();
    }

    final PoiSearch.OnPoiSearchListener onPoiSearchListener = new PoiSearch.OnPoiSearchListener() {
        @Override
        public void onPoiSearched(PoiResult poiResult, int i) {
            if (poiResult == null) {
                result.success(new ArrayList<>());
                return;
            }
            List<PoiItem> pois = poiResult.getPois();
            List<Map<String, Object>> arr = new ArrayList<>();
            Map<String, Object> map;
            for (PoiItem poi: pois) {
                map = new HashMap<>();
                map.put("poiId", poi.getPoiId());
                map.put("title", poi.getTitle());
                map.put("snippet", poi.getSnippet());
                map.put("postcode", poi.getPostcode());
                map.put("provinceCode", poi.getProvinceCode());
                map.put("provinceName", poi.getProvinceName());
                map.put("cityCode", poi.getCityCode());
                map.put("cityName", poi.getCityName());
                map.put("adCode", poi.getAdCode());
                map.put("adName", poi.getAdName());
                map.put("typeCode", poi.getTypeCode());
                map.put("typeDes", poi.getTypeDes());
                map.put("parkingType", poi.getParkingType());
                map.put("businessArea", poi.getBusinessArea());
                map.put("direction", poi.getDirection());
                map.put("distance", poi.getDistance());
                map.put("email", poi.getEmail());
                map.put("tel", poi.getTel());
                map.put("website", poi.getWebsite());
                map.put("isIndoorMap", poi.isIndoorMap());
                // 经纬度
                map.put("latLonPoint", new double[]{ poi.getLatLonPoint().getLatitude(), poi.getLatLonPoint().getLongitude()} );
                if (poi.getEnter() != null) {
                    map.put("latLonPoint", new double[]{ poi.getEnter().getLatitude(), poi.getEnter().getLongitude()} );
                }
                if (poi.getExit() != null) {
                    map.put("latLonPoint", new double[]{ poi.getExit().getLatitude(), poi.getExit().getLongitude()} );
                }
                // 图片
                if (poi.getPhotos() != null && !poi.getPhotos().isEmpty()) {
                    List<Map<String, String>> photos = new ArrayList<>();
                    for (Photo p: poi.getPhotos()) {
                        Map<String, String> photo = new HashMap<>();
                        photo.put("title", p.getTitle());
                        photo.put("url", p.getUrl());
                        photos.add(photo);
                    }
                    map.put("photos", photos);
                }
                // 子POI信息
                if (poi.getSubPois() != null && !poi.getSubPois().isEmpty()) {
                    List<Map<String, Object>> subPois = new ArrayList<>();
                    for (SubPoiItem item: poi.getSubPois()) {
                        Map<String, Object> subPoi = new HashMap<>();
                        subPoi.put("poiId", item.getPoiId());
                        subPoi.put("title", item.getTitle());
                        subPoi.put("subTypeDes", item.getSubTypeDes());
                        subPoi.put("subName", item.getSubName());
                        subPoi.put("snippet", item.getSnippet());
                        subPoi.put("distance", item.getDistance());
                        subPoi.put("latLon", new double[] { item.getLatLonPoint().getLatitude(), item.getLatLonPoint().getLongitude() });
                        subPois.add(subPoi);
                    }
                    map.put("subPois", subPois);
                }
                arr.add(map);
            }
            result.success(arr);
        }

        @Override
        public void onPoiItemSearched(PoiItem poiItem, int i) {

        }
    };
}
