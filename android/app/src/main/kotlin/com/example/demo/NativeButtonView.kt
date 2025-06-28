package com.example.demo

import android.content.Context
import android.graphics.Color
import android.view.View
import android.widget.Button
import android.widget.Toast
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.common.BinaryMessenger

internal class NativeButtonView(context: Context, id: Int, creationParams: Map<*, *>?, onClick: () -> Unit) : PlatformView {
    private val button: Button

    override fun getView(): View {
        return button
    }

    override fun dispose() {}

    init {
        button = Button(context).apply {
            text = creationParams?.get("text")?.toString() ?: "Native Button"
            textSize = 24f
            setBackgroundColor(Color.rgb(0, 220, 0))
            setTextColor(Color.WHITE)
            setOnClickListener {
                onClick()
            }
        }

    }
}