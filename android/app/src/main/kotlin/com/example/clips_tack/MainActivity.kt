package com.example.clips_tack

import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.widget.Toast
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var shortcutChannel: MethodChannel? = null
    private var pendingShortcutAction: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        pendingShortcutAction = shortcutActionFromIntent(intent)
        super.onCreate(savedInstanceState)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        handleShortcutIntent(intent, dispatchToFlutter = true)
    }

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

        shortcutChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            MOBILE_SHORTCUT_CHANNEL
        )
        shortcutChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "getInitialAction" -> result.success(pendingShortcutAction)
                "clearInitialAction" -> {
                    pendingShortcutAction = null
                    result.success(null)
                }
                "updateWidgets" -> {
                    ClipStackWidgetProvider.updateAll(this)
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun handleShortcutIntent(intent: Intent?, dispatchToFlutter: Boolean) {
        val action = shortcutActionFromIntent(intent) ?: return
        pendingShortcutAction = action

        if (dispatchToFlutter) {
            shortcutChannel?.invokeMethod("onShortcutAction", action)
        }
    }

    private fun shortcutActionFromIntent(intent: Intent?): String? {
        return when (intent?.action) {
            ACTION_CREATE_CLIP -> FLUTTER_ACTION_CREATE_CLIP
            ACTION_SEARCH_CLIPS -> FLUTTER_ACTION_SEARCH_CLIPS
            ACTION_OPEN_PINNED -> FLUTTER_ACTION_OPEN_PINNED
            ACTION_OPEN_HOME -> FLUTTER_ACTION_OPEN_HOME
            else -> null
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
        private const val MOBILE_SHORTCUT_CHANNEL = "clips_tack/mobile_shortcuts"
        private const val FLUTTER_PREFS_NAME = "FlutterSharedPreferences"
        private const val OVERLAY_BUBBLE_ENABLED_KEY = "flutter.overlay_bubble_enabled"

        const val ACTION_CREATE_CLIP = "com.example.clips_tack.action.CREATE_CLIP"
        const val ACTION_SEARCH_CLIPS = "com.example.clips_tack.action.SEARCH_CLIPS"
        const val ACTION_OPEN_PINNED = "com.example.clips_tack.action.OPEN_PINNED"
        const val ACTION_OPEN_HOME = "com.example.clips_tack.action.OPEN_HOME"

        private const val FLUTTER_ACTION_CREATE_CLIP = "create_clip"
        private const val FLUTTER_ACTION_SEARCH_CLIPS = "search_clips"
        private const val FLUTTER_ACTION_OPEN_PINNED = "open_pinned"
        private const val FLUTTER_ACTION_OPEN_HOME = "open_home"
    }
}
