package com.example.clips_tack

import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Settings
import android.widget.Toast
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun onResume() {
        super.onResume()
        startEnabledBubbleIfNeeded()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, OVERLAY_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "hasPermission" -> result.success(hasOverlayPermission())
                    "requestPermission" -> {
                        result.success(requestOverlayPermission())
                    }
                    "startBubble" -> result.success(startOverlayBubble())
                    "stopBubble" -> {
                        stopService(Intent(this, OverlayBubbleService::class.java))
                        result.success(true)
                    }
                    "isBubbleRunning" -> result.success(OverlayBubbleService.isRunning)
                    else -> result.notImplemented()
                }
            }
    }

    private fun hasOverlayPermission(): Boolean {
        return Build.VERSION.SDK_INT < Build.VERSION_CODES.M || Settings.canDrawOverlays(this)
    }

    private fun requestOverlayPermission(): Boolean {
        if (hasOverlayPermission()) return true

        try {
            val intent = Intent(
                Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                Uri.parse("package:$packageName")
            )
            startActivity(intent)
        } catch (_: Exception) {
            startActivity(Intent(Settings.ACTION_SETTINGS))
            Toast.makeText(
                this,
                "Mở quyền hiển thị trên ứng dụng khác cho ClipStack",
                Toast.LENGTH_LONG
            ).show()
        }

        return false
    }

    private fun startOverlayBubble(): Boolean {
        if (!hasOverlayPermission()) {
            requestOverlayPermission()
            return false
        }

        startService(Intent(this, OverlayBubbleService::class.java))
        return true
    }

    private fun startEnabledBubbleIfNeeded() {
        if (!hasOverlayPermission() || OverlayBubbleService.isRunning) return

        val preferences = getSharedPreferences(FLUTTER_PREFS_NAME, MODE_PRIVATE)
        val shouldShowBubble = preferences.getBoolean(OVERLAY_BUBBLE_ENABLED_KEY, false)
        if (shouldShowBubble) {
            startService(Intent(this, OverlayBubbleService::class.java))
        }
    }

    companion object {
        private const val OVERLAY_CHANNEL = "clips_tack/overlay"
        private const val FLUTTER_PREFS_NAME = "FlutterSharedPreferences"
        private const val OVERLAY_BUBBLE_ENABLED_KEY = "flutter.overlay_bubble_enabled"
    }
}
