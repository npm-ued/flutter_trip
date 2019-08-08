package org.devio.flutter.hybrid;

import io.flutter.plugin.common.EventChannel;
import io.flutter.view.FlutterView;

/**
 * EventChannelPlugin
 * 用于数据流（event streams）的通信，持续通信，通过长用于Native向Dart的通信，
 * 如：手机电量变化，网络连接变化，陀螺仪，传感器等；
 * Author: CrazyCodeBoy
 * 技术博文：http://www.devio.org
 * GitHub:https://github.com/crazycodeboy
 * Email:crazycodeboy@gmail.com
 */
public class EventChannelPlugin implements EventChannel.StreamHandler {
    private EventChannel.EventSink eventSink;

    static EventChannelPlugin registerWith(FlutterView flutterView) {
        EventChannelPlugin plugin = new EventChannelPlugin();
        new EventChannel(flutterView, "EventChannelPlugin").setStreamHandler(plugin);
        return plugin;
    }

    void send(Object params) {
        if (eventSink != null) {
            eventSink.success(params);
        }
    }

    @Override
    public void onListen(Object args, EventChannel.EventSink eventSink) {
        this.eventSink = eventSink;
    }

    @Override
    public void onCancel(Object o) {
        eventSink = null;
    }
}
