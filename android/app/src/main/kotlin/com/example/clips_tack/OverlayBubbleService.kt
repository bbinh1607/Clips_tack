package com.example.clips_tack

import android.app.Service
import android.content.ClipData
import android.content.ClipboardManager
import android.content.Intent
import android.content.SharedPreferences
import android.graphics.Color
import android.graphics.PixelFormat
import android.graphics.Rect
import android.graphics.Typeface
import android.graphics.drawable.GradientDrawable
import android.os.Build
import android.os.IBinder
import android.provider.Settings
import android.text.TextUtils
import android.util.Log
import android.view.Gravity
import android.view.MotionEvent
import android.view.View
import android.view.WindowManager
import android.widget.FrameLayout
import android.widget.LinearLayout
import android.widget.ScrollView
import android.widget.TextView
import android.widget.Toast
import kotlin.math.abs
import kotlin.math.min
import org.json.JSONArray
import org.json.JSONException

class OverlayBubbleService : Service() {
    private var windowManager: WindowManager? = null
    private var bubbleView: View? = null
    private var dismissTargetView: View? = null
    private var clipsPanelView: View? = null
    private var layoutParams: WindowManager.LayoutParams? = null
    private var dismissTargetActive = false
    private lateinit var preferences: SharedPreferences

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onCreate() {
        super.onCreate()
        preferences = getSharedPreferences(PREFS_NAME, MODE_PRIVATE)

        if (!hasOverlayPermission()) {
            stopSelf()
            return
        }

        windowManager = getSystemService(WINDOW_SERVICE) as WindowManager
        showBubble()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (!hasOverlayPermission()) {
            stopSelf()
            return START_NOT_STICKY
        }

        if (bubbleView == null) {
            showBubble()
        }

        return START_STICKY
    }

    override fun onDestroy() {
        removeClipsPanel()
        hideDismissTarget()
        removeBubble()
        isRunning = false
        super.onDestroy()
    }

    private fun hasOverlayPermission(): Boolean {
        return Build.VERSION.SDK_INT < Build.VERSION_CODES.M || Settings.canDrawOverlays(this)
    }

    private fun showBubble() {
        if (bubbleView != null) return

        val size = dp(BUBBLE_SIZE_DP)
        val view = buildBubbleView(size)
        val params = WindowManager.LayoutParams(
            size,
            size,
            overlayWindowType(),
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or
                WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL or
                WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS,
            PixelFormat.TRANSLUCENT
        ).apply {
            gravity = Gravity.TOP or Gravity.START
            x = safeX(preferences.getInt(PREF_X, dp(DEFAULT_X_DP)), size)
            y = safeY(preferences.getInt(PREF_Y, dp(DEFAULT_Y_DP)), size)
        }

        view.setOnTouchListener(BubbleTouchListener(params))

        try {
            windowManager?.addView(view, params)
            bubbleView = view
            layoutParams = params
            isRunning = true
        } catch (error: RuntimeException) {
            Log.e(TAG, "Cannot add overlay bubble", error)
            Toast.makeText(
                this,
                LABEL_BUBBLE_PERMISSION_ERROR,
                Toast.LENGTH_LONG
            ).show()
            stopSelf()
        }
    }

    private fun buildBubbleView(size: Int): View {
        val background = GradientDrawable(
            GradientDrawable.Orientation.TL_BR,
            intArrayOf(Color.rgb(37, 99, 235), Color.rgb(15, 143, 131))
        ).apply {
            shape = GradientDrawable.OVAL
            setStroke(dp(2), Color.argb(90, 255, 255, 255))
        }

        return FrameLayout(this).apply {
            layoutParams = FrameLayout.LayoutParams(size, size)
            this.background = background
            elevation = dp(8).toFloat()
            alpha = 0.96f
            addView(
                TextView(context).apply {
                    text = "C"
                    setTextColor(Color.WHITE)
                    textSize = 22f
                    gravity = Gravity.CENTER
                    typeface = Typeface.DEFAULT_BOLD
                },
                FrameLayout.LayoutParams(
                    FrameLayout.LayoutParams.MATCH_PARENT,
                    FrameLayout.LayoutParams.MATCH_PARENT
                )
            )
        }
    }

