import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:youllgetit_flutter/models/user_model.dart';
import 'package:youllgetit_flutter/screens/internship_selector_screen.dart';
import 'package:youllgetit_flutter/utils/database_manager.dart';
import 'package:youllgetit_flutter/widgets/settings/gdpr_page.dart';
import 'package:youllgetit_flutter/widgets/settings/language_settings.dart';

class EntryScreen extends ConsumerStatefulWidget {
  const EntryScreen({super.key});

  @override
  ConsumerState<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends ConsumerState<EntryScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _gdprChecked = false;
  bool _nameEntered = false;

  // Custom color constant
  static const Color primaryColor = Color(0xFFFFDE15);

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_updateNameStatus);
  }

  @override
  void dispose() {
    _nameController.removeListener(_updateNameStatus);
    _nameController.dispose();
    super.dispose();
  }

  void _updateNameStatus() {
    final hasName = _nameController.text.trim().isNotEmpty;
    if (hasName != _nameEntered) {
      setState(() {
        _nameEntered = hasName;
      });
    }
  }

  bool get _isFormValid => _nameEntered && _gdprChecked;

  void _handleContinuePressed() {
    final username = _nameController.text.trim();
    
    DatabaseManager.updateUser(UserModel(
      username: username,
      lastChanged: DateTime.now().toUtc()
    ));
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuestionnaireScreen(),
      ),
    );
  }

  void _showLanguageSelector() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LanguageSettings(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _showLanguageSelector,
            icon: const Icon(Icons.language, color: Colors.grey),
            tooltip: l10n.languagesSelectLanguage,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildLogo(),
              const SizedBox(height: 32),
              _buildWelcomeText(l10n),
              const SizedBox(height: 24),
              _buildNameField(l10n),
              const SizedBox(height: 24),
              _buildGdprCheckbox(l10n),
              const SizedBox(height: 32),
              _buildContinueButton(l10n),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Center(
      child: Container(
        width: 80,
        height: 80,
        decoration: const BoxDecoration(
          color: primaryColor,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.person,
          size: 40,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildWelcomeText(AppLocalizations l10n) {
    return Text(
      l10n.entryScreenWelcome,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildNameField(AppLocalizations l10n) {
    return TextField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: l10n.entryScreenYourName,
        hintText: l10n.entryScreenEnterFullName,
        prefixIcon: const Icon(Icons.person_outline),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
      ),
    );
  }

  Widget _buildGdprCheckbox(AppLocalizations l10n) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: _gdprChecked,
          activeColor: primaryColor,
          onChanged: (bool? value) {
            setState(() {
              _gdprChecked = value ?? false;
            });
          },
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _gdprChecked = !_gdprChecked;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: RichText(
                text: TextSpan(
                  text: l10n.entryScreenIAgreeToThe,
                  style: const TextStyle(color: Colors.black87),
                  children: [
                    TextSpan(
                      text: l10n.entryScreenGdprPrivacyPolicy,
                      style: const TextStyle(
                        color: Color(0xFFB8A00D), // Darker shade of primary color
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const GDPRPage(),
                            )
                          );
                        },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton(AppLocalizations l10n) {
    return ElevatedButton(
      onPressed: _isFormValid ? _handleContinuePressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: _isFormValid ? const Color(0xFFB8A00D) : Colors.grey,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: _isFormValid ? 2 : 0,
      ),
      child: Text(
        l10n.entryScreenContinue,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}