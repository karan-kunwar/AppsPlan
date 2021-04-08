package com.example.madboxes;

import android.app.Activity;
import android.app.ActivityManager;
import android.app.usage.UsageStats;
import android.app.usage.UsageStatsManager;
import android.content.ComponentName;
import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;

import java.lang.reflect.Field;
import java.util.List;
import java.util.Map;
import java.util.SortedMap;
import java.util.TreeMap;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "samples.flutter.io/foregroundApp";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            // Note: this method is invoked on the main thread.
                            if (call.method.equals("getCurrentForegroundApp")) {
                                String currentForegroundApp = getCurrentForegroundApp();

                                if (currentForegroundApp!=null) {
                                    result.success(currentForegroundApp);
                                } else {
                                    result.error("UNAVAILABLE", "Unable to fetch foreground app", null);
                                }
                            } else {
                                result.notImplemented();
                            }

                        }
                );
    }

    private String getCurrentForegroundApp(){

        String currentForegroundApp = "unknown";
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP) {
            UsageStatsManager usm = (UsageStatsManager) getSystemService(Context.USAGE_STATS_SERVICE);
            long time = System.currentTimeMillis();
            List<UsageStats> appList = usm.queryUsageStats(UsageStatsManager.INTERVAL_DAILY,
                    time - 1000 * 1000, time);
            if (appList != null && appList.size() > 0) {
                SortedMap<Long, UsageStats> mySortedMap = new TreeMap<Long, UsageStats>();
                for (UsageStats usageStats : appList) {
                    mySortedMap.put(usageStats.getLastTimeUsed(),
                            usageStats);
                }
                if (mySortedMap != null && !mySortedMap.isEmpty()) {
                    currentForegroundApp= mySortedMap.get(
                            mySortedMap.lastKey()).getPackageName();
                }
            }
        } else {
            ActivityManager am = (ActivityManager) getBaseContext().getSystemService(ACTIVITY_SERVICE);
            currentForegroundApp= am.getRunningTasks(1).get(0).topActivity .getPackageName();

        }
        return currentForegroundApp;

    }

}
