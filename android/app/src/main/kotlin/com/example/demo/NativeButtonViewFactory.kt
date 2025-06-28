package com.example.demo

import android.content.Context
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class NativeViewFactory(private val onClick: () -> Unit) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId:Int, args: Any?): PlatformView {
        val creationParams = args as Map<*, *>?
        return NativeButtonView(context, viewId, creationParams, onClick)
    }
}