    private fun showDismissTarget() {
        if (dismissTargetView != null) return

        val size = dp(DISMISS_TARGET_SIZE_DP)
        val view = buildDismissTargetView(size)
        val params = WindowManager.LayoutParams(
            size,
            size,
            overlayWindowType(),
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or
                WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL or
                WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS,
            PixelFormat.TRANSLUCENT
        ).apply {
            gravity = Gravity.BOTTOM or Gravity.CENTER_HORIZONTAL
            x = 0
            y = dp(DISMISS_TARGET_BOTTOM_MARGIN_DP)
        }

        try {
            windowManager?.addView(view, params)
            dismissTargetView = view
            dismissTargetActive = false
        } catch (error: RuntimeException) {
            Log.w(TAG, "Cannot add overlay dismiss target", error)
        }
    }

    private fun buildDismissTargetView(size: Int): View {
        return FrameLayout(this).apply {
            layoutParams = FrameLayout.LayoutParams(size, size)
            background = dismissTargetBackground(active = false)
            elevation = dp(12).toFloat()
            alpha = 0.94f
            addView(
                TextView(context).apply {
                    text = "\u00d7"
                    gravity = Gravity.CENTER
                    setTextColor(Color.WHITE)
                    textSize = 34f
                    typeface = Typeface.DEFAULT_BOLD
                },
                FrameLayout.LayoutParams(
                    FrameLayout.LayoutParams.MATCH_PARENT,
                    FrameLayout.LayoutParams.MATCH_PARENT
                )
            )
        }
    }

    private fun setDismissTargetActive(active: Boolean) {
        val target = dismissTargetView ?: return
        if (dismissTargetActive == active) return

        dismissTargetActive = active
        target.background = dismissTargetBackground(active)
        target.animate()
            .scaleX(if (active) 1.12f else 1f)
            .scaleY(if (active) 1.12f else 1f)
            .setDuration(90)
            .start()
    }

    private fun hideDismissTarget() {
        val view = dismissTargetView ?: return
        try {
            windowManager?.removeView(view)
        } catch (error: RuntimeException) {
            Log.w(TAG, "Cannot remove overlay dismiss target", error)
        }
        dismissTargetView = null
        dismissTargetActive = false
    }

    private fun dismissTargetBackground(active: Boolean): GradientDrawable {
        return GradientDrawable().apply {
            shape = GradientDrawable.OVAL
            setColor(if (active) Color.rgb(220, 38, 38) else Color.argb(230, 17, 24, 39))
            setStroke(dp(2), Color.argb(if (active) 220 else 120, 255, 255, 255))
        }
    }

    private fun showClipsPanel() {
        removeClipsPanel()

        val clips = loadSavedClips()
        val width = min(resources.displayMetrics.widthPixels - dp(32), dp(PANEL_MAX_WIDTH_DP))
            .coerceAtLeast(dp(PANEL_MIN_WIDTH_DP))
        val height = min(resources.displayMetrics.heightPixels - dp(160), dp(PANEL_MAX_HEIGHT_DP))
            .coerceAtLeast(dp(PANEL_MIN_HEIGHT_DP))
        val view = buildClipsPanelView(clips)
        val params = WindowManager.LayoutParams(
            width,
            height,
            overlayWindowType(),
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or
                WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL,
            PixelFormat.TRANSLUCENT
        ).apply {
            gravity = Gravity.TOP or Gravity.START
            x = ((resources.displayMetrics.widthPixels - width) / 2).coerceAtLeast(0)
            y = dp(PANEL_TOP_MARGIN_DP)
        }

        try {
            windowManager?.addView(view, params)
            clipsPanelView = view
        } catch (error: RuntimeException) {
            Log.w(TAG, "Cannot add clips panel", error)
        }
    }

