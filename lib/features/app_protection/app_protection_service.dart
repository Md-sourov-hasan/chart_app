import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

@immutable
class AppProtectionStatus {
  const AppProtectionStatus({
    required this.isSupported,
    required this.isAdminActive,
    required this.isDeviceOwner,
    required this.isUninstallBlocked,
    required this.isLockTaskPermitted,
  });

  final bool isSupported;
  final bool isAdminActive;
  final bool isDeviceOwner;
  final bool isUninstallBlocked;
  final bool isLockTaskPermitted;

  bool get hasBasicProtection => isSupported && isAdminActive;
  bool get hasFullProtection =>
      isSupported && isDeviceOwner && isUninstallBlocked;

  factory AppProtectionStatus.unsupported() {
    return const AppProtectionStatus(
      isSupported: false,
      isAdminActive: false,
      isDeviceOwner: false,
      isUninstallBlocked: false,
      isLockTaskPermitted: false,
    );
  }

  factory AppProtectionStatus.fromMap(Map<Object?, Object?> data) {
    bool readBool(String key) => data[key] == true;

    return AppProtectionStatus(
      isSupported: true,
      isAdminActive: readBool('isAdminActive'),
      isDeviceOwner: readBool('isDeviceOwner'),
      isUninstallBlocked: readBool('isUninstallBlocked'),
      isLockTaskPermitted: readBool('isLockTaskPermitted'),
    );
  }
}

class AppProtectionService {
  AppProtectionService._();

  static const MethodChannel _channel = MethodChannel(
    'app.protection/device_admin',
  );

  static Future<AppProtectionStatus> getStatus() async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      return AppProtectionStatus.unsupported();
    }

    final response = await _channel.invokeMapMethod<Object?, Object?>(
      'getProtectionStatus',
    );

    if (response == null) {
      return AppProtectionStatus.unsupported();
    }

    return AppProtectionStatus.fromMap(response);
  }

  static Future<void> requestDeviceAdmin() async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      return;
    }

    await _channel.invokeMethod<void>('requestDeviceAdmin');
  }

  static Future<void> openDeviceAdminSettings() async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      return;
    }

    await _channel.invokeMethod<void>('openDeviceAdminSettings');
  }

  static Future<void> openDeviceOwnerHelp() async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      return;
    }

    await _channel.invokeMethod<void>('openDeviceOwnerHelp');
  }

  static Future<bool> applyDeviceOwnerProtection() async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      return false;
    }

    return await _channel.invokeMethod<bool>('applyDeviceOwnerProtection') ??
        false;
  }
}
