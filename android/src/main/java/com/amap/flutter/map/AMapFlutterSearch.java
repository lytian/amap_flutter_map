package com.amap.flutter.map;

import android.content.Context;

import androidx.annotation.NonNull;

import com.amap.api.maps.MapsInitializer;
import com.amap.api.services.core.AMapException;
import com.amap.api.services.core.LatLonPoint;
import com.amap.api.services.core.PoiItem;
import com.amap.api.services.geocoder.GeocodeAddress;
import com.amap.api.services.geocoder.GeocodeQuery;
import com.amap.api.services.geocoder.GeocodeResult;
import com.amap.api.services.geocoder.GeocodeSearch;
import com.amap.api.services.geocoder.RegeocodeAddress;
import com.amap.api.services.geocoder.RegeocodeQuery;
import com.amap.api.services.geocoder.RegeocodeResult;
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
            case "geocodeQuery":
                try {
                    geocodeQuery((Map) call.arguments);
                } catch (AMapException e) {
                    e.printStackTrace();
                    result.error(e.getErrorType(), e.getMessage(), "");
                }
                break;
            case "regeocodeQuery":
                try {
                    regeocodeQuery((Map) call.arguments);
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
            // ????????????
            List<Double> location = (List<Double>) params.get("location");
            poiSearch.setBound(new PoiSearch.SearchBound(
                new LatLonPoint(location.get(0), location.get(1)),
                params.get("radius") == null ? 3000 : (int) params.get("radius")
            ));
        } else if (params.containsKey("polygon") && params.get("polygon") != null) {
            // ???????????????
            List<List<Double>> polygon = (List<List<Double>>) params.get("polygon");
            List<LatLonPoint> pointList = new ArrayList<>();
            for (List<Double> p: polygon) {
                pointList.add(new LatLonPoint(p.get(0), p.get(1)));
            }
            poiSearch.setBound(new PoiSearch.SearchBound(pointList));
        }
        poiSearch.setOnPoiSearchListener(new PoiSearch.OnPoiSearchListener() {
            @Override
            public void onPoiSearched(PoiResult poiResult, int rCode) {
                if (rCode != 1000) {
                    result.error(rCode + "", "poi????????????", "");
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
                    // ?????????
                    map.put("latLonPoint", new double[]{ poi.getLatLonPoint().getLatitude(), poi.getLatLonPoint().getLongitude()} );
                    if (poi.getEnter() != null) {
                        map.put("latLonPoint", new double[]{ poi.getEnter().getLatitude(), poi.getEnter().getLongitude()} );
                    }
                    if (poi.getExit() != null) {
                        map.put("latLonPoint", new double[]{ poi.getExit().getLatitude(), poi.getExit().getLongitude()} );
                    }
                    // ??????
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
                    // ???POI??????
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
        });
        poiSearch.searchPOIAsyn();
    }

    private void geocodeQuery(Map<String, Object> params) throws AMapException {
        GeocodeSearch geocoderSearch = new GeocodeSearch(context);
        geocoderSearch.setOnGeocodeSearchListener(geocodeSearchListener);
        GeocodeQuery query = new GeocodeQuery((String) params.get("address"), (String) params.get("city"));
        geocoderSearch.getFromLocationNameAsyn(query);
    }

    private void regeocodeQuery(Map<String, Object> params) throws AMapException {
        GeocodeSearch geocoderSearch = new GeocodeSearch(context);
        geocoderSearch.setOnGeocodeSearchListener(geocodeSearchListener);
        List<Double> location = (List<Double>) params.get("location");
        String mapType = GeocodeSearch.AMAP;
        if (params.get("mapType") == "gps") {
            mapType = GeocodeSearch.GPS;
        }
        RegeocodeQuery query = new RegeocodeQuery(
            new LatLonPoint(location.get(0), location.get(1)),
            params.get("radius") == null ? 1000 : (int) params.get("radius"),
            mapType
        );
        geocoderSearch.getFromLocationAsyn(query);
    }

    final GeocodeSearch.OnGeocodeSearchListener geocodeSearchListener = new GeocodeSearch.OnGeocodeSearchListener() {
        @Override
        public void onRegeocodeSearched(RegeocodeResult regeocodeResult, int rCode) {
            if (rCode != 1000) {
                result.error(rCode + "", "?????????????????????", "");
                return;
            }
            RegeocodeAddress regeo = regeocodeResult.getRegeocodeAddress();
            Map<String, Object> args = new HashMap<>();
            args.put("formattedAddress", regeo.getFormatAddress());
            args.put("country", regeo.getCountry());
            args.put("countryCode", regeo.getCountryCode());
            args.put("province", regeo.getProvince());
            args.put("city", regeo.getCity());
            args.put("cityCode", regeo.getCityCode());
            args.put("district", regeo.getDistrict());
            args.put("adCode", regeo.getAdCode());
            args.put("township", regeo.getTownship());
            args.put("towncode", regeo.getTowncode());
            args.put("neighborhood", regeo.getNeighborhood());
            args.put("building", regeo.getBuilding());
            result.success(args);
        }

        @Override
        public void onGeocodeSearched(GeocodeResult geocodeResult, int rCode) {
            if (rCode != 1000) {
                result.error(rCode + "", "??????????????????", "");
                return;
            }
            List<GeocodeAddress> addressList = geocodeResult.getGeocodeAddressList();
            List<Map<String, Object>> arr = new ArrayList<>();
            Map<String, Object> map;
            for (GeocodeAddress geo: addressList) {
                map = new HashMap<>();
                map.put("formattedAddress", geo.getFormatAddress());
                map.put("country", geo.getCountry());
                map.put("province", geo.getProvince());
                map.put("city", geo.getCity());
                map.put("district", geo.getDistrict());
                map.put("building", geo.getBuilding());
                map.put("neighborhood", geo.getNeighborhood());
                map.put("township", geo.getTownship());
                map.put("adcode", geo.getAdcode());
                map.put("postcode", geo.getPostcode());
                // ?????????
                map.put("location", new double[]{ geo.getLatLonPoint().getLatitude(), geo.getLatLonPoint().getLongitude()} );
                map.put("level", geo.getLevel());
                arr.add(map);
            }
            result.success(arr);
        }
    };
}