    private fun buildClipsPanelView(clips: List<SavedClip>): View {
        return LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            background = roundedRect(Color.WHITE, PANEL_RADIUS_DP)
            elevation = dp(16).toFloat()
            setPadding(dp(16), dp(14), dp(16), dp(14))

            addView(buildPanelHeader(clips.size))

            if (clips.isEmpty()) {
                addView(
                    TextView(context).apply {
                        text = LABEL_EMPTY_CLIPS
                        setTextColor(Color.rgb(75, 85, 99))
                        textSize = 14f
                        gravity = Gravity.CENTER
                    },
                    LinearLayout.LayoutParams(
                        LinearLayout.LayoutParams.MATCH_PARENT,
                        0,
                        1f
                    )
                )
            } else {
                addView(buildClipsScrollView(clips), LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.MATCH_PARENT,
                    0,
                    1f
                ))
            }
        }
    }

    private fun buildPanelHeader(clipCount: Int): View {
        return LinearLayout(this).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER_VERTICAL
            setPadding(0, 0, 0, dp(10))

            addView(
                TextView(context).apply {
                    text = "$LABEL_SAVED_CLIPS ($clipCount)"
                    setTextColor(Color.rgb(17, 24, 39))
                    textSize = 17f
                    typeface = Typeface.DEFAULT_BOLD
                    maxLines = 1
                    ellipsize = TextUtils.TruncateAt.END
                },
                LinearLayout.LayoutParams(
                    0,
                    LinearLayout.LayoutParams.WRAP_CONTENT,
                    1f
                )
            )

            addView(
                TextView(context).apply {
                    text = "\u00d7"
                    gravity = Gravity.CENTER
                    setTextColor(Color.rgb(17, 24, 39))
                    textSize = 24f
                    typeface = Typeface.DEFAULT_BOLD
                    background = roundedRect(Color.rgb(243, 244, 246), CLOSE_BUTTON_RADIUS_DP)
                    setOnClickListener { removeClipsPanel() }
                },
                LinearLayout.LayoutParams(dp(36), dp(36))
            )
        }
    }

    private fun buildClipsScrollView(clips: List<SavedClip>): View {
        val visibleClips = clips.take(MAX_PANEL_ITEMS)

        return ScrollView(this).apply {
            isFillViewport = false
            addView(
                LinearLayout(context).apply {
                    orientation = LinearLayout.VERTICAL
                    visibleClips.forEachIndexed { index, clip ->
                        addView(buildClipRow(clip))
                        if (index < visibleClips.lastIndex) {
                            addView(View(context), LinearLayout.LayoutParams(
                                LinearLayout.LayoutParams.MATCH_PARENT,
                                dp(8)
                            ))
                        }
                    }
                },
                FrameLayout.LayoutParams(
                    FrameLayout.LayoutParams.MATCH_PARENT,
                    FrameLayout.LayoutParams.WRAP_CONTENT
                )
            )
        }
    }

    private fun buildClipRow(clip: SavedClip): View {
        return LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            background = roundedRect(
                if (clip.isPinned) Color.rgb(239, 246, 255) else Color.rgb(249, 250, 251),
                CLIP_ROW_RADIUS_DP,
                if (clip.isPinned) Color.rgb(96, 165, 250) else Color.rgb(229, 231, 235)
            )
            setPadding(dp(12), dp(10), dp(12), dp(10))
            isClickable = true
            isFocusable = true
            setOnClickListener {
                copyClipToClipboard(clip.content)
                removeClipsPanel()
            }

            if (clip.isPinned) {
                addView(
                    TextView(context).apply {
                        text = LABEL_PINNED
                        setTextColor(Color.rgb(37, 99, 235))
                        textSize = 11f
                        typeface = Typeface.DEFAULT_BOLD
                    },
                    LinearLayout.LayoutParams(
                        LinearLayout.LayoutParams.MATCH_PARENT,
                        LinearLayout.LayoutParams.WRAP_CONTENT
                    )
                )
            }

            addView(
                TextView(context).apply {
                    text = clip.preview
                    setTextColor(Color.rgb(31, 41, 55))
                    textSize = 14f
                    maxLines = 3
                    ellipsize = TextUtils.TruncateAt.END
                },
                LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.MATCH_PARENT,
                    LinearLayout.LayoutParams.WRAP_CONTENT
                )
            )
        }
    }

    private fun removeClipsPanel() {
        val view = clipsPanelView ?: return
        try {
            windowManager?.removeView(view)
        } catch (error: RuntimeException) {
            Log.w(TAG, "Cannot remove clips panel", error)
        }
        clipsPanelView = null
    }

    private fun loadSavedClips(): List<SavedClip> {
        val flutterPrefs = getSharedPreferences(FLUTTER_PREFS_NAME, MODE_PRIVATE)
        val jsonString = flutterPrefs.getString(FLUTTER_CLIPS_KEY, null) ?: return emptyList()

        return try {
            val array = JSONArray(jsonString)
            buildList {
                for (index in 0 until array.length()) {
                    val item = array.optJSONObject(index) ?: continue
                    val content = item.optString("content").trim()
                    if (content.isEmpty()) continue

                    add(
                        SavedClip(
                            content = content,
                            isPinned = item.optBoolean("isPinned", false)
                        )
                    )
                }
            }
        } catch (error: JSONException) {
            Log.w(TAG, "Cannot parse saved clips", error)
            emptyList()
        }
    }

    private fun copyClipToClipboard(content: String) {
        val clipboard = getSystemService(CLIPBOARD_SERVICE) as ClipboardManager
        clipboard.setPrimaryClip(ClipData.newPlainText("ClipStack", content))
        Toast.makeText(this, LABEL_COPIED, Toast.LENGTH_SHORT).show()
    }

    private fun roundedRect(
        color: Int,
        radiusDp: Int,
        strokeColor: Int? = null
    ): GradientDrawable {
        return GradientDrawable().apply {
            shape = GradientDrawable.RECTANGLE
            cornerRadius = dp(radiusDp).toFloat()
            setColor(color)
            strokeColor?.let { setStroke(dp(1), it) }
        }
    }

    private fun overlayWindowType(): Int {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
        } else {
            @Suppress("DEPRECATION")
            WindowManager.LayoutParams.TYPE_PHONE
        }
    }

    private fun removeBubble() {
        val view = bubbleView ?: return
        try {
            windowManager?.removeView(view)
        } catch (error: RuntimeException) {
            Log.w(TAG, "Cannot remove overlay bubble", error)
        }
        bubbleView = null
        layoutParams = null
    }

    private fun dismissBubbleUntilNextAppOpen() {
        removeClipsPanel()
        hideDismissTarget()
        removeBubble()
        isRunning = false
        Toast.makeText(this, LABEL_BUBBLE_HIDDEN, Toast.LENGTH_SHORT).show()
        stopSelf()
    }

    private fun dp(value: Int): Int {
        return (value * resources.displayMetrics.density).toInt()
    }

    private fun safeX(value: Int, bubbleSize: Int): Int {
        val max = (resources.displayMetrics.widthPixels - bubbleSize).coerceAtLeast(0)
        return value.coerceIn(0, max)
    }

    private fun safeY(value: Int, bubbleSize: Int): Int {
        val max = (resources.displayMetrics.heightPixels - bubbleSize).coerceAtLeast(0)
        return value.coerceIn(0, max)
    }

    private fun isOverDismissTarget(view: View, event: MotionEvent): Boolean {
        val bounds = dismissTargetBounds() ?: return false
        val bubbleLocation = IntArray(2)
        view.getLocationOnScreen(bubbleLocation)
        val bubbleCenterX = bubbleLocation[0] + view.width / 2
        val bubbleCenterY = bubbleLocation[1] + view.height / 2

        return bounds.contains(bubbleCenterX, bubbleCenterY) ||
            bounds.contains(event.rawX.toInt(), event.rawY.toInt())
    }

    private fun dismissTargetBounds(): Rect? {
        val target = dismissTargetView ?: return null
        val location = IntArray(2)
        target.getLocationOnScreen(location)
        return Rect(
            location[0],
            location[1],
            location[0] + target.width,
            location[1] + target.height
        )
    }

    private inner class BubbleTouchListener(
        private val params: WindowManager.LayoutParams
    ) : View.OnTouchListener {
        private var initialX = 0
        private var initialY = 0
        private var initialTouchX = 0f
        private var initialTouchY = 0f
        private var hasDragged = false
        private var isHoveringDismissTarget = false

        override fun onTouch(view: View, event: MotionEvent): Boolean {
            when (event.action) {
                MotionEvent.ACTION_DOWN -> {
                    initialX = params.x
                    initialY = params.y
                    initialTouchX = event.rawX
                    initialTouchY = event.rawY
                    hasDragged = false
                    isHoveringDismissTarget = false
                    removeClipsPanel()
                    view.animate().scaleX(0.92f).scaleY(0.92f).setDuration(90).start()
                    return true
                }
                MotionEvent.ACTION_MOVE -> {
                    val dx = event.rawX - initialTouchX
                    val dy = event.rawY - initialTouchY

                    if (abs(dx) > dp(DRAG_SLOP_DP) || abs(dy) > dp(DRAG_SLOP_DP)) {
                        hasDragged = true
                        showDismissTarget()
                    }

                    params.x = safeX(initialX + dx.toInt(), view.width)
                    params.y = safeY(initialY + dy.toInt(), view.height)
                    try {
                        windowManager?.updateViewLayout(view, params)
                    } catch (error: RuntimeException) {
                        Log.w(TAG, "Cannot move overlay bubble", error)
                    }

                    isHoveringDismissTarget = hasDragged && isOverDismissTarget(view, event)
                    setDismissTargetActive(isHoveringDismissTarget)
                    return true
                }
                MotionEvent.ACTION_UP,
                MotionEvent.ACTION_CANCEL -> {
                    view.animate().scaleX(1f).scaleY(1f).setDuration(120).start()

                    if (
                        event.action == MotionEvent.ACTION_UP &&
                        hasDragged &&
                        isHoveringDismissTarget
                    ) {
                        dismissBubbleUntilNextAppOpen()
                        return true
                    }

                    hideDismissTarget()

                    if (hasDragged) {
                        persistPosition()
                    } else if (event.action == MotionEvent.ACTION_UP) {
                        showClipsPanel()
                    }
                    return true
                }
            }

            return false
        }

        private fun persistPosition() {
            preferences.edit()
                .putInt(PREF_X, params.x)
                .putInt(PREF_Y, params.y)
                .apply()
        }
    }

    private data class SavedClip(
        val content: String,
        val isPinned: Boolean
    ) {
        val preview: String
            get() {
                val normalized = content.replace(Regex("\\s+"), " ").trim()
                return if (normalized.length > CLIP_PREVIEW_MAX_CHARS) {
                    "${normalized.take(CLIP_PREVIEW_MAX_CHARS - 3)}..."
                } else {
                    normalized
                }
            }
    }

    companion object {
        @Volatile
        var isRunning: Boolean = false
            private set

        private const val PREFS_NAME = "clipstack_overlay_bubble"
        private const val FLUTTER_PREFS_NAME = "FlutterSharedPreferences"
        private const val TAG = "ClipStackBubble"
        private const val PREF_X = "bubble_x"
        private const val PREF_Y = "bubble_y"
        private const val FLUTTER_CLIPS_KEY = "flutter.clips"
        private const val BUBBLE_SIZE_DP = 56
        private const val DEFAULT_X_DP = 18
        private const val DEFAULT_Y_DP = 180
        private const val DRAG_SLOP_DP = 4
        private const val DISMISS_TARGET_SIZE_DP = 72
        private const val DISMISS_TARGET_BOTTOM_MARGIN_DP = 36
        private const val PANEL_MIN_WIDTH_DP = 280
        private const val PANEL_MAX_WIDTH_DP = 380
        private const val PANEL_MIN_HEIGHT_DP = 260
        private const val PANEL_MAX_HEIGHT_DP = 460
        private const val PANEL_TOP_MARGIN_DP = 88
        private const val PANEL_RADIUS_DP = 18
        private const val CLOSE_BUTTON_RADIUS_DP = 18
        private const val CLIP_ROW_RADIUS_DP = 12
        private const val MAX_PANEL_ITEMS = 30
        private const val CLIP_PREVIEW_MAX_CHARS = 180

        private const val LABEL_SAVED_CLIPS = "\u0110o\u1ea1n \u0111\u00e3 l\u01b0u"
        private const val LABEL_EMPTY_CLIPS =
            "Ch\u01b0a c\u00f3 \u0111o\u1ea1n n\u00e0o \u0111\u00e3 l\u01b0u"
        private const val LABEL_PINNED = "\u0110\u00e3 ghim"
        private const val LABEL_COPIED = "\u0110\u00e3 sao ch\u00e9p"
        private const val LABEL_BUBBLE_HIDDEN =
            "\u0110\u00e3 \u1ea9n bong b\u00f3ng. M\u1edf l\u1ea1i \u1ee9ng d\u1ee5ng \u0111\u1ec3 hi\u1ec7n l\u1ea1i."
        private const val LABEL_BUBBLE_PERMISSION_ERROR =
            "Ch\u01b0a th\u1ec3 hi\u1ec7n bong b\u00f3ng ClipStack. H\u00e3y ki\u1ec3m tra quy\u1ec1n hi\u1ec3n th\u1ecb tr\u00ean \u1ee9ng d\u1ee5ng kh\u00e1c."
    }
}
