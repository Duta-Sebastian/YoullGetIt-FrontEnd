import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:youllgetit_flutter/providers/locale_provider.dart';

class LanguageSettings extends ConsumerWidget {
  const LanguageSettings({super.key});

  static const Color primaryColor = Color(0xFFFFDE15);
  static const Color primaryDark = Color(0xFFB8A00D);

  final List<Map<String, dynamic>> _languages = const [
    {
      'code': 'ro', 
      'flag': '🇷🇴', 
      'countryKeys': ['countryRomania', 'countryMoldova']
    },
    {
      'code': 'en', 
      'flag': '🇬🇧', 
      'countryKeys': ['countryUnitedKingdom']
    },
    {
      'code': 'fr', 
      'flag': '🇫🇷', 
      'countryKeys': ['countryFrance', 'countryBelgium', 'countrySwitzerland']
    },
    {
      'code': 'de', 
      'flag': '🇩🇪', 
      'countryKeys': ['countryGermany', 'countrySwitzerland']
    },
    {
      'code': 'it', 
      'flag': '🇮🇹', 
      'countryKeys': ['countryItaly', 'countrySwitzerland']
    },
    {
      'code': 'es', 
      'flag': '🇪🇸', 
      'countryKeys': ['countrySpain']
    },
    {
      'code': 'nl', 
      'flag': '🇳🇱', 
      'countryKeys': ['countryNetherlands', 'countryBelgium']
    },
  ];

  String _getLanguageName(String code, AppLocalizations l10n) {
    switch (code) {
      case 'ro': return l10n.languagesRomanian;
      case 'fr': return l10n.languagesFrench;
      case 'de': return l10n.languagesGerman;
      case 'it': return l10n.languagesItalian;
      case 'es': return l10n.languagesSpanish;
      case 'nl': return l10n.languagesDutch;
      case 'en': return l10n.languagesEnglish;
      default: return code.toUpperCase();
    }
  }

  String _getCountryNames(List<String> countryKeys, AppLocalizations l10n) {
    final countryNames = countryKeys.map((key) {
      switch (key) {
        case 'countryRomania': return l10n.countryRomania;
        case 'countryMoldova': return l10n.countryMoldova;
        case 'countryFrance': return l10n.countryFrance;
        case 'countryBelgium': return l10n.countryBelgium;
        case 'countryGermany': return l10n.countryGermany;
        case 'countrySwitzerland': return l10n.countrySwitzerland;
        case 'countryItaly': return l10n.countryItaly;
        case 'countrySpain': return l10n.countrySpain;
        case 'countryNetherlands': return l10n.countryNetherlands;
        case 'countryUnitedKingdom': return l10n.countryUnitedKingdom;
        default: return key;
      }
    }).toList();
    
    return countryNames.join(' & ');
  }

  void _updateLanguage(String languageCode, WidgetRef ref, BuildContext context) {
    final newLocale = Locale(languageCode);
    ref.read(localeProvider.notifier).setLocale(newLocale);
    
    // Remove any existing snackbar silently without animation
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    
    // Wait a frame for the locale to update, then show snackbar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        final updatedL10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    updatedL10n.languagesLanguageChangedTo(
                      _getLanguageName(languageCode, updatedL10n)
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: primaryDark,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.languagesSelectLanguage,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Header section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.languagesChoosePreferredLanguage,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${l10n.languagesSelected}: ${_getLanguageName(currentLocale.languageCode, l10n)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: primaryDark,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          
          // Languages list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              itemCount: _languages.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final language = _languages[index];
                final languageCode = language['code']!;
                final isSelected = currentLocale.languageCode == languageCode;
                
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected ? primaryColor : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: isSelected ? primaryColor.withAlpha((0.1*255).toInt()) : Colors.white,
                    boxShadow: isSelected ? [
                      BoxShadow(
                        color: primaryColor.withAlpha((0.2*255).toInt()),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ] : null,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => _updateLanguage(languageCode, ref, context),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            // Flag
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey.shade100,
                              ),
                              child: Center(
                                child: Text(
                                  language['flag']!,
                                  style: const TextStyle(fontSize: 24),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            
                            // Language info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _getLanguageName(languageCode, l10n),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                      color: isSelected ? primaryDark : Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _getCountryNames(language['countryKeys'], l10n),
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            // Selection indicator
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: isSelected
                                ? Container(
                                    key: const ValueKey('selected'),
                                    width: 24,
                                    height: 24,
                                    decoration: const BoxDecoration(
                                      color: primaryColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  )
                                : Container(
                                    key: const ValueKey('unselected'),
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.shade400),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}