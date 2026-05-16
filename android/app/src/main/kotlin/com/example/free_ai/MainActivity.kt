package com.example.free_ai

import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.UserManager
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channelName = "app.protection/device_admin"
    private val onboardingPrefsName = "app_onboarding"
    private val adminPromptKey = "admin_prompt_completed"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channelName,
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getProtectionStatus" -> result.success(getProtectionStatus())
                "requestDeviceAdmin" -> {
                    requestDeviceAdmin()
                    result.success(true)
                }
                "openDeviceAdminSettings" -> {
                    openDeviceAdminSettings()
                    result.success(true)
                }
                "openDeviceOwnerHelp" -> {
                    openDeviceOwnerHelp()
                    result.success(true)
                }
                "applyDeviceOwnerProtection" -> result.success(applyDeviceOwnerProtection())
                else -> result.notImplemented()
            }
        }
    }

    override fun onResume() {
        super.onResume()
        applyDeviceOwnerProtection()
        requestDeviceAdminIfNeeded()
    }

    private fun getProtectionStatus(): Map<String, Boolean> {
        val manager = getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
        val admin = deviceAdminComponent()
        val isAdminActive = manager.isAdminActive(admin)
        val isDeviceOwner = manager.isDeviceOwnerApp(packageName)
        val isUninstallBlocked = if (isDeviceOwner) {
            manager.isUninstallBlocked(admin, packageName)
        } else {
            false
        }

        return mapOf(
            "isAdminActive" to isAdminActive,
            "isDeviceOwner" to isDeviceOwner,
            "isUninstallBlocked" to isUninstallBlocked,
            "isLockTaskPermitted" to manager.isLockTaskPermitted(packageName),
        )
    }

    private fun requestDeviceAdminIfNeeded() {
        val manager = getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
        if (manager.isAdminActive(deviceAdminComponent()) || hasCompletedAdminPrompt()) {
            return
        }

        if (!manager.isAdminActive(deviceAdminComponent())) {
            requestDeviceAdmin()
        }
    }

    private fun requestDeviceAdmin() {
        markAdminPromptCompleted()
        val intent = Intent(DevicePolicyManager.ACTION_ADD_DEVICE_ADMIN).apply {
            putExtra(DevicePolicyManager.EXTRA_DEVICE_ADMIN, deviceAdminComponent())
            putExtra(
                DevicePolicyManager.EXTRA_ADD_EXPLANATION,
                getString(R.string.device_admin_add_explanation),
            )
        }
        startActivity(intent)
    }

    private fun openDeviceAdminSettings() {
        startActivity(Intent(Settings.ACTION_SECURITY_SETTINGS))
    }

    private fun openDeviceOwnerHelp() {
        startActivity(Intent(Settings.ACTION_DEVICE_INFO_SETTINGS))
    }

    private fun applyDeviceOwnerProtection(): Boolean {
        val manager = getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
        val admin = deviceAdminComponent()
        if (!manager.isDeviceOwnerApp(packageName) || !manager.isAdminActive(admin)) {
            return false
        }

        manager.addUserRestriction(admin, UserManager.DISALLOW_UNINSTALL_APPS)
        manager.addUserRestriction(admin, UserManager.DISALLOW_APPS_CONTROL)
        manager.setLockTaskPackages(admin, arrayOf(packageName))
        setAsKioskHome(manager, admin)
        manager.setUninstallBlocked(admin, packageName, true)
        if (manager.isLockTaskPermitted(packageName)) {
            startLockTask()
        }
        return manager.isUninstallBlocked(admin, packageName)
    }

    private fun setAsKioskHome(manager: DevicePolicyManager, admin: ComponentName) {
        val homeFilter = IntentFilter(Intent.ACTION_MAIN).apply {
            addCategory(Intent.CATEGORY_HOME)
            addCategory(Intent.CATEGORY_DEFAULT)
        }
        manager.addPersistentPreferredActivity(
            admin,
            homeFilter,
            ComponentName(this, MainActivity::class.java),
        )
    }

    private fun deviceAdminComponent(): ComponentName {
        return ComponentName(this, AppDeviceAdminReceiver::class.java)
    }

    private fun hasCompletedAdminPrompt(): Boolean {
        return getSharedPreferences(onboardingPrefsName, Context.MODE_PRIVATE)
            .getBoolean(adminPromptKey, false)
    }

    private fun markAdminPromptCompleted() {
        getSharedPreferences(onboardingPrefsName, Context.MODE_PRIVATE)
            .edit()
            .putBoolean(adminPromptKey, true)
            .apply()
    }
}
