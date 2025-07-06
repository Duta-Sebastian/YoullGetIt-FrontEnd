import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youllgetit_flutter/l10n/generated/app_localizations.dart';
import 'package:youllgetit_flutter/models/user_model.dart';
import 'package:youllgetit_flutter/screens/questionnaire_path_screen.dart';
import 'package:youllgetit_flutter/utils/database_manager.dart';
import 'package:youllgetit_flutter/widgets/settings/gdpr_page.dart';
import 'package:youllgetit_flutter/widgets/settings/language_settings.dart';
import 'package:youllgetit_flutter/widgets/animations/animated_pufferfish.dart';

class EntryScreen extends ConsumerStatefulWidget {
  const EntryScreen({super.key});

  @override
  ConsumerState<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends ConsumerState<EntryScreen> with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  bool _gdprChecked = false;
  bool _nameEntered = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Beautiful yellow color palette
  static const Color primaryYellow = Color(0xFFFFDE15);
  static const Color lightYellow = Color(0xFFFFF4A3);
  static const Color darkYellow = Color(0xFFE6C200);

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_updateNameStatus);
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _nameController.removeListener(_updateNameStatus);
    _nameController.dispose();
    _animationController.dispose();
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
        builder: (context) => const QuestionnairePathScreen()
      )
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
      backgroundColor: Colors.white, // Clean white background
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              children: [
                // Top bar with language selector
                _buildTopBar(l10n),
                
                // Main content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 60),
                          
                          // Animated Pufferfish Logo
                          _buildAnimatedLogo(),
                          
                          const SizedBox(height: 48),
                          
                          // Welcome text
                          _buildWelcomeText(l10n),
                          
                          const SizedBox(height: 56),
                          
                          // Form
                          _buildForm(l10n),
                          
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.06 * 255).toInt()),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: _showLanguageSelector,
              icon: const Icon(
                Icons.language,
                size: 18,
                color: Color(0xFF2D2D2D),
              ),
              label: Text(
                l10n.languagesSelectLanguage,
                style: const TextStyle(
                  color: Color(0xFF2D2D2D),
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF2D2D2D),
                elevation: 0,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: Colors.grey[200]!,
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedLogo() {
    return const AnimatedPufferfish(
      rotation: 0.0, // No rotation for the entry screen
    );
  }

  Widget _buildWelcomeText(AppLocalizations l10n) {
    return Column(
      children: [
        Text(
          l10n.entryScreenWelcome,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2D2D2D),
            height: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            l10n.internshipMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForm(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildNameField(l10n),
        const SizedBox(height: 24),
        _buildGdprCheckbox(l10n),
        const SizedBox(height: 32),
        _buildContinueButton(l10n),
      ],
    );
  }

  Widget _buildNameField(AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.06 * 255).toInt()),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _nameController,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: l10n.entryScreenYourName,
          hintText: l10n.entryScreenEnterFullName,
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: lightYellow,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.person_outline,
              size: 20,
              color: Color(0xFF2D2D2D),
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: primaryYellow, width: 2),
          ),
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        ),
      ),
    );
  }

  Widget _buildGdprCheckbox(AppLocalizations l10n) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center, // Changed from start to center
      children: [
        Transform.scale(
          scale: 1.2,
          child: Checkbox(
            value: _gdprChecked,
            activeColor: primaryYellow,
            checkColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            side: BorderSide(
              color: Colors.grey[300]!,
              width: 1.5,
            ),
            onChanged: (bool? value) {
              setState(() {
                _gdprChecked = value ?? false;
              });
            },
          ),
        ),
        const SizedBox(width: 8), // Reduced from 12 to 8
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _gdprChecked = !_gdprChecked;
              });
            },
            child: RichText(
              text: TextSpan(
                text: l10n.entryScreenIAgreeToThe,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  height: 1.4,
                  fontWeight: FontWeight.w400,
                ),
                children: [
                  TextSpan(
                    text: l10n.entryScreenGdprPrivacyPolicy,
                    style: const TextStyle(
                      color: darkYellow,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      decorationColor: darkYellow,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const GDPRPage(),
                          ),
                        );
                      },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton(AppLocalizations l10n) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: _isFormValid
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [primaryYellow, darkYellow],
              )
            : null,
        color: _isFormValid ? null : Colors.grey[200],
        boxShadow: _isFormValid
            ? [
                BoxShadow(
                  color: primaryYellow.withAlpha((0.4 * 255).toInt()),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isFormValid ? _handleContinuePressed : null,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.entryScreenContinue,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                    color: _isFormValid ? Colors.white : Colors.grey[500],
                  ),
                ),
                if (_isFormValid) ...[
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 20,
                    color: Colors.white,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}