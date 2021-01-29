package com.locus.ProjectLocus

import android.app.job.JobInfo
import android.app.job.JobScheduler
import android.content.BroadcastReceiver
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.os.Build

class RebootReceiver : BroadcastReceiver(){

    override fun onReceive(context: Context?, intent: Intent?) {
        if(intent!!.action == "android.intent.action.BOOT_COMPLETED"
                || intent.action == "android.intent.action.QUICKBOOT_POWERON"
                || intent.action == "android.intent.action.REBOOT"){
            val intent = Intent(context,LocationService::class.java)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
                context!!.startForegroundService(intent)
            }
            else{
                context!!.startService(intent)
            }
        }
    }
}