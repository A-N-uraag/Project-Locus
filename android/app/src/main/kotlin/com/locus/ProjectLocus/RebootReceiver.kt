package com.locus.ProjectLocus

import android.app.job.JobInfo
import android.app.job.JobScheduler
import android.content.BroadcastReceiver
import android.content.ComponentName
import android.content.Context
import android.content.Intent

class RebootReceiver : BroadcastReceiver(){

    override fun onReceive(context: Context?, intent: Intent?) {
        if(intent!!.action == "android.intent.action.BOOT_COMPLETED"
                || intent.action == "android.intent.action.QUICKBOOT_POWERON"
                || intent.action == "android.intent.action.REBOOT"){
            val jobInfo = JobInfo.Builder(25041997, ComponentName(context!!,LocationService::class.java))
                    .setOverrideDeadline(0)
                    .build()
            val scheduler = context.getSystemService(Context.JOB_SCHEDULER_SERVICE) as JobScheduler
            scheduler.schedule(jobInfo)
        }
    }
}