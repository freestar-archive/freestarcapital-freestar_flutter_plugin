package com.freestar.ads.flutter.freestar_flutter_plugin;

import com.freestar.android.ads.AdRequest;
import com.freestar.android.ads.ChocolateLogger;

import java.util.Map;

class Utils {

    private Utils(){}

    static void addTargetingParams(AdRequest adRequest, Map map) {
        if (map == null || map.isEmpty()) {
            return;
        }
        Map targetingMap = (Map)map.get("targetingMap");
        if (targetingMap != null && !targetingMap.isEmpty()) {
            for (Object key : targetingMap.keySet()) {
                String value = (String)targetingMap.get(key);
                ChocolateLogger.w("Utils", "fsfp_tag: add custom targeting. name: " + key + " value: " + value);
                adRequest.addCustomTargeting((String)key, value);
            }
        }
    }
}
