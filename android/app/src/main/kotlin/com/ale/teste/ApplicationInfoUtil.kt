package com.ale.teste

import android.content.Context
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager

object ApplicationInfoUtil {
    fun getInfo(infoName: String?, context: Context): String? {
        var e: ApplicationInfo?
        try {
            e = context.packageManager.getApplicationInfo(context.packageName, 128)
            return e.metaData.getString(infoName)
        } catch (e1: PackageManager.NameNotFoundException) {
            e1.printStackTrace()
        }
        return ""
    }
}
