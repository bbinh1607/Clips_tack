package com.example.clips_tack

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ClipData
import android.content.ClipboardManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.os.Build
import android.widget.RemoteViews
import android.widget.Toast
import org.json.JSONArray

class ClipStackWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == ACTION_COPY_LATEST) {
            copyLatestClip(context)
            updateAll(context)
            return
        }

        super.onReceive(context, intent)
    }

    companion object {
        private const val ACTION_COPY_LATEST = "com.example.clips_tack.widget.COPY_LATEST"
        private const val FLUTTER_PREFS_NAME = "FlutterSharedPreferences"
        private const val CLIPS_KEY = "flutter.clips"

        fun updateAll(context: Context) {
            val manager = AppWidgetManager.getInstance(context)
            val component = ComponentName(context, ClipStackWidgetProvider::class.java)
            val ids = manager.getAppWidgetIds(component)

            for (id in ids) {
                updateWidget(context, manager, id)
            }
        }

        private fun updateWidget(
            context: Context,
            manager: AppWidgetManager,
            widgetId: Int
        ) {
            val latestClip = latestClip(context)
            val views = RemoteViews(context.packageName, R.layout.clip_stack_widget)

            views.setTextViewText(
                R.id.widget_clip_content,
                latestClip?.content ?: context.getString(R.string.widget_empty_content)
            )
            views.setTextViewText(
                R.id.widget_clip_meta,
                if (latestClip?.isPinned == true) {
                    context.getString(R.string.widget_pinned_meta)
                } else {
                    context.getString(R.string.widget_latest_meta)
                }
            )

            views.setOnClickPendingIntent(
                R.id.widget_root,
                activityIntent(context, MainActivity.ACTION_OPEN_HOME)
            )
            views.setOnClickPendingIntent(
                R.id.widget_new_button,
                activityIntent(context, MainActivity.ACTION_CREATE_CLIP)
            )
            views.setOnClickPendingIntent(
                R.id.widget_pinned_button,
                activityIntent(context, MainActivity.ACTION_OPEN_PINNED)
            )
            views.setOnClickPendingIntent(
                R.id.widget_copy_button,
                copyIntent(context)
            )

            manager.updateAppWidget(widgetId, views)
        }

        private fun latestClip(context: Context): WidgetClip? {
            val raw = context
                .getSharedPreferences(FLUTTER_PREFS_NAME, Context.MODE_PRIVATE)
                .getString(CLIPS_KEY, null) ?: return null

            return try {
                val array = JSONArray(raw)
                if (array.length() == 0) return null

                val clip = array.getJSONObject(0)
                val content = clip.optString("content").trim()
                if (content.isEmpty()) return null

                WidgetClip(
                    content = content.replace(Regex("\\s+"), " "),
                    isPinned = clip.optBoolean("isPinned", false)
                )
            } catch (_: Exception) {
                null
            }
        }

        private fun copyLatestClip(context: Context) {
            val content = latestClip(context)?.content

            if (content == null) {
                Toast.makeText(
                    context,
                    context.getString(R.string.widget_empty_content),
                    Toast.LENGTH_SHORT
                ).show()
                return
            }

            val clipboard = context.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
            clipboard.setPrimaryClip(
                ClipData.newPlainText(context.getString(R.string.app_name), content)
            )
            Toast.makeText(
                context,
                context.getString(R.string.widget_copied_message),
                Toast.LENGTH_SHORT
            ).show()
        }

        private fun activityIntent(context: Context, action: String): PendingIntent {
            val intent = Intent(context, MainActivity::class.java)
                .setAction(action)
                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)

            return PendingIntent.getActivity(
                context,
                action.hashCode(),
                intent,
                pendingIntentFlags()
            )
        }

        private fun copyIntent(context: Context): PendingIntent {
            val intent = Intent(context, ClipStackWidgetProvider::class.java)
                .setAction(ACTION_COPY_LATEST)

            return PendingIntent.getBroadcast(
                context,
                ACTION_COPY_LATEST.hashCode(),
                intent,
                pendingIntentFlags()
            )
        }

        private fun pendingIntentFlags(): Int {
            return PendingIntent.FLAG_UPDATE_CURRENT or
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    PendingIntent.FLAG_IMMUTABLE
                } else {
                    0
                }
        }
    }
}

private data class WidgetClip(
    val content: String,
    val isPinned: Boolean
)
