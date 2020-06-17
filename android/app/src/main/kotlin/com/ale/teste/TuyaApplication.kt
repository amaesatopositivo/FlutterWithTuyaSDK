package com.ale.teste

import android.app.Application
import android.content.Intent
import android.util.Log
import com.tuya.smart.android.user.api.ILoginCallback
import com.tuya.smart.android.user.bean.User
import io.flutter.app.FlutterApplication
import com.tuya.smart.home.sdk.TuyaHomeSdk

class TuyaApplication: FlutterApplication() {
    override fun onCreate() {
        initSdk(this)
        super.onCreate()
    }


    private fun initSdk(application: Application) {
        Log.d("TUYA", "application")
        TuyaHomeSdk.init(application, "mdycmqgsdxrpmwtmm5ae", "hernsa5yeruc9madhmry4hqm7yw47p7c")

        TuyaHomeSdk.setOnNeedLoginListener { context ->
            TuyaHomeSdk.getUserInstance().loginWithEmail("55", "alexandremaesato@gmail.com", "qwe123@", object : ILoginCallback {
                override fun onSuccess(user: User?) {
                    Log.d("Ale", "TuyaApplication: Logou com sucesso")
                }

                override fun onError(code: String?, error: String?) {
                    Log.d("Ale", "TuyaApplication: Erro para logar -> $error")
                }

            })
        }
        TuyaHomeSdk.setDebugMode(true)
    }

    override fun onTerminate() {
        super.onTerminate()
        TuyaHomeSdk.onDestroy()
    }
}