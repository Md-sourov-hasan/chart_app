import 'package:flutter/material.dart';

import '../app_protection_service.dart';

class AppProtectionCard extends StatefulWidget {
  const AppProtectionCard({super.key});

  @override
  State<AppProtectionCard> createState() => _AppProtectionCardState();
}

class _AppProtectionCardState extends State<AppProtectionCard> {
  AppProtectionStatus? _status;
  bool _isBusy = false;

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    final status = await AppProtectionService.getStatus();
    if (!mounted) {
      return;
    }

    setState(() {
      _status = status;
    });
  }

  Future<void> _runAction(Future<void> Function() action) async {
    setState(() {
      _isBusy = true;
    });

    await action();
    await Future<void>.delayed(const Duration(milliseconds: 500));
    await _loadStatus();

    if (!mounted) {
      return;
    }

    setState(() {
      _isBusy = false;
    });
  }

  Future<void> _applyFullProtection() async {
    setState(() {
      _isBusy = true;
    });

    await AppProtectionService.applyDeviceOwnerProtection();
    await Future<void>.delayed(const Duration(milliseconds: 300));
    await _loadStatus();

    if (!mounted) {
      return;
    }

    setState(() {
      _isBusy = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final status = _status;
    if (status == null || !status.isSupported) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final headline = status.hasFullProtection
        ? 'Uninstall block is active'
        : status.hasBasicProtection
        ? 'Basic uninstall protection is active'
        : 'Uninstall protection is off';
    final message = status.hasFullProtection
        ? 'This Android device recognizes the app as Device Owner and uninstall/apps settings are blocked.'
        : status.hasBasicProtection
        ? 'The app is a Device Admin app. Someone must disable admin access before uninstalling it.'
        : 'Enable Device Admin to make uninstall harder. For a full uninstall block, set this app up as Device Owner on the device.';

    return Card(
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.72),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  status.hasFullProtection ? Icons.verified_user : Icons.shield,
                  color: status.hasFullProtection
                      ? colorScheme.primary
                      : colorScheme.secondary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    headline,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (_isBusy)
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(message, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                if (!status.isAdminActive)
                  FilledButton(
                    onPressed: _isBusy
                        ? null
                        : () => _runAction(
                            AppProtectionService.requestDeviceAdmin,
                          ),
                    child: const Text('Enable Device Admin'),
                  ),
                if (status.isAdminActive && !status.hasFullProtection)
                  FilledButton(
                    onPressed: _isBusy ? null : _applyFullProtection,
                    child: const Text('Apply Full Block'),
                  ),
                OutlinedButton(
                  onPressed: _isBusy
                      ? null
                      : () => _runAction(
                          AppProtectionService.openDeviceAdminSettings,
                        ),
                  child: const Text('Open Security Settings'),
                ),
                if (status.isAdminActive && !status.isDeviceOwner)
                  TextButton(
                    onPressed: _isBusy
                        ? null
                        : () => _runAction(
                            AppProtectionService.openDeviceOwnerHelp,
                          ),
                    child: const Text('Device Owner Help'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
