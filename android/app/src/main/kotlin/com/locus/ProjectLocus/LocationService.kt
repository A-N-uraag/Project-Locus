package com.locus.ProjectLocus

import android.app.*
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.IBinder
import androidx.annotation.Nullable
import androidx.core.app.NotificationCompat
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.util.*

class LocationService: Service(){

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val CHANNEL = "locus_app.location_service_channel"
        createNotificationChannel()
        val notificationbuilder = NotificationCompat.Builder(this,getString(R.string.CHANNEL_ID))
                .setSmallIcon(R.mipmap.ic_launcher)
                .setContentTitle("Location update in progress")
                .setContentText("Your location is being updated in the background")
                .setPriority(NotificationCompat.PRIORITY_DEFAULT)
                .setCategory(NotificationCompat.CATEGORY_SERVICE)
        startForeground(2021,notificationbuilder.build())
        scheduleLocationTask()
        val engine = FlutterEngine(this)
        engine.dartExecutor.executeDartEntrypoint(
                        DartExecutor.DartEntrypoint(io.flutter.view.FlutterMain.findAppBundlePath(),
                                "androidLocationUpdate"
                        )
                )
        MethodChannel(engine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "stopForegroundService") {
                stopForegroundService()
            } else {
                result.notImplemented()
            }
        }
        return START_STICKY
    }

    private fun stopForegroundService(){
        stopForeground(true)
        stopSelf()
    }

    private fun scheduleLocationTask(){
        val intent = Intent(this,LocationService::class.java)
        val pendingintent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            PendingIntent.getForegroundService(this,2021,intent, PendingIntent.FLAG_ONE_SHOT)
        } else {
            PendingIntent.getService(this,2021,intent, PendingIntent.FLAG_ONE_SHOT)
        }
        val manager = this.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val datetime = Calendar.getInstance().time
        manager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP,datetime.time + 900000,pendingintent)
    }

    @Nullable
    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val name = getString(R.string.channel_name)
            val descriptionText = getString(R.string.channel_description)
            val CHANNEL_ID = getString(R.string.CHANNEL_ID)
            val importance = NotificationManager.IMPORTANCE_DEFAULT
            val channel = NotificationChannel(CHANNEL_ID, name, importance).apply {
                description = descriptionText
            }
            val notificationManager: NotificationManager =
                    getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }

    override fun onDestroy() {
        if(!MainActivity.isActivityVisible){
            android.os.Process.killProcess(android.os.Process.myPid());
        }
        super.onDestroy()
    }
}