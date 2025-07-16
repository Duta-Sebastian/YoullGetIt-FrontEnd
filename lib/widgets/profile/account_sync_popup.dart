import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youllgetit_flutter/l10n/generated/app_localizations.dart';

class AccountSyncPopup extends StatelessWidget {
  final VoidCallback? onCreateAccount;
  final VoidCallback? onDismiss;

  const AccountSyncPopup({
    super.key,
    this.onCreateAccount,
    this.onDismiss,
  });

  static const String _hasShownPopupKey = 'has_shown_account_sync_popup';

  static Future<bool> shouldShowPopup() async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool(_hasShownPopupKey) ?? false);
  }

  static Future<void> markPopupAsShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasShownPopupKey, true);
  }

  static Future<void> showIfNeeded(
    BuildContext context, {
    VoidCallback? onCreateAccount,
    VoidCallback? onDismiss,
  }) async {
    if (await shouldShowPopup()) {
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AccountSyncPopup(
            onCreateAccount: onCreateAccount,
            onDismiss: onDismiss,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFFFDE15).withAlpha((0.1 * 255).toInt()),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.sync,
                size: 40,
                color: Color(0xFFFFDE15),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Title
            Text(
              _getLocalizedText(context, 'title'),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 16),
            
            // Description
            Text(
              _getLocalizedText(context, 'description'),
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 32),
            
            // Buttons - Column layout for better centering
            Column(
              children: [
                // Create Account Button - Primary action first
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () async {
                      await markPopupAsShown();
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                      onCreateAccount?.call();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFDE15),
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      _getLocalizedText(context, 'createAccount'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Not Now Button - Secondary action
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: TextButton(
                    onPressed: () async {
                      await markPopupAsShown();
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                      onDismiss?.call();
                    },
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _getLocalizedText(context, 'notNow'),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getLocalizedText(BuildContext context, String key) {
    final localizations = AppLocalizations.of(context)!;
    
    switch (key) {
      case 'title':
        return localizations.profilePopupTitle;
      case 'description':
        return localizations.profilePopupDescription;
      case 'createAccount':
        return localizations.profilePopupCreateAccount;
      case 'notNow':
        return localizations.profilePopupNotNow;
      default:
        return '';
    }
  }
}