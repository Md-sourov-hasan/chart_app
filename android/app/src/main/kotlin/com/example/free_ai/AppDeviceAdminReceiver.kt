package com.example.free_ai

import android.app.admin.DeviceAdminReceiver
import android.content.Context
import android.content.Intent

class AppDeviceAdminReceiver : DeviceAdminReceiver() {
    override fun onDisableRequested(context: Context, intent: Intent): CharSequence {
        return context.getString(R.string.device_admin_disable_warning)
    }
}
