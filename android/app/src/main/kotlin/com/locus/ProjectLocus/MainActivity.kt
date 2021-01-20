package com.locus.ProjectLocus

import android.app.AlarmManager
import android.app.AlarmManager.RTC_WAKEUP
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.*

class MainActivity: FlutterActivity() {
    private val CHANNEL = "locus_app.android_alarm_channel"
    companion object{
        var isActivityVisible = false
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        isActivityVisible = true
    }

    override fun onPause() {
        super.onPause()
        isActivityVisible = false
    }

    override fun onResume() {
        super.onResume()
        isActivityVisible = true
    }

    override fun onDestroy() {
        super.onDestroy()
        isActivityVisible = false
    }

    override fun onStop() {
        super.onStop()
        isActivityVisible = false
    }

    override fun onRestart() {
        super.onRestart()
        isActivityVisible = true
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "scheduleLocationTask") {
                scheduleLocationTask()
            } else {
                result.notImplemented()
            }
        }
    }

    private fun scheduleLocationTask(){
        val intent = Intent(context,LocationService::class.java)
        val pendingintent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            PendingIntent.getForegroundService(context,2021,intent,PendingIntent.FLAG_ONE_SHOT)
        } else {
            PendingIntent.getService(context,2021,intent,PendingIntent.FLAG_ONE_SHOT)
        }
        val manager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val datetime = Calendar.getInstance().time
        manager.setExactAndAllowWhileIdle(RTC_WAKEUP,datetime.time + 900000,pendingintent)
    }
}
