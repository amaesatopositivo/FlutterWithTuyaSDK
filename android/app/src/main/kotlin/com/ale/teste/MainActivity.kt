package com.ale.teste

import com.tuya.smart.home.sdk.TuyaHomeSdk
import com.tuya.smart.home.sdk.bean.HomeBean
import com.tuya.smart.home.sdk.callback.ITuyaGetHomeListCallback
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import com.google.gson.Gson

class MainActivity: FlutterActivity() {
    private  val gson = Gson()
    private val CHANNEL = "com.ale.teste/login"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler{
            call, result ->
            when(call.method){
                "isLogged" ->{
                    result.success(isLogged())
                }
                "getHomeBeans" ->{
                    TuyaHomeSdk.getHomeManagerInstance().queryHomeList(object: ITuyaGetHomeListCallback {
                        override fun onSuccess(homeBeans: List<HomeBean>) {
                            result.success(gson.toJson(homeBeans))
                        }
                        override fun onError(errorCode: String?, error: String?) {
                            result.error(errorCode, error, null)
                        }
                    })
                }
            }
        }
    }

    fun isLogged():Boolean{
        return TuyaHomeSdk.getUserInstance().isLogin
    }

}